# Metastability and MTBF (RTL + Quartus)

**Keywords:** `metastability`, `mtbf`, `metastable`, `synchronizer chain`, `bitsync3`, `3-flop`, `3-stage`, `settling time`, `toggle rate`

## Quick rules

| Situation | Guidance |
|-----------|----------|
| Single-bit async → sync clock | Minimum **2-flop** chain (`km_hssi_bitsync`); use **3-flop** (`km_hssi_bitsync3`) for critical paths or when Quartus MTBF report is low |
| Multi-bit unrelated clocks | **Never** sample a bus with a plain 2-flop chain; use handshake, gray FIFO, or library `vecsync` / `async_fifo` |
| Quartus MTBF / STA | Full procedure: [quartus-design-recommendations.md](quartus-design-recommendations.md) §3 |
| Intentional synchronizer | `SYNCHRONIZER_IDENTIFICATION FORCED` + preserve/merge attributes — [synchronizer_attributes.sv](../examples/cdc/synchronizer_attributes.sv) |
| Not a synchronizer | `SYNCHRONIZER_IDENTIFICATION OFF` on datapath registers (e.g. multi-bit CDC buses, PPM math) |

## 2-flop vs 3-flop (project)

From [cdc-reusable-patterns.md §1.2](../design/cdc-reusable-patterns.md):

- **`km_hssi_bitsync`:** standard 2-stage bit synchronizer.
- **`km_hssi_bitsync3`:** higher-MTBF triple-flop; gray-code checks for DV metastability injection on multi-bit sources.

From Quartus Design Recommendations (683082): designers commonly use **two** registers; **three** provides better metastability protection. If MTBF is still insufficient at high clock/data rates, **add another stage** (latency trade-off).

## MTBF (tooling)

- MTBF is a **statistical estimate** of time between metastability failures — set targets in **system** context.
- Requires correct **timing constraints** and synchronizer chains that **meet timing**; otherwise reports omit MTBF.
- Default toggle-rate assumption: **12.5%** of source clock — override for reset synchronizers and slow-changing controls.
- See [quartus-design-recommendations.md §3.2–3.4](quartus-design-recommendations.md).
- **Timing Analyzer:** `report_metastability`, clock transfer reports — [timing-analyzer-ug.md §2.5](timing-analyzer-ug.md).

## Related design analysis

- Legacy vs modern ToD: [architecture-comparison.md §4](../design/architecture-comparison.md)
- Legacy IP CDC deep dive: [legacy-tod-sync-analysis.md](../design/legacy-tod-sync-analysis.md)
