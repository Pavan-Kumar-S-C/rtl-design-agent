# RTL Design Agent — team demo cheat sheet

**Before demo:** Install skills → reload Cursor → open one small `.sv` module → type `@help` first.

---

## Demo order (~15 min)

| # | Invoke | Paste this prompt |
|---|--------|-------------------|
| 0 | `@help` | `@help` |
| 1 | `@rtl-design` | `@rtl-design Review the open RTL module for latch inference, missing default cases, reset polarity, and synthesizability. List findings by severity.` |
| 2 | `@lint` | `@lint SpyGlass reports inferred latch on signal tx_valid. What is the root cause and what RTL change fixes it for lint_rtl sign-off?` |
| 3 | `@cdc` | `@cdc After check_cdc -type sync I get CDC_UNSYNC_ASYNCRESET. Explain the violation, which goal this belongs to, and the FPGA fix pattern.` |
| 4 | `@sdc` | `@sdc Write create_clock and set_input_delay for a 125 MHz Avalon-MM slave. Clock clk_125, reset rst_n active-low. Do not invent port names.` |
| 5 | `@timing-analysis` | `@timing-analysis Setup slack is -0.28 ns on a clk_a to clk_b path. What does it mean and what should I check in RTL vs constraints?` |
| 6 | `@testbench` | `@testbench Generate a self-checking SystemVerilog testbench for the open module: functional tests (reset, main path) and negative tests for each MAS assumption/failure. No false FAIL in the log.` |
| 7 | **Redirect test** | `@rtl-design I'm getting CDC_UNSYNC_ASYNCRESET — how do I fix it?` → expect redirect to `@cdc` |

**Optional (lifecycle):** `@rtl-design I have HAS/MAS in the workspace. Assess the project and offer RTL database generation. Do not generate RTL until DB is validated.`

---

## What to say between prompts

| Step | One line |
|------|----------|
| `@help` | Seven skills, one repo — each loads only its own docs. |
| `@rtl-design` | Company RTL rules, not generic internet Verilog. |
| `@lint` / `@cdc` | SpyGlass FPGA scope — tags, Tcl, fix patterns from our summaries. |
| `@sdc` vs `@timing-analysis` | Write constraints vs interpret reports — deliberately split. |
| `@testbench` | Self-checking TB: functional tests + negative tests per MAS assumptions/failures; no false FAIL. |
| Redirect test | Wrong invoke → redirect, not a mixed answer. |

---

## Why not a plain Cursor agent?

| Plain agent | RTL Design Agent |
|-------------|------------------|
| Guesses which docs to read | **Router** loads one matched topic / goal file |
| May invent clocks, ports, resets | **Ask when missing** — conduct rules |
| Mixes RTL, SDC, SpyGlass in one answer | **7 skills + deny lists** — hard boundaries |
| Generic “internet” RTL advice | **Your** standards, examples, UG summaries |
| Inconsistent prompts per engineer | Same **@invokes** every time |
| Hard to update team knowledge | **Git pull** + reinstall |

**Management one-liner:** Smart intern with your sign-off checklists and guardrails to stay in the right lane.

**Engineer one-liner:** `@cdc` gives Ch. 6 tags and Tcl — not a random lecture and not a made-up `create_clock`.

---

## Install (remind the room)

```powershell
git clone https://github.com/Pavan-Kumar-S-C/rtl-design-agent.git
cd rtl-design-agent
.\scripts\install-rtl-design-agent.ps1 -Local
```

Reload Cursor → `@help`
