---
tags: [type/reference, source/claude-code, topic/seo, topic/seed-pipeline, client/seed, status/final]
date: 2026-06-10
session-topic: seed-source-fitness-pipeline-upgrade
---

# Claude Code Session: Seed DS-01 Source-Fitness Pipeline Upgrade

**Date**: 2026-06-10
**Session Duration**: Single working session

## Problem/Challenge

A standalone `SKILL.md` (the `summary-creation` skill in `~/Downloads`) used by the SciCare team to gather high-quality scientific sources contained source-selection rules the Seed DS-01 content pipeline lacked. The core question: **would porting any of its methodology improve source quality in the DS-01 generation and review workflows?**

The investigation distinguished two different things a pipeline can optimize for:
- **Source integrity** — does the DOI resolve, is it the right paper, does the abstract back the claim? (The Seed pipeline was already very strong here.)
- **Source *fitness*** — even if real and on-point, is it the *right kind* of study (population, scope, recency, reputability) for who we're writing for? (Largely absent.)

## Solution Summary

Added a **source-fitness layer** at the points where sources are *selected* and *reviewed*, rather than copying the whole `summary-creation` skill. Three files changed (all additive, all backed up, repo confirmed pushed to GitHub first). A fourth file was assessed and a serious staleness problem documented but **deferred** by user choice.

Key framing that emerged:
- The DS-01 **review** commands are a *fraud/accuracy audit* (integrity).
- The DS-01 **generation** side is *source harvesting + prioritization*, not discovery — Tier 3 sources are whatever competitors cited (a quality ceiling). It already owns `pubmed-research`/`academic-paper-research` skills but only the review steps used them.

## Technical Implementation

**Repo:** `Seed-SEO-Draft-Generator-v4` is its own nested git repo (NOT a submodule of the vault), remote `github.com/dperalta716/obsidian-vault-Seed-SEO-Draft-Generator`. Verified backed up before edits: local HEAD `2a8156b` == GitHub `main`.

**Backup convention used:** `<file>.backup.2026-06-10` (matches existing `.backup.YYYY-MM-DD` pattern).

**Call graph confirmed:**
```
orchestrate-ds01-drafts (skill)
├─ /generate-ds01-draft (skill) .............. GENERATION
└─ /full-draft-review-auto-ds01 (command)
      └─ Step 3 runs /review-sources-2-v3 (command) ... REVIEW
```
No skill version of review-sources exists — it is command-only.

**Edits made (additive only):**

1. `.claude/skills/generate-ds01-draft/SKILL.md` — Phase 2 → Step 2.1 §C "Build Evidence Strategy":
   - **Source Fitness Gate** (Tier 3 only; Tier 0 SciCare brief + Tier 1 Claims Library exempt): population match, scope match, recency (2019+), reputability.
   - **Guided Discovery**: for a topic claim with no Tier 0/1 source, run `pubmed-search.sh "[claim topic] healthy adults" 5 relevance` to *find* a best-fit source instead of borrowing the competitor's. Never for DS-01 product claims (Claims-Library-locked).
   - **Mandatory auto-caveat**: if topic evidence skews animal/in-vitro, the draft is written WITH a "human research is limited" caveat in the prose (varied wording).

2. `.claude/commands/review-sources-2-v3.md` — new sub-step **3f** after 3e: record study type / population / year per VALID citation; flag (never auto-replace) population mismatch / scope drift / stale / reputability. Flags appended to the END of the new version file as `## Reviewer Notes — Source Fitness` so they travel into Google Docs.

3. `.claude/commands/phase-1-analyze-seo-draft-external-mrd-compliant.md` — into the "Source Quality Rules" block: added **population/model fit** (overrides study-type ranking), **scope match**, and **evidence-base transparency** (preclinical caveat written into prose). Deliberately did NOT add a hard 2019+ rule here — Phase-1 revisions preserve all existing citations even if old.

**Verification of diffs:** `diff <file>.backup.2026-06-10 <file>` showed inserts only (no deletions) on all three.

## Key Learnings

- **Integrity ≠ fitness.** A citation can pass DOI verification and abstract-match yet still be a poor fit (wrong population, off-scope, stale). The review pipeline only caught the former.
- **The DS-01 generation side does not discover sources** — it harvests Tier 0 (SciCare brief), Tier 1 (Claims Library), and Tier 3 (competitor-scraped DOIs). Without a SciCare brief, topic evidence is capped at "what competitors cited." Guided Discovery (PubMed) breaks that ceiling.
- **SciCare POV briefs already do fitness work** — they annotate each reference with Article Type / Population/Demographic / Open Access. The gap is only brief-less topics + Tier 3 + the review steps.
- **`review-sources-2-v3` already reads `/Phase 1 Draft Revsions/`** — so the 3f fitness flags automatically cover Phase-1 v2 drafts; no extra work needed there.
- **Don't impose 2019+ on Phase-1 revisions** — that pipeline preserves all existing (often older) citations by design; "last 10 years unless landmark" is correct there.
- **Flag, don't auto-replace** fitness issues — auto-swapping a valid source risks substituting a worse-matched one; let a human/SciCare decide.
- **Batch mode constraint** — `orchestrate-ds01-drafts` fans out in parallel, so a "pause and ask" gate (like summary-creation uses) would break it. Chosen behavior: auto-caveat in prose + flags at bottom of draft.
- **Seed-v4 is a nested repo** — git operations must `cd` into the folder; the parent vault repo does not track its `.claude/` files.

## Related Notes

- [[project_phase1_editor_stale]] (memory)
- [[project_seed_no_strain_names]] (memory)
- [[feedback_seed_drafting_changes]] (memory)
- [[feedback_never_edit_in_place]] (memory)

## Follow-up Actions

- **DEFERRED (user chose "just assess for now"):** `phase-1-revised-draft-editor.md` (the Claude drafting/QA step that produces the corrected v2) is ~6 months stale — last changed 2025-12-01, predates the 2026 MRD overhaul. Zero references to Claims Library / POV / MRD / Disclaimer Cheat Sheet / SciCare / compliance guards / "Inspiring Scientist" voice. **Actively reverses** the MRD analyze step: re-adds stripped strain names (L92/L148/L194) and enforces a 15–17 citation target (L76/L215) that the MRD step abolished. Proposed fix scope: invert strain-name rule, drop citation target → preserve-all, add 2026 compliance guards + disclaimer symbols + voice, add source-fitness criterion.
- **Smoke test the live edits:** run the external MRD analyze on a published article whose topic leans preclinical (mushroom / green-tea) and confirm the generated instructions now (a) prefer healthy-adult sources and (b) tell the drafter to write the "human research is limited" caveat. Likewise run `/generate-ds01-draft` on a brief-less keyword to confirm Guided Discovery + auto-caveat fire.
- **Commit:** three edits not yet committed; auto-backup ("vault backup" commit, ~10 min cadence) will sweep + push them. Commit explicitly if a descriptive message is wanted.
- `analyze-seo-draft.md` confirmed **legacy** (non-MRD generic instructions generator, superseded) — intentionally left untouched.
