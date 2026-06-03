# RTL Design Agent (Cursor)

Company-wide Cursor agent for **writing, reviewing, and refactoring** synthesizable **Verilog** and **SystemVerilog** RTL.

Standalone repository — use **`@rtl-design`** or **`@rtl-coding-standards`** (same standards in this repo).

## Invoke

In Cursor **Agent** chat:

```text
@rtl-design Review this module for latch inference and missing default cases.
```

## Quick start

| Path | Who |
|------|-----|
| [SETUP.md](SETUP.md) | Designers — clone, install, daily use |
| [AGENTS.md](AGENTS.md) | Maintainer — where rules and skills live |
| [docs/standards/](docs/standards/) | Company RTL rules (markdown) |

```bash
git clone https://github.com/Pavan-Kumar-S-C/rtl-design-agent.git rtl-design-agent
cd rtl-design-agent
bash scripts/install-rtl-design-agent.sh
```

Restart Cursor → use `@rtl-design` in any RTL project.

## Layout

```
rtl-design-agent/
├── .cursor/skills/rtl-design/           # @rtl-design entry
├── .cursor/skills/rtl-coding-standards/ # @rtl-coding-standards (same rules)
├── .cursor/rules/                       # always-on conduct
├── docs/standards/INDEX.md          # keyword → topic files (selective load)
├── docs/design/                     # your design guides + section router
├── docs/examples/                   # golden .v / .sv per topic
└── scripts/                             # install to ~/.cursor or project
```

## Maintainer

1. Add or edit standards under [docs/standards/](docs/standards/).
2. Update [docs/README.md](docs/README.md) and [docs/standards/INDEX.md](docs/standards/INDEX.md) when adding topics.

Designer install: [SETUP.md](SETUP.md). Content map: [AGENTS.md](AGENTS.md).
