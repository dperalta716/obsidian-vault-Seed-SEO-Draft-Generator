# Proposed `/goal` — DS-01 Draft-Generation Calibration

**Author:** Fable 5 (design session, 2026-06-10)
**Status:** Final — paste the block below into a fresh session as-is.

---

## The goal

```
/goal Read FABLE-DS01-CALIBRATION-HANDOFF.md in full, then Fable-Sandbox/README.md
in full — they carry the outcome, hard constraints, evidence map, verified
stage→command mapping, grading rubric with carve-outs, & the setup already
completed. Then execute start to finish.

Calibrate the DS-01 draft pipeline by editing ONLY the -fable copies inside
Fable-Sandbox/ so that a blind end-to-end run produces a v5 carrying Seed's voice,
humor, structure, & named-expert EEAT at the level of the voice-preserved
published finals & the 9 North Star articles.

Already done (do not redo): -fable copies of the generator skill & the 4-stage
review chain exist in Fable-Sandbox/, outputs redirected to
Fable-Sandbox/Generated-Drafts/, GDocs upload removed. Pipeline: stage1+v1
(generate-ds01-draft-fable) → v2 seed-perspective → v3 quality → v4 sources → v5
claims.

Method: (1) Extract style DNA from the 9 North Star articles in Published Drafts/
and bake it into the -fable files. (2) Build the static gap map on the TRAIN
topic, fermented foods (Generated-Drafts/060): diff its existing v5 against its
published final, AND diff v1→v2→v3→v4→v5 inside the folder to locate where voice
erodes within the pipeline itself — a gap absent at v1 belongs to the generator;
a gap that appears during review belongs to that review stage. Use the negatives
(059 yogurt, 061 ACV) only to identify editor-stripped patterns you must NOT
optimize toward. (3) Run the April-regression check: regenerate the train topic's
v1 with the current -fable generator (frozen stage1) and compare it for voice
against the stored April v1 — the generator has roughly doubled since April with
compliance additions that may flatten voice. (4) Iterate with BOTH the generator
and the review stages in scope; downstream-first is a cost rule, not a scope
rule: review-stage edits reuse the frozen v1, and generator-attributed gaps are
batched into a single edit + single v1 regeneration, never fixed one at a time.
Re-run only from the earliest changed stage. HELD-OUT topics: best tea (068) and
probiotic drinks (067) — never read or diff their published finals until grading.

Execution rules: ALL drafting, reviewing, and grading runs in Opus subagents
(model: opus) that read and execute the -fable instruction files; you only
orchestrate, diagnose, and edit the -fable files. Drafting/reviewing subagents
never read ANY file in Published Drafts/. Never hand-edit a generated draft.

Acceptance: run the full -fable chain blind end-to-end (frozen stage1 → fresh v1
→ v5) on BOTH held-out topics. For each, 3 independent Opus graders classify
every v5-vs-published-final difference into Tiers 0–4 per the handoff §8 rubric
and the README §6 carve-outs (editor-added emoji/callouts/internal links = Tier
4; a difference where the v5 better satisfies the standard than the final — e.g.
a named expert the editor dropped — is not a gap), majority-vote into one
structured verdict per topic. Then run the brief-pathway smoke test (README §6b):
one brief-era topic, prebiotic foods (Generated-Drafts/108), end-to-end through
the calibrated -fable chain WITH its real SciCare brief; graders check brief
alignment and the North Star style bar — no published-final diff. This validates
that calibration edits coexist with the brief machinery the calibration topics
could not exercise.

Done when BOTH held-out verdicts report zero Tier 0, Tier 1, & Tier 2 gaps with
Tier 3 within the README §6 tolerance, AND the brief-pathway smoke test passes,
AND Fable-Sandbox/calibration-analysis.md
records the gap map, every -fable change with reasoning, & both final verdicts.
Hard bound: if not converged after 30 of your turns, stop, write an honest status
report including the latest verdicts to calibration-analysis.md, and surface it —
that bounded report also satisfies this goal. Throughout: zero writes outside
Fable-Sandbox/ (verify with git status at the end against the pre-existing
baseline) and no upload-to-gdocs command is ever copied or run
```

---

## What changed from the handoff §6 draft, and why

1. **Added `Fable-Sandbox/README.md` as a second mandatory read.** The design session pre-built the sandbox (copies made, paths redirected, upload stripped) and wrote the operational detail — stage mapping, subagent prompt template, grading schema, tolerance definitions — into the README. This keeps the goal lean (the evaluator's job stays small) while making the run fully self-sufficient.

2. **Setup phase rewritten from "duplicate everything" to "already done — do not redo."** The copies exist; redoing them would waste turns and risk divergence.

3. **Resolved the Tier 3 contradiction.** The §6 draft demanded "Tiers 0–3 = zero," but the §8 rubric table allows Tier 3 "within tolerance." The rubric is the decision procedure, so the goal now requires zero Tier 0–2 and Tier 3 within a tolerance that README §6 makes measurable (sentence-length, paragraph density, intro shape, section length vs. the North Star bar). An unmeasurable "zero style-mechanics differences" against a human-edited target is an asymptote, not a finish line.

4. **Named the train/held-out split explicitly** (train: fermented foods + the two negatives for pattern-confirmation; held out: best tea + probiotic drinks). With only 3 convergence pairs, leaving the split to the run risks accidentally diagnosing on a held-out topic. Tea — the strongest exemplar — stays held out precisely so the acceptance test is meaningful.

5. **Added grading carve-outs to the definition of done.** Without them, zero Tier 0–2 is mechanically unreachable: the published finals contain editor-added emoji, callout boxes, and internal links that the pipeline's own style rules forbid drafts from producing, and one held-out final (probiotic drinks) itself violates the E-E-A-T standard by dropping the named expert. Graders must score "does the v5 fall short of what the best editors preserve," not "does the v5 differ from the final."

6. **Made the 30-turn bound a satisfiable exit.** In the §6 draft, a non-converged run could never clear the goal and would idle against the evaluator. Now the bounded honest status report explicitly satisfies the goal, so the run always terminates cleanly — converged or reported.

7. **Authorized reuse of existing stage1_analysis (and v1) as frozen inputs.** Reproducible inputs the handoff already pointed at: they predate the published finals (no blindness leak), match what the writers actually had, avoid SERP drift, and save the most expensive regeneration. The acceptance runs still regenerate v1 → v5 fresh so end-to-end interaction effects are tested.

8. **Fixed grader count at exactly 3** (was "2–3") so majority vote is always well-defined, and required graders to be independent.

9. **Strengthened the blindness rule into an operational instruction** — every drafting/reviewing subagent prompt forbids reading anything in `Published Drafts/` (template in README §3) — rather than a principle Fable holds in mind.

10. **Noted the no-brief reality.** No SciCare POV brief exists for any calibration topic (all three targets predate the earliest brief folder). The generator's Phase 0 will correctly no-op, which matches the conditions the originals were produced under. Recorded in README §5 so the run doesn't chase missing briefs.

11. **Added the brief-pathway smoke test to the definition of done.** Because the calibration topics are necessarily brief-less (their answer keys predate the briefs), the brief pathway — Phase 0 lookup, Tier 0 evidence promotion, POV Brief Guardrail — goes unexercised by the blind runs. The smoke test closes that generalization gap cheaply: one brief-era topic (prebiotic foods, 108, which has both a real brief and a full prior run) goes end-to-end through the calibrated chain, graded for brief alignment plus the North Star style bar, with no published-final diff. Spec in README §6b.

12. **Put the generator explicitly in scope and added the v1→v5 erosion diagnostic.** The voice DNA lives in the generator (intro architecture, expert quote, headers, closers); the four review stages are compliance/accuracy passes that cannot inject voice a v1 lacks — and, as four consecutive auto-apply-all passes, are structurally four miniature editors that may erode it. The per-stage files make the diagnosis free: diff v1→v2→v3→v4→v5 to see where voice appears or erodes, and attribute fixes accordingly. Downstream-first is reframed as a cost rule (review edits reuse the frozen v1; generator edits are batched into one edit + one regeneration), not a scope restriction.

13. **Added the April-regression check.** The current generator is ~2× its April 29 size, almost entirely post-May compliance additions (hedging rules, implied-claims guards, topic gates). The convergence-target v1s — the ones the audits praise for voice — were produced by the lean April skill. Before iterating, the run regenerates one train v1 with the current -fable generator and compares it against the stored April v1: if the added compliance machinery has flattened the voice, that is the first and highest-leverage generator-side finding.
