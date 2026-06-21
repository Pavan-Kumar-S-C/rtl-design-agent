# Topic: MAS and RTL implementation

**Load when keywords:** mas, micro architecture, assumption, failure mode, debug logic, mas section, i_ port, o_ port, port naming (write/update RTL)

**Standard:** [docs/standards/mas-rtl-workflow.md](../../../../docs/standards/mas-rtl-workflow.md)

**Also load when:** HAS/MAS lifecycle — [topics/requirements.md](requirements.md) + [dev-verify-workflow.md](../dev-verify-workflow.md)

**Do:**

- After HAS review → prepare/update MAS before RTL
- RTL comments reference MAS `§` sections
- Inputs `i_*`, outputs `o_*` on write/update
- Synthesizable debug logic, switch-controlled, off by default

**Ask user if:** MAS missing but RTL requested; debug enable mechanism not specified; legacy port names conflict with `i_`/`o_` convention.
