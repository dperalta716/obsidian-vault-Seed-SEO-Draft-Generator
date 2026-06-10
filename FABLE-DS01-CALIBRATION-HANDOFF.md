# Fable Handoff — DS-01 Draft-Generation Calibration

**For:** Fable 5 (orchestrator)
**Author:** David Peralta (with Claude)
**Date:** 2026-06-10
**Working directory:** `/Users/david/Documents/Obsidian Vaults/claude-code-demo/Seed-SEO-Draft-Generator-v4/`

---

## 0. How to use this document — read this first

**The single deliverable of this session is a finished, properly written `/goal`** — nothing else. You are **not** running the calibration in this session. You are designing it and writing the goal that *another* session will run.

Concretely, the two phases are:

- **This session (design — what you're doing now):** read this document, read the environment it points to, re-examine the whole approach, and **write the final `/goal`** to `Fable-Sandbox/proposed-goal.md`. Do not create the sandbox, spawn Opus subagents, or generate any drafts now. The output is the goal text, full stop.
- **A later session (execution — not now):** David pastes that `/goal` into a fresh session, and from that goal alone you run the entire calibration start to finish — sandbox, Opus subagents, the loop, grading, the lot.

Because of that split, **the `/goal` you write must be self-sufficient: runnable start to finish in a brand-new session with no other instructions.** The cleanest way to guarantee that is to have the goal's first instruction be "read `FABLE-DS01-CALIBRATION-HANDOFF.md` in full, then execute" — so the execution session inherits all of this context, and the goal itself carries the outcome, constraints, and success criteria crisply on top of that.

**This entire plan is open to your reevaluation.** We chose you because your judgment and use of context are strong. Everything in Sections 1, 2, 4, 5, and 6 — the approach, the loop, the decomposition, the draft goal — is ours to *propose* and yours to *improve*. If something is wrong or there's a better way, change it, say why, and bake the better version into the goal you write. The **only** thing that is not yours to revise is **Section 3 (Hard Constraints)** — those are fixed.

Before you design anything, read these to ground yourself in how the system actually works:

- `CLAUDE.md` (repo root) — project conventions.
- `.claude/skills/orchestrate-ds01-drafts/` and `.claude/skills/generate-ds01-draft/` — the orchestrator and generator. **Read the SKILL.md files to learn the true stage sequence and which command owns each stage** rather than trusting any mapping inferred here.
- `.claude/commands/` — the per-stage commands.
- The two audit documents in Section 4 — they are the richest signal in this whole job.

---

## 1. The outcome we're trying to achieve

The DS-01 draft-generation pipeline is now run by a team of new writers. Their published output is **mixed quality**. We want to improve the *process* so that the draft it produces — before it ever reaches a human editor — already carries Seed's voice, humor, structure, and E-E-A-T at the level of our best work, so that editorial rework shrinks and quality stops depending on which writer or editor touched it.

**Success, in plain terms:** the pipeline produces a DS-01 draft that needs only light copy-editing to stand next to our best published articles — same conversational voice, same humor, same structural rhythm, same named-expert trust signals — *without you having seen the target answer while generating it.*

You are improving the **process**, not reproducing any single article. A process that nails one article by copying it has learned nothing. The win is a process that produces near-publishable drafts on topics it has not seen.

---

## 2. The system as it exists today

The pipeline is a sequence of stages, each persisted as its own file in a per-topic folder under `Generated-Drafts/<NNN-topic>/`:

```
stage1 analysis  →  v1 (draft)  →  v2 (seed perspective)  →  v3 (reviewed)  →  v4 (sources verified)  →  v5 (claims verified)
```

`v5` is the automated finish line. It then goes to a **human editor**, who produces the **final published version** in `Published Drafts/` (note: published files use `keyword-guide.md` naming, *not* the numbered-slug naming of `Generated-Drafts/` — match by topic, not filename).

Key properties you can exploit:

- **Every stage is a saved file**, and **each stage has its own command** in `.claude/commands/`. That means stages can be re-run in isolation: freeze an upstream version file and re-run only the stages downstream of it. (Confirm the exact stage→command mapping from the orchestrator SKILL.md before relying on it.)
- **Inputs are reproducible.** SciCare PoV briefs live centrally in `Reference/SciCare POV briefs/` and `Reference/2026-03 DS-01 Updated Messaging Reference Files/`; stage 1 is generated from the keyword. So for any topic you can reconstruct the same inputs the writers had.
- **The new citation-sourcing method is already incorporated** into the workflows. Do **not** add it or change it — it's already there.

---

## 3. Hard constraints — read twice, do not revise

### 3.1 The sandbox — originals are untouchable

- Create a **single new sandbox folder** inside this directory (suggested: `Fable-Sandbox/`).
- **Copy every pipeline skill and command into it**, renaming each with a **`-fable` suffix** (e.g. `stage2-generate-draft` → `stage2-generate-draft-fable`, `generate-ds01-draft` → `generate-ds01-draft-fable`, `orchestrate-ds01-drafts` → `orchestrate-ds01-drafts-fable`). You may modify the `-fable` copies as much as you want.
- Generate **all** calibration drafts **inside the sandbox**, in a `Fable-Sandbox/Generated-Drafts/` folder that mirrors the real structure.
- **Never write to anything outside the sandbox.** The following stay exactly as they are: the skills, the drafting workflows, the review workflow, the orchestrator, and everything else in the repo. The original `.claude/skills/` and `.claude/commands/` are read-only references you copy *from*, never edit.
- **Verification of this constraint:** at the end, `git status` and a diff over the original `.claude/skills/`, `.claude/commands/`, and all existing content must show **zero modifications**. Only new files under `Fable-Sandbox/` may appear.

### 3.2 `upload-to-gdocs` never runs

- Do **not** copy and do **not** run any `upload-to-gdocs*` command (`upload-to-gdocs-ds01`, `upload-to-gdocs-phase1`, `upload-to-gdocs-v3`). Publishing is out of scope. The pipeline ends at the sandbox `v5`.

### 3.3 You orchestrate; Opus does the drafting and reviewing

- **You (Fable) do not run the skills yourself.** Whenever a skill is **drafting or reviewing** (stage 1, v1 generation, the v2–v5 review passes), spawn an **Opus subagent** to run the `-fable` version of that skill/command.
- **Your job is high-level:** read the Opus outputs, judge the gap, decide what to change in the sandbox skills, and orchestrate the next step. Think and review; let Opus run.
- Rationale: you cost ~2× Opus and run slow, but your judgment and use of context are the scarce resource. Opus is the fast, capable executor. Spend your tokens on orchestration and review, not on running the pipeline.

### 3.4 No cheating the target

- **Blind generation.** When you generate a draft for a topic you will grade, the Opus subagent producing it must **not** read that topic's published final (or the editor's version) beforehand. The target is the answer key, used only to grade and diagnose *after* generation.
- **No hand-editing drafts to force a match.** The only things you change are the `-fable` sandbox skills/commands. You never hand-edit a generated draft file to make it line up with the target.

### 3.5 Bound the run

- This is open-ended optimization against a partly subjective target. **Cap it** (a turn limit and/or a "good enough" threshold — see Section 6) so it converges instead of chasing an asymptote at Fable token prices. Report status if you hit the bound without full convergence.

---

## 4. The evidence to calibrate against

### 4.1 Convergence targets — input-parity finals (converge toward these)

These were produced under the **current** regime (MRD + PoV briefs), so they share inputs with what the pipeline produces today. They are the legitimate end-to-end match targets. All three are **voice-preserved** finals — the editor kept (or improved) the voice:

| Article | Published final | v5 source folder |
|---|---|---|
| Best Tea for Gut Health | `Published Drafts/best-tea-for-gut-health-digestion-guide.md` | `Generated-Drafts/068-best-tea-for-gut-health-digestion/` |
| Fermented Foods for Gut Health | `Published Drafts/fermented-foods-for-gut-health-guide.md` | `Generated-Drafts/060-fermented-foods-for-gut-health/` |
| "Probiotic" Drinks | `Published Drafts/what-is-a-probiotic-drink-guide.md` | `Generated-Drafts/067-what-is-a-probiotic-drink/` |

**Best Tea** is the single strongest example — voice preserved nearly verbatim, both expert quotes kept, conversational headers intact, callout boxes and a strong closer *added*. Treat it as the model for "edit without stripping."

**"Probiotic" Drinks** is a deliberate *teaching* case: the **best voice work of the batch** (intro preserved and improved, conversational headers kept) **but** the named expert attribution was dropped, leaving the piece with no named expert. It is simultaneously "this is the voice we want" and "never drop the named expert." Hold both lessons.

### 4.2 Negatives — what not to do (never optimize toward these)

| Article | Published final | v5 source folder |
|---|---|---|
| Apple Cider Vinegar | `Published Drafts/apple-cider-vinegar-for-gut-health-guide.md` | `Generated-Drafts/061-apple-cider-vinegar-for-gut-health/` |
| Best Yogurt | `Published Drafts/best-yogurt-for-gut-health-guide.md` | `Generated-Drafts/059-best-yogurt-for-gut-health/` |

In both, the editor **destroyed the intro** (a vivid, recognizable scene became a clinical/chemical lead), swapped conversational headers for keyword labels, and — for ACV — dropped the named expert. These are the failure modes to design *against*.

### 4.3 The full gradient — both audits (all 11 articles)

Read both in full. They analyze, article by article, exactly what survived editing and what got stripped — intros, headers, expert quotes — across all 11 published new-team articles. This is the nuance behind the 5 anchors above:

- `Generated-Drafts/editorial-personality-audit-v2.md` (round 1, 6 articles)
- `Generated-Drafts/editorial-personality-audit-round-2.md` (round 2, 5 articles)

### 4.4 ⚠️ The critical nuance: the published version is a *mixed* signal

The audits expose something that changes the whole objective: **the editorial process sometimes makes an article *worse* on voice than the v5 draft was.** In the negatives (ACV, Yogurt), the draft had the personality and the editor stripped it out.

Therefore:

- **Converge only toward the voice-preserved finals (4.1).** "Match the published version" is valid *only* where the editor preserved or improved the voice.
- **Never optimize toward the stripped finals (4.2).** Doing so would train the process to produce *flatter* drafts — the opposite of the goal. For those topics, the v5 *draft* is the better voice reference.
- The real finish line is **"produce the voice the best editors preserve, with the E-E-A-T the best ones protect,"** not "reproduce whatever was published."

### 4.5 North Star — the gold standard for style (read-only)

These 9 articles are our **gold standard for tone of voice, humor, and article structure** (spacing, sentence length, rhythm, paragraph density). They predate the current MRD and have no PoV brief, so they are **not** end-to-end match targets — but **style is largely independent of the brief**, which is why they define the qualitative bar for *those* dimensions. **Study them to extract the style DNA and bake that standard into the sandbox skills; judge output against them. Do not treat them as a literal convergence target, and never modify them.**

All in `Published Drafts/`:

- `how-long-take-probiotics-duration-guide.md`
- `can-probiotics-cause-diarrhea-gut-adjustment-guide.md`
- `probiotics-sibo-treatment-research-guide.md`
- `best-probiotic-for-antibiotics-guide.md`
- `best-time-to-take-probiotics-guide.md`
- `best-probiotic-for-men-strain-specific-guide.md`
- `best-probiotic-for-women-strain-benefits-guide.md`
- `probiotics-for-pcos-guide.md`
- `best-probiotics-for-weight-loss-guide.md`

---

## 5. Our current thinking on the approach (revise if you can do better)

The expensive risk is re-running the full pipeline end-to-end for every tweak. You don't have to. The architecture (saved per-stage files + per-stage commands) supports a token-sensitive loop in three layers:

**Layer 1 — Free static gap map (no regeneration).** For each convergence-target pair, diff the **existing v5** (already sitting in the `Generated-Drafts/` folders above — your free baseline) against its published final, and **attribute every difference to the stage that should own the fix**: structure/missing sections → the draft generator (v1); tone/voice/humor → the review passes; sourcing → the sources pass; claims → the claims pass. Aggregate into a single map of *what is systematically wrong and where*. This costs almost nothing and likely tells you most of what to change. Also diff the negatives' v5 vs published to confirm the "editor stripped it" pattern and make sure you're not chasing it.

**Layer 2 — Targeted, downstream-first edits with frozen upstream.** Prefer fixing as far **downstream** (in the review passes) as possible, because review-stage edits let you reuse a frozen v1. Only edit the v1 generator for things that genuinely can't be repaired downstream (fundamental structure, required sections). Generate v1 **once per test topic via an Opus subagent, then freeze it**; iterate on the review chain reusing that frozen v1. Re-run **only from the earliest changed stage forward**. All of this runs on Opus, in the sandbox, against the `-fable` skills.

**Layer 3 — Full end-to-end, blind, on held-out topics.** Stages interact, so cheap stage-isolated iteration can fool you. Hold out at least 2 convergence-target topics, never diagnose against them, and use a **full end-to-end blind run** (Opus, sandbox) as the acceptance test before declaring a tweak good.

**Train/test split:** diagnose and tune on most of the convergence-target pairs; reserve held-out topics purely for blind validation.

---

## 6. Suggested goal (draft) — and why it's written this way

### First — what a `/goal` is (so the one you write actually runs)

A `/goal` is a Claude Code primitive for autonomous, multi-turn execution. You give it a **completion condition**. After every turn, a *small, fast evaluator model* checks whether that condition is satisfied based on what you've surfaced in the conversation. If it isn't, the evaluator's reason becomes guidance and the next turn starts automatically — no human prompt between turns. When the condition is met, the goal clears. In short: it keeps you working until the finish line is provably crossed, which is exactly what an hours-long delegable job like this one needs.

Two consequences shape how the goal must be written:

1. **The finish line is judged by a small model reading your output — not by you.** So success has to be a crisp, checkable signal, not a subjective read of two long articles. That is the entire reason this job routes success through a **structured Opus grading verdict** (Section 8): the evaluator only has to confirm "the verdict reports zero Tier 0–3 gaps," which it can do reliably — instead of trying to judge prose itself.
2. **Keep the condition tight and self-contained.** There's a length ceiling (on the order of a few thousand characters), so push the detail into this handoff doc — which the goal instructs you to read first — and keep the goal's own success condition lean.

A well-formed `/goal` for this job contains four things:

- **A measurable end state** — e.g. "for ≥2 held-out topics, zero Tier 0–3 gaps."
- **How it's proven** — "via the Opus graders' structured verdict."
- **Constraints that must hold throughout** — sandbox-only `-fable` edits, Opus does all drafting/review, no `upload-to-gdocs`, blind generation, no hand-editing drafts, originals end unmodified.
- **A bound** — a turn cap, so it converges instead of chasing an asymptote at Fable token prices.

The draft below already follows that anatomy. Your job is to sharpen it, not to invent the shape.

### The draft

This is a **draft you will finalize**. The deliverable of this session is the improved version of this goal, written to `Fable-Sandbox/proposed-goal.md`, runnable start to finish in a fresh session. Re-examine every clause; change what should change; then write the final version.

```
/goal Read FABLE-DS01-CALIBRATION-HANDOFF.md in full first; it carries the
outcome, constraints, evidence, and the gap rubric. Then execute the following
start to finish.

Calibrate the DS-01 draft-generation pipeline — working ONLY on -fable copies
inside Fable-Sandbox/ — so that a BLIND end-to-end run produces a v5 that passes
the gap rubric (Tiers 0-3 = zero) against our voice-preserved published finals
and hits the North Star style bar, with named-expert E-E-A-T intact.

Setup: duplicate all pipeline skills/commands into Fable-Sandbox/ with a -fable
suffix (exclude upload-to-gdocs entirely). Extract the style DNA (voice, humor,
sentence length, spacing, structure) from the 9 North Star articles. Build the
free static gap map by diffing the existing v5s of the convergence targets
against their published finals and attributing each gap to its owning stage.

Loop: edit the -fable skills downstream-first; spawn Opus subagents to run all
drafting and review (freeze v1, re-run only from the earliest changed stage);
you review and orchestrate, you do not run skills yourself; never read a held-out
topic's published final before generating its draft; never hand-edit a draft.

Grade with Opus: for each held-out blind run, an Opus subagent (2-3 graders,
majority vote) classifies every diff against the published final into Tiers 0-4
and returns a structured verdict.

Done when: for at least 2 held-out topics, the grading verdict reports ZERO
Tier 0-3 gaps (substantive, E-E-A-T, voice/humor, style-mechanics) — only Tier 4
word-level copy edits remain — and style matches the North Star bar. Write the
calibration log and the final improved -fable skills to Fable-Sandbox/. Stop
after 30 turns and report if not converged. The original skills, commands,
workflows, and orchestrator must end with zero modifications.
```

**Why each piece is there:**

- *"working ONLY on -fable copies inside Fable-Sandbox/" + the closing "zero modifications" line* — the sandbox boundary is the non-negotiable constraint; it's stated at both ends so the evaluator checks it every turn.
- *"a BLIND end-to-end run"* — forces the anti-cheating condition into the definition of done; a match achieved by peeking doesn't count.
- *"voice-preserved published finals … North Star style bar … named-expert E-E-A-T"* — three explicit quality dimensions, so the evaluator isn't judging a vague "is it good."
- *"downstream-first … freeze v1 … re-run only from the earliest changed stage"* — encodes the token-sensitive loop so a long Fable run doesn't burn the budget regenerating from scratch.
- *"spawn Opus subagents … you do not run skills yourself"* — the orchestration model, in the goal itself.
- *"at least 2 held-out topics … minor word-level copy edits"* — a bounded, checkable finish state on data the process didn't train on.
- *"Stop after 30 turns"* — hard bound against an asymptotic target at Fable prices.

---

## 7. Deliverables

### 7.1 Output of THIS (design) session — the only thing due now

- **`Fable-Sandbox/proposed-goal.md`** — the final, self-sufficient `/goal`, runnable start to finish in a fresh session, plus a short note on what you changed from the draft in Section 6 and why. That's it. Nothing else runs in this session.

  (Creating just the `Fable-Sandbox/` folder to hold this one file is fine; do **not** populate the sandbox with skill copies or drafts yet — that happens when the goal runs.)

### 7.2 What the goal will produce when RUN later (for reference, not this session)

1. The duplicated, improved `-fable` skills and commands inside `Fable-Sandbox/`.
2. `Fable-Sandbox/calibration-analysis.md` — the static gap map, per-stage attribution, what changed and why, and the before/after blind-run grading verdicts on the held-out topics.
3. `Fable-Sandbox/Generated-Drafts/` — the calibration drafts.

---

## 8. Success criteria — the gap rubric

"Nailed it" must be a decision procedure, not a vibe. Grading is done by **Opus subagents** (2–3 graders, majority vote) that classify **every** difference between a blind held-out v5 and its voice-preserved published final into these tiers and return a structured verdict:

| Tier | What it is | Allowed at success? |
|---|---|---|
| **0 — Substantive** | Missing/reordered sections, wrong framing, missing required elements | **Zero** |
| **1 — E-E-A-T** | Missing or unattributed named-expert quote | **Zero** |
| **2 — Voice/humor** | Clinical lead vs scene, keyword headers vs conversational, stripped asides/humor | **Zero** |
| **3 — Style mechanics** | Sentence-length distribution, paragraph density, spacing off vs the North Star bar | **Within tolerance** |
| **4 — Copy edits** | Synonym swaps, comma changes, tightening | **Allowed** — legitimate editing |

**The calibration succeeds when a blind held-out run leaves only Tier 4 differences.** Exact reproduction is neither expected nor the target — two excellent versions of the same article always differ at the word level; that's what Tier 4 is for. The `/goal` evaluator checks the graders' structured verdict ("zero Tier 0–3 gaps on both held-out topics"), not the prose itself, so the pass/fail is reliable.

### Acceptance — this (design) session

- [ ] `Fable-Sandbox/proposed-goal.md` exists, is self-sufficient (runnable start to finish in a fresh session), and notes what changed from the Section 6 draft and why.
- [ ] Nothing else was created or run — no skill copies, no drafts, no Opus calls.

### Acceptance — the calibration run (later, when the goal executes)

- [ ] `git status` / diff shows **zero modifications** to any original skill, command, workflow, or orchestrator — only new `Fable-Sandbox/` files.
- [ ] No `upload-to-gdocs` command was copied or run.
- [ ] All drafting/reviewing was done by Opus subagents; Fable only orchestrated and reviewed.
- [ ] For ≥2 held-out topics, the Opus grading verdict reports **zero Tier 0–3 gaps** vs the voice-preserved published final, with style matching the North Star bar.
- [ ] `calibration-analysis.md` and the improved `-fable` skills are written, with the reasoning recorded.
```
