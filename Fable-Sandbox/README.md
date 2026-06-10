# Fable-Sandbox — DS-01 Calibration Workspace

**Created:** 2026-06-10 (design session)
**Read order for the execution session:** (1) `FABLE-DS01-CALIBRATION-HANDOFF.md` at repo root, in full. (2) This README, in full. (3) The goal in `proposed-goal.md` is what you are executing.

This sandbox was pre-built in the design session so the calibration run can start cold. Everything below is verified against the actual files, not inferred.

---

## 1. What is already done (do not redo)

- All pipeline skills/commands are copied here with a `-fable` suffix.
- In every copy, output paths are redirected: `Generated-Drafts/` → `Fable-Sandbox/Generated-Drafts/`.
- Cross-references between copies are rewired to the `-fable` names (the chain calls the `-fable` review commands, the orchestrator calls the `-fable` generator).
- **The Google Docs upload stage is removed** from `full-draft-review-auto-ds01-fable.md` and the upload "next step" pointer is removed from `review-claims-3-v3-fable.md`. The pipeline ends at `v5-claims-verified.md`. No `upload-to-gdocs*` file was copied; none may ever be run.
- Every copy carries a sandbox banner note at the top.

**Not done yet (the run does these):** style-DNA extraction, static gap map, any draft generation, any `-fable` content changes beyond the mechanical ones above.

## 2. File map

```
Fable-Sandbox/
  README.md                                  ← you are here
  proposed-goal.md                           ← the /goal + design change log
  skills/
    generate-ds01-draft-fable/SKILL.md       ← stage1 analysis + v1 draft (Phases 0–2)
    orchestrate-ds01-drafts-fable/           ← batch orchestrator (likely UNUSED — calibration is per-topic)
  commands/
    full-draft-review-auto-ds01-fable.md     ← chains the 4 review stages, upload removed
    review-draft-seed-perspective-ds01-fable.md   ← v1 → v2
    review-draft-1-v2-fable.md                    ← v2 → v3 (run in DS-01 mode)
    review-sources-2-v3-fable.md                  ← v3 → v4
    review-claims-3-v3-fable.md                   ← v4 → v5
  Generated-Drafts/                          ← ALL calibration drafts go here, mirroring real structure
  calibration-analysis.md                    ← created by the run: gap map, changes + reasoning, verdicts
```

**Verified stage → file mapping** (from the originals, 2026-06-10):

| Stage | Output file | Owned by |
|---|---|---|
| Stage 1 analysis | `stage1_analysis-[slug].md` | `generate-ds01-draft-fable` Phase 1 |
| v1 draft | `v1-[slug]-claude-draft.md` | `generate-ds01-draft-fable` Phase 2 |
| v2 | `v2-seed-perspective-reviewed.md` | `review-draft-seed-perspective-ds01-fable` |
| v3 | `v3-reviewed.md` | `review-draft-1-v2-fable` (DS-01 mode) |
| v4 | `v4-sources-verified.md` | `review-sources-2-v3-fable` |
| v5 (FINAL) | `v5-claims-verified.md` | `review-claims-3-v3-fable` |

Each review command writes its output next to its input file, so passing explicit `Fable-Sandbox/Generated-Drafts/...` paths keeps everything inside the sandbox.

## 3. How Opus subagents run the `-fable` files

The `-fable` copies are NOT registered slash commands or skills — they are instruction files. Spawn an Agent with `model: "opus"` and a prompt of this shape:

```
Read this instruction file in full and execute it exactly:
/[absolute path]/Fable-Sandbox/commands/review-draft-seed-perspective-ds01-fable.md

Input file: Fable-Sandbox/Generated-Drafts/[NNN]-[slug]/v1-[slug]-claude-draft.md
Save output in the same folder. Do not write anywhere outside Fable-Sandbox/.
Do NOT read anything in "Published Drafts/". Reference/ files are read-only inputs.
```

The "do not read Published Drafts" line is mandatory for every drafting/reviewing subagent — that is the blindness constraint. Grader subagents are the only ones allowed to read a published final, and only for the topic they're grading, only after that topic's v5 exists.

## 4. Evidence map

**Convergence targets** (voice-preserved finals — legitimate match targets):

| Topic | Published final | v5 source folder | Role |
|---|---|---|---|
| Fermented Foods | `Published Drafts/fermented-foods-for-gut-health-guide.md` | `Generated-Drafts/060-fermented-foods-for-gut-health/` | **TRAIN** — diagnose + tune here |
| Best Tea | `Published Drafts/best-tea-for-gut-health-digestion-guide.md` | `Generated-Drafts/068-best-tea-for-gut-health-digestion/` | **HELD OUT** — blind validation only |
| "Probiotic" Drinks | `Published Drafts/what-is-a-probiotic-drink-guide.md` | `Generated-Drafts/067-what-is-a-probiotic-drink/` | **HELD OUT** — blind validation only |

**Negatives** (editor stripped the voice — NEVER optimize toward these finals; their v5 drafts are the better voice reference):

| Topic | Published final | v5 source folder |
|---|---|---|
| Apple Cider Vinegar | `Published Drafts/apple-cider-vinegar-for-gut-health-guide.md` | `Generated-Drafts/061-apple-cider-vinegar-for-gut-health/` |
| Best Yogurt | `Published Drafts/best-yogurt-for-gut-health-guide.md` | `Generated-Drafts/059-best-yogurt-for-gut-health/` |

**North Star** (style bar for voice/humor/structure; not end-to-end match targets; read-only): the 9 articles listed in handoff §4.5, all in `Published Drafts/`.

**Audits** (richest diagnostic signal — read both in full):
- `Generated-Drafts/editorial-personality-audit-v2.md` (round 1, 6 articles)
- `Generated-Drafts/editorial-personality-audit-round-2.md` (round 2, 5 articles)

**Split rationale:** only 3 convergence pairs exist, and the handoff requires ≥2 held-out. So: train on fermented foods (full v5-vs-final diff allowed), confirm the "editor stripped it" pattern on the two negatives, and hold tea + probiotic drinks fully out — never read or diff their published finals until grading. Caveat to accept honestly: the audits describe all 11 articles, including the held-out ones, and you must read the audits. That secondhand description is permitted context; reading the held-out *finals* themselves before grading is not.

## 5. Input reuse and blindness

- **No SciCare POV brief exists for any calibration topic.** All three targets were drafted in early April 2026; the earliest brief folder is 2026-05-08. Phase 0 of the generator will correctly find nothing — this matches the conditions the targets were produced under. Do not hunt for briefs.
- **Reuse the existing `stage1_analysis-[slug].md` from the original `Generated-Drafts/` folders** (copy — never move or edit the originals — into the sandbox topic folder). This is legitimate and preferred: it predates the published finals, it reproduces the writers' inputs, and it avoids re-scraping a SERP that has drifted. When invoking the generator with a frozen stage1, instruct the subagent to skip Phases 0–1 and start at Phase 2 with the provided stage1 file.
- **The existing v1 files are also legitimate frozen inputs** while you are iterating only on review stages (downstream-first). Regenerate v1 only after you change the generator, and for the final blind acceptance runs (frozen stage1 → fresh v1 → v5 through the full `-fable` chain).
- **Never hand-edit any generated draft file.** The only files you may edit are the `-fable` skills/commands and your own analysis/log files.

## 6. Grading: rubric operationalization

Tiers are defined in handoff §8. Use exactly 3 independent Opus graders per held-out topic; each classifies **every** v5-vs-published-final difference into Tiers 0–4; majority vote per finding; output a structured verdict:

```json
{
  "topic": "...",
  "tier0": [], "tier1": [], "tier2": [],
  "tier3": {"findings": [], "within_tolerance": true},
  "tier4_count": 0,
  "pass": true
}
```

**Mandatory carve-outs** (without these, zero Tier 0–2 is mechanically unreachable):

1. **Editor-added surface elements are Tier 4**: emoji (🦠/🌱/etc.), callout boxes ("Science Translation", "Pro Tip"), and internal links to other seed.com articles all appear in the published finals but the pipeline style rules *forbid* drafts from producing them. Their absence from a v5 is never a gap.
2. **Direction matters**: a difference where the v5 *better* satisfies the calibration standard than the final is NOT a gap. Concrete case: the probiotic-drinks final dropped the named Dirk Gevers attribution (the audits flag this as the final's failure). A v5 with a properly attributed named-expert quote scores zero Tier 1 findings there, not one.
3. **Tier 4 means**: synonym swaps, comma/punctuation changes, light tightening, light rewording of the same idea in the same position. Two excellent versions always differ at this level; it is expected.

**Tier 3 tolerance** (measure against the 9 North Star articles): average sentence length within ±20% of the North Star mean; paragraphs ≤3 sentences throughout; intro follows hook → direct short answer → nuance; H2 sections within the 300–500 word norm. Within all four → `within_tolerance: true`.

## 7. Audit findings distilled (priors, not a substitute for your own style-DNA pass)

What the best editors preserve and the pipeline must therefore produce robustly:

- **Intro = scene, never a clinical lead.** Recognizable scenario hook ("standing in the dairy aisle…"), then "Here's the short answer…", then nuance. The two destroyed intros (ACV, yogurt) became chemical inventories — the canonical failure.
- **Named-expert E-E-A-T.** Dirk Gevers, Ph.D. quote(s), attribution intact, title ("Chief Scientific Officer at Seed Health") strengthens it. Quote never names a product. This is the single most-dropped element (same editor, three times across both audits).
- **Headers: conversational with the keyword landed naturally in 1–2 of them.** Parenthetical asides ("…(and Who Probably Doesn't Need It)") are on-voice; pure keyword labels are the flattening pattern.
- **Conversational connective tissue**: "Here's the thing…", "The short answer?", "Let's break it down" — tiny devices, repeatedly trimmed, that signal "you're in a conversation."
- **Closers: vivid extended metaphor** (garden / orchard / "first chapter, not the whole book") + a warm grounding line. Editors consistently *add* these — the drafts should already carry them.
- **Competitive-positioning lines** ("This is where most articles stop…") create curiosity; they survived in the best edits.

## 8. Hard constraints recap (handoff §3 — fixed)

1. Edit only inside `Fable-Sandbox/`; originals end the run with **zero git modifications** (verify with `git status` + diff at the end; note the repo had pre-existing uncommitted changes before the sandbox existed — compare against that baseline, your run must add nothing outside `Fable-Sandbox/`).
2. No `upload-to-gdocs*` is ever copied or run.
3. Fable orchestrates; **Opus subagents** do all drafting, reviewing, and grading.
4. Blind generation; no hand-editing drafts.
5. Bounded run: 30 Fable turns hard cap, then stop and report status honestly.
