# Legacy ToD Synchronizer CDC Analysis (`altera_eth_1588_tod_synchronizer`)

**Scope:** Clock-domain crossing, control signaling, metastability, and Quartus synchronizer handling in the legacy Ethernet 1588 ToD synchronizer IP.

**Compare with:** [architecture-comparison.md](architecture-comparison.md), [km-xcvr-tod-analysis.md](km-xcvr-tod-analysis.md), [cdc-reusable-patterns.md](cdc-reusable-patterns.md).

## Contents

- [1. Overview](#1-overview)
- [2. Clock domains](#2-clock-domains)
- [3. Multi-bit bus CDC](#3-multi-bit-bus-cdc)
- [4. Toggle and control signaling](#4-toggle-and-control-signaling)
- [5. Metastability and Quartus attributes](#5-metastability-and-quartus-attributes)
- [6. Data integrity](#6-data-integrity)
- [7. Risk summary and migration](#7-risk-summary-and-migration)
- [8. References](#8-references)

---

## 1. Overview

The legacy `altera_eth_1588_tod_synchronizer` moves a full ToD snapshot and checksum between **independent** master/slave clocks (and optionally a third sampling clock in modes 0–15). The replacement `km_xcvr_mps_tod_counter` runs **single-domain** and limits CDC to a **1-bit** externally synchronized reference.

---

## 2. Clock domains

| Domain | Role |
|--------|------|
| `clk_master` | Source ToD, checksum generation, toggle master |
| `clk_slave` | Samples `transfer_bus`, edge-detects toggle |
| `clk_sampling` (modes 0–15) | Phase accumulation via gray FIFO |

**Issue:** Multiple unrelated domains increase constraint surface and metastability exposure versus one SerDes word clock.

---

## 3. Multi-bit bus CDC

**112-bit path:** 96-bit ToD + 16-bit checksum on `transfer_bus` crosses `clk_master` → `clk_slave` as a **plain two-register chain** in the slave domain (`reception_bus0` → `reception_bus1`), not per-bit synchronizers:

```verilog
// tod_sync_clk_align.sv — slave side (conceptual)
reception_bus0 <= transfer_bus_delayed;
reception_bus1 <= reception_bus0;
```

**Protection relied upon:**

- Physical SDC (`set_net_delay`, `set_max_skew`) for routing proximity
- Master holding data stable for several clock periods before sample
- Post-hoc **checksum** compare

**Not present:** req/ack handshake, gray encoding on the data bus, or hold-off until safe capture.

**Quartus implication:** These datapath registers are **not** valid synchronizer chains (multi-bit independent metastability per bit). Do **not** mark them `SYNCHRONIZER_IDENTIFICATION FORCED`. See [quartus-design-recommendations.md §3.1.1](../standards/quartus-design-recommendations.md).

---

## 4. Toggle and control signaling

- `toggle_transfer` uses the **same** 2-flop path as the data bus; edge detect: `toggle = toggle_bit_slave ^ toggle_bit_slave_old`.
- **Both-edge** sensitivity can amplify synchronizer asymmetry between rising and falling toggles.
- Multiple control signals (`start_tod_sync`, `reset_master`, `init_count`, `start_count`, `stop_count`) each use dedicated bit synchronizers and ad-hoc FSM sequencing across domains.

**Modern pattern:** Single `i_ref_signal` with configurable rising-only or toggle mode and deterministic `active_tick` pipeline — see [km-xcvr-tod-analysis.md](km-xcvr-tod-analysis.md).

---

## 5. Metastability and Quartus attributes

### Weak multi-bit sync

112-bit parallel sampling allows **per-bit** metastability; checksum is **probabilistic** and can miss correlated corruption.

### `SYNCHRONIZER_IDENTIFICATION OFF` on datapath

Legacy design marks some cross-domain math registers OFF so Quartus does **not** treat them as synchronizers (correct for non-synchronizer datapath):

```verilog
(* altera_attribute = {" -name SYNCHRONIZER_IDENTIFICATION OFF "} *) reg [20:0] ppm_diff;
```

### Proper single-bit sync

Control paths use `_std_synchr_nocut` (2–3 flops) with **`SYNCHRONIZER_IDENTIFICATION FORCED`**. Phase readback uses a 6-stage clock crosser — not on the main ToD transfer path.

### Async FIFO (modes 0–15)

Gray pointers with 2-flop `bitsync` — the **only** structurally sound multi-bit CDC in the legacy IP for that path.

**Tooling:** For intentional synchronizers and MTBF reporting, follow [quartus-design-recommendations.md §3](../standards/quartus-design-recommendations.md) and [metastability-mtbf.md](../standards/metastability-mtbf.md).

---

## 6. Data integrity

Valid transfer: `tod_valid = toggle_ok & chks_ok & state_ok` (IDL → WAIT → TRANSFER FSM).

On checksum failure: slave **holds previous value** — no error flag or retry.

**Modern approach:** No multi-bit CDC; sample-and-hold on tick; software coherent status snapshot; named error signals and `o_sync_done` masking.

---

## 7. Risk summary and migration

| Risk | Legacy | Recommended direction |
|------|--------|------------------------|
| Multi-bit metastability | High (112-bit 2-flop) | Eliminate bus CDC or use `vecsync` / FIFO |
| MTBF visibility | Mixed OFF/FORCED attributes | FORCED on true synchronizers only |
| Control complexity | Many synced FSM signals | Single ref + tick pipeline |
| Lab debug | Silent checksum fail | Explicit status/errors |

Use [cdc-reusable-patterns.md §7 Selection Guide](cdc-reusable-patterns.md) for replacement primitives.

---

## 8. References

- [architecture-comparison.md](architecture-comparison.md)
- [cdc-reusable-patterns.md](cdc-reusable-patterns.md)
- [quartus-design-recommendations.md](../standards/quartus-design-recommendations.md)
- Example legacy toggle detect: [docs/examples/cdc/legacy_tod_toggle_detect.v](../examples/cdc/legacy_tod_toggle_detect.v)
