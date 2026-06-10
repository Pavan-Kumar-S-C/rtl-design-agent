# Topic: Traceability & verification

**Load when keywords:** traceability, traceability matrix, coverage, gap analysis, verify rtl, uncovered requirement, consistency check

**Workflow:** [dev-verify-workflow.md](../dev-verify-workflow.md) — steps 5 and 7 (gap analysis + RTL verification)

**Schema:** [docs/standards/rtl-database-schema.md](../../../../docs/standards/rtl-database-schema.md) (`traceability.yaml`)

**Links:** requirement <-> db entry <-> RTL <-> verification artifact. A requirement is covered only when traceability reaches an RTL element (or SystemRDL/IP-XACT register block).

**Outputs:** gap analysis report, traceability matrix, RTL verification report ([templates](../../../../templates/rtl-db/reports/)).

**Stop and present discrepancies** when requirements and RTL disagree — do not continue generation.
