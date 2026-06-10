# full-draft-review-auto-ds01-fable

> **FABLE SANDBOX COPY** — calibration version of `full-draft-review-auto-ds01`. The Google Docs upload stage has been removed per the calibration hard constraints: **the pipeline ends at v5**. All file operations stay inside `Fable-Sandbox/`. This copy may be freely modified during calibration; the original in `.claude/commands/` is read-only.

Automated full draft review workflow for **DS-01 articles** that chains all 4 review commands together, automatically applying ALL changes at each step. Run once and walk away.

## Usage

- `/full-draft-review-auto-ds01-fable` - Processes the most recent draft in /Fable-Sandbox/Generated-Drafts/
- `/full-draft-review-auto-ds01-fable filename.md` - Processes a specific file
- `/full-draft-review-auto-ds01-fable keyword` - Processes draft containing keyword in filename

## What This Command Does

Runs the complete DS-01 review workflow **automatically**, applying all recommended changes at each step:

```
┌─────────────────────────────────────────────────────────────────┐
│  Step 1: DS-01 Seed Perspective Review → Apply ALL              │
│  ↓                                                              │
│  Step 2: Quality Review (DS-01 mode) → Apply ALL                │
│  ↓                                                              │
│  Step 3: Sources Verification → Auto-saves                      │
│  ↓                                                              │
│  Step 4: Claims Verification → Apply ALL                        │
│  ↓                                                              │
│  DONE — v5-claims-verified.md is the finish line (no upload)    │
└─────────────────────────────────────────────────────────────────┘
```

**No user interaction required** - just invoke the command and let it run.

## Version File Progression

| Step | Input File | Output File |
|------|------------|-------------|
| 1 | v1-[keyword].md | v2-seed-perspective-reviewed.md |
| 2 | v2-seed-perspective-reviewed.md | v3-reviewed.md |
| 3 | v3-reviewed.md | v4-sources-verified.md |
| 4 | v4-sources-verified.md | v5-claims-verified.md (FINAL — no upload) |

## Implementation

### STEP 0: File Identification

Identify the starting file using standard logic:
- If no argument: Find most recent v1-*.md file in `/Fable-Sandbox/Generated-Drafts/` subdirectories
- If argument looks like filename: Use that specific file
- If argument is keyword: Find keyword folder and use latest version (prefer v1 if exists)

**Store the file path and keyword folder path** for use throughout the workflow.

**Verify this is a DS-01 article** by scanning for DS-01®, "Daily Synbiotic", probiotic/microbiome content. If it appears to be an NPD article (PM-02/DM-02/AM-02), warn and suggest `/full-draft-review-auto` instead.

### STEP 0.5: SciCare POV Brief Lookup

Search `Reference/SciCare POV briefs/` (including all subfolders) for a markdown file whose name matches or closely matches the article keyword.

```bash
find "Reference/SciCare POV briefs" -name "*.md" -type f 2>/dev/null
```

**Matching logic:**
- Exact match: keyword is "gut health detox" → look for `gut health detox.md`
- Fuzzy match: if no exact match, check if any filename contains the keyword or vice versa
- If multiple matches, prefer the most specific one

**If a matching POV brief is found:**
1. Read the file in full
2. Extract:
   - **SciCare's POV/Key Takeaway** — the scientific perspective on this topic
   - **Suggested References** — pre-vetted academic sources with DOIs/URLs
   - **Any specific cautions or nuances** — things SciCare flagged as important
3. Store this as the **POV Brief Guardrail** — it applies to ALL subsequent review steps
4. Log: `Found SciCare POV brief: [filename] — applying as alignment guardrail`

**If no matching POV brief is found:**
- Log: `No SciCare POV brief found for this keyword — proceeding with standard review`
- Continue to Step 1 as normal

**How the POV Brief Guardrail applies to all steps:**

When a POV brief is loaded, every review step must additionally check:
1. **Alignment**: Does the draft's narrative align with SciCare's stated POV? Flag any sections where the draft contradicts or undermines the POV.
2. **Reference incorporation**: Did the draft use the suggested references from the POV brief? If key references were omitted, flag this as a gap.
3. **Revision safety**: Before applying any fix, verify it does NOT contradict the POV brief. If a proposed revision would conflict with SciCare's position, skip that revision and flag it for manual review instead.

This is a guardrail, not a suggestion — the POV brief represents SciCare's vetted scientific position. No automated fix should override it.

### STEP 1: DS-01 Seed Perspective Review (Auto-Apply All)

Execute the full `/review-draft-seed-perspective-ds01-fable` command logic:

1. **Load DS-01 Reference Files (2026 Messaging):**
   - `Reference/2026-03 DS-01 Updated Messaging Reference Files/POV_ 27APR2026.md`
   - `Reference/2026-03 DS-01 Updated Messaging Reference Files/New MRD/DS-01® Messaging + Positioning Reference Document • Claims Library.md`
   - `Reference/2026-03 DS-01 Updated Messaging Reference Files/New MRD/DS-01® Messaging + Positioning Reference Document • Product Positioning.md`
   - `Reference/2026-03 DS-01 Updated Messaging Reference Files/New MRD/DS-01® Messaging + Positioning Reference Document • Timeline of Benefits + Mechanisms.md`
   - `Reference/2026-03 DS-01 Updated Messaging Reference Files/New MRD/DS-01® Messaging + Positioning Reference Document - disclaimer cheat sheet.md`
   - Plus shared compliance/tone files (NO-NO-WORDS, What we are and are not allowed to say, Tone of Voice 2026, COPYStyleGuide)

2. **Relevance Analysis** - Map article keyword to messaging pillars and Timeline of Benefits phases
3. **Grade Against DS-01 Checks (19 standard + up to 3 POV brief checks if applicable):**
   - Claims Library Compliance (5): Claims Library language, disclaimers, substantive claims, no individual strain names, attribution
   - POV & Messaging Alignment (5): POV positions, gut-[topic] axis, ViaCap®, clinical trials (Allegretti 2026), complementary positioning
   - DS-01 Differentiators (5): Messaging pillar talking points, Timeline of Benefits phasing, clinical data, educational angle, Dirk quote
   - Objectivity & Implied Claims Guard (4): No implied superiority, no implied synergy, research/product separation, topic appropriateness + hedging + per-claim presentation
   - **SciCare POV Brief Alignment (if POV brief was loaded in Step 0.5):**
     - (SC-1) Does the draft's core narrative align with SciCare's stated POV/Key Takeaway?
     - (SC-2) Were the suggested references from the POV brief incorporated (or was there a good reason to omit them)?
     - (SC-3) Does any section of the draft contradict SciCare's position or make claims the POV brief explicitly warns against?
4. **Generate Report** - Show the full analysis

**AUTO-APPLY:** Instead of asking "Would you like me to fix these issues?", automatically:
- Apply ALL fixes (equivalent to user typing 'all')
- **POV Brief Safety Check**: Before applying each fix, verify it does NOT contradict the SciCare POV brief (if one was loaded). If a fix would conflict, skip it and flag it in the output as `⚠️ Skipped (conflicts with SciCare POV brief): [description]`
- Create v2-seed-perspective-reviewed.md
- Preserve original v1 file

**Progress Output:**
```
═══════════════════════════════════════════════════
STEP 1/4: DS-01 Seed Perspective Review
═══════════════════════════════════════════════════
[Show abbreviated analysis - just grade and summary]
[If POV brief loaded: show SciCare alignment grade (SC-1, SC-2, SC-3)]
Applied ALL fixes → v2-seed-perspective-reviewed.md
[If any fixes skipped due to POV conflict: list them]
```

### STEP 2: Quality Review (Auto-Apply All)

Using v2-seed-perspective-reviewed.md as input, execute `/review-draft-1-v2-fable` logic **in DS-01 mode**:

1. **Product Detection** - Should detect DS-01 (if not, force DS-01 mode)
2. **Relevance Analysis** - Map to messaging pillars and Timeline phases
3. **PRIMARY Grading** - 19 Seed perspective checks (DS-01 version, including Objectivity & Implied Claims Guard)
4. **SECONDARY Checks** - Citations, Product Refs, Compliance, Structure, Tone, SEO
5. **Generate Report** - Show full analysis

**DS-01-specific adjustments for SECONDARY checks:**
- **Product References:** Check for DS-01® with ® symbol, linked to https://seed.com/daily-synbiotic (NOT NPD product URLs)
- **Compliance:** Same NO-NO words and forbidden claims apply
- **Structure:** Same requirements (Overview, Key Insight, FAQs, Citations)

**AUTO-APPLY:** Instead of asking "Would you like me to fix these issues?", automatically:
- Apply ALL fixes (equivalent to user typing 'all')
- Create v3-reviewed.md
- Preserve v2 file

**Progress Output:**
```
═══════════════════════════════════════════════════
📋 STEP 2/4: Quality Review
═══════════════════════════════════════════════════
[Show abbreviated analysis - grades and key issues]
✅ Applied ALL fixes → v3-reviewed.md
```

### STEP 3: Sources Verification (Auto-runs)

Using v3-reviewed.md as input, execute `/review-sources-2-v3-fable` logic:

1. **Extract All Citations** - Parse citations section and inline references
2. **Triple-Fallback Verification** - PubMed API → WebFetch → Firecrawl
3. **Fix Invalid Citations** - Search PubMed for correct sources
4. **Update Article** - Replace all instances of corrected citations

This step already runs without prompts - just execute and save.

**Progress Output:**
```
═══════════════════════════════════════════════════
📋 STEP 3/4: Sources Verification
═══════════════════════════════════════════════════
📚 Verified X citations
✅ Valid: Y | ❌ Fixed: Z | ⚠️ Manual: W
✅ Saved → v4-sources-verified.md
```

### STEP 4: Claims Verification (Auto-Apply All)

Using v4-sources-verified.md as input, execute `/review-claims-3-v3-fable` logic:

1. **Claim Extraction** - Find all sentences with citations
2. **Fetch Source Content** - PubMed → WebFetch → Firecrawl
3. **Verify Claims** - Compare claims against source abstracts
4. **Generate Recommendations** - MODIFY, REPLACE, or REMOVE

**AUTO-APPLY:** Instead of asking "Apply Changes?", automatically:
- Apply ALL recommended changes (equivalent to user typing 'all')
- Create v5-claims-verified.md
- Preserve v4 file

**Progress Output:**
```
═══════════════════════════════════════════════════
📋 STEP 4/4: Claims Verification
═══════════════════════════════════════════════════
📊 Claims Analyzed: X
✅ Supported: Y | ⚠️ Partial: Z | ❌ Fixed: W
✅ Applied ALL changes → v5-claims-verified.md
```

### STEP 5: REMOVED IN SANDBOX — pipeline ends at v5

The Google Docs upload stage is intentionally removed from this calibration copy. **`v5-claims-verified.md` is the finish line.** Do not invoke any `upload-to-gdocs*` command. Do not touch Google Docs, Drive, or Sheets.

### FINAL: Completion Summary

```
═══════════════════════════════════════════════════════════════════
🎉 FULL DS-01 DRAFT REVIEW COMPLETE!
═══════════════════════════════════════════════════════════════════

📁 Original: v1-[keyword].md (preserved)

Version Progression:
├── v1-[keyword].md → Original
├── v2-seed-perspective-reviewed.md → DS-01 Seed alignment fixes
├── v3-reviewed.md → Quality & compliance fixes
├── v4-sources-verified.md → Citation verification
└── v5-claims-verified.md → Claims verification (FINAL)

═══════════════════════════════════════════════════════════════════
📋 Summary of All Changes Applied:
═══════════════════════════════════════════════════════════════════

Step 1 (DS-01 Seed Perspective):
- [Brief summary of fixes applied]

Step 2 (Quality Review):
- [Brief summary of fixes applied]

Step 3 (Sources):
- Verified: X | Fixed: Y | Manual: Z

Step 4 (Claims):
- Analyzed: X | Supported: Y | Modified: Z

═══════════════════════════════════════════════════════════════════
```

## Error Handling

If any step fails:
1. **Report the error** with full details
2. **Save progress** - Keep all version files created up to that point
3. **Provide manual recovery command** - Show the exact command to resume from the failed step

Example:
```
❌ STEP 3 FAILED: Sources Verification

Error: PubMed API rate limited

Progress saved:
✅ v2-seed-perspective-reviewed.md
✅ v3-reviewed.md (saved before failure)

To resume manually, run:
/review-sources-2-v3-fable [path-to-v3-reviewed.md]
```

## Important Notes

- **DS-01 articles only** - For NPD articles (PM-02/DM-02/AM-02), use `/full-draft-review-auto`
- **All original files preserved** - Never overwrites, only creates new versions
- **Fully automatic** - No user interaction required after invocation
- **Progress tracking** - Shows each step as it completes
- **Atomic steps** - Each step saves before moving to the next
- **Graceful failure** - Saves progress even if a step fails
- **Same quality** - Applies identical logic as running commands individually
- **Time estimate** - Typically takes 5-10 minutes depending on citation count
- **Uploads to DS-01 folder** - NOT the NPD folder
- **Tracks in Phase 3** - NOT Phase 2

## When to Use This vs Individual Commands

| Use `/full-draft-review-auto-ds01-fable` when: | Use individual commands when: |
|------------------------------------------|-------------------------------|
| You want "set it and forget it" | You want to review each step's output |
| You always accept all changes | You want selective control over fixes |
| Processing a standard DS-01 draft | Draft has unusual issues needing attention |
| Batch processing multiple DS-01 drafts | Learning/auditing the review process |

## When to Use This vs `/full-draft-review-auto`

| Use `/full-draft-review-auto-ds01-fable` | Use `/full-draft-review-auto` |
|-------------------------------------|-------------------------------|
| DS-01® Daily Synbiotic articles | PM-02® Sleep + Restore articles |
| Probiotic/microbiome/gut health topics | DM-02® Daily Multivitamin articles |
| References 2026 DS-01 Messaging Reference docs | AM-02® Energy + Focus articles |
| Uploads to DS-01 Drive folder | References NPD Claims + Messaging docs |
| Tracks in Phase 3 Tracking | Uploads to NPD Drive folder |
| | Tracks in Phase 2 Tracking |

## Batch Processing

To process multiple DS-01 drafts, run the command multiple times:
```
/full-draft-review-auto-ds01-fable 066-probiotics-for-bloating
/full-draft-review-auto-ds01-fable 067-best-probiotic-for-ibs
/full-draft-review-auto-ds01-fable 068-gut-brain-axis
```

Each invocation is independent and will process the specified draft through the full workflow.
