# Recommended target-project layout

The RTL Development & Verification agent offers to scaffold this layout in a
**New Project** (it asks first and never overwrites). For Partial/Existing
projects it instead detects your real locations and records them in
`rtl_db/index.yaml` `paths:`.

```text
docs/has/   # HAS documents (input)
docs/mas/   # MAS documents (input)
regs/       # SystemRDL / IP-XACT register sources (input)
rtl/        # RTL source (existing + generated, gated)
rtl_db/     # agent-managed database + reports (see templates/rtl-db/)
```

All locations are configurable via `rtl_db/index.yaml`. See
[../rtl-db/](../rtl-db/) for the database and report templates, and
[docs/standards/rtl-database-schema.md](../../docs/standards/rtl-database-schema.md)
for the schema.
