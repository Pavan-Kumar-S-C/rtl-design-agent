# Register sources (SystemRDL / IP-XACT)

Add your register definitions here as **SystemRDL** (`.rdl`) or **IP-XACT**
(`.xml`). These are the **source of truth** for register fields and access.

The agent does not redefine registers in YAML; `rtl_db/register_map.yaml` only
indexes and traces requirements to the blocks defined here. Register RTL is
generated from these sources rather than hand-written.

This folder is registered in `paths.register_sources` in `rtl_db/index.yaml`.
