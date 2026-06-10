# Topic: Requirements (HAS/MAS)

**Load when keywords:** has, mas, requirement, spec intake, extract requirements, requirement model

**Workflow:** [dev-verify-workflow.md](../dev-verify-workflow.md) — step 3 (requirement analysis)

**Schema:** [docs/standards/rtl-database-schema.md](../../../../docs/standards/rtl-database-schema.md) (`requirements.yaml`)

**Do:** extract only from provided HAS/MAS; categorize (interface/register/memory/clock/reset/parameter/protocol/constraint); flag unknowns as `TBD`.

**Output:** requirement extraction report ([template](../../../../templates/rtl-db/reports/requirement-extraction-report.md)).

**Ask user if:** HAS/MAS location unknown, scope unclear, or a requirement is ambiguous — never invent.
