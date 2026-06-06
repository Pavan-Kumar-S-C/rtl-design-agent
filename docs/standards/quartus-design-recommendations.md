# Quartus Prime Design Recommendations (agent summary)

**Source:** Intel/Altera *Quartus Prime Pro Edition User Guide: Design Recommendations* (UG-20131, doc **683082**, Quartus Prime **25.1**).

**Verbatim PDF (opt-in):** [Design Recommendations.pdf](Design%20Recommendations.pdf)

**Keywords:** `quartus`, `altera_attribute`, `synchronizer identification`, `metastability`, `mtbf`, `preserve register`, `dont merge`, `timing analyzer`, `report_metastability`, `synchronizer chain`

**Do not invent** assignment values or MTBF numbers not stated here or in the PDF.

## Contents

- [1. HDL coding styles (overview)](#1-hdl-coding-styles-overview)
- [2. Recommended design practices (overview)](#2-recommended-design-practices-overview)
- [2.2.6 Managing design metastability (overview)](#226-managing-design-metastability-overview)
- [3. Managing metastability with Quartus Prime](#3-managing-metastability-with-quartus-prime)
- [3.1 Metastability analysis](#31-metastability-analysis)
- [3.1.1 Data synchronization register chains](#311-data-synchronization-register-chains)
- [3.1.2 Identify synchronizers](#312-identify-synchronizers)
- [3.1.3 Timing constraints and synchronizer ID](#313-timing-constraints-and-synchronizer-id)
- [3.2 Metastability and MTBF reporting](#32-metastability-and-mtbf-reporting)
- [3.3 MTBF optimization](#33-mtbf-optimization)
- [3.4 Reducing metastability effects](#34-reducing-metastability-effects)
- [3.5 Scripting (Tcl)](#35-scripting-tcl)

---

## 1. HDL coding styles (overview)

Chapter 1 covers templates, IP instantiation, inferred DSP/memory/FIFO, register/latch guidelines, and general coding (tri-state, clock mux, FSM, counters, low-level primitives).

**Agent use:** Match keywords `hdl template`, `infer ram`, `infer fifo`, `register power-up`, `latch` → read the corresponding section in the PDF Contents (pages 4–68).

**CDC-related excerpt:** Example synchronizer modules use `/* synthesis preserve dont_replicate */` on synchronizer flops; unrelated RAM blocks may use `SYNCHRONIZER_IDENTIFICATION OFF` so they are **not** treated as synchronizers.

---

## 2. Recommended design practices (overview)

Chapter 2 covers synchronous design practices, combinational/clock/power optimization, Design Assistant DRC, and embedded RAM.

**Agent use:** Keywords `design assistant`, `synchronous design`, `clock mux`, `global clock` → PDF chapter 2.

---

## 2.2.6 Managing design metastability (overview)

Synchronization of asynchronous signals can cause metastability. Quartus Prime can analyze **mean time between failures (MTBF)** due to metastability. A **high metastability MTBF** indicates a more robust design.

**Related (full detail):** [§3 Managing metastability with Quartus Prime](#3-managing-metastability-with-quartus-prime).

**RTL practice (from same guide, design-practices chapter):**

- Use a **synchronization register chain** in the destination clock domain (commonly **two** registers; **three** gives better protection).
- Place synchronizer registers **close together** in the device to minimize interconnect delay, improve settling time, and **increase MTBF**.
- Ensure follower registers are not subject to optimizations that merge or retime them away.

**Project patterns:** [docs/design/cdc-reusable-patterns.md](../design/cdc-reusable-patterns.md), [docs/examples/cdc/](../examples/cdc/).

---

## 3. Managing metastability with Quartus Prime

Quartus Prime analyzes and optimizes **MTBF** for transfers between unrelated or asynchronous clock domains. Features require **Timing Analyzer** constraints (typical and worst-case MTBF for select families).

### Concepts

- **Metastable state:** Output may hover between valid levels; `tCO` is violated; downstream registers may capture **different** values.
- **MTBF:** Statistical estimate of average time between metastability-induced failures. Target MTBF is **system-dependent**; calculations are **estimates**.
- **Synchronization register / synchronizer:** First register(s) in the new clock domain that resample an asynchronous or unrelated-clock signal.

---

## 3.1 Metastability analysis

The **first register** in the destination domain on an async/unrelated-clock path is the synchronization register.

Designers typically use **two** synchronizer stages; **three** is a common standard for better protection.

Timing Analyzer reports **per-synchronizer MTBF** (when requirements are met) and can estimate **design-wide MTBF**. Use reports to decide if chains must be lengthened.

---

## 3.1.1 Data synchronization register chains

A **synchronization register chain** must satisfy:

1. All registers clocked by the **same** clock or **phase-related** clocks.
2. The **first** register is driven **asynchronously** or from an **unrelated** clock domain.
3. Each register fans out to **only one** register, except the **last** in the chain.
4. Registers in the chain must **not include resets** (for Quartus to identify the chain).

**Chain length:** Number of registers in the destination domain meeting the above.

**Available settling time:** Sum of register-to-register **output slacks** in the chain; more settling time (more stages or more slack) **improves MTBF**.

---

## 3.1.2 Identify synchronizers

Enable metastability MTBF analysis by identifying synchronizer chains.

- Global: **Settings → Timing Analyzer → Synchronizer identification** (Auto lists possible synchronizers).
- Altera/Intel FPGA IP often includes pre-identified chains.

---

## 3.1.3 Timing constraints and synchronizer ID

MTBF is computed only if the synchronizer chain **meets timing**. Slack in synchronizer register-to-register paths is the **available settling time**.

- Apply **real application frequency** constraints for meaningful MTBF.
- **Auto** and **Forced If Asynchronous** use timing constraints to detect transfers between unrelated domains — clock domains must be related correctly.
- **Input ports** are treated as asynchronous unless associated with a clock domain.
  - Use `set_input_delay -clock <clk> ...` on synchronous ports; `set_max_delay` alone does not associate a port with a clock for synchronizer ID.
- Registers at the end of **false paths** may be identified as synchronizers; if incorrect, set **Synchronizer Identification = Off** on the first register of that chain.

---

## 3.2 Metastability and MTBF reporting

Results appear in **Compilation Report** and **Timing Analyzer** reports. MTBF uses timing/structure, silicon characteristics, operating conditions, and **data toggle rate**.

After changing synchronizer identification settings: **rerun Fitter**, then rerun Timing Analyzer for updated MTBF.

### Auto vs forced identification

- **Auto only:** Lists likely synchronizers; may **not** report per-chain MTBF.
- **Forced identification** on synchronization registers: required to obtain MTBF per chain.
- If timing is not met: synchronizers may be listed **without** MTBF.

### MTBF Summary

Estimates overall robustness of cross-clock and asynchronous transfers using all chains in the design.

### Synchronizer data toggle rate

MTBF calculations assume synchronized data toggles at **12.5%** of the **source clock frequency** unless overridden.

For reset synchronizers, specify **toggle_rate** explicitly when the default is wrong.

---

## 3.3 MTBF optimization

**Optimize Design for Metastability** (default ON): **Assignments → Settings → Compiler Settings → Advanced Settings (Fitter)**.

```tcl
set_global_assignment -name OPTIMIZE_FOR_METASTABILITY <ON|OFF>
```

Fitter places/routes identified synchronizers to increase **output setup slack** (settling time), improving MTBF. Synthesis does not perform optimizations that reduce MTBF on protected synchronizer registers.

### 3.3.1 Synchronization register chain length

**SYNCHRONIZATION_REGISTER_CHAIN_LENGTH** (default **3**): how many registers in each identified chain are **protected** from MTBF-reducing optimizations and **optimized** for metastability.

- Example: length **2** → first two registers in each chain protected/optimized.
- Set to the **maximum chain length** in the design so all synchronizer registers are covered.

```tcl
set_global_assignment -name SYNCHRONIZATION_REGISTER_CHAIN_LENGTH <N>
set_instance_assignment -name SYNCHRONIZATION_REGISTER_CHAIN_LENGTH <N> -to <first_register_or_instance>
```

(Global: **Advanced Settings (Synthesis)**; per-chain: Assignment Editor on **first** register of chain.)

---

## 3.4 Reducing metastability effects

Use Metastability Summary to compare against system targets.

### 3.4.1 System-centric timing constraints

- Use **Timing Analyzer** with complete, correct constraints.
- Prefer **system-centric I/O** constraints over FPGA-only shortcuts.
- Use **`set_input_delay`** (not only `set_max_delay`) to tie input ports to clock domains.

### 3.4.2 Force identification of synchronization registers

| Setting | Use |
|---------|-----|
| **Forced If Asynchronous** | Default forced analysis for async/unrelated paths |
| **Forced** | Register looks synchronous but should be analyzed |
| **Off** | Not a synchronizer (e.g. end of false path, multi-bit bus wrongly flagged) |

Use global **Auto** first to discover chains, then refine per register.

**Verilog `altera_attribute` (example from guide):**

```verilog
(* altera_attribute = "-name SYNCHRONIZER_IDENTIFICATION OFF" *) reg [20:0] ppm_diff;
```

**Library pattern (project):** `SYNCHRONIZER_IDENTIFICATION FORCED`, `DONT_MERGE_REGISTER`, `PRESERVE_REGISTER` on intentional synchronizers — see [docs/examples/cdc/synchronizer_attributes.sv](../examples/cdc/synchronizer_attributes.sv).

### 3.4.3 Synchronizer data toggle rate

Specify realistic toggle rates via Assignment Editor or Tcl (25.1+: **double** type for decimal rates).

### 3.4.4–3.4.7 Other mitigations

- Turn on **Optimize Design for Metastability**.
- Increase **Synchronization Register Chain Length** to max chain in design.
- Add **extra synchronizer stages** if reported MTBF is too low (adds latency).
- Faster speed grade can help (device-dependent).

---

## 3.5 Scripting (Tcl)

```tcl
set_global_assignment -name SYNCHRONIZER_IDENTIFICATION <OFF|AUTO|"FORCED IF ASYNCHRONOUS">
set_instance_assignment -name SYNCHRONIZER_IDENTIFICATION <AUTO|"FORCED IF ASYNCHRONOUS"|FORCED|OFF> -to <register_or_instance>
set_instance_assignment -name SYNCHRONIZER_TOGGLE_RATE <transitions_per_second> -to <register>
```

**report_metastability** — generate metastability reports outside the GUI (see PDF §3.5.3 for options).

**Help:** `quartus_sh --qhelp`

---

## Cross-links

| Topic | Doc |
|-------|-----|
| 2ff vs 3ff / `bitsync3` | [metastability-mtbf.md](metastability-mtbf.md), [cdc-reusable-patterns.md §1.2](../design/cdc-reusable-patterns.md) |
| SDC / `report_metastability` / CDC constraints | [timing-analyzer-ug.md](timing-analyzer-ug.md) |
| IP Catalog / megafunctions | [megafunctions-ip-cores.md](megafunctions-ip-cores.md) |
| Legacy ToD sync anti-patterns | [legacy-tod-sync-analysis.md](../design/legacy-tod-sync-analysis.md) |
| Coverage matrix | [COVERAGE.md](../COVERAGE.md) |
