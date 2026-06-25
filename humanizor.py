import sys
import subprocess
import re
import argparse

def protect_environments(text):
    """
    Finds LaTeX figures, tables, and equations and replaces them 
    with a placeholder token so the AI doesn't rewrite or break them.
    """
    # Matches \begin{figure}...\end{figure}, table, equation, etc.
    # re.DOTALL ensures the regex captures multiline LaTeX blocks
    pattern = r'(\\begin\{(?:figure|table|equation|align|tikzpicture|lstlisting)\*?\}.*?\\end\{\1\*?\})'
    
    env_dict = {}
    counter = 0
    
    def repl(match):
        nonlocal counter
        token = f"___LATEX_ENV_{counter}___"
        env_dict[token] = match.group(1)
        counter += 1
        return token
        
    protected_text = re.sub(pattern, repl, text, flags=re.DOTALL)
    return protected_text, env_dict

def restore_environments(text, env_dict):
    """Swaps the placeholders back to the original LaTeX blocks."""
    for token, original_env in env_dict.items():
        text = text.replace(token, original_env)
    return text

def run_stealth_humanizer(text):
    """Pipes text into the StealthHumanizer CLI."""
    if not text.strip():
        return text
        
    try:
        process = subprocess.Popen(
            ["stealthhumanizer", "humanize", "--model", "claude-code"],
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )
        stdout, stderr = process.communicate(input=text)
        
        if process.returncode != 0:
            print(f"\nWarning: StealthHumanizer failed on a chunk. Keeping original text.\nError: {stderr}")
            return text
            
        return stdout
    except FileNotFoundError:
        print("Error: 'stealthhumanizer' command not found. Ensure it is linked globally.")
        sys.exit(1)

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

    # 2. Split the chapter strictly by \section
    section_pattern = r'(\\section(?:\[.*?\])?\{.*?\})'
    section_parts = re.split(section_pattern, chapter_content)

    processed_parts = []
    
    # section_parts alternates: [text, \section{...}, text, \section{...}]
    for i, part in enumerate(section_parts):
        if i % 2 == 1:
            # It's a \section header. Save it exactly as-is.
            processed_parts.append(part)
            print(f"Preserving header: {part.strip()}")
        else:
            # It's paragraph text.
            word_count = len(part.split())
            if word_count < 5:
                # Skip processing empty spacing or tiny fragments
                processed_parts.append(part)
                continue
                
            print(f"Humanizing section body ({word_count} words)...")
            
            # Protect graphs and figures
            protected_text, env_dict = protect_environments(part)
            
            # Send to Claude
            humanized_text = run_stealth_humanizer(protected_text)
            
            # Restore graphs and figures
            restored_text = restore_environments(humanized_text, env_dict)
            processed_parts.append(restored_text)

    # 3. Reassemble and Save
    output_filename = f"chapter{args.chapter}_demo.tex"
    final_output = chapter_header + "".join(processed_parts)

    with open(output_filename, 'w', encoding='utf-8') as f:
        f.write(final_output)

    print(f"\nSuccess! Demo file safely generated at: {output_filename}")

if __name__ == "__main__":
    main()