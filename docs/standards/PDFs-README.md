# Optional PDFs (verbatim Intel / Synopsys user guides)

Agent skills use **markdown summaries** in this directory. PDFs are **not required** for `@rtl-design`, `@timing-analysis`, `@sdc`, `@cdc`, or `@lint`.

| PDF | Use |
|-----|-----|
| `VC_SpyGlass_CDC_UserGuide.pdf` | Opt-in per-tag CDC reference |
| `vc_spyglass_lint_userguide.pdf` | Opt-in lint tag reference |
| `Timing Analyser UG.pdf` | Opt-in full Timing Analyzer wording |
| `Timing analyser CookBook.pdf` | Opt-in cookbook Tcl (e.g. JTAG) |
| `Design Recommendations.pdf` | Opt-in full Quartus Design Rec |
| `ug_intro_to_megafunctions-683102-848730.pdf` | Opt-in megafunctions UG |

## Slim clone (default — no PDFs)

```powershell
.\scripts\sparse-clone.ps1
```

Or on an existing clone:

```powershell
.\scripts\apply-slim-docs-checkout.ps1
```

## Get PDFs later (full checkout of PDFs only)

From a slim clone:

```powershell
git sparse-checkout add docs/standards/*.pdf
# or
git checkout main -- docs/standards/*.pdf
```

You can decide later whether to use Git LFS, a release bundle, or keep PDFs in git for full clones.
