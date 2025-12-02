# AM-02 Claims Substantiation Process Instructions

## Overview
This document provides step-by-step instructions for processing AM-02 claims substantiation from Google Sheets to Obsidian markdown notes with proper hyperlinks.

Instructions for New Claude Session

Provide these instructions to the new Claude session:

---

## Instructions for Claude to Process AM-02 Claims

### Initial Context
I have an AM-02 Google Spreadsheet with multiple tabs containing supplement claims substantiation data. I've already run a Google Apps Script that extracted all hyperlinks into an "Extracted Links" tab.

### Your Task

1. **Create markdown files for each tab** in the spreadsheet (except "Extracted Links")
   - Use the naming pattern: `AM-02-[Ingredient-Name]-Claims.md`
   - Each file should follow this exact structure:

```markdown
# AM-02 [Ingredient Name] ([Dose]) Claims Substantiation

## Study 1: [Study Name]
**Link**: [Add link here]

### Claims
✅ [List each claim on its own line with checkmark]

### Supporting Material
[Copy the supporting text exactly]

### Study Dose
[Dose information]

### Dose Matched
[Yes/No/High/Low/N/A]

### Support for Claim
[High/Medium/Low or other assessment]

### Notes/Caveats
[Any notes or "None specified"]

---

[Repeat for each study]

## Product Information
- **Product Dose**: [dose]
- **% DV**: [percentage or "Not established"]

#supplement #[ingredient-tag] #AM-02 #claims-substantiation #regulatory [additional relevant tags]
```

2. **After creating all files**, read the "Extracted Links" tab and update all files:
   - Match tab names to file names (handle naming variations like "Thamin" vs "Thiamine")
   - Replace "[Add link here]" with the actual hyperlinks
   - Use the study name to match the correct study section
   - Format links as: `[URL](URL)` for clickable markdown links

3. **Handle special cases**:
   - If a link shows "[NO LINK FOUND]", leave as "[Add link here]"
   - Some ingredients may have more studies than others (e.g., CoQ10 had 5, PQQ had 2)
   - Preserve all special characters and formatting in claims and supporting material

### Key Technical Details

- The spreadsheet ID is: 1N54MrH4IjcW36_7_8zgR3MSMJm74Ha5HhfoBv_URERo
- Spreadsheet URL: https://docs.google.com/spreadsheets/d/1N54MrH4IjcW36_7_8zgR3MSMJm74Ha5HhfoBv_URERo/edit?gid=2016867633#gid=2016867633
- All files should be created in: `/Users/david/Documents/Obsidian Vaults/claude-code-demo/SEO Clients/Seed/NPD Keyword Research/Claims/`

### Expected Output

You should create markdown files (one for each ingredient tab) with all hyperlinks properly inserted from the "Extracted Links" tab.

---

## Step 3: Final Verification

After the process is complete, spot-check a few files to ensure:
1. All studies have the correct hyperlinks
2. The formatting is consistent
3. Tags are appropriate for each ingredient
4. Claims are properly formatted with checkmarks

## Notes from DM-02 Experience
- The process successfully handled 22 files with 68 total hyperlinks
- Most vitamin/mineral files had 3 studies each
- Special ingredients like CoQ10 and PQQ had different numbers of studies
- The automated approach saved significant manual work

## Files Created for Reference
- This instruction file: `AM-02-Process-Instructions.md`
- Google Apps Script is embedded above
- Python update script can be adapted if needed (see `update_dm02_links.py` for reference)