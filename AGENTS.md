# RTL Design Agent — maintainer guide

## Purpose

Cursor skills + rules for **`@rtl-design`** and **`@rtl-coding-standards`** — synthesizable Verilog and SystemVerilog RTL design and review for any project (Ethernet, FPGA, ASIC).

## Where to add content

| Content | Location |
|---------|----------|
| **Company coding rules** | [docs/standards/rtl-coding-standards.md](docs/standards/rtl-coding-standards.md) and additional `docs/standards/<topic>.md` |
| **Golden examples** | [docs/examples/](docs/examples/) |
| **Design flow cheatsheet** | [.cursor/skills/rtl-design/design-workflow.md](.cursor/skills/rtl-design/design-workflow.md) |
| **Review checklist** | [.cursor/skills/rtl-design/review-checklist.md](.cursor/skills/rtl-design/review-checklist.md) |
| **Always-on conduct** | [.cursor/rules/rtl-design-conduct.mdc](.cursor/rules/rtl-design-conduct.mdc) |
| **Legacy invoke** | [.cursor/skills/rtl-coding-standards/SKILL.md](.cursor/skills/rtl-coding-standards/SKILL.md) |

## Entry skill

[.cursor/skills/rtl-design/SKILL.md](.cursor/skills/rtl-design/SKILL.md) — procedure:

1. [topic-router.md](.cursor/skills/rtl-design/topic-router.md) — **ask user** if scope unclear
2. [docs/standards/INDEX.md](docs/standards/INDEX.md) — keyword match → load **only** those topic files
3. [docs/design/INDEX.md](docs/design/INDEX.md) — matched **Content** sections only
4. [docs/examples/](docs/examples/) — matched topics only
5. Per-topic stubs: [.cursor/skills/rtl-design/topics/](.cursor/skills/rtl-design/topics/)

## First-time GitHub

See [docs/GITHUB.md](docs/GITHUB.md) or run `scripts/create-github-repo.ps1`.

## Publishing changes

1. Edit markdown under `docs/standards/` or skill stubs.
2. Update [docs/README.md](docs/README.md) index when adding files.
3. Commit with a clear message (e.g. `docs: add CDC crossing rules`).
4. Teammates: `git pull` and re-run `scripts/install-rtl-design-agent.sh` if using global install.

## Verbatim standards

If a standards file is marked **verbatim** at the top, the agent must not paraphrase those sections.

## Optional: project rule snippet

Copy [templates/project-rule-snippet.mdc](templates/project-rule-snippet.mdc) into any RTL project's `.cursor/rules/` to remind the agent to use `@rtl-design` for `.v` / `.sv` work.
