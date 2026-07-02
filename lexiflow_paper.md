LexiFlow: A Web Platform for Translating and Transcribing Native
Mandarin Content

Adam Ismail Hassan Amer Abouraya, Shahliza Abd Halim

*Faculty of Computing*

*Universiti Teknologi Malaysia*

*81310 Johor Bahru, Johor, Malaysia*

*adam\@graduate.utm.my, shahliza\@utm.my*

***Abstract---***Authentic Mandarin audio and video are valuable
language-learning material, but turning them into usable study resources
is labour-intensive: educators must manually transcribe, translate, and
annotate content with pinyin before it is usable by learners, and
existing tools such as LanguageReactor depend on creator-supplied
subtitles that are rarely available for Mandarin content. This paper
presents LexiFlow, a web-based platform that automates this pipeline
using voice activity detection, automatic speech recognition, neural
machine translation, and pinyin generation to produce synchronised,
searchable bilingual subtitles from an arbitrary video URL or uploaded
file. Beyond subtitle generation, LexiFlow integrates a Free Spaced
Repetition Scheduler (FSRS) flashcard system, an automatically generated
and semantically graded quiz engine, and a large-language-model-assisted
crowd-correction mechanism that lets viewer-reported transcription or
translation errors be corrected automatically without overwriting the
original AI-generated record. The system is implemented as a
dual-backend, polyglot-persistence architecture and deployed across four
independent hosting environments. This paper describes the system\'s
architecture, the specific models and libraries used at each pipeline
stage, and the rationale behind the key implementation decisions.

***Keywords---**Mandarin language learning; automatic speech
recognition; neural machine translation; spaced repetition; large
language models; web platform*

**I. INTRODUCTION**

With over a billion speakers, Mandarin is one of the most strategically
valuable languages for learners to acquire, yet its tonal pronunciation
and logographic writing system make it one of the hardest to self-study
from authentic, real-world material \[1\]. Language acquisition research
shows that learners progress fastest through meaningful exposure to
comprehensible authentic content rather than artificially simplified
textbook material \[1\], and that combining spoken audio with
synchronised text strengthens comprehension and retention \[2\]. In
practice, however, preparing authentic Mandarin video for classroom or
self-study use is slow: lecturers at Universiti Teknologi Malaysia (UTM)
reported that manually transcribing, translating, and annotating only a
few minutes of native Mandarin audio with pinyin can take eight to ten
hours.

Existing subtitle-based learning tools do not solve this problem for
Mandarin specifically. Tools such as LanguageReactor overlay
translations on existing platform subtitles, but rely entirely on the
availability of creator-supplied captions, which are comparatively rare
for Mandarin content and never include pinyin. General-purpose
transcription services, in turn, do not produce the timestamp-aligned,
pinyin-annotated format that Mandarin learners specifically need.
LexiFlow addresses this gap with a platform that ingests an arbitrary
video URL or uploaded file and automatically produces synchronised,
searchable, bilingual subtitles with pinyin, alongside a full suite of
vocabulary-review tools built around that processed content.

**II. RELATED WORK**

Krashen\'s Input Hypothesis \[1\] and Mayer\'s Cognitive Theory of
Multimedia Learning \[2\] together motivate LexiFlow\'s design: learners
acquire language most effectively from comprehensible, meaningfully
contextualised input, and dual-channel (audio plus synchronised text)
presentation reduces cognitive load compared to audio alone. Commercial
platforms such as FluentU and Yabla curate pre-annotated Mandarin video
libraries, but depend on in-house annotation teams and therefore cannot
scale to arbitrary, learner-chosen content; LanguageReactor instead
supports arbitrary content but only where native-language subtitles
already exist. LexiFlow\'s contribution is to remove the dependency on
either pre-existing subtitles or manual annotation by fully automating
transcription, translation, and pinyin generation for arbitrary source
material.

**III. SYSTEM ARCHITECTURE**

LexiFlow follows a Pipe-and-Filter architectural style: each stage of
media processing (voice activity detection, speech recognition,
translation, pinyin generation) is an independently replaceable filter
connected by data pipes, which allows individual models to be swapped
without affecting the rest of the pipeline. The system is split into a
React/TypeScript frontend, a Node.js (Express) backend responsible for
user-facing business logic and authentication, and a Python FastAPI
service responsible for the computationally heavy AI media-processing
pipeline. Identity is delegated entirely to Auth0, an external
Identity-as-a-Service provider, with just-in-time user provisioning into
the relational database on first login. Persistence is polyglot:
PostgreSQL (via the Prisma ORM) is the system of record for all
user-owned learning data (vocabulary, flashcards, quizzes, AI segment
corrections), while MongoDB Atlas stores processing-job state, raw
subtitle documents, and crowd-sourced segment reports.

**IV. IMPLEMENTATION**

*A. Media Processing Pipeline*

Incoming media is retrieved with yt-dlp and normalised to 16 kHz mono
PCM with FFmpeg. Speech regions are located with Silero VAD \[3\], a
pre-trained voice activity detector, before being transcribed with
faster-whisper, a CTranslate2-optimised re-implementation of OpenAI\'s
Whisper automatic speech recognition model \[4\]. Pinyin is generated
per character with PyPinyin, and an English translation is produced by a
self-hosted LibreTranslate instance. LibreTranslate was selected over
the originally-considered SeamlessM4T v2 multilingual translation model
\[5\] because it does not require sustained GPU memory to run
continuously, which better matches the project\'s hosting budget while
still meeting the translation-quality requirements of
Mandarin-to-English subtitle generation.

*B. Spaced-Repetition Flashcards*

Vocabulary review uses a direct implementation of the open-source FSRS
(Free Spaced Repetition Scheduler) algorithm, which models each
vocabulary item\'s retrievability, stability, and difficulty and has
been shown to outperform legacy scheduling algorithms such as SM-2. Each
of the four recall-quality ratings a learner submits (Again, Hard, Good,
Easy) updates these memory-state variables and recomputes the next
scheduled review timestamp.

*C. Automated Quiz Generation and Semantic Grading*

Quizzes are generated on demand from a learner\'s saved vocabulary,
supporting multiple-choice, fill-in-the-blank, true/false, and
open-ended short-answer questions. Short-answer responses are graded
semantically rather than by exact string match: both the learner\'s
answer and the reference definition are embedded using the pre-trained
multilingual paraphrase-multilingual-MiniLM-L12-v2 Sentence-Transformers
model, and graded by cosine similarity against fixed thresholds (\>0.90
exact/synonym, \>0.80 acceptable, \>0.70 partial credit). The same
embedding model rejects multiple-choice distractors that are too
semantically close to the correct answer, preventing accidentally-valid
distractors.

*D. AI-Assisted Crowd Correction*

Viewers can flag a specific subtitle segment as containing a
translation, pinyin, or transcription error. Once a segment accumulates
at least three reports from at least 25% of its viewers, LexiFlow
automatically resolves the report by sending the flagged segment, three
segments of surrounding context, and an error-specific instruction to
Meta\'s Llama 3.3 70B model, accessed through Groq\'s low-latency,
OpenAI-compatible inference API in JSON-constrained output mode.
Critically, the correction is never written back into the original
AI-generated transcription stored in MongoDB; instead, it is stored as
an addressable patch in a relational table and merged over the original
segment only at read time, keeping the original record auditable and any
correction trivially reversible. Reporters are asked to rate each
correction, building a labelled dataset for future correction-quality
evaluation.

*E. Deployment*

The frontend is deployed on Vercel\'s edge CDN. The Node.js backend and
PostgreSQL database run on a Tencent Cloud Lighthouse server, redeployed
automatically by a GitHub Actions workflow that builds a Docker image,
pushes it to the GitHub Container Registry, and restarts the container
over SSH on every push to the main branch. The GPU-bound FastAPI
media-processing service is hosted primarily on a local, on-premises GPU
server to avoid the recurring cost of continuous cloud GPU rental, with
a distributed rented-GPU provider (SaladPool) configured as a failover
target.

**V. DISCUSSION**

At the time of writing, the core pipeline (transcription, translation,
pinyin generation, flashcards, quizzes, and AI-assisted correction) is
implemented and deployed to a live test environment. Formal user
acceptance testing and structured test-case execution are scheduled for
the next evaluation phase and are therefore outside the scope of this
paper; preliminary informal feedback from a stakeholder demonstration
session was used to guide the user-interface redesign described in
Section IV.

**VI. CONCLUSION AND FUTURE WORK**

LexiFlow demonstrates that current open-source and commercially-hosted
speech, translation, and language model components can be composed into
a single pipeline that removes the manual transcription bottleneck
facing Mandarin language educators, while also providing learners with
spaced-repetition and quiz-based review tools built directly on top of
that content. Future work includes formal user acceptance testing,
migrating the remaining job-queue responsibilities from MongoDB onto
PostgreSQL, and evaluating lighter, Mandarin-specific speech and
translation models to reduce inference cost.

**. ACKNOWLEDGMENT**

The author thanks the UTM Language Academy lecturers who participated in
the requirements-gathering interviews that shaped this project.

**. REFERENCES**

\[1\] S. D. Krashen, The Input Hypothesis: Issues and Implications.
London: Longman, 1985.

\[2\] R. E. Mayer, Multimedia Learning, 2nd ed. Cambridge: Cambridge
University Press, 2009.

\[3\] Silero Team, \"Silero VAD: Pre-trained Enterprise-Grade Voice
Activity Detector, Number Detector and Language Classifier,\" 2024.

\[4\] A. Radford, J. W. Kim, T. Xu, G. Brockman, C. McLeavey, and I.
Sutskever, \"Robust speech recognition via large-scale weak
supervision,\" in Proc. Int. Conf. Machine Learning, 2023.

\[5\] L. Barrault et al., \"Seamless: Multilingual expressive and
streaming speech translation,\" arXiv preprint arXiv:2312.05187, 2023.

\[6\] Chinese Testing International, \"HSK Test Syllabus,\" 2025.
