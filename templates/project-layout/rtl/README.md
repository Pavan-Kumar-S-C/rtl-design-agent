# RTL source

RTL source files (`.v` / `.sv`) live here — both existing modules and
agent-generated RTL.

RTL generation is **gated**: the agent generates only from a validated RTL
database, reuses existing RTL where possible, and avoids duplicate
functionality. Generated files are linked back to requirements in
`rtl_db/traceability.yaml`.

This folder is registered as `paths.rtl_dir` in `rtl_db/index.yaml`.
