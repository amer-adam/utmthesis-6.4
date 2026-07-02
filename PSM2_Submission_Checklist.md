# PSM 2 Submission Checklist — LexiFlow (Adam)

Deadline: 2 July 2026, 5:00 PM. This tracks what was fixed automatically and what still needs your action.

## 1. What I found and fixed in `thesis-template-demo.tex`

Your compiled `thesis-template-demo.pdf` was missing almost everything the rubric scores under "Introduction," front matter, and the appendices — not because the content wasn't written, but because it was all commented out in the `.tex` file. I uncommented and fixed:

- **Front matter (all commented out, none of this was in your PDF):** cover page, signed supervisor page (`figs/super2.pdf`), declaration, dedication, acknowledgement, English abstract, Malay abstrak, table of contents, list of tables, list of figures, list of abbreviations, list of appendices.
- **Appendices (all commented out, so every `Appendix~\ref{...}` in your text was rendering as a broken "??"):** List of Prompts Used (rubric-scored, 5%), Test Execution Report, UAT Report, Stakeholder Interview Questions, Feedback on Prototype Meeting, SRS, SDD. I left "Project Timeline Management with Jira" commented out since that appendix chapter has no content in it (no screenshot was ever added) — add one and uncomment it if you want it included.
- **Report Organization (Section 1.7):** said "five well-rounded chapters" and only described Chapters 1–5, but the thesis has six chapters (Chapter 6 is the Conclusion, never mentioned). Rewrote to correctly describe all six.
- Verified: all brace pairs balanced, all `\ref{app:...}` now resolve to a real `\label`, all five `\includepdf` source PDFs exist in `figs/`.

**I could not fully recompile the PDF in my sandbox** — it's missing the `newtxtext`/`newtxmath` and `algorithm` TeX packages (no root access, no package-repository access here). Your own machine has `texlive-full` per your README, so it should compile cleanly there. **Please recompile locally and check the output before submitting** — that's the one step I couldn't verify end-to-end.

## 2. Short paper — brought in line with the `StuOrganize` sample

Your original short paper had all the right section headings but **zero tables and zero figures** (vs. the sample's 9 tables/figures across 6 pages). It also still said testing was "outside the scope of this paper," even though your thesis Chapter 5/6 shows testing was completed. I:

- Added **Table I** (comparison vs. LanguageReactor/FluentU/Yabla — pulled from your own Chapter 2 literature review, not invented).
- Added **Table II** (tools/technology stack, pulled from your own Implementation section).
- Added **Table III** (testing/UAT outcomes summary).
- Added 6 figures: architecture diagram, subtitle/flashcard/quiz/crowd-correction screenshots, deployment topology.
- **Rewrote the Discussion and Conclusion/Future Work paragraphs** — they previously said UAT hadn't happened yet and listed "formal UAT" as future work. Replaced with the actual results (25/30 Playwright tests passed, 2 defects found, 4-user UAT completed) and updated future work to match your thesis Chapter 6 (fix the 2 known bugs, close the accuracy gap, add classroom management, ONNX/TensorRT optimization).
- Removed reference [6] (HSK Test Syllabus), which was never cited anywhere in the text.
- Now 4 pages, both `.docx` and `.pdf` saved in `short_paper/`.

## 3. PSM2 forms — filled what I know, left the rest for you

Both `PSM2.RRAF_.01` and `PSM2.NPEF_.02u` were completely blank. I filled Name, Project Title, Supervisor, Project Type, and Email across every copy of Section A. **Left blank / need your input:**

- **Matric No.:** I used `A22EC0002`, pulled from a commented-out line in your `.tex` — please confirm this is correct.
- **Session/Semester:** I guessed `2025/2026-2` — please confirm the exact UTM session code.
- **NRIC/Passport, phone number:** left blank, I don't have this.
- **Turnitin similarity % table (NPEF form):** left blank — see item 4 in the email checklist below, no Turnitin report exists yet.
- **Both forms need Section B/C filled and signed by your supervisor** — that's not something I can do.

## 4. Full submission checklist (per the coordinator's email)

| # | Item | Status |
|---|---|---|
| 1 | PSM2.RRAF.01 form | Student section filled; **needs supervisor Section B/C + signature** |
| 2 | PSM2.NPEF.02 form | Student section filled; **needs Turnitin % pasted in + supervisor sign-off** |
| 3 | Final report (PDF + Word, inc. TER & UAT) | PDF: fixed, **recompile locally to confirm**. Word: **no `.docx` exists** — LaTeX has no direct Word export; recompile the PDF first, then use Overleaf's "Download as Word" or a PDF→Word converter |
| 4 | Turnitin report | **Missing entirely** — you need to run this yourself (also required to fill item 2) |
| 5 | 3-minute showcase video (link in Word/PPT, filename `3-min_showcase_video`) | **Missing** — no video or link found anywhere in the project. Record it, then drop the link into a Word or PowerPoint file with that exact filename |
| 6 | Short paper (Word + PDF) | Done — both files updated in `short_paper/` |

## 5. Minor things worth a glance

- The PSM2 forms print the course code as "SECR 4134" (RRAF) and "SEC_ 4134" (NPEF) rather than "SECJ 4134" — that's baked into UTM's official template, not something I changed, but worth double-checking with the coordinator if it looks wrong.
- Your supervisor's signed confirmation page (`figs/super2.pdf`, dated 26 June 2025) is now embedded in the front matter — good to go.
