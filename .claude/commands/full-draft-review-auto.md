# full-draft-review-auto

Automated full draft review workflow that chains all 5 review/upload commands together, automatically applying ALL changes at each step. Run once and walk away.

## Usage

- `/full-draft-review-auto` - Processes the most recent draft in /Generated-Drafts/
- `/full-draft-review-auto filename.md` - Processes a specific file
- `/full-draft-review-auto keyword` - Processes draft containing keyword in filename

## What This Command Does

Runs the complete review workflow **automatically**, applying all recommended changes at each step:

```
┌─────────────────────────────────────────────────────────────────┐
│  Step 1: Seed Perspective Review → Apply ALL                   │
│  ↓                                                              │
│  Step 2: Quality Review → Apply ALL                             │
│  ↓                                                              │
│  Step 3: Sources Verification → Auto-saves                      │
│  ↓                                                              │
│  Step 4: Claims Verification → Apply ALL                        │
│  ↓                                                              │
│  Step 5: Upload to Google Docs                                  │
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
| 5 | v5-claims-verified.md | → Google Docs |

## Implementation

### STEP 0: File Identification

Identify the starting file using standard logic:
- If no argument: Find most recent v1-*.md file in `/Generated-Drafts/` subdirectories
- If argument looks like filename: Use that specific file
- If argument is keyword: Find keyword folder and use latest version (prefer v1 if exists)

**Store the file path and keyword folder path** for use throughout the workflow.

### STEP 1: Seed Perspective Review (Auto-Apply All)

Execute the full `/review-draft-seed-perspective` command logic:

1. **Product Auto-Detection** - Scan article to determine PM-02/DM-02/AM-02
2. **Load Reference Files** - Claims docs, NPD Messaging, SciComms Education
3. **Relevance Analysis** - Identify which SciComms content is relevant
4. **Grade Against 15 Checks** - Claims Usage (5), NPD Messaging (5), SciComms (5)
5. **Generate Report** - Show the full analysis

**AUTO-APPLY:** Instead of asking "Would you like me to fix these issues?", automatically:
- Apply ALL fixes (equivalent to user typing 'all')
- Create v2-seed-perspective-reviewed.md
- Preserve original v1 file

**Progress Output:**
```
═══════════════════════════════════════════════════
📋 STEP 1/5: Seed Perspective Review
═══════════════════════════════════════════════════
[Show abbreviated analysis - just grade and summary]
✅ Applied ALL fixes → v2-seed-perspective-reviewed.md
```

### STEP 2: Quality Review (Auto-Apply All)

Using v2-seed-perspective-reviewed.md as input, execute `/review-draft-1-v2` logic:

1. **Product Detection** - Confirm product focus
2. **Relevance Analysis** - Check SciComms relevance
3. **PRIMARY Grading** - 15 Seed perspective checks
4. **SECONDARY Checks** - Citations, Product Refs, Compliance, Structure, Tone, SEO
5. **Generate Report** - Show full analysis

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

### STEP 5: Upload to Google Docs

Using v5-claims-verified.md as input, execute `/upload-to-gdocs-v3` logic:

1. **Extract Primary Keyword** - From line 3 metadata
2. **Create Google Doc** - Using google-docs skill
3. **Insert Content** - Full markdown content
4. **Move to NPD Folder** - Using google-drive skill
5. **Update Tracking Sheet** - Using google-sheets skill
6. **Add Date-Stamped Note** - "M/D: ready for review"

**Progress Output:**
```
═══════════════════════════════════════════════════
📋 STEP 5/5: Upload to Google Docs
═══════════════════════════════════════════════════
✅ Created Google Doc: [keyword]
✅ Moved to NPD drafts folder
✅ Updated tracking spreadsheet (row X)
🔗 Link: [Google Docs URL]
```

### FINAL: Completion Summary

```
═══════════════════════════════════════════════════════════════════
🎉 FULL DRAFT REVIEW COMPLETE!
═══════════════════════════════════════════════════════════════════

📁 Original: v1-[keyword].md (preserved)

Version Progression:
├── v1-[keyword].md → Original
├── v2-seed-perspective-reviewed.md → Seed alignment fixes
├── v3-reviewed.md → Quality & compliance fixes
├── v4-sources-verified.md → Citation verification
└── v5-claims-verified.md → Claims verification

📤 Uploaded to Google Docs:
🔗 [Full Google Docs URL]
📊 Added to tracking: Row X

═══════════════════════════════════════════════════════════════════
📋 Summary of All Changes Applied:
═══════════════════════════════════════════════════════════════════

Step 1 (Seed Perspective):
- [Brief summary of fixes applied]

Step 2 (Quality Review):
- [Brief summary of fixes applied]

Step 3 (Sources):
- Verified: X | Fixed: Y | Manual: Z

Step 4 (Claims):
- Analyzed: X | Supported: Y | Modified: Z

Step 5 (Upload):
- ✅ Google Doc created and tracked

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

- **All original files preserved** - Never overwrites, only creates new versions
- **Fully automatic** - No user interaction required after invocation
- **Progress tracking** - Shows each step as it completes
- **Atomic steps** - Each step saves before moving to the next
- **Graceful failure** - Saves progress even if a step fails
- **Same quality** - Applies identical logic as running commands individually
- **Time estimate** - Typically takes 5-10 minutes depending on citation count

## When to Use This vs Individual Commands

| Use `/full-draft-review-auto` when: | Use individual commands when: |
|--------------------------------------|-------------------------------|
| You want "set it and forget it" | You want to review each step's output |
| You always accept all changes | You want selective control over fixes |
| Processing a standard draft | Draft has unusual issues needing attention |
| Batch processing multiple drafts | Learning/auditing the review process |

## Batch Processing (Future Enhancement)

To process multiple drafts, run the command multiple times:
```
/full-draft-review-auto 049-kava-vs-ashwagandha
/full-draft-review-auto 050-magnesium-for-sleep
/full-draft-review-auto 051-vitamin-d-benefits
```

Each invocation is independent and will process the specified draft through the full workflow.
