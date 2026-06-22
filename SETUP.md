# RTL Design Agent — setup

## Prerequisites

- **Cursor** (not VS Code) with Agent chat
- **Git** access to this repository

## Repository

**Clone URL:** https://github.com/Pavan-Kumar-S-C/rtl-design-agent.git

**Browse:** https://github.com/Pavan-Kumar-S-C/rtl-design-agent

### Slim clone (recommended — no PDFs, ~2 MB vs ~70 MB)

PDFs in `docs/standards/` are optional (verbatim UG reference only). Agent skills use **markdown** summaries.

Windows (PowerShell):

```powershell
.\scripts\sparse-clone.ps1
# or clone elsewhere:
.\scripts\sparse-clone.ps1 -Destination C:\tools\rtl-design-agent
```

Linux / macOS:

```bash
bash scripts/sparse-clone.sh
bash scripts/sparse-clone.sh my-rtl-design-agent
```

On an **existing** full clone, drop PDFs from the working tree:

```powershell
.\scripts\apply-slim-docs-checkout.ps1
```

```bash
bash scripts/apply-slim-docs-checkout.sh
```

Restore PDFs later: `git sparse-checkout add docs/standards/*.pdf` — see [docs/standards/PDFs-README.md](docs/standards/PDFs-README.md).

Global install (`install-rtl-design-agent.ps1`) uses a **slim cache** by default. Full docs cache: `-IncludePdfDocs` / `--include-pdf-docs`.

## Available invokes

| Invoke | Purpose |
|--------|---------|
| `@help` | List all invoke names and what each does |
| `@rtl-design` | RTL write/review/lifecycle (alias `@rtl-coding-standards`) |
| `@timing-analysis` | STA, timing reports, MTBF |
| `@sdc` | SDC constraint files |
| `@cdc` | VC SpyGlass CDC verification (FPGA) |
| `@lint` | VC SpyGlass Lint (FPGA RTL) |
| `@testbench` | Self-checking simulation testbenches (alias `tb`) |

Type **`@help`** in Agent chat for the full list. Registry: `.cursor/skills/invoke-registry.md`.

## Where skills appear in Cursor

The agent is **not** a separate Cursor app — it is **skills + rules** that Cursor loads from specific folders.

| Setup | Folder Cursor reads | When it applies |
|-------|---------------------|-----------------|
| **A — Open agent repo** | `rtl-design-agent/.cursor/skills/rtl-design/` and `.cursor/rules/` | Only while **File → Open Folder** is `rtl-design-agent` |
| **B — Global install** (recommended for RTL projects) | `%USERPROFILE%\.cursor\skills\` (`rtl-design`, `timing-analysis`, `sdc`, `cdc`, `lint`, `testbench`, `help`, …) | **Any** folder you open in Cursor (GDR, SM, your block) |
| **C — Per-project link** | `your-rtl-project/.cursor/skills/rtl-design/` | Only that project workspace |

In **Agent** chat, type **`@help`** to see all invokes, or **`@rtl-design`** for RTL work. If skills are missing: run the install script, then **Developer: Reload Window**.

Standards markdown the agent reads live under **`rtl-design-agent/docs/standards/`** (via INDEX routing). With global install, skills symlink/copy from the cloned repo — keep the clone and run `git pull` + re-install after updates.

## Designer setup

### Option A — Open this repo

```bash
git clone https://github.com/Pavan-Kumar-S-C/rtl-design-agent.git rtl-design-agent
```

Windows (PowerShell):

```powershell
git clone https://github.com/Pavan-Kumar-S-C/rtl-design-agent.git rtl-design-agent
```

**Cursor:** File → Open Folder → `rtl-design-agent`

Skills load from `.cursor/skills/rtl-design/` automatically.

### Option B — Global install (any RTL project)

```bash
git clone https://github.com/Pavan-Kumar-S-C/rtl-design-agent.git rtl-design-agent
cd rtl-design-agent
bash scripts/install-rtl-design-agent.sh
```

Windows (PowerShell):

```powershell
git clone https://github.com/Pavan-Kumar-S-C/rtl-design-agent.git rtl-design-agent
cd rtl-design-agent
.\scripts\install-rtl-design-agent.ps1
```

Installs **`rtl-design`**, **`rtl-coding-standards`**, **`timing-analysis`**, **`sdc`**, **`cdc`**, **`lint`**, **`testbench`**, and **`help`** → `%USERPROFILE%\.cursor\skills\`

Restart Cursor. Use **`@help`** to list features; **`@rtl-design`** for RTL from any open folder.

Re-run the install script after `git pull` to refresh skills.

### Option C — Link into one project

```bash
git clone https://github.com/Pavan-Kumar-S-C/rtl-design-agent.git rtl-design-agent
cd /path/to/your-rtl-project
/path/to/rtl-design-agent/scripts/install-rtl-design-agent.sh --link-to-project
```

Windows (PowerShell):

```powershell
git clone https://github.com/Pavan-Kumar-S-C/rtl-design-agent.git rtl-design-agent
cd C:\path\to\your-rtl-project
C:\path\to\rtl-design-agent\scripts\install-rtl-design-agent.ps1 -LinkToProject
```

Creates `.cursor/skills/rtl-design` and `rtl-coding-standards` in that project.

Use **`--copy`** (or `-Copy`) if symlinks fail on NFS.

## Daily use

```text
@rtl-design Review this FSM for latch issues — use docs/standards/INDEX topics only.
```

The agent reads [docs/standards/](docs/standards/) before writing or reviewing RTL.

## Proxy (corporate network)

If `git clone` fails:

```bash
export http_proxy=http://proxy-dmz.altera.com:912
export https_proxy=http://proxy-dmz.altera.com:912
git clone https://github.com/Pavan-Kumar-S-C/rtl-design-agent.git rtl-design-agent
```

Windows (PowerShell):

```powershell
$env:http_proxy='http://proxy-dmz.altera.com:912'
$env:https_proxy='http://proxy-dmz.altera.com:912'
git clone https://github.com/Pavan-Kumar-S-C/rtl-design-agent.git rtl-design-agent
```

## Troubleshooting

| Issue | Fix |
|-------|-----|
| `@rtl-design` not in menu | Run install script; Reload Window; confirm `~/.cursor/skills/rtl-design/SKILL.md` exists |
| Need invoke list | Type `@help` in Agent chat |
| STA / timing reports | Use `@timing-analysis`, not `@rtl-design` |
| SDC constraint files | Use `@sdc`, not `@rtl-design` |
| SpyGlass CDC verification | Use `@cdc`, not `@rtl-design` |
| SpyGlass Lint | Use `@lint`, not `@rtl-design` |
| Simulation testbench | Use `@testbench`, not `@rtl-design` |
| Agent ignores standards | Add files under `docs/standards/`; check [docs/README.md](docs/README.md) index |
| Wrong project conventions | Paste module spec or point to local README in the prompt |

## Scope

This repo is only for **Verilog and SystemVerilog RTL** design and review (`@rtl-design`, `@rtl-coding-standards`). Other product agents, if any, live in their own repositories.
