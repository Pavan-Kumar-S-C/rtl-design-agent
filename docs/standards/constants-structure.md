# Constants, comments, and module structure

**Keywords:** `localparam`, `parameter`, `define`, `magic number`, `comment`, `module size`, `avmm`, `avalon`, `interface`, `bus`

- Define widths, delays, and limits with **`localparam`** or `` `define `` — **no magic numbers** in logic.
- Hard-coded values must be **consistent** with configuration parameters (cache size, addresses, rate, PL, etc.).
- Every logic block **>5 lines** needs an **intent** comment (what the hardware does), not a line-by-line narration.
- Keep submodules **focused**, **<150 lines** where practical; split when larger.
- Reuse existing standard interfaces (AVMM, Avalon-ST, project bus conventions) — do not invent parallel ad-hoc buses.
