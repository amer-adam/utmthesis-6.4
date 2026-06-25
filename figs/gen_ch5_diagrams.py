import matplotlib.pyplot as plt
from matplotlib.patches import FancyBboxPatch, FancyArrowPatch
from matplotlib.lines import Line2D

BOX_FACE = "#eef1f6"
BOX_EDGE = "#2b3a55"
TEXT_COLOR = "#1a1a1a"


def draw_box(ax, x, y, w, h, text, face=BOX_FACE, edge=BOX_EDGE, fontsize=10.5):
    box = FancyBboxPatch((x, y), w, h, boxstyle="round,pad=0.02,rounding_size=0.04",
                          linewidth=1.4, edgecolor=edge, facecolor=face)
    ax.add_patch(box)
    ax.text(x + w / 2, y + h / 2, text, ha="center", va="center",
            fontsize=fontsize, color=TEXT_COLOR, linespacing=1.4)


def draw_arrow(ax, x1, y, x2, color=BOX_EDGE):
    arrow = FancyArrowPatch((x1, y), (x2, y), arrowstyle="-|>", mutation_scale=14,
                             linewidth=1.4, color=color)
    ax.add_patch(arrow)


# ---------------------------------------------------------------------------
# Figure 1: Pipe-and-Filter media-processing pipeline (current implementation)
# ---------------------------------------------------------------------------
fig, ax = plt.subplots(figsize=(13, 3.0))
ax.set_xlim(0, 13)
ax.set_ylim(0, 3)
ax.axis("off")

stages = [
    "Source\n(YouTube URL via\nyt-dlp / local upload)",
    "FFmpeg\n16 kHz mono\nPCM/MP3",
    "Whisper Large v3\nTurbo (ASR)\ntranscribe",
    "LLM Translator\n(DeepSeek-V4-Flash,\ntime-chunked)",
    "PyPinyin +\nHSK tagging",
    "Subtitle document\n(stored, served to\nfrontend)",
]

box_w, box_h, gap = 1.9, 1.5, 0.25
x = 0.15
y = 0.75
centers = []
for label in stages:
    draw_box(ax, x, y, box_w, box_h, label, fontsize=9.6)
    centers.append((x, x + box_w))
    x += box_w + gap

for i in range(len(stages) - 1):
    draw_arrow(ax, centers[i][1], y + box_h / 2, centers[i + 1][0])

plt.tight_layout()
plt.savefig("fig_media_pipeline.pdf", bbox_inches="tight")
plt.close()

# ---------------------------------------------------------------------------
# Figure 2: Simplified deployment topology (current implementation)
# ---------------------------------------------------------------------------
fig, ax = plt.subplots(figsize=(11, 6.4))
ax.set_xlim(0, 11)
ax.set_ylim(0, 6.4)
ax.axis("off")

YELLOW = "#fdf3d0"
BLUE = "#cfe2f7"
GREEN = "#d9ead3"
PURPLE = "#e7d9f0"
GREY = "#e9e9e9"
PINK = "#f7d9d9"

draw_box(ax, 4.2, 5.5, 2.6, 0.7, "User Browser", face=YELLOW)
draw_box(ax, 4.2, 4.3, 2.6, 0.7, "Vercel Edge CDN\n(React/TypeScript frontend)", face=BLUE, fontsize=9.5)
draw_box(ax, 3.6, 2.7, 3.8, 1.1,
         "Tencent Cloud Lighthouse VM\nDocker Compose: Node.js backend +\nFastAPI worker + PostgreSQL",
         face=BLUE, fontsize=9.3)
draw_box(ax, 0.3, 2.8, 2.6, 0.9, "SaladPool\nFastAPI worker\n(failover only)", face=PINK, fontsize=9)
draw_box(ax, 7.9, 4.0, 2.8, 0.9, "Hosted language models\n(Whisper, DeepSeek-V4,\nLlama 3.3 70B)", face=PURPLE, fontsize=9)
draw_box(ax, 7.9, 2.6, 2.8, 0.9, "MongoDB Atlas\n(job queue + raw\nsubtitle documents)", face=GREEN, fontsize=9)
draw_box(ax, 3.6, 0.4, 3.8, 0.9, "GitHub Actions -> GHCR\n(CI/CD on push to main)", face=GREY, fontsize=9.3)

def arrow(x1, y1, x2, y2):
    ax.add_patch(FancyArrowPatch((x1, y1), (x2, y2), arrowstyle="-|>", mutation_scale=14,
                                  linewidth=1.3, color=BOX_EDGE))

arrow(5.5, 5.5, 5.5, 5.0)
arrow(5.5, 4.3, 5.5, 3.8)
arrow(2.9, 3.2, 3.6, 3.2)
arrow(7.4, 3.4, 7.9, 3.0)
arrow(7.4, 3.9, 7.9, 4.4)
arrow(5.5, 1.3, 5.5, 2.7)

ax.text(3.2, 3.35, "failover\n(rare)", fontsize=7.6, ha="center")
ax.text(7.65, 4.25, "API calls", fontsize=7.6, ha="center")
ax.text(7.65, 3.15, "queue + docs", fontsize=7.6, ha="center")
ax.text(5.7, 1.9, "deploys", fontsize=7.6, ha="left")

plt.tight_layout()
plt.savefig("fig_deployment_topology.pdf", bbox_inches="tight")
plt.close()

print("done")
