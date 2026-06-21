# Topic: Quartus module build (synthesis)

**Load when keywords:** `quartus`, `synthesis`, `compile`, `qpf`, `qsf`, `qshell`, `quartus_map`, `analysis and synthesis` — **and** the user **explicitly** requested a Quartus step.

**Standard:** [docs/standards/quartus-module-build.md](../../../../docs/standards/quartus-module-build.md)

**Use workspace as-is:** RTL stays where it is; run Quartus from the user’s existing `.qpf` directory when **qshell** / PATH has `quartus_*`. **Do not** create `quartus/module_build/` by default.

**Out of scope:** fit, STA, timing reports → `@timing-analysis`. `.sdc` → `@sdc`.

**Ask if missing:** which `.qpf`, device/part (if not in `.qsf`), top entity.

**Never:** run Quartus after RTL-only tasks unless user asks.
