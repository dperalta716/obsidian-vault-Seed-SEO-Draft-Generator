# Phase 1 Draft Revisions Workflow

This folder contains revised versions of Seed SEO Phase 1 drafts that have undergone competitive analysis and quality control improvements.

## Complete Step-by-Step Workflow

### Step 1: Run Competitive Analysis on Original Draft

**Command**: `/analyze-seo-draft <path-to-original-draft>`

**Example**:
```
/analyze-seo-draft Seed-SEO-Draft-Generator-v4/Draft Optimizations/001-Signs Probiotics are Working/Signs probiotics are working.md
```

**What happens**:
1. Claude extracts the primary keyword from your draft's SEO metadata
2. Analyzes current citation count vs. target (12-15 citations)
3. Searches and fetches top 3-4 competing articles for that keyword
4. Compares your draft to competitors across multiple dimensions
5. Generates structured analysis with:
   - Where your draft excels
   - Where competitors have advantages
   - Concrete recommendations (HIGH/MEDIUM/NICE-TO-HAVE priority)
6. Asks: "What changes should we implement into this draft?"
7. **Automatically creates** `Drafting Instructions.md` in the same folder as your original draft

**Your action**: Review the analysis and tell Claude which recommendations to implement (usually "all of them")

---

### Step 2: Generate Revised Draft Using Instructions

**Take the Drafting Instructions to your external drafter** (Gemini, human writer, etc.)

**Input to drafter**:
- Original draft file
- `Drafting Instructions.md` file (created automatically in Step 1)

**Drafter's task**: Create revised version implementing:
- All content additions (timeline section, new signs, troubleshooting, etc.)
- All content trimming (reduce word count where specified)
- Citation management (remove unnecessary, add required)
- Tone and voice requirements

**Save the revised draft as**: `[original-name]-revised v1.md` in the same folder

**Example**:
```
Original: Signs probiotics are working.md
Revised:  Signs Probiotics Are working-revised v1.md
```

**Important**: Keep the v1 file in the same folder as:
- Original draft
- Drafting Instructions.md

---

### Step 3: Quality Assessment & Correction

**Command**: `/phase-1-revised-draft-editor <path-to-revised-v1>`

**Example**:
```
/phase-1-revised-draft-editor Seed-SEO-Draft-Generator-v4/Draft Optimizations/001-Signs Probiotics are Working/Signs Probiotics Are working-revised v1.md
```

**What happens**:
1. Claude automatically locates in the same folder:
   - Original draft (oldest .md file by modification date)
   - Drafting Instructions.md
   - Your revised v1 file
2. Performs 3-part quality assessment:
   - **Adherence to Instructions** (/100): Did v1 implement all requirements?
   - **Language Preservation** (/100): Were unchanged sections kept intact?
   - **Tone Consistency** (/100): Do new sections match Seed's voice?
3. Generates comprehensive report with:
   - Overall grade (combined score)
   - 🚨 Critical issues (factual errors, misattributions)
   - ⚠️ High priority fixes (lost content, missing details)
   - 📝 Medium priority improvements
   - ✅ What worked well
4. Asks: "What corrections should I implement in v2?"

**Your action**: Choose which corrections to apply:
- "Implement all HIGH and MEDIUM priority corrections" (recommended)
- "Implement only CRITICAL and HIGH priority fixes"
- "Create v2 with all identified improvements"
- Or specify custom selection

---

### Step 4: Review Corrected v2

Claude creates: `[original-name]-revised v2.md` in the same folder

**What's in v2**:
- All excellent additions from v1 ✅
- Fixed critical issues (misattributions, errors) ✅
- Restored unnecessarily removed content ✅
- Citation count adjusted to target range (15-17) ✅
- Preserved original language in unchanged sections ✅

**Your folder now contains**:
```
📁 Draft Optimizations/001-Signs Probiotics/
├── Signs probiotics are working.md          (original)
├── Drafting Instructions.md                 (auto-created)
├── Signs Probiotics Are working-revised v1.md (first revision)
└── Signs Probiotics Are working-revised v2.md (corrected version)
```

**Final action**: Review v2 and decide if it's ready for publication or needs additional edits

---

## Quick Reference

| Step | Command | Input | Output |
|------|---------|-------|--------|
| 1 | `/analyze-seo-draft` | Original draft | Competitive analysis + Drafting Instructions.md |
| 2 | External drafter | Original + Instructions | Revised v1.md |
| 3 | `/phase-1-revised-draft-editor` | Revised v1 | Quality assessment + Revised v2.md |
| 4 | Manual review | Revised v2 | Final decision |

---

## File Naming Conventions

**Original drafts**: Any descriptive name
- Example: `Signs probiotics are working.md`
- Example: `best-vitamins-for-energy.md`

**Revised versions**: `[original-name]-revised v1.md`, `v2.md`, etc.
- Example: `Signs Probiotics Are working-revised v1.md`
- Example: `best-vitamins-for-energy-revised v1.md`

**Instructions**: Always `Drafting Instructions.md` (auto-created by `/analyze-seo-draft`)

---

## Tips for Success

### Before Step 1
- Ensure original draft has SEO metadata with primary keyword clearly defined
- Original draft should have citations in the format: `([Author Year](DOI_URL))`
- Draft should be a complete first version (not an outline)

### Between Steps 1 & 2
- Carefully read the Drafting Instructions before passing to external drafter
- If using Gemini or AI drafter, provide both the original file AND the instructions file
- Emphasize the importance of NOT rewriting sections that aren't targeted for change

### Before Step 3
- Ensure v1 is saved in the same folder as original and instructions
- Do a quick scan of v1 to spot any obvious issues before running quality assessment
- Have the original draft open for quick comparison if needed

### After Step 4
- Compare v2 against original to see full evolution
- Check that all your selected improvements were implemented
- Verify citation count is in target range (15-17)
- Confirm word count is under 2000 (ideally 1600-1800)

---

## Troubleshooting

**Q: `/phase-1-revised-draft-editor` can't find the original draft**
- Check that the original .md file is in the same folder as v1
- Ensure the original file doesn't have "revised", "v1", "v2", or "Instructions" in the filename
- The command looks for the oldest .md file by modification date

**Q: Drafting Instructions weren't created automatically**
- This is a new feature - older runs of `/analyze-seo-draft` didn't auto-create this file
- You can manually save the instructions Claude provides as `Drafting Instructions.md`

**Q: Quality assessment scores seem harsh**
- Scores are calibrated to identify room for improvement
- 80+ overall is good, 90+ is excellent
- Focus on the specific recommendations rather than the number

**Q: v2 still has issues after correction**
- You can run `/phase-1-revised-draft-editor` on v2 to create v3
- Or manually edit v2 based on the assessment report
- Some issues may require human judgment beyond automated fixes

---

## Version History

**Current Workflow Version**: 1.0 (Created 2025-01-13)

This workflow integrates:
- `/analyze-seo-draft` command (updated with auto-save feature)
- `/phase-1-revised-draft-editor` command (new)
- Competitive analysis methodology
- Quality assessment framework
- Seed brand voice requirements

---

## Related Documentation

- `/analyze-seo-draft` command details: `.claude/commands/analyze-seo-draft.md`
- `/phase-1-revised-draft-editor` command details: `.claude/commands/phase-1-revised-draft-editor.md`
- Main Seed SEO workflow: `CLAUDE.md` in project root
- Seed tone of voice guide: `Reference/Style/Seed-Tone-of-Voice-and-Structure.md`
