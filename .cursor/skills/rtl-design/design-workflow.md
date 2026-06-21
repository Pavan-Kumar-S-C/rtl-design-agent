# Design workflow

**Start:** [topic-router.md](topic-router.md) — confirm topics with user if unclear.

## 0. Sources and doubts

- Apply [topic-router.md](topic-router.md): match INDEX rows, or **fallback** to guidelines + user input.
- **Ask the user** only if you have **doubts** (dialect, write vs review, missing ports/clocks/resets, CSR/CT22 in scope).
- If the prompt is broad but workable, proceed with dialect + synthesizability guidelines and what the user stated.

## 1. Spec intake

- Ports, clocks, resets, parameters — **from user or open spec**, not invented

## 2. Architecture

- Clock domains, CDC list — load [cdc-crossings.md](../../../docs/standards/cdc-crossings.md) only if CDC keywords match
- If **IP Catalog / megafunction** fits ([megafunctions-ip-cores.md](../../../docs/standards/megafunctions-ip-cores.md)): **ask** IP vs custom RTL
- If **`km_hssi_*` library macro** fits ([rtl-macro-library.md](../../../docs/design/rtl-macro-library.md)): **ask** macro vs inline (unless user already named it)

## 3. Implementation

- Load matched standards + [docs/examples/](../../../docs/examples/) only
- **MAS / ports / debug:** [mas-rtl-workflow.md](../../../docs/standards/mas-rtl-workflow.md) — `i_*`/`o_*` ports, MAS `§` comments, switch-controlled synthesizable debug (off by default)
- FSM: [fsm-coding.md](../../../docs/standards/fsm-coding.md) + `examples/fsm/`
- CDC with catalog match: confirm macro choice with user → then use `docs/examples/cdc/*_inst.sv` templates or inline per user answer

## 4. Handoff

- List open questions for user
