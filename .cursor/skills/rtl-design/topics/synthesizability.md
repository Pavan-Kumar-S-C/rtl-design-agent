# Topic: Synthesizability and lint

**Load when keywords:** synth, latch, verilator, combinational, initial, #delay (RTL coding rules)

**Standard:** [docs/standards/synthesizability-lint.md](../../../../docs/standards/synthesizability-lint.md)

**Do not load under `@rtl-design`:** SpyGlass Lint flow / `check_lint` / tag debug → invoke **`@lint`** instead ([rtl-design-exclusions.md](../rtl-design-exclusions.md)).

**Examples:** [docs/examples/comb/](../../../../docs/examples/comb/)

**Ask user if:** whether the block must be fully synthesizable or TB-only.
