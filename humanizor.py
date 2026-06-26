import sys
import subprocess
import re
import argparse
import time

def protect_latex(text):
    """
    Finds LaTeX environments, commands, and math blocks, and replaces them 
    with placeholder tokens so the AI doesn't rewrite or break them.
    """
    # 1. Environments pattern
    env_pattern = r'\\begin\{(?:figure|table|equation|align|tikzpicture|lstlisting|verbatim|algorithm|algorithmic)\*?\}.*?\\end\{(?:figure|table|equation|align|tikzpicture|lstlisting|verbatim|algorithm|algorithmic)\*?\}'
    
    # 2. Commands pattern (labels, citations, references, urls, etc.)
    cmd_pattern = r'\\(?:label|ref|cite|citep|citet|citeauthor|citeyear|url|texttt|pageref)\{[^{}]*\}'
    
    # 3. Href pattern: \href{url}{text}
    href_pattern = r'\\href\{[^{}]*\}\{[^{}]*\}'
    
    # 4. Inline and Display Math patterns: $...$, $...$, \(...\), \[...\]
    # Note: Use negative lookbehind to avoid matching escaped dollar signs \$
    math_pattern = r'\$\$(?:[^\$]|\\\$)+\$\$|(?<!\\)\$(?:[^\$]|\\\$)+(?<!\\)\$|\\\(.*?\\\)|\\\[.*?\\\]'

    # Combine them into a single pattern using alternation
    combined_pattern = f'({env_pattern}|{cmd_pattern}|{href_pattern}|{math_pattern})'
    
    env_dict = {}
    counter = 0
    
    def repl(match):
        nonlocal counter
        token = f"___LATEX_PROTECT_{counter}___"
        env_dict[token] = match.group(1)
        counter += 1
        return token
        
    protected_text = re.sub(combined_pattern, repl, text, flags=re.DOTALL)
    return protected_text, env_dict

def restore_latex(text, env_dict):
    """Swaps the placeholders back to the original LaTeX blocks."""
    for token, original_env in env_dict.items():
        text = text.replace(token, original_env)
    return text

def run_stealth_humanizer(text, retries=3, delay=2, backoff=2):
    """Pipes text into the StealthHumanizer CLI with retry logic and rate-limiting delay."""
    if not text.strip():
        return text

    import os

    # Rate-limiting delay of 2 seconds between Claude API requests
    time.sleep(2)

    # Resolve executable name for Windows vs Unix
    cmd_name = "stealthhumanizer.cmd" if sys.platform == "win32" else "stealthhumanizer"

    # Set up environment variables so stealthhumanizer can find claude
    custom_env = os.environ.copy()
    user_profile = os.environ.get("USERPROFILE") or os.path.expanduser("~")
    claude_bin = os.path.join(user_profile, ".local", "bin", "claude.exe")
    if os.path.exists(claude_bin):
        custom_env["STEALTHHUMANIZER_CLAUDE_CODE_BIN"] = claude_bin
    else:
        home_claude = os.path.expanduser("~/.local/bin/claude")
        if os.path.exists(home_claude):
            custom_env["STEALTHHUMANIZER_CLAUDE_CODE_BIN"] = home_claude

    for attempt in range(retries):
        try:
            process = subprocess.Popen(
                [cmd_name, "humanize", "--model", "claude-code"],
                stdin=subprocess.PIPE,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True,
                env=custom_env
            )
            stdout, stderr = process.communicate(input=text)
            
            if process.returncode == 0:
                return stdout
            
            print(f"\nWarning: StealthHumanizer failed on attempt {attempt + 1}/{retries}. Error: {stderr.strip()}")
            if attempt < retries - 1:
                sleep_time = delay * (backoff ** attempt)
                print(f"Retrying in {sleep_time} seconds...")
                time.sleep(sleep_time)
                
        except FileNotFoundError:
            # Fallback check just in case cmd_name was wrong or not in path
            fallback_cmd = "stealthhumanizer" if cmd_name == "stealthhumanizer.cmd" else "stealthhumanizer.cmd"
            try:
                process = subprocess.Popen(
                    [fallback_cmd, "humanize", "--model", "claude-code"],
                    stdin=subprocess.PIPE,
                    stdout=subprocess.PIPE,
                    stderr=subprocess.PIPE,
                    text=True,
                    env=custom_env
                )
                stdout, stderr = process.communicate(input=text)
                if process.returncode == 0:
                    return stdout
            except FileNotFoundError:
                pass
                
            print(f"Error: '{cmd_name}' command not found. Ensure it is linked globally.")
            sys.exit(1)
        except Exception as e:
            print(f"\nWarning: Subprocess error on attempt {attempt + 1}/{retries}: {e}")
            if attempt < retries - 1:
                sleep_time = delay * (backoff ** attempt)
                print(f"Retrying in {sleep_time} seconds...")
                time.sleep(sleep_time)

    print("\nWarning: StealthHumanizer failed after maximum retries. Keeping original text.")
    return text

def main():
    parser = argparse.ArgumentParser(description="Isolate and humanize a specific thesis chapter.")
    parser.add_argument("input_file", help="Path to your thesis.tex file")
    parser.add_argument("-c", "--chapter", type=int, required=True, help="Chapter number to target (e.g., 5)")
    args = parser.parse_args()

    try:
        with open(args.input_file, 'r', encoding='utf-8') as f:
            content = f.read()
    except FileNotFoundError:
        print(f"Error: Cannot find file {args.input_file}")
        sys.exit(1)

    # 1. Extract the specific chapter
    # re.split creates a list: [pre-chapter text, \chapter{...}, chapter 1 text, \chapter{...}, ...]
    chapter_pattern = r'(\\chapter(?:\[.*?\])?\{.*?\})'
    chapter_parts = re.split(chapter_pattern, content)

    target_idx = (args.chapter * 2) - 1
    
    if target_idx >= len(chapter_parts):
        print(f"Error: Chapter {args.chapter} not found in {args.input_file}.")
        sys.exit(1)

    chapter_header = chapter_parts[target_idx]
    chapter_content = chapter_parts[target_idx + 1]

    print(f"Found Chapter {args.chapter}: {chapter_header.strip()}")

    # 2. Split the chapter by section, sub-section, sub-sub-section, etc.
    section_pattern = r'(\\(?:section|subsection|subsubsection|paragraph|subparagraph)(?:\[.*?\])?\{.*?\})'
    section_parts = re.split(section_pattern, chapter_content)

    processed_parts = []
    
    # section_parts alternates: [body_text, header_cmd, body_text, header_cmd, ...]
    for i, part in enumerate(section_parts):
        if i % 2 == 1:
            # It's a structure header. Save it exactly as-is.
            processed_parts.append(part)
            print(f"Preserving header: {part.strip()}")
        else:
            # It's body text. We will split it into paragraph chunks.
            # Paragraphs are separated by double newlines or blank lines.
            paragraphs = re.split(r'(\n\s*\n)', part)
            
            # Group paragraphs into chunks of at most 400 words
            chunks = []
            current_chunk_parts = []
            current_word_count = 0
            
            for j, p_part in enumerate(paragraphs):
                if j % 2 == 1:
                    # It's a separator
                    current_chunk_parts.append(p_part)
                else:
                    # It's paragraph text
                    word_count = len(p_part.split())
                    if current_word_count + word_count > 400 and current_chunk_parts:
                        chunks.append("".join(current_chunk_parts))
                        current_chunk_parts = [p_part]
                        current_word_count = word_count
                    else:
                        current_chunk_parts.append(p_part)
                        current_word_count += word_count
            
            if current_chunk_parts:
                chunks.append("".join(current_chunk_parts))
                
            # Process each chunk
            processed_chunks = []
            for chunk in chunks:
                word_count = len(chunk.split())
                if word_count < 5:
                    processed_chunks.append(chunk)
                    continue
                    
                print(f"  Humanizing chunk ({word_count} words)...")
                protected_text, env_dict = protect_latex(chunk)
                humanized_text = run_stealth_humanizer(protected_text)
                restored_text = restore_latex(humanized_text, env_dict)
                processed_chunks.append(restored_text)
                
            processed_parts.append("".join(processed_chunks))

    # 3. Reassemble and Save
    output_filename = f"chapter{args.chapter}_demo.tex"
    final_output = chapter_header + "".join(processed_parts)

    with open(output_filename, 'w', encoding='utf-8') as f:
        f.write(final_output)

    print(f"\nSuccess! Demo file safely generated at: {output_filename}")

if __name__ == "__main__":
    main()