# upload-to-gdocs-v3

Upload a SEO draft markdown file as a formatted Google Doc (rendered headings, bold, hyperlinks, Seed brand colors) to the NPD drafts folder, and update the tracking spreadsheet using Google Workspace skills (MCP-independent).

## Usage
```
/upload-to-gdocs-v3 <file-path>
```

## Description
This command automates the complete process of:
1. Converting a markdown draft to a **formatted Google Doc** (rendered headings, bold, hyperlinks, Seed brand colors) using the **markdown-to-gdoc skill**
2. **Placing the doc directly in the NPD drafts folder** on creation
3. Updating the Phase 2 Tracking spreadsheet using the **google-sheets skill**
4. **Adding date-stamped notes** in the Notes/Comments column
5. No manual folder organization, paste-as-markdown, or MCP server required!

## Implementation

When this command is invoked with a file path:

1. **Identify the markdown file** to upload
   - If a specific file path is provided, use that file
   - If a folder path is provided, find the highest-numbered `v*` file in that folder (e.g., `v5-claims-verified.md` over `v3-reviewed.md`)
   - Verify the file exists and is readable

2. **Extract the primary keyword** from the metadata
   - Look for line 3 of the file, formatted as `**Primary keyword:** [keyword]` or `**Primary Keyword:** [keyword]`
   - Clean the extracted keyword (remove asterisks and "Primary keyword:" prefix)
   - This keyword will be used as the Google Doc title

3. **Convert and upload** using the markdown-to-gdoc skill:
   - Execute bash script: `~/.claude/skills/markdown-to-gdoc/scripts/convert-and-upload.sh`
   - Parameters:
     * First argument: "david@david-peralta.com"
     * Second argument: The full path to the markdown file
     * Third argument: The extracted primary keyword (document title)
     * Fourth argument: "~/.claude/skills/markdown-to-gdoc/templates/seed-compliance.docx" (Seed brand template)
     * Fifth argument: "1JWFAoYKwsD2zTtypjs2gb34F0jAvv2bD" (NPD drafts folder ID)
   - This single call handles: markdown → docx conversion (with Seed fonts/colors), upload to Google Drive with conversion to Google Docs format, placement in the NPD folder, and post-upload formatting (heading colors, link styling)
   - Parse the returned JSON to extract:
     * `id` - The document ID
     * `webViewLink` - The Google Docs link

4. **Find the next available row** in the tracking spreadsheet:
   - Execute bash script: `~/.claude/skills/google-sheets/scripts/read-values.sh`
   - Parameters:
     * First argument: "david@david-peralta.com"
     * Second argument: "1VMNPMKCFG6an5UpteL5aUtm-VLgFgrSOFZDZE6h1ig8"
     * Third argument: "Phase 2 Tracking!B:B"
   - Parse the returned JSON array
   - Iterate through the values to find the first empty cell
   - The row number of the first empty cell is where we'll add our new entry

5. **Update the spreadsheet** with the new entry:
   - Execute bash script: `~/.claude/skills/google-sheets/scripts/write-values.sh`
   - Parameters:
     * First argument: "david@david-peralta.com"
     * Second argument: "1VMNPMKCFG6an5UpteL5aUtm-VLgFgrSOFZDZE6h1ig8"
     * Third argument: `Phase 2 Tracking!B{row}:F{row}` where {row} is the next empty row number
     * Fourth argument: JSON array: `[[keyword, "", "", doc_link, "Ready for Review"]]`
     * Note: Columns C (MSV) and D (KD) are left empty as placeholders

6. **Add date-stamped note** to the Notes/Comments column:
   - Get today's date and format as M/D (e.g., "10/23" for October 23rd)
   - Execute bash script: `~/.claude/skills/google-sheets/scripts/write-values.sh`
   - Parameters:
     * First argument: "david@david-peralta.com"
     * Second argument: "1VMNPMKCFG6an5UpteL5aUtm-VLgFgrSOFZDZE6h1ig8"
     * Third argument: `Phase 2 Tracking!K{row}` where {row} is the same row number from step 5
     * Fourth argument: JSON array: `[["{M/D}: ready for review"]]` (e.g., "10/23: ready for review")

7. **Provide feedback** to the user:
   - Confirm successful Google Doc creation with the document title
   - Confirm automatic movement to NPD drafts folder
   - Display the Google Doc link (which now points to the doc in the correct folder)
   - Confirm spreadsheet update with the row number that was updated
   - Display success message: "✅ Document successfully created, organized, and tracked!"
   - Report any errors encountered during the process

## Key Improvements Over v2
- **Formatted output**: Produces Google Docs with rendered headings, bold text, hyperlinks, and Seed brand colors
- **Single-step upload**: One script call handles conversion, upload, and folder placement (replaces 3 separate calls)
- **MCP-independent**: No dependency on Google Workspace MCP server
- **Token efficient**: Skills only load when needed, not in every conversation
- **Faster execution**: Direct API calls via bash scripts

## Skill Script Paths

All scripts are located in the user's Claude skills directory:

**Markdown-to-GDoc Skill (handles conversion + upload + folder placement):**
- Convert and upload: `~/.claude/skills/markdown-to-gdoc/scripts/convert-and-upload.sh`
- Seed template: `~/.claude/skills/markdown-to-gdoc/templates/seed-compliance.docx`

**Google Sheets Skill:**
- Read values: `~/.claude/skills/google-sheets/scripts/read-values.sh`
- Write values: `~/.claude/skills/google-sheets/scripts/write-values.sh`

## Error Handling
- If the file doesn't exist or can't be read, report: "Error: File not found at {path}"
- If the primary keyword can't be extracted, report: "Error: Could not extract primary keyword from line 3. Expected format: **Primary keyword:** [keyword]"
- If Google Doc creation fails, report the specific error from the script output and stop
- If document ID extraction fails, report: "Error: Could not extract document ID from response"
- If content insertion fails, report the error but note that the empty doc was created (provide manual edit instructions as fallback)
- If folder movement fails, report the error but note that the doc was created (provide manual move instructions as fallback)
- If spreadsheet update fails, report the error but note that the Google Doc was created and moved
- Always provide clear, actionable feedback about what succeeded or failed

## Configuration
- Google Email: david@david-peralta.com
- NPD Drafts Folder ID: 1JWFAoYKwsD2zTtypjs2gb34F0jAvv2bD
- NPD Drafts Folder Link: https://drive.google.com/drive/folders/1JWFAoYKwsD2zTtypjs2gb34F0jAvv2bD
- Tracking Spreadsheet ID: 1VMNPMKCFG6an5UpteL5aUtm-VLgFgrSOFZDZE6h1ig8
- Tracking Spreadsheet Link: https://docs.google.com/spreadsheets/d/1VMNPMKCFG6an5UpteL5aUtm-VLgFgrSOFZDZE6h1ig8/
- Target Sheet: "Phase 2 Tracking"

## Required Skills
This command requires the following Claude Code skills:
1. **markdown-to-gdoc** - For converting markdown to formatted Google Docs with Seed brand styling (handles conversion, upload, and folder placement in one call)
2. **google-sheets** - For updating tracking spreadsheet

Ensure all skills are installed and credentials are configured at `~/.claude/skills/google-workspace-credentials/david@david-peralta.com.json`.
