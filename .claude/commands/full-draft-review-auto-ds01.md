# full-draft-review-auto-ds01

Automated full draft review workflow for **DS-01 articles** that chains all 5 review/upload commands together, automatically applying ALL changes at each step. Run once and walk away.

## Usage

- `/full-draft-review-auto-ds01` - Processes the most recent draft in /Generated-Drafts/
- `/full-draft-review-auto-ds01 filename.md` - Processes a specific file
- `/full-draft-review-auto-ds01 keyword` - Processes draft containing keyword in filename

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
│  Step 5: Upload to Google Docs (DS-01 folder + Phase 3)         │
└─────────────────────────────────────────────────────────────────┘
```

**No user interaction required** - just invoke the command and let it run.

## Version File Progression

| Step | Input File | Output File |
|------|------------|-------------|
| 1 | v1-[keyword].md | v2-seed-perspective-reviewed.md |
| 2 | v2-seed-perspective-reviewed.md | v3-reviewed.md |
| 3 | v3-reviewed.md | v4-sources-verified.md |
| 4 | v4-sources-verified.md | v5-claims-verified.md |
| 5 | v5-claims-verified.md | → Google Docs (DS-01 folder) |

## Implementation

### STEP 0: File Identification

Identify the starting file using standard logic:
- If no argument: Find most recent v1-*.md file in `/Generated-Drafts/` subdirectories
- If argument looks like filename: Use that specific file
- If argument is keyword: Find keyword folder and use latest version (prefer v1 if exists)

**Store the file path and keyword folder path** for use throughout the workflow.

**Verify this is a DS-01 article** by scanning for DS-01®, "Daily Synbiotic", probiotic/microbiome content. If it appears to be an NPD article (PM-02/DM-02/AM-02), warn and suggest `/full-draft-review-auto` instead.

### STEP 1: DS-01 Seed Perspective Review (Auto-Apply All)

Execute the full `/review-draft-seed-perspective-ds01` command logic:

1. **Load DS-01 Reference Files (2026 Messaging):**
   - `Reference/2026-03 DS-01 Updated Messaging Reference Files/POV_ 27APR2026.md`
   - `Reference/2026-03 DS-01 Updated Messaging Reference Files/New MRD/DS-01® Messaging + Positioning Reference Document • Claims Library.md`
   - `Reference/2026-03 DS-01 Updated Messaging Reference Files/New MRD/DS-01® Messaging + Positioning Reference Document • Product Positioning.md`
   - `Reference/2026-03 DS-01 Updated Messaging Reference Files/New MRD/DS-01® Messaging + Positioning Reference Document • Timeline of Benefits + Mechanisms.md`
   - `Reference/2026-03 DS-01 Updated Messaging Reference Files/New MRD/DS-01® Messaging + Positioning Reference Document - disclaimer cheat sheet.md`
   - Plus shared compliance/tone files (NO-NO-WORDS, What we are and are not allowed to say, Tone of Voice 2026, COPYStyleGuide)

2. **Relevance Analysis** - Map article keyword to messaging pillars and Timeline of Benefits phases
3. **Grade Against 15 DS-01 Checks:**
   - Claims Library Compliance (5): Claims Library language, disclaimers, substantive claims, no individual strain names, attribution
   - POV & Messaging Alignment (5): POV positions, gut-[topic] axis, ViaCap®, clinical trials (Allegretti 2026), complementary positioning
   - DS-01 Differentiators (5): Messaging pillar talking points, Timeline of Benefits phasing, clinical data, educational angle, Dirk quote
4. **Generate Report** - Show the full analysis

**AUTO-APPLY:** Instead of asking "Would you like me to fix these issues?", automatically:
- Apply ALL fixes (equivalent to user typing 'all')
- Create v2-seed-perspective-reviewed.md
- Preserve original v1 file

**Progress Output:**
```
═══════════════════════════════════════════════════
📋 STEP 1/5: DS-01 Seed Perspective Review
═══════════════════════════════════════════════════
[Show abbreviated analysis - just grade and summary]
✅ Applied ALL fixes → v2-seed-perspective-reviewed.md
```

### STEP 2: Quality Review (Auto-Apply All)

Using v2-seed-perspective-reviewed.md as input, execute `/review-draft-1-v2` logic **in DS-01 mode**:

1. **Product Detection** - Should detect DS-01 (if not, force DS-01 mode)
2. **Relevance Analysis** - Map to messaging pillars and Timeline phases
3. **PRIMARY Grading** - 15 Seed perspective checks (DS-01 version)
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
📋 STEP 2/5: Quality Review
═══════════════════════════════════════════════════
[Show abbreviated analysis - grades and key issues]
✅ Applied ALL fixes → v3-reviewed.md
```

### STEP 3: Sources Verification (Auto-runs)

Using v3-reviewed.md as input, execute `/review-sources-2-v3` logic:

1. **Extract All Citations** - Parse citations section and inline references
2. **Triple-Fallback Verification** - PubMed API → WebFetch → Firecrawl
3. **Fix Invalid Citations** - Search PubMed for correct sources
4. **Update Article** - Replace all instances of corrected citations

This step already runs without prompts - just execute and save.

**Progress Output:**
```
═══════════════════════════════════════════════════
📋 STEP 3/5: Sources Verification
═══════════════════════════════════════════════════
📚 Verified X citations
✅ Valid: Y | ❌ Fixed: Z | ⚠️ Manual: W
✅ Saved → v4-sources-verified.md
```

### STEP 4: Claims Verification (Auto-Apply All)

Using v4-sources-verified.md as input, execute `/review-claims-3-v3` logic:

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
📋 STEP 4/5: Claims Verification
═══════════════════════════════════════════════════
📊 Claims Analyzed: X
✅ Supported: Y | ⚠️ Partial: Z | ❌ Fixed: W
✅ Applied ALL changes → v5-claims-verified.md
```

### STEP 5: Upload to Google Docs (DS-01)

Using v5-claims-verified.md as input, execute `/upload-to-gdocs-ds01` logic:

1. **Extract Primary Keyword** - From line 3 metadata
2. **Create Google Doc** - Using google-docs skill
3. **Insert Content** - Full markdown content
4. **Move to DS-01 Folder** - Using google-drive skill (folder: `1c6L_PMTktN3lNUz64TQpapA9pE--yY_V`)
5. **Update Tracking Sheet** - Using google-sheets skill (tab: "Phase 3 Tracking")
6. **Add Date-Stamped Note** - "M/D: ready for review"

**Progress Output:**
```
═══════════════════════════════════════════════════
📋 STEP 5/5: Upload to Google Docs (DS-01)
═══════════════════════════════════════════════════
✅ Created Google Doc: [keyword]
✅ Moved to DS-01 drafts folder
✅ Updated Phase 3 tracking spreadsheet (row X)
🔗 Link: [Google Docs URL]
```

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
└── v5-claims-verified.md → Claims verification

📤 Uploaded to Google Docs (DS-01 folder):
🔗 [Full Google Docs URL]
📊 Added to Phase 3 tracking: Row X

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

Step 5 (Upload):
- ✅ Google Doc created and tracked (Phase 3)

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
/review-sources-2-v3 [path-to-v3-reviewed.md]
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

| Use `/full-draft-review-auto-ds01` when: | Use individual commands when: |
|------------------------------------------|-------------------------------|
| You want "set it and forget it" | You want to review each step's output |
| You always accept all changes | You want selective control over fixes |
| Processing a standard DS-01 draft | Draft has unusual issues needing attention |
| Batch processing multiple DS-01 drafts | Learning/auditing the review process |

## When to Use This vs `/full-draft-review-auto`

| Use `/full-draft-review-auto-ds01` | Use `/full-draft-review-auto` |
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
/full-draft-review-auto-ds01 066-probiotics-for-bloating
/full-draft-review-auto-ds01 067-best-probiotic-for-ibs
/full-draft-review-auto-ds01 068-gut-brain-axis
```

Each invocation is independent and will process the specified draft through the full workflow.
