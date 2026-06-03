# Verilog vs SystemVerilog

**Keywords:** `verilog`, `systemverilog`, `sv`, `dialect`, `.v`, `.sv`, `1364`, `1800`, `logic`, `always_ff`

- **Match the open project dialect** — file extensions (`.v`, `.vh`, `.sv`, `.svh`), `module` style, and language features used in neighboring files.
- Do **not** introduce SystemVerilog-only constructs (`logic`, `always_ff`, `interface`, packages, etc.) into **Verilog-2001** (or earlier) files unless the user asks to migrate.
- Do **not** downgrade SystemVerilog modules to Verilog without explicit user request.
- Mixed projects: keep boundaries clear (no SV types in pure `.v` unless the project already does).
- Testbenches may use a richer dialect than RTL when the project allows it — follow local TB convention.

**Examples:** [docs/examples/dialect/](../../examples/dialect/)
