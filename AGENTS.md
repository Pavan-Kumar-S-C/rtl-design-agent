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
| **Dev & verification lifecycle** | [.cursor/skills/rtl-design/dev-verify-workflow.md](.cursor/skills/rtl-design/dev-verify-workflow.md) |
| **RTL database schema** | [docs/standards/rtl-database-schema.md](docs/standards/rtl-database-schema.md) |
| **DB + report + scaffold templates** | [templates/rtl-db/](templates/rtl-db/), [templates/project-layout/](templates/project-layout/) |
| **Always-on conduct** | [.cursor/rules/rtl-design-conduct.mdc](.cursor/rules/rtl-design-conduct.mdc) |
| **Legacy invoke** | [.cursor/skills/rtl-coding-standards/SKILL.md](.cursor/skills/rtl-coding-standards/SKILL.md) |

## Entry skill

[.cursor/skills/rtl-design/SKILL.md](.cursor/skills/rtl-design/SKILL.md) — procedure:

1. [topic-router.md](.cursor/skills/rtl-design/topic-router.md) — **Step 0** coding vs lifecycle intent; **ask user** if scope unclear
2. [docs/standards/INDEX.md](docs/standards/INDEX.md) — keyword match → load **only** those topic files
3. [docs/design/INDEX.md](docs/design/INDEX.md) — matched **Content** sections only
4. [docs/examples/](docs/examples/) — matched topics only
5. Per-topic stubs: [.cursor/skills/rtl-design/topics/](.cursor/skills/rtl-design/topics/)
6. Lifecycle tasks: [dev-verify-workflow.md](.cursor/skills/rtl-design/dev-verify-workflow.md) + [rtl-database-schema.md](docs/standards/rtl-database-schema.md)

## Updating content

1. Edit markdown under `docs/standards/` or skill stubs.
2. Update [docs/README.md](docs/README.md) and [docs/standards/INDEX.md](docs/standards/INDEX.md) when adding files.
3. Teammates refresh: `git pull` in their clone, then re-run `scripts/install-rtl-design-agent.sh` (or `.ps1`) if using global install — see [SETUP.md](SETUP.md).

## Verbatim standards

If a standards file is marked **verbatim** at the top, the agent must not paraphrase those sections.

## Optional: project rule snippet

Copy [templates/project-rule-snippet.mdc](templates/project-rule-snippet.mdc) into any RTL project's `.cursor/rules/` to remind the agent to use `@rtl-design` for `.v` / `.sv` work.
