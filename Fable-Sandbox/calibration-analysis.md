# DS-01 Pipeline Calibration — Analysis & Change Log

**Run date:** 2026-06-10
**Orchestrator:** Fable 5 (this session). All drafting/reviewing/grading by Opus subagents.
**Goal:** Blind end-to-end `-fable` run produces a v5 carrying Seed's voice, humor, structure, and named-expert E-E-A-T at the North Star bar. Done = zero Tier 0/1/2 gaps + Tier 3 within tolerance on BOTH held-out topics (best tea 068, probiotic drinks 067), plus brief-pathway smoke test (prebiotic foods 108) passes.

---

## 1. North Star Style DNA (extracted from the 9 gold-standard articles)

The reproducible target a generator must hit on an unseen topic:

1. **Intro = 3-part scene.** Open IN the reader's lived moment (at the shelf, just diagnosed, day 3 of capsules) → validate it → fast plain answer ("The short answer is…") → "but it's more nuanced" pivot. 3-5 short paragraphs, 1-3 sentences each.
2. **Named-expert E-E-A-T.** Dirk Gevers, Ph.D. quote attributed WITH title — "Chief Scientific Officer at Seed Health." 1 quote is the strong default. Quote speaks to the SCIENCE (transience, strain-specificity, precision), NEVER names a product.
3. **Headers: conversational + keyword.** Either ask the reader's literal question, or `Vivid Concept: plain-language payoff`. Parenthetical/colon-subtitle asides are signature. Keyword lands naturally in H1, ≥1 H2, Overview, first paragraphs, Key Insight, 2-3 FAQs.
4. **Dense connective tissue.** A conversational device every 1-2 paragraphs: "Here's the thing", "The short answer?", "Let's break it down", direct you/your, ≤1 rhetorical Q per 400-500 words.
5. **Closer = "The Key Insight".** Re-answer plainly → reframe as long-term *practice* → extended ecosystem metaphor (garden/seed/city/orchestra) → warm "seeded in science" / "good health isn't hacked—it's cultured" grounding line. 150-220 words.
6. **Competitive myth-busting.** Name the standard advice ("you've probably heard…", "it's a common belief that…") then pivot "but the science tells a different story."
7. **Humor/empathy on embarrassing topics.** Validation sentence ("you're not alone / this is normal") + one light self-aware beat. Metaphor before the technical term, every time.
8. **Mechanics (corpus avg):** ~1,950 words; avg sentence ~17-19 words with high variation (3-word punches next to 30-word explanations); max 3 sentences/paragraph; H2 sections ~180-320 words; 6-10 H2s; 3-5 Overview bullets; 3-5 FAQs with bolded lead answers.

*(Carve-out: emoji, callout boxes, and internal seed.com links are editor-added — drafts are forbidden from producing them, so their absence is never a gap.)*

---

## 2. Static Gap Map — TRAIN topic (fermented foods, 060)

### Headline result: the review chain is preservation-clean. v1 voice ≈ v5 voice.
Intro, headers, expert quote, connective tissue, and closer all survive v1→v5 essentially unchanged. So the gaps vs. the published final are almost entirely **generator absences at birth**, not review-stage erosion.

### v5-vs-final gaps, tiered:

| Tier | Gap | Owner |
|---|---|---|
| **1 E-E-A-T** | Expert quote attributed "says Dirk Gevers, Ph.D." with **no title**. "Chief Scientific Officer at Seed Health" never present in any draft stage. | **Generator** (v3 also misses it as E-E-A-T checkpoint) |
| **2 Voice** | Closer is clinical/declarative — no extended metaphor, no kicker. Final adds "One is the garden you tend daily… The other is the carefully selected seed you plant…" + "The strongest gut ecosystems aren't built on a single food or a single strain." | **Generator** (v2 pushes it *more* clinical) |
| **2 Voice** | No humor/aside beats beyond baseline "here's the thing." | **Generator** |
| **0 Substantive** | Under-segmentation: SCFA production and "why fermented ≠ probiotics" buried inside other sections instead of dedicated H3s. | **Generator** |

### Per-element erosion table (v1→v5):

| Element | v1 | v2 | v3 | v4 | v5 | Blame |
|---|---|---|---|---|---|---|
| Intro | scene present | = | = | = | = | generator (missing humor beat = absence, not erosion) |
| Headers | conv/keyword mix | = | minor rename | = | = | generator (under-segmentation) |
| Expert quote | present, **no title** | improved, no title | no title | = | = | **generator** (v3 misses) |
| Connective tissue | rich asides | = | = | = | = | none (final trims editorially) |
| Closer | flat, no metaphor | **more clinical** | = | = | = | generator + v2 |

### Negatives confirmation (059 yogurt, 061 ACV)
Pattern confirmed from the audits: editor destroyed those intros (scene → clinical/chemical lead) and dropped the named expert. We must NOT optimize toward those finals — for those topics the v5 *draft* is the better voice reference. No action beyond avoidance.

---

## 3. April-Regression Check — RESULT
Regenerated the train v1 with the *current* (pre-edit) `-fable` generator on the frozen stage1 (Opus, blind). The fresh v1 self-assessment confirmed the gap map exactly: scene intro present, conversational headers present, expert quote present **but no title**, closer ends on a warm grounding line **but no extended metaphor**. So the deficiency is NOT an April-vs-now regression of voice instructions (the current generator's voice spec is actually richer than April's and adds the scene→answer→nuance intro architecture April lacked) — it is a set of **generator absences** the spec never required strongly enough. Conclusion: fix by *strengthening* the existing voice requirements, not by reverting to April. No compliance rule touched.

---

## 4. Diagnosis → Planned -fable Edits

**Primary owner is the generator.** The current generator (598 lines vs April's 312) actually contains a *richer* voice spec than April (it even adds the scene→answer→nuance intro architecture April lacked). The risk is that the concrete voice guidance is buried under a large compliance wall (Step 2.1) and an abstract "Inspiring Scientist" preamble, so it under-fires on the closer, the expert title, humor, and segmentation. Fixes (batched, one v1 regeneration):

- **G1 (Tier 1):** Require the Dirk Gevers attribution to carry name + credential + title ("Dirk Gevers, Ph.D., Chief Scientific Officer at Seed Health") on first use. Add to compliance self-check.
- **G2 (Tier 2):** Make the "The Key Insight" closer mandatory-include an extended ecosystem metaphor + a warm "cultured/seeded in science" grounding kicker. Give a concrete pattern, not just "warm grounding line."
- **G3 (Tier 2):** Add explicit humor/empathy beat requirement (validation sentence + one light aside on any embarrassing dimension; metaphor-before-term).
- **G4 (Tier 0):** Instruct dedicated H2/H3 segmentation of distinct mechanisms rather than burying them.

**Review-stage guardrails (downstream-first, reuse frozen v1):**
- **R-v2 (seed-perspective):** Add a Voice-Preservation Guardrail (parallel to the POV Brief Guardrail) — when injecting compliance/messaging, do not flatten the scene intro, the metaphor closer, or conversational headers; compliance is ADDED around voice, never by replacing it.
- **R-v3 (review-draft-1):** Add an explicit E-E-A-T check: the named expert quote must carry name + title; if missing, ADD the title rather than only flagging.

---

## 5. Change Log

All edits are confined to `Fable-Sandbox/`. No compliance rule was removed or softened anywhere — every change ADDS a voice requirement or a voice-preservation guardrail.

### Generator — `Fable-Sandbox/skills/generate-ds01-draft-fable/SKILL.md`
- **G1 (Tier 1 E-E-A-T):** Dirk Gevers quote attribution must carry full credential + title on first use ("Dirk Gevers, Ph.D., Chief Scientific Officer at Seed Health"). Added to the quote rules and to the compliance self-check. *Why:* the bare "says Dirk Gevers, Ph.D." was present-absent at v1 and never added downstream — the clearest generator gap.
- **G2 (Tier 2 voice — closer):** "The Key Insight" now has a REQUIRED 4-step closer pattern: plain re-answer → reframe as long-term practice → extended ecosystem metaphor across 2-3 sentences → warm cultivation/"seeded in science" grounding line (no emoji). Mirrored into the article-structure template and the self-check. *Why:* drafts produced a competent-but-flat closer; the memorable garden/seed metaphor was always editor-added.
- **G3 (Tier 2 voice — humor/metaphor density):** Upgraded humor from "occasional/where natural" to a firm requirement — a conversational device roughly every other paragraph; on embarrassing dimensions a validation sentence precedes any joke; metaphor-before-the-technical-term at each mechanism. Added to self-check. *Why:* the North Star carries this density; drafts under-fired.
- **G4 (Tier 0 structure):** Outline step now requires each distinct mechanism/distinction (SCFA, fermented≠probiotic, survivability, diversity-vs-volume) to earn its own H2/H3 rather than being buried. Added to self-check. *Why:* under-segmentation forced editorial restructuring.

### Review v2 — `Fable-Sandbox/commands/review-draft-seed-perspective-ds01-fable.md`
- **R-v2 Voice-Preservation Guardrail** (parallel to the existing POV Brief Guardrail): every messaging/compliance fix must ADD around the voice, never flatten it — scene intro stays a scene, metaphor closer stays, conversational headers stay, asides stay, expert attribution keeps its title (add it if missing). When compliance and voice collide, separate into adjacent sentences/paragraphs. *Why:* the erosion diagnostic showed this is the only stage that materially rewrites prose, and it pushed the closer *more* clinical.

### Review v3 — `Fable-Sandbox/commands/review-draft-1-v2-fable.md`
- **R-v3 E-E-A-T check:** Structure & Length now verifies the expert attribution carries the full title and **adds it if the quote is present but untitled** (not merely flags). Added a VOICE PRESERVATION line to the content-preservation guardrail so messaging injection here also can't clinicalize the intro/closer/headers. *Why:* v3 is the natural E-E-A-T checkpoint but missed the titleless expert on the train topic.

### Flag-rule note (README §5b)
None of these edits touch Phase 0 (brief lookup), the evidence hierarchy/tiers, or the POV Brief Guardrail. They are purely additive voice requirements and voice-preservation guardrails, so they are expected to coexist with the brief machinery — to be confirmed by the brief-pathway smoke test (§7).

## 6. Held-Out Verdicts
*(populated at acceptance)*

## 7. Brief-Pathway Smoke Test (prebiotic foods 108)
*(populated after both held-out topics pass)*
