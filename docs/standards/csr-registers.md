# Registers and CSR

**Keywords:** `csr`, `register`, `mmio`, `avmm`, `ro`, `wo`, `rc`, `w1c`, `memory map`, `alias`

- Document registers and attributes (RO, WO, RC, W1C, etc.) — implement per spec.
- Initialize registers and memory to **known state** before use; clear sensitive data after use when security applies.
- Memory regions **alias-free**; boundary-check addresses; mirrored ranges get same protection.

**When applicable only** — if the user did not mention CSR/register work, **ask** whether this standard applies before using it.
