# RTL review checklist

Use [topic-router.md](topic-router.md): load **only** checklist sections whose topics matched the user prompt.

## Pre-review (always)

- [ ] Coding guidelines + user brief used; design sections loaded only when INDEX matched or user named them
- [ ] **Asked user** only if doubts remained (dialect, scope, spec gaps)
- [ ] Spec from user or open RTL — not invented
- [ ] Dialect matches project (`.v` vs `.sv`)

## Per topic (check only if that topic was loaded)

### Synth / lint — [synthesizability-lint.md](../../../docs/standards/synthesizability-lint.md)

- [ ] No latch inference; full `case` / `else` in comb blocks
- [ ] No `#delay` in synth logic

### FSM — [fsm-coding.md](../../../docs/standards/fsm-coding.md)

- [ ] Two/three-process style; known reset state
- [ ] `default` on all `case`

### CDC — [cdc-crossings.md](../../../docs/standards/cdc-crossings.md)

- [ ] Crossings commented; 2-flop / FIFO per case
- [ ] If catalog macro applies: user chose **library macro** vs **inline** ([rtl-macros.md](../../../docs/standards/rtl-macros.md)); no silent `km_hssi_*` without intent

### Clocks / resets — [clocks-resets.md](../../../docs/standards/clocks-resets.md)

- [ ] Reset polarity documented; sync release where required

### CSR — [csr-registers.md](../../../docs/standards/csr-registers.md) *(only if user confirmed CSR scope)*

- [ ] Attributes per spec; no invented addresses

### CT22 — [ct22-security-debug.md](../../../docs/standards/ct22-security-debug.md) *(only if user confirmed CT22 scope)*

- [ ] Table rows marked N/A or checked

## Close-out

- [ ] Cited standard files used
- [ ] Open questions listed — no guessed implementation
