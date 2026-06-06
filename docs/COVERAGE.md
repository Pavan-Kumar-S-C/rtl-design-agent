# Doc-to-skill coverage matrix

Tracks mapping: **source section → INDEX row → skill topic → example file**.

**Legend:** `full` = section + INDEX + example where applicable; `partial` = INDEX/section only; `pdf` = PDF on disk, agent uses markdown summary.

## Standards

| Source | Section / topic | standards/INDEX | topics/*.md | Example | Status |
|--------|-----------------|-----------------|-------------|---------|--------|
| [quartus-design-recommendations.md](standards/quartus-design-recommendations.md) | §1–2 overview | Quartus row + section router | quartus-metastability | — | full |
| quartus-design-recommendations.md | §3 metastability / MTBF | Quartus + Metastability rows | quartus-metastability | synchronizer_attributes.sv | full |
| [metastability-mtbf.md](standards/metastability-mtbf.md) | bridge | Metastability / MTBF row | quartus-metastability | bitsync3_inst.sv | full |
| [Design Recommendations.pdf](standards/Design%20Recommendations.pdf) | full UG 683082 | pdf opt-in in INDEX | quartus-metastability | — | pdf |
| [timing-analyzer-ug.md](standards/timing-analyzer-ug.md) | Ch.1 concepts + Ch.2 STA/SDC (see below) | Timing Analyzer UG router | timing-analyzer | 4× UG `.sdc` | **partial** |
| [timing-analyzer-cookbook.md](standards/timing-analyzer-cookbook.md) | All cookbook topics (27 pp) | Cookbook row + 12-row router | timing-analyzer | 10× cookbook `.sdc` + stubs | **full** |
| Timing Analyser UG.pdf | full UG 683243 (~145 pp) | pdf opt-in | timing-analyzer | — | pdf |
| [Timing analyser CookBook.pdf](standards/Timing%20analyser%20CookBook.pdf) | MNL-01035 / 683081 | pdf opt-in (JTAG Tcl) | timing-analyzer | — | pdf |
| [cdc-crossings.md](standards/cdc-crossings.md) | pointer | CDC row | cdc | examples/cdc/ | partial |
| [megafunctions-ip-cores.md](standards/megafunctions-ip-cores.md) | § agent–simulation | Megafunctions row | rtl-macros | — | full |
| [ug_intro_to_megafunctions-683102-848730.pdf](standards/ug_intro_to_megafunctions-683102-848730.pdf) | UG-01056 | pdf opt-in | rtl-macros | — | pdf |
| Other standards/*.md | per topic | per row | per topic | per topic | full |

### Timing Analyzer UG — section coverage (timing-analyzer-ug.md)

| PDF area | In markdown | Example |
|----------|-------------|---------|
| §1.1 paths/clocks | yes | — |
| §1.2 setup/hold/recovery/removal | yes | — |
| §1.2.5 multicycle concepts | yes | multicycle_setup_hold.sdc |
| §1.2.6 metastability concepts | yes (brief) | quartus §3 for detail |
| §1.2.7–1.2.10 pessimism, clock-as-data, multicorner, time borrow | yes (summary) | — |
| §2.1 flow | yes | initial_dual_clock.sdc |
| §2.5.1 report catalog | yes (table) | — |
| §2.6.1 initial SDC | yes | initial_dual_clock.sdc |
| §2.6.5 clocks (base/virtual/generated/PLL/mux/groups/latency) | yes (summary) | generated_clock_mux.sdc |
| §2.6.5.7 CDC constraints | yes | cdc_async_bus.sdc |
| §2.6.6 I/O | yes (brief) | — |
| §2.6.7 delay/skew | yes (summary) | — |
| §2.6.8 exceptions + precedence + multicycle how-to | yes | multicycle_setup_hold.sdc |
| §2.7 Tcl/collections | yes (summary) | — |
| §2.6.8.5 multicycle worked examples, §2.6.9–10, §2.8 imported results | **no** — PDF only | — |

## Design docs

| Source | Section | design/INDEX | topics/cdc | Example | Status |
|--------|---------|--------------|------------|---------|--------|
| cdc-reusable-patterns.md | §1.1 2-stage bitsync | yes | cdc | km_hssi_bitsync_inst.sv, sync_2ff.* | full |
| cdc-reusable-patterns.md | §1.2 3-stage / MTBF | yes | cdc + metastability | bitsync3_inst.sv | full |
| cdc-reusable-patterns.md | §1.3 toggle/edge | yes | cdc | toggle_edge_detector.sv | full |
| cdc-reusable-patterns.md | §2.1 vecsync_cdc | yes | cdc | vecsync_cdc_inst.sv | full |
| cdc-reusable-patterns.md | §2.2 vecsync restricted | yes | cdc | — | partial |
| cdc-reusable-patterns.md | §2.3 vecsync handshake | yes | cdc | — | partial |
| cdc-reusable-patterns.md | §2.4 pulse cross | yes | cdc | pulse_cross_inst.sv | full |
| cdc-reusable-patterns.md | §2.5 lvlsync | yes | cdc | — | partial |
| cdc-reusable-patterns.md | §3 latching | yes | cdc | latching/*.sv | full |
| cdc-reusable-patterns.md | §4 reset | yes | clocks-resets | init_pipeline_3stage.sv | partial |
| cdc-reusable-patterns.md | §5 gray | yes | cdc | gray_*.sv | full |
| cdc-reusable-patterns.md | §6 async FIFO | yes | cdc | async_fifo_inst.sv | full |
| cdc-reusable-patterns.md | §7 selection guide | yes | cdc | — | partial |
| architecture-comparison.md | §1–6 | yes | — | legacy_tod_toggle_detect.v (§2) | partial |
| architecture-comparison.md | §4 metastability | yes | quartus-metastability | synchronizer_attributes.sv | full |
| km-xcvr-tod-analysis.md | §1–5 | yes | cdc | km_xcvr_tick_detect.sv | partial |
| legacy-tod-sync-analysis.md | §1–8 | yes | quartus-metastability | legacy_tod_toggle_detect.v | full |
| rtl-macro-library.md | catalog + ask rule | RTL macros row | rtl-macros | examples/cdc/*_inst.sv | full |
| macro-library-user.md | user table | optional | rtl-macros | — | partial (template) |

## Skill entry points

| File | Notes |
|------|-------|
| [.cursor/skills/rtl-design/SKILL.md](../.cursor/skills/rtl-design/SKILL.md) | Routes via INDEX; Quartus/MTBF called out |
| [topic-router.md](../.cursor/skills/rtl-design/topic-router.md) | Procedure for selective load |

## Maintainer

When adding a design section or standard topic, update this table and the relevant INDEX in the same change.
