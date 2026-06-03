# Topic: Quartus metastability / MTBF

**Load when keywords:** quartus, altera_attribute, synchronizer identification, mtbf, metastability, report_metastability, synchronizer chain, optimize for metastability, toggle rate

**Standard (read matched section only):** [docs/standards/quartus-design-recommendations.md](../../../../docs/standards/quartus-design-recommendations.md)

**Bridge:** [docs/standards/metastability-mtbf.md](../../../../docs/standards/metastability-mtbf.md)

**Examples:** [docs/examples/cdc/synchronizer_attributes.sv](../../../../docs/examples/cdc/synchronizer_attributes.sv), [bitsync3_inst.sv](../../../../docs/examples/cdc/bitsync3_inst.sv)

**Verbatim PDF:** [docs/standards/Design Recommendations.pdf](../../../../docs/standards/Design%20Recommendations.pdf) — only when user asks for full UG wording.

**Also load when:** reviewing Intel/Altera synchronizer attributes on project cells — plus [topics/cdc.md](cdc.md) for CDC primitives; SDC / `report_metastability` — [topics/timing-analyzer.md](timing-analyzer.md).

**Ask user if:** device family, Quartus version, or whether MTBF report vs RTL fix is the goal.
