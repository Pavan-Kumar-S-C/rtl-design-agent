# FSM coding

**Keywords:** `fsm`, `state machine`, `state`, `next state`, `two process`, `three process`, `default case`, `unreachable`

- Use **two-process or three-process** style:
  1. **State register** (sequential)
  2. **Next-state logic** (combinational)
  3. **Output logic** (combinational), optional separate block
- **Default cases** on all `case` statements; **`else`** on all meaningful `if` chains in combinational blocks to prevent latches.
- **No unreachable states** — review random input sequences; FSM must not hang in unreachable states.
- Power-up / reset must enter a **known state**; default settings must **not** enable debug/validation modes unintentionally.

**Examples:** [docs/examples/fsm/](../../examples/fsm/)
