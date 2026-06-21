# MAS outline — `<module_or_block_name>`

**HAS reference:** `<HAS doc §>`  
**Revision:** `<date / version>`  
**Author:**

---

## 1. Scope

- Purpose:
- Clock domains:
- Reset(s):
- Top-level interfaces:

## 2. Assumptions

| ID | Assumption | If violated |
|----|------------|-------------|
| A1 | | |

## 3. Failure and unexpected behavior

| ID | Condition | Symptom | Detection / debug |
|----|-----------|---------|-------------------|
| F1 | | | |

## 4. Functional description

### 4.1 `<subsection>`

(Implementation detail for RTL — FSM states, pipeline stages, handshakes.)

## 5. Debug strategy

| ID | MAS § | Signal / counter | Enable | Default |
|----|-------|------------------|--------|---------|
| D1 | | | `i_dbg_enable` or `` `ifdef `` | **off** |

Rules: debug logic **synthesizable**, present in hardware, **no functional impact** when disabled.

## 6. Port list (RTL naming)

| Direction | Name | Width | Description |
|-----------|------|-------|-------------|
| input | `i_` | | |
| output | `o_` | | |
