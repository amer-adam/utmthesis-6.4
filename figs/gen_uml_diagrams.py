"""
UML-notation System Architecture (Component) Diagram and Deployment Diagram
for the LexiFlow SDD, matching the visual conventions of the existing
Figure 3.1 Component Diagram (PlantUML-style: component "plug" icon,
package folder-tab frame, dashed dependency arrows with <<stereotype>>
labels for component diagrams; 3D node boxes, artifact document-icon boxes,
and solid communication paths for deployment diagrams).
"""
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle, FancyArrowPatch, PathPatch
from matplotlib.path import Path
import matplotlib.patheffects as pe

BLACK = "#000000"
NAME_BLUE = "#0000CC"
STEREO_BROWN = "#8B4513"
LABEL_ORANGE = "#8B4513"
FILL_WHITE = "#FFFFFF"
FILL_GREY = "#F2F2F2"

plt.rcParams["font.family"] = "DejaVu Sans"


# --------------------------------------------------------------------------
# UML primitives
# --------------------------------------------------------------------------
def component_icon(ax, x, y, s=0.14):
    """Small UML component 'plug' icon: a rectangle with two small tabs."""
    ax.add_patch(Rectangle((x, y), s, s * 1.4, facecolor="white", edgecolor="black", linewidth=0.9, zorder=5))
    ax.add_patch(Rectangle((x - s * 0.35, y + s * 0.15), s * 0.35, s * 0.35, facecolor="white", edgecolor="black", linewidth=0.9, zorder=6))
    ax.add_patch(Rectangle((x - s * 0.35, y + s * 0.75), s * 0.35, s * 0.35, facecolor="white", edgecolor="black", linewidth=0.9, zorder=6))


def component_box(ax, x, y, w, h, name, stereotype=None, fill=FILL_WHITE, fontsize=8.6, name_fontsize=9.2):
    ax.add_patch(Rectangle((x, y), w, h, facecolor=fill, edgecolor="black", linewidth=1.1, zorder=3))
    component_icon(ax, x + w - 0.22, y + h - 0.24)
    ty = y + h / 2
    if stereotype:
        ax.text(x + w / 2, ty + 0.13, f"«stereotype»".replace("stereotype", stereotype),
                ha="center", va="center", fontsize=fontsize, color=STEREO_BROWN, style="italic", zorder=4)
        ax.text(x + w / 2, ty - 0.14, name, ha="center", va="center", fontsize=name_fontsize,
                color=NAME_BLUE, weight="bold", zorder=4, linespacing=1.3)
    else:
        ax.text(x + w / 2, ty, name, ha="center", va="center", fontsize=name_fontsize,
                color=NAME_BLUE, weight="bold", zorder=4, linespacing=1.3)


def package_frame(ax, x, y, w, h, label):
    """PlantUML-style package frame with a folder tab in the top-left corner."""
    ax.add_patch(Rectangle((x, y), w, h, facecolor="none", edgecolor="black", linewidth=1.2, zorder=1))
    tab_w, tab_h = 1.9, 0.34
    tab = Rectangle((x, y + h), tab_w, tab_h, facecolor="white", edgecolor="black", linewidth=1.2, zorder=2)
    ax.add_patch(tab)
    # angled cut corner on the tab (classic folder-tab notch)
    ax.plot([x + tab_w - 0.16, x + tab_w, x + tab_w], [y + h + tab_h, y + h + tab_h, y + h],
            color="black", linewidth=1.2, zorder=2)
    ax.text(x + 0.12, y + h + tab_h / 2, label, ha="left", va="center", fontsize=9.2, weight="bold", zorder=3)


def subsystem_frame(ax, x, y, w, h, label):
    """Plain bordered rectangle with a label bar at the top (for nested subsystems)."""
    ax.add_patch(Rectangle((x, y), w, h, facecolor="none", edgecolor="black", linewidth=1.0, zorder=1))
    ax.text(x + 0.12, y + h - 0.16, label, ha="left", va="top", fontsize=9.0, weight="bold", zorder=2)


def dep_arrow(ax, x1, y1, x2, y2, label=None, lx=None, ly=None, rad=0.0):
    style = f"arc3,rad={rad}" if rad else None
    ax.add_patch(FancyArrowPatch((x1, y1), (x2, y2), arrowstyle="-|>", mutation_scale=11,
                                  linewidth=0.9, linestyle=(0, (4, 2)), color="black",
                                  connectionstyle=style, zorder=4))
    if label:
        lx = lx if lx is not None else (x1 + x2) / 2
        ly = ly if ly is not None else (y1 + y2) / 2
        ax.text(lx, ly, f"«{label}»", ha="center", va="center", fontsize=7.6,
                color=LABEL_ORANGE, style="italic", zorder=5,
                bbox=dict(boxstyle="round,pad=0.08", facecolor="white", edgecolor="none"))


# ---------------------------------------------------------------------------
# Figure 3.2: System Architecture Diagram (UML Component Diagram)
# ---------------------------------------------------------------------------
fig, ax = plt.subplots(figsize=(13.0, 8.6))
ax.set_xlim(0, 13.0)
ax.set_ylim(0, 8.6)
ax.axis("off")
ax.set_aspect("equal")

package_frame(ax, 0.15, 0.15, 12.7, 7.85, "cmp System Architecture")

# User Interface
component_box(ax, 0.7, 6.55, 2.7, 1.0, "User Interface\n(React 18 + TypeScript)")

# Backend subsystem containing Node.js + FastAPI
subsystem_frame(ax, 4.3, 6.1, 8.1, 1.65, "Backend Services")
component_box(ax, 4.6, 6.3, 3.35, 1.0, "Node.js Backend\n(Express)", stereotype="component")
component_box(ax, 8.5, 6.3, 3.6, 1.0, "FastAPI Worker", stereotype="component")

# Media processing pipeline subsystem
subsystem_frame(ax, 4.3, 3.15, 8.1, 2.35, "Media Processing Pipeline")
component_box(ax, 4.6, 3.4, 1.85, 1.4, "FFmpeg", stereotype="filter", fontsize=7.6, name_fontsize=8.4)
component_box(ax, 6.6, 3.4, 1.95, 1.4, "Whisper\nLarge v3 Turbo", stereotype="filter", fontsize=7.6, name_fontsize=8.0)
component_box(ax, 8.7, 3.4, 1.75, 1.4, "LLM\nTranslator", stereotype="filter", fontsize=7.6, name_fontsize=8.0)
component_box(ax, 10.6, 3.4, 1.55, 1.4, "PyPinyin\n+ HSK", stereotype="filter", fontsize=7.6, name_fontsize=8.0)

# Feature filters subsystem
component_box(ax, 0.55, 3.35, 3.35, 1.65, "Feature Filters\n(FSRS, quiz generator,\ncrowd-correction)", stereotype="component", fontsize=7.6, name_fontsize=8.2)

# Data layer
component_box(ax, 0.55, 0.55, 3.0, 1.0, "PostgreSQL", stereotype="database")
component_box(ax, 4.9, 0.55, 3.0, 1.0, "MongoDB", stereotype="database")
component_box(ax, 8.95, 0.55, 3.15, 1.0, "External AI Services", stereotype="external", fontsize=7.8, name_fontsize=8.6)

# Dependency arrows
dep_arrow(ax, 3.4, 7.05, 4.6, 7.0, "REST API")
dep_arrow(ax, 6.3, 6.3, 6.3, 5.5, "invokes")                # Node -> pipeline
dep_arrow(ax, 10.3, 6.3, 10.3, 4.8, "invokes")               # FastAPI -> pipeline
dep_arrow(ax, 4.65, 6.35, 3.2, 5.0, "invokes", rad=0.15)     # Node -> feature filters
dep_arrow(ax, 2.1, 3.35, 2.1, 1.55, "reads/writes")          # feature filters -> PostgreSQL
dep_arrow(ax, 8.4, 3.15, 6.4, 1.55, "job docs", rad=-0.15)   # pipeline -> MongoDB
dep_arrow(ax, 10.35, 3.4, 10.5, 1.55, "AI calls", rad=0.2)   # pipeline -> external AI

plt.tight_layout()
plt.savefig("fig_system_architecture_uml.pdf", bbox_inches="tight")
plt.close()
print("done: fig_system_architecture_uml.pdf")


# --------------------------------------------------------------------------
# UML deployment-diagram primitives
# --------------------------------------------------------------------------
def uml_node(ax, x, y, w, h, label, depth=0.28, fill="#FFFFFF", fontsize=9.0, label_va="top"):
    """UML deployment-diagram 'node': a 3D cube. (x,y) is the bottom-left of the front face."""
    # front face
    ax.add_patch(Rectangle((x, y), w, h, facecolor=fill, edgecolor="black", linewidth=1.1, zorder=3))
    # top face (parallelogram)
    top = Path([(x, y + h), (x + depth, y + h + depth), (x + w + depth, y + h + depth), (x + w, y + h), (x, y + h)],
               [Path.MOVETO, Path.LINETO, Path.LINETO, Path.LINETO, Path.CLOSEPOLY])
    ax.add_patch(PathPatch(top, facecolor=fill, edgecolor="black", linewidth=1.1, zorder=3))
    # side face (parallelogram)
    side = Path([(x + w, y), (x + w + depth, y + depth), (x + w + depth, y + h + depth), (x + w, y + h), (x + w, y)],
                [Path.MOVETO, Path.LINETO, Path.LINETO, Path.LINETO, Path.CLOSEPOLY])
    ax.add_patch(PathPatch(side, facecolor="#EAEAEA", edgecolor="black", linewidth=1.1, zorder=3))
    if label_va == "top":
        ax.text(x + 0.14, y + h - 0.12, label, ha="left", va="top", fontsize=fontsize, weight="bold", zorder=6, linespacing=1.3)
    else:
        ax.text(x + w / 2, y + h / 2, label, ha="center", va="center", fontsize=fontsize, weight="bold", zorder=6, linespacing=1.3)
    return depth


def artifact_box(ax, x, y, w, h, name, stereotype="artifact", fontsize=7.8, name_fontsize=8.4):
    """UML artifact: rectangle with a folded-corner document icon."""
    ax.add_patch(Rectangle((x, y), w, h, facecolor="white", edgecolor="black", linewidth=0.9, zorder=5))
    fold = 0.16
    icon_x, icon_y, icon_w, icon_h = x + w - 0.34, y + h - 0.30, 0.22, 0.24
    doc = Path([(icon_x, icon_y), (icon_x, icon_y + icon_h), (icon_x + icon_w - fold, icon_y + icon_h),
                (icon_x + icon_w, icon_y + icon_h - fold), (icon_x + icon_w, icon_y), (icon_x, icon_y)],
               [Path.MOVETO, Path.LINETO, Path.LINETO, Path.LINETO, Path.LINETO, Path.CLOSEPOLY])
    ax.add_patch(PathPatch(doc, facecolor="white", edgecolor="black", linewidth=0.8, zorder=6))
    ax.plot([icon_x + icon_w - fold, icon_x + icon_w - fold, icon_x + icon_w],
            [icon_y + icon_h, icon_y + icon_h - fold, icon_y + icon_h - fold], color="black", linewidth=0.7, zorder=7)
    ty = y + h / 2
    ax.text(x + w / 2, ty + 0.11, f"«{stereotype}»", ha="center", va="center", fontsize=fontsize,
            color=STEREO_BROWN, style="italic", zorder=6)
    ax.text(x + w / 2, ty - 0.13, name, ha="center", va="center", fontsize=name_fontsize,
            color=NAME_BLUE, weight="bold", zorder=6, linespacing=1.2)


def comm_path(ax, x1, y1, x2, y2, label=None, lx=None, ly=None, rad=0.0):
    style = f"arc3,rad={rad}" if rad else None
    ax.add_patch(FancyArrowPatch((x1, y1), (x2, y2), arrowstyle="-", mutation_scale=10,
                                  linewidth=1.1, color="black", connectionstyle=style, zorder=4))
    if label:
        lx = lx if lx is not None else (x1 + x2) / 2
        ly = ly if ly is not None else (y1 + y2) / 2
        ax.text(lx, ly, label, ha="center", va="center", fontsize=7.6, color="black", zorder=5,
                bbox=dict(boxstyle="round,pad=0.08", facecolor="white", edgecolor="none"))


def deploy_arrow(ax, x1, y1, x2, y2, label="deploy", rad=0.0):
    style = f"arc3,rad={rad}" if rad else None
    ax.add_patch(FancyArrowPatch((x1, y1), (x2, y2), arrowstyle="-|>", mutation_scale=11,
                                  linewidth=0.9, linestyle=(0, (4, 2)), color="black",
                                  connectionstyle=style, zorder=4))
    lx, ly = (x1 + x2) / 2, (y1 + y2) / 2
    ax.text(lx, ly, f"«{label}»", ha="center", va="center", fontsize=7.4, color=LABEL_ORANGE,
            style="italic", zorder=5, bbox=dict(boxstyle="round,pad=0.08", facecolor="white", edgecolor="none"))


# ---------------------------------------------------------------------------
# Figure 3.3: Deployment Diagram (UML Deployment Diagram)
# ---------------------------------------------------------------------------
fig, ax = plt.subplots(figsize=(13.2, 8.8))
ax.set_xlim(0, 13.2)
ax.set_ylim(0, 8.8)
ax.axis("off")
ax.set_aspect("equal")

d = 0.26

# User Browser (top)
uml_node(ax, 5.5, 7.55, 2.2, 0.7, "User Browser", depth=d, fontsize=8.6)

# Vercel Edge CDN, containing the frontend artifact
uml_node(ax, 5.15, 5.65, 2.9, 1.35, "«device»\nVercel Edge CDN", depth=d, fontsize=8.2)
artifact_box(ax, 5.4, 5.85, 2.4, 0.75, "React Frontend\nBuild")

# Tencent Cloud Lighthouse VM, containing Docker Compose execution environment
uml_node(ax, 3.55, 2.75, 6.6, 2.35, "«device»\nTencent Cloud Lighthouse VM", depth=d, fontsize=8.4)
# nested execution-environment box for Docker Compose
ax.add_patch(Rectangle((3.85, 2.95), 6.0, 1.7, facecolor="#FAFAFA", edgecolor="black", linewidth=0.9, linestyle=(0, (3, 2)), zorder=4))
ax.text(3.98, 4.5, "«execution environment»\nDocker Compose", ha="left", va="top", fontsize=7.6, style="italic", color=STEREO_BROWN, zorder=5)
artifact_box(ax, 4.0, 3.1, 1.85, 0.85, "Node.js\nBackend")
artifact_box(ax, 6.05, 3.1, 1.75, 0.85, "FastAPI\nWorker")
artifact_box(ax, 7.95, 3.1, 1.75, 0.85, "PostgreSQL", stereotype="artifact")

# SaladPool failover node
uml_node(ax, 0.3, 2.95, 2.55, 1.55, "«device»\nSaladPool Worker", depth=d, fontsize=8.0)
artifact_box(ax, 0.5, 3.1, 2.05, 0.75, "FastAPI Worker\n(failover only)", fontsize=7.2, name_fontsize=7.6)

# MongoDB Atlas managed service node
uml_node(ax, 10.55, 2.75, 2.4, 1.55, "«device»\nMongoDB Atlas", depth=d, fontsize=7.8)
artifact_box(ax, 10.75, 2.9, 1.95, 0.75, "MongoDB", fontsize=7.2, name_fontsize=7.8)

# Hosted AI services node
uml_node(ax, 9.6, 5.5, 3.4, 1.6, "«device»\nHosted AI Services", depth=d, fontsize=8.2)
artifact_box(ax, 9.85, 5.7, 2.9, 0.9, "Whisper, LLM Translator,\nLlama 3.3 70B", fontsize=7.0, name_fontsize=7.4)

# CI/CD execution environment node
uml_node(ax, 0.3, 0.35, 4.6, 1.1, "«execution environment»\nGitHub Actions -> GHCR", depth=d, fontsize=8.0)
artifact_box(ax, 0.5, 0.5, 2.5, 0.55, "Container Image", fontsize=6.8, name_fontsize=7.4)

# Communication paths
comm_path(ax, 6.6, 7.55, 6.6, 7.0, "HTTPS")
comm_path(ax, 6.6, 5.65, 6.6, 5.1, "HTTPS")
comm_path(ax, 2.85, 3.7, 3.55, 3.7, "failover\n(rare)")
comm_path(ax, 10.15, 3.55, 10.55, 3.55, "queue + docs")
comm_path(ax, 9.15, 5.05, 9.6, 5.9, "API calls", rad=-0.15, lx=9.75, ly=5.35)
deploy_arrow(ax, 2.6, 1.45, 4.4, 2.75, "deploy", rad=-0.2)

plt.tight_layout()
plt.savefig("fig_deployment_uml.pdf", bbox_inches="tight")
plt.close()
print("done: fig_deployment_uml.pdf")
