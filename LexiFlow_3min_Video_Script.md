# LexiFlow — 3-Minute Showcase Video Script

Target run time: 2:50–3:00. Rubric scores this on clarity/organization, engagement/professionalism, and delivery — so keep energy up, cut dead air, and show the live app rather than slides wherever possible.

Record screen capture at 1080p. Have the live site open in a browser tab, logged in, with one already-processed video ready so you don't wait on processing live. Do a dry run once before the real take.

---

## 0:00–0:20 — Hook + Problem (talking head or voiceover over title screen)

> "Mandarin is spoken by over a billion people, but for learners it's one of the hardest languages to self-study from real, authentic content. Why? Because turning a native Mandarin video into something you can actually learn from — accurate transcription, translation, and pinyin — takes a teacher eight to ten hours, for just a few minutes of footage. That's LexiFlow's problem to solve."

**On screen:** Title card with project name, then cut straight to a talking-head shot or the problem stated over a blank/existing-tool screenshot (e.g. `fig_ss_subtitles.png` blurred, or a LanguageReactor/YouTube screenshot showing missing Mandarin subtitles).

## 0:20–0:40 — Solution one-liner + architecture glance

> "LexiFlow is a web platform that takes any Mandarin audio or video — a URL or an upload — and automatically produces synchronised, searchable bilingual subtitles with pinyin, using voice activity detection, speech recognition, and neural translation. It's built as a pipe-and-filter pipeline, so each processing stage can be swapped independently."

**On screen:** Show `arch.png` (architecture diagram) for 5–6 seconds, then cut to the live app home/upload screen.

## 0:40–1:20 — Core demo: submit a video → subtitle playback

> "Let's see it in action. I'll drop in a Mandarin video URL — LexiFlow segments the audio, transcribes it, translates it, and generates pinyin automatically. Once it's processed, here's the result: synchronised subtitles with the original Chinese, pinyin, and English translation, all timestamped to the audio."

**On screen:** Live demo — paste a URL (or open a pre-processed one to save time), then show the subtitle playback screen (matches `fig_ss_subtitles.png`). Click a word to show the tap-to-look-up definition popup.

> "Tapping any word gives an instant dictionary lookup with its HSK level, so learners always know if a word is within their current proficiency."

## 1:20–1:50 — Flashcards (spaced repetition)

> "Every word a learner saves feeds into a spaced-repetition flashcard system built on FSRS — the same algorithm used by modern tools like Anki. Learners rate how well they remembered each card, and the app reschedules the next review automatically to maximise long-term retention."

**On screen:** Live demo of `fig_ss_flashcards.png` — flip a card, tap one of the four recall buttons (Again/Hard/Good/Easy).

## 1:50–2:15 — Quizzes

> "LexiFlow can also turn a learner's saved vocabulary into a quiz on demand — multiple-choice, fill-in-the-blank, true/false, or open-ended. Short answers are graded semantically using a language model, not exact string matching, so a correct paraphrase still counts."

**On screen:** Live demo of `fig_ss_quizzes.png` — answer one question, show the score result.

## 2:15–2:35 — Crowd correction (the differentiator)

> "Because the whole pipeline is AI-generated, errors happen. So viewers can flag a subtitle segment as wrong, and once enough reports come in, LexiFlow automatically re-evaluates it with a large language model and applies a correction — without ever overwriting the original record, so everything stays auditable."

**On screen:** Live demo of `fig_ss_crowdreport.png` — click the flag icon on a segment, show the report dialog.

## 2:35–2:55 — Results + close

> "The system has been tested end-to-end: 25 of 30 automated test cases passed, with the two remaining issues already root-caused, and it's been validated with real learners, native speakers, and an instructor through user acceptance testing. LexiFlow shows that today's speech, translation, and language-model tools can be combined into one pipeline that removes the manual bottleneck facing Mandarin educators — and gives learners a genuinely useful way to study from content they actually care about."

**On screen:** Quick montage — deployment topology (`fig_deployment_topology-1.png`) for 2–3 seconds, then closing title card with project name, your name, and the live URL (`lexiflow.amerai.top`).

## 2:55–3:00 — End card

Project name, your name, supervisor's name, "Thank you." Hold for 3–4 seconds so it doesn't feel abrupt.

---

## Practical notes

- **Total spoken word count target:** ~380–420 words at a natural pace fills close to 3:00. Time yourself once reading it aloud before recording.
- If a live processing demo is too slow/unreliable to show on camera, say so honestly ("processing typically takes about a minute — here's one I ran earlier") rather than cutting to a suspiciously instant result.
- Rubric wants "professional and visually appealing" — normalise your audio levels, cut hard pauses/"ums" in editing, and don't let any single static screenshot sit for more than ~8 seconds without a cut, zoom, or cursor movement.
- If you want a talking-head intro/outro (recommended — rubric rewards a confident, visible speaker, not just narrated screen capture), record that separately against a plain background and edit it in at 0:00 and 2:55.
