# Topic: RTL database

**Load when keywords:** rtl database, db entry, requirement database, register map index, rtl_db

**Workflow:** [dev-verify-workflow.md](../dev-verify-workflow.md) — steps 4-5 (database management + gap analysis)

**Schema:** [docs/standards/rtl-database-schema.md](../../../../docs/standards/rtl-database-schema.md)

**Files (target project `rtl_db/`):** `index.yaml`, `requirements.yaml`, `modules.yaml`, `register_map.yaml`, `traceability.yaml` — validated by `schema/*.schema.json`.

**Registers:** index/trace to **SystemRDL / IP-XACT** sources; do **not** redefine fields in YAML.

**Templates:** [templates/rtl-db/](../../../../templates/rtl-db/)

**Ask user if:** verify-before-generate when both HAS/MAS and DB exist; offer DB generation when missing. Update DB only after approval of the gap report.
