# RTL database schema

Defines the structured database the **RTL Development & Verification** lifecycle creates and maintains in the **target project** (not this repo). See workflow: [.cursor/skills/rtl-design/dev-verify-workflow.md](../../.cursor/skills/rtl-design/dev-verify-workflow.md).

- Format: **YAML**, validated by **JSON Schema** (`rtl_db/schema/*.schema.json`).
- Registers: **not redefined** here — `register_map.yaml` indexes/traces to **SystemRDL** / **IP-XACT** sources, which remain the register source of truth.
- Reports: markdown under `rtl_db/reports/` (formats below).
- Templates: [templates/rtl-db/](../../templates/rtl-db/).

## Conventions

- **Stable IDs.** Requirement ids `REQ-xxxx`, never reused/renumbered. Mark removed items `status: obsolete`; do not silently delete.
- **No invented values.** Unknown fields use `TBD` and are surfaced to the user as questions.
- **Quote scalars that YAML may mis-coerce.** Addresses, hex, version-like, and id strings are quoted: `base_offset: "0x40"`. Enforced via JSON Schema `type: string` / `pattern`.
- **Schema header.** Each YAML starts with `# yaml-language-server: $schema=./schema/<file>.schema.json` for live editor validation.
- **Coverage rule.** A requirement counts as covered only when traceability reaches an RTL element (or a SystemRDL/IP-XACT register block).

## Files

### `rtl_db/index.yaml`

DB metadata, file manifest, and configurable paths the agent reads to locate inputs/outputs.

```yaml
# yaml-language-server: $schema=./schema/index.schema.json
version: "1.0"
project: "my_block"
generated_by: "rtl-design lifecycle"
paths:
  has_dir: "docs/has"
  mas_dir: "docs/mas"
  rtl_dir: "rtl"
  register_sources: ["regs"]
  standards_dir: "docs/standards"
  reports_dir: "rtl_db/reports"
files:
  - requirements.yaml
  - modules.yaml
  - register_map.yaml
  - traceability.yaml
```

### `rtl_db/requirements.yaml`

Requirements extracted from HAS/MAS.

```yaml
# yaml-language-server: $schema=./schema/requirements.schema.json
requirements:
  - id: "REQ-0001"
    source: "HAS §3.2"
    text: "Block exposes an Avalon-MM slave for configuration."
    category: "interface"        # interface|register|memory|clock|reset|parameter|protocol|constraint
    status: "active"             # active|obsolete|tbd
    derived: false
```

### `rtl_db/modules.yaml`

Design entities and their requirement links.

```yaml
# yaml-language-server: $schema=./schema/modules.schema.json
modules:
  - name: "cfg_csr"
    description: "Configuration/status register block."
    interfaces:
      - { name: "avmm_s", type: "avalon-mm", role: "slave" }
    parameters:
      - { name: "ADDR_W", value: "TBD" }
    clocks: ["clk"]
    resets: ["rst_n"]
    memories: []
    instantiated_macros_ip: []
    traces_to: ["REQ-0001"]
```

### `rtl_db/register_map.yaml`

Index/traceability into SystemRDL or IP-XACT sources — **not** a field-level redefinition.

```yaml
# yaml-language-server: $schema=./schema/register_map.schema.json
register_blocks:
  - block_name: "cfg_csr"
    source_type: "systemrdl"     # systemrdl|ipxact
    source_file: "regs/cfg_csr.rdl"
    base_offset: "0x0000"
    traces_to: ["REQ-0001"]
```

### `rtl_db/traceability.yaml`

Bidirectional links across the lifecycle.

```yaml
# yaml-language-server: $schema=./schema/traceability.schema.json
links:
  - requirement_id: "REQ-0001"
    db_entry: "modules/cfg_csr"          # modules/<name> | register_blocks/<block_name>
    rtl: "rtl/cfg_csr.sv"                  # file or module; empty until generated
    verification: "TBD"                    # test/assertion/report ref; TBD until verified
    status: "in_progress"                  # in_progress|covered|uncovered|conflict
```

## Report formats (`rtl_db/reports/`)

Markdown; skeletons in [templates/rtl-db/reports/](../../templates/rtl-db/reports/).

| Report | Purpose | Key content |
|--------|---------|-------------|
| `requirement-extraction-report.md` | Step 3 output | requirement list by category, sources, open `TBD` questions |
| `gap-analysis-report.md` | Step 5 output | missing / obsolete / incorrect-mapping / ambiguous tables |
| `traceability-matrix.md` | Step 7 output | requirement <-> db entry <-> RTL <-> verification table + coverage % |
| `rtl-generation-plan.md` | Step 6 pre-output | modules to generate/reuse, requirements satisfied, IP/macro choices |
| `rtl-verification-report.md` | Step 7 output | per-requirement pass/fail, uncovered requirements, implementation gaps |

## Maintainer

When you change the schema, update the matching `templates/rtl-db/schema/*.schema.json` and the example template YAML in the same change.
