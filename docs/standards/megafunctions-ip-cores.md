# Altera / Intel IP cores and megafunctions (agent summary)

**Source:** *Introduction to Altera IP Cores* (UG-01056, doc **683102**, Quartus Prime **25.1**).

**Verbatim PDF:** [ug_intro_to_megafunctions-683102-848730.pdf](ug_intro_to_megafunctions-683102-848730.pdf)

**Keywords:** `megafunction`, `ip catalog`, `parameter editor`, `altera ip`, `intel ip`, `altfp`, `altera_mf`, `qip`, `ip`, `qsys`, `inferred ram`, `inferred fifo`, `dsp block`, `pll ip`

**Project RTL library (separate):** [rtl-macro-library.md](../design/rtl-macro-library.md) for `km_hssi_*` CDC cells — still **ask user** before use.

## Contents

- [Agent rule: IP megafunction vs custom RTL](#agent-rule-ip-megafunction-vs-custom-rtl)
- [What the IP Catalog provides](#what-the-ip-catalog-provides)
- [IP Catalog and Parameter Editor](#ip-catalog-and-parameter-editor)
- [Best practices](#best-practices)
- [Generate and instantiate in HDL](#generate-and-instantiate-in-hdl)
- [Licensing and upgrade](#licensing-and-upgrade)
- [Simulation](#simulation)

---

## Agent rule: IP megafunction vs custom RTL

When the task could use an **Altera IP Catalog** core or **inferred megafunction** (RAM, FIFO, DSP, PLL, etc.) from HDL templates:

1. Name the **likely IP Catalog / megafunction** path (e.g. “FIFO Intel FPGA IP”, “infer RAM via Insert Template”, “parameterized DSP”).
2. **Ask the user:** generate/use **IP Catalog megafunction (IP core)** or **custom/inferred RTL** (or project `km_hssi_*` library — see [rtl-macros.md](rtl-macros.md))?
3. Do **not** silently add `.v`/`.vhd` from `/quartus/libraries/megafunctions` or hand-copy generated IP without `.ip`/`.qip`/`.qsys`.
4. Skip the ask if the user already named the IP core or megafunction (e.g. “use FIFO Intel FPGA IP”).

**Two reuse layers (do not conflate):**

| Layer | Source | Examples |
|-------|--------|----------|
| Altera IP / megafunction | IP Catalog + Parameter Editor (this doc) | FIFO IP, PLL IP, inferred RAM templates (`altera_mf`) |
| Project CDC library | [rtl-macro-library.md](../design/rtl-macro-library.md) | `km_hssi_bitsync`, `km_hssi_async_fifo`, … |

---

## What the IP Catalog provides

Altera IP library categories (from UG):

- Basic Functions
- Memory
- Interfaces and Controllers
- Bridges and Adapters
- Processors and Peripherals
- DSP
- University Program
- Interface Protocols
- Verification

Access: **Tools → IP Catalog** (also **View → IP Catalog** in Platform Designer for system interconnect IP).

---

## IP Catalog and Parameter Editor

- Filter: **Show IP for active device family** or all device families.
- **Search** by full or partial IP name.
- **Double-click** IP → Parameter Editor → custom variation.
- **Quartus Prime Pro:** generates `<name>.ip` (auto-added to project).
- **Standard Edition:** generates `.qip` — you must add `.qip` to the project.
- **Platform Designer:** `.qsys` for system-generated IP.

**Naming:** no spaces in IP variation names or paths.

**Do not** manually edit `.qsys`, `.ip`, or `.qip` — use Quartus tools.

---

## Best practices

| Rule | Detail |
|------|--------|
| No spaces in IP output path | Generation fails or breaks upgrades |
| Use `.ip`/`.qip`/`.qsys` with generated HDL | Do not add only `.v`/`.vhd` without wrapper metadata — loses upgrade/parameter editor |
| Stable directory layout | Do not break relative path between `.qsys` and generation output |
| Do not use `/quartus/libraries/megafunctions` directly | Regenerate via IP Catalog each release |
| RAM/FIFO for current family | Do not reuse Quartus-generated RAM/FIFO files targeting **older** families (may not error but not optimized) |
| ROM `.mif`/`.hex` | Keep init files in same folder as `.qsys`/`.qip` |
| Simulation | Use **ip-setup-simulation** and **ip-make-simscript**; top-level script should **source** generated setup scripts, not hard-code generated file names |

---

## Generate and instantiate in HDL

**Flow (Pro Edition):**

1. Open project (`.qpf`).
2. **IP Catalog** → double-click IP → set top-level variation name → **OK**.
3. Parameter Editor → set options → generate synthesis (and optional simulation) files.

**Instantiate in HDL:** call IP module name; set parameters/`defparam` (Verilog) or `generic map` (VHDL). Include `altera_mf` libraries in VHDL when required.

**HDL templates (infer megafunctions):** **Edit → Insert template** → Verilog/VHDL → **Full Designs** → RAM, ROM, shift register, arithmetic, DSP optimized for device.

**Wrapper:** include generated `<variant>.v` or `<variant>.vhd` **and** project `.ip`/`.qip`. For third-party synthesis area/timing estimates, `<variant>_syn.v` may be used with wrapper in Quartus project.

**Scripting:** IP generation and `ip-setup-simulation` supported from command line (see PDF §1.5.2, §1.10.4).

---

## Licensing and upgrade

- **Evaluation mode** for unlicensed IP (time-limited, watermarked) — see §1.2.1.
- Check license status before production builds — §1.2.2.
- **Upgrade IP** when Quartus or IP version changes — §1.9; use Catalog replacement if IP deprecated.
- Command-line upgrade supported for many cores — §1.9.1.

---

## Simulation

- Enable **Generate IP simulation model when generating IP** (IP General Settings) when needed.
- **Tools → Generate Simulator Script for IP** (`ip-setup-simulation`) → combined script per simulator.
- Top-level TB should **source** combined script templates (names change after IP upgrade).
- **ip-make-simscript** for per-IP scripts merged into flow.
- F-tile designs: run Analysis & Elaboration and Support-Logic Generation before combined script generation (UG note).

---

## When to prefer IP Catalog vs project `km_hssi_*`

| Need | Prefer |
|------|--------|
| Vendor FIFO/RAM/PLL/DSP for Intel FPGA | IP Catalog (this doc) |
| km_xcvr CDC library cells, company sync FIFO | [rtl-macro-library.md](../design/rtl-macro-library.md) |
| Simple 2-flop sync, no vendor IP | Inline or `km_hssi_bitsync` (ask user) |

**Related:** [quartus-design-recommendations.md](quartus-design-recommendations.md) (HDL templates, infer multipliers), [timing-analyzer-ug.md](timing-analyzer-ug.md) (constraints on generated paths).
