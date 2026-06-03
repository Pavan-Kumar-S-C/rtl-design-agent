# Security and debug (CT22 manual review)

**Keywords:** `ct22`, `security`, `debug`, `lock`, `fuse`, `zeroization`, `backdoor`, `power-up`, `validation mode`

When IP has security/debug claims, verify in review (N/A items skip with reason):

| Area | Check |
|------|--------|
| FSM | Reachable states; default state; no hang on random sequences |
| Conditionals | Default on `case`; intentional missing `else` documented |
| Power-up | Known pin/register values; debug not enabled by default |
| Debug ports | Gated (e.g. parameter-gated debug); disabled/locked from unauthorized access; classify debug signal levels |
| Secure paths | Access protection on config/debug/firmware paths; no unintended backdoors |
| Keys / sensitive data | Secure storage, partial-write protection, zeroization after use (if feature exists) |
| Locks / fuses | Lock behavior after set; reset domain not attacker-controlled |
| Input validation | Untrusted input cannot violate bounds or force illegal states |

Reference: company CT22 conduct manual code reviews (Q21.1) — apply items relevant to the block under review.

**When applicable only** — **ask** the user if CT22/security review is in scope before applying this table.
