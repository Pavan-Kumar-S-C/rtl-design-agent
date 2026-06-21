# Optional Quartus helper scripts

Use when the user’s FPGA workspace already has a **`.qpf`** and **qshell** (or Quartus on PATH).

The agent normally runs Quartus **directly** in the project directory — no `quartus/module_build/` copy of RTL.

```powershell
# From the directory that contains design.qpf:
..\..\scripts\quartus\module-build.ps1 -ProjectDir . -Phase synth
```

`resolve-quartus.ps1` is a fallback when qshell is not active (`QUARTUS_ROOT` or `rtl_db` `implementation.quartus_bin`).

See [docs/standards/quartus-module-build.md](../../docs/standards/quartus-module-build.md).
