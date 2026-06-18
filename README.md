# RTL Design Agent (Cursor)

Company-wide Cursor agent for **writing, reviewing, and refactoring** synthesizable **Verilog** and **SystemVerilog** RTL.

Standalone repository — invoke skills in Cursor Agent chat:

| Invoke | Use for |
|--------|---------|
| `@help` | List all features |
| `@rtl-design` | RTL write/review + HAS/MAS lifecycle |
| `@timing-analysis` | STA / timing reports, MTBF |
| `@sdc` | SDC constraint files |
| `@cdc` | VC SpyGlass CDC verification (FPGA) |
| `@lint` | VC SpyGlass Lint on FPGA RTL |
| `@testbench` | Self-checking simulation testbenches |

## Invoke

In Cursor **Agent** chat:

```text
@help
```

```text
@rtl-design Review this module for latch inference and missing default cases.
```

```text
@sdc Add set_input_delay for this Avalon-MM slave port.
```

```text
@cdc Debug CDC_UNSYNC_ASYNCRESET after check_cdc -type sync.
```

```text
@lint Fix lint_rtl violations — inferred latch and multiple drivers.
```

```text
@testbench Generate a self-checking SystemVerilog testbench for this module.
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
├── .cursor/skills/rtl-design/           # @rtl-design
├── .cursor/skills/timing-analysis/      # @timing-analysis
├── .cursor/skills/sdc/                  # @sdc
├── .cursor/skills/cdc/                  # @cdc (SpyGlass CDC)
├── .cursor/skills/lint/                 # @lint (SpyGlass Lint)
├── .cursor/skills/testbench/            # @testbench
├── .cursor/skills/help/                 # @help
├── .cursor/skills/invoke-registry.md    # invoke catalog (maintainer)
├── .cursor/skills/rtl-coding-standards/ # @rtl-coding-standards (alias)
├── .cursor/rules/                       # always-on conduct
├── docs/standards/INDEX.md              # keyword → topic files (selective load)
├── docs/standards/spyglass-cdc/         # per-goal CDC summaries (@cdc)
├── docs/standards/spyglass-lint-fpga.md # Lint summary (@lint)
├── docs/standards/testbench-generation.md
├── docs/design/                         # your design guides + section router
├── docs/examples/                       # golden .v / .sv per topic
└── scripts/                             # install to ~/.cursor or project
```

## Maintainer

1. Add or edit standards under [docs/standards/](docs/standards/).
2. Update [docs/README.md](docs/README.md) and [docs/standards/INDEX.md](docs/standards/INDEX.md) when adding topics.

Designer install: [SETUP.md](SETUP.md). Content map: [AGENTS.md](AGENTS.md).
