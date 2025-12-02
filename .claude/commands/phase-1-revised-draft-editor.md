# phase-1-revised-draft-editor

Performs quality assessment of a revised SEO draft against the original draft and drafting instructions, then generates a corrected v2 version based on your selected improvements.

## Usage

```
/phase-1-revised-draft-editor <revised_draft_file_path>
```

## Parameters

- `revised_draft_file_path` (required): Path to the revised draft markdown file to analyze (e.g., "article-revised v1.md")

## Description

This command automates the quality control workflow for revised SEO drafts:

1. **Locates required files** (original draft, drafting instructions, revised v1) in the same folder
2. **Performs 3-criteria quality assessment** comparing v1 against instructions and original
3. **Generates detailed evaluation report** with scores and recommendations
4. **Asks for your feedback** on which corrections to implement
5. **Creates corrected v2 file** implementing selected improvements

## Workflow

### Step 1: Locate Required Files

From the provided revised draft file path, automatically find:

- **Revised Draft (v1)**: The file path you provided
- **Folder Path**: Extract the parent directory from the v1 file path
- **Original Draft**: Find the oldest .md file in that folder (by file modification date)
  - This will be the file created first, before any revisions
  - Skip files with "revised", "v1", "v2", "Instructions", etc. in the name
- **Drafting Instructions**: Look for file named "Drafting Instructions.md" in the same folder

**Confirmation**: Display which files were found:
```
Found required files:
- Original: [filename]
- Instructions: Drafting Instructions.md
- Revised v1: [filename]
```

If any file is missing, alert the user and ask them to provide the file path.

### Step 2: Quality Assessment (3 Criteria)

Perform comprehensive evaluation across three dimensions:

#### Criterion 1: Adherence to Revision Instructions (/100)

Compare revised draft against Drafting Instructions and evaluate:

**HIGH PRIORITY Additions** (40 points)
- Were all required sections added? (Timeline, Troubleshooting, FAQ updates, etc.)
- Are they in the correct locations?
- Do they meet word count targets?
- Do they include required citations?

**MEDIUM PRIORITY Additions** (20 points)
- Were recommended sections added?
- Are they complete and well-integrated?

**NICE-TO-HAVE Additions** (10 points)
- Were optional sections included?

**Trimming Requirements** (15 points)
- Were targeted sections reduced/removed as instructed?
- Was the overall word count brought down appropriately?

**Citation Management** (15 points)
- Were unnecessary citations removed?
- Were new citations added where required?
- Is final count in target range (15-17)?
- Proper format: ([Author Year](DOI_URL))?

**Overall Compliance Score**: X/100

#### Criterion 2: Language Preservation (/100)

Compare revised draft to original draft and identify:

**Unchanged Sections Preserved** (50 points)
- Sections NOT targeted for revision should maintain original language
- Flag unnecessary rewrites
- Score based on percentage of untargeted sections preserved

**Critical Content Retained** (30 points)
- Expert quotes preserved (with correct attribution)
- Specific strain names maintained
- Key statistics and data kept
- Important disclaimers retained

**Factual Accuracy** (20 points)
- No misattributions (quotes to wrong people)
- No changed statistics or claims
- No lost citations that should remain

**Overall Preservation Score**: X/100

#### Criterion 3: Tone Consistency in New Sections (/100)

Evaluate new/revised sections against Seed brand voice requirements:

**Conversational Voice** (25 points)
- Uses "you/your" throughout
- Contractions present (don't, you're, it's)
- Reads like "knowledgeable friend"

**Accessibility** (25 points)
- Sentence length under 25 words average
- Paragraph length 2-3 sentences max
- Plain language before technical terms
- 7th-8th grade reading level

**Personality & Empathy** (25 points)
- Acknowledges reader concerns
- Uses analogies and metaphors
- Gentle humor where appropriate
- Normalizes potentially embarrassing topics

**Scientific Balance** (25 points)
- Evidence-based without being academic
- Realistic expectations (not overpromising)
- Appropriate disclaimers
- Maintains authority without condescension

**Overall Tone Score**: X/100

### Step 3: Generate Assessment Report

Output a comprehensive structured report:

#### Overall Grade
- Combined score (average of 3 criteria): X/100
- Letter grade equivalent
- Summary assessment (Excellent/Good/Fair/Needs Work)

#### Critical Issues to Fix (🚨 HIGHEST PRIORITY)
- Factual errors (misattributions, wrong stats, incorrect claims)
- Compliance violations
- Missing required sections

#### High Priority Improvements (⚠️ HIGH PRIORITY)
- Important content unnecessarily removed
- Lost specificity (strain names, expert quotes, statistics)
- Significant tone mismatches in new sections

#### Medium Priority Improvements (📝 MEDIUM PRIORITY)
- Minor language changes in preserved sections
- Missing optional sections
- Citation count outside target range

#### What Worked Exceptionally Well (✅)
- Successfully implemented additions
- Excellent tone matching in new content
- Good citation management
- Effective trimming

### Step 4: Interactive Selection

Present the assessment report to the user, then ask:

**"What corrections should I implement in v2?"**

Provide options:
- "Implement all HIGH and MEDIUM priority corrections"
- "Implement only CRITICAL and HIGH priority fixes"
- "Let me specify which corrections to make"
- "Create v2 with all identified improvements"

Wait for user to select their preferred approach.

### Step 5: Generate Corrected v2

Based on user's selection, create the corrected version:

**File Handling**:
- **Keep v1 unchanged**: Original revised draft remains as-is for comparison
- **Create new v2**: Extract filename from v1, replace "v1" with "v2" (or add "-revised v2" if no version number)
- **Save in same folder**: Keep all versions together

**Corrections to Apply** (based on user selection):

1. **Fix Critical Issues**:
   - Restore correct quote attributions
   - Fix any factual errors
   - Correct compliance violations

2. **Restore Lost Content**:
   - Add back expert quotes removed unnecessarily
   - Restore specific strain names
   - Bring back important statistics or disclaimers
   - Re-add removed bullet points

3. **Citation Adjustments**:
   - Add back strategic citations if count is too low
   - Ensure proper citation format throughout
   - Verify all citations have working DOI links

4. **Minor Language Fixes**:
   - Restore original phrasing in unchanged sections
   - Maintain successful new additions from v1

**Confirmation Output**:
```
Created corrected version: [filename]-revised v2.md

Changes implemented:
- Fixed [X] critical issues
- Restored [Y] pieces of lost content
- Adjusted citations: [Z] added back
- Final citation count: [N] (target: 15-17)
- Final word count: [W] (max: 2000)

Summary:
[Brief description of main corrections made]
```

## Example

```
/phase-1-revised-draft-editor Seed-SEO-Draft-Generator-v4/Draft Optimizations/001-Signs Probiotics are Working/Signs Probiotics Are working-revised v1.md
```

## Output Format

The command provides:
1. Confirmation of files located (original, instructions, v1)
2. Three-part quality assessment with scores
3. Detailed recommendations organized by priority
4. Interactive correction selection
5. Corrected v2 file with change summary

## Notes

- Automatically finds original draft using file modification dates (oldest file in folder)
- Preserves v1 file unchanged for comparison purposes
- Focuses on objective quality metrics (adherence, preservation, tone)
- Prioritizes critical fixes (factual errors) over minor improvements
- Ensures final v2 maintains all improvements from v1 while fixing issues
- Works in tandem with `/analyze-seo-draft` for complete revision workflow

## Integration with `/analyze-seo-draft`

This command is designed to work as Phase 1 of the revision workflow:

1. Run `/analyze-seo-draft` on original draft → Generates Drafting Instructions
2. External drafter (Gemini, human, etc.) creates revised v1 using instructions
3. Run `/phase-1-revised-draft-editor` on v1 → Quality assessment + corrected v2
4. v2 is now ready for final review or publication

All files (original, instructions, v1, v2) remain in the same folder for easy comparison and version control.
