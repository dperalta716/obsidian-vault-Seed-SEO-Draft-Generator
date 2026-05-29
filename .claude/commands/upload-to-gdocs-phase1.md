# upload-to-gdocs-phase1

Upload a Phase 1 revised SEO draft markdown file to Google Docs, automatically move it to the p1 edits folder, and update the "p1 edits" tracking spreadsheet using Google Workspace skills (MCP-independent).

## Usage
```
/upload-to-gdocs-phase1 <file-path>
```

## Description
This command automates the complete process for **p1 edits** workflow:
1. Converting a markdown draft to a **formatted Google Doc** (rendered headings, bold, hyperlinks, Seed brand colors) using the **markdown-to-gdoc skill**
2. **Placing the doc directly in the p1 edits folder** on creation
3. **Finding and updating the existing row** in the "p1 edits" spreadsheet tab using the **google-sheets skill**
4. **Adding date-stamped notes** in the NotesComments column
5. No manual folder organization, paste-as-markdown, or MCP server required!

## Key Differences from upload-to-gdocs-ds01
- **Target Sheet**: "p1 edits" (not "Phase 3 Tracking")
- **Lookup Method**: Searches for existing row by URL slug in Column A (doesn't append new rows)
- **Column Mapping**: Updates columns B (Doc Link), C (Status), F (Notes/Comments)
- **Target Folder**: p1 edits folder (different folder ID)
- **Metadata Extraction**: Extracts URL slug from markdown file

## Implementation

When this command is invoked with a file path:

1. **Identify the markdown file** to upload
   - If a specific file path is provided, use that file
   - If a folder path is provided, find the highest-numbered `v*` file in that folder (e.g., `v5-claims-verified.md` over `v3-reviewed.md`)
   - Verify the file exists and is readable

2. **Extract metadata** from the file
   - **Primary keyword** from line 3: `**Primary keyword:** [keyword]` or `**Primary Keyword:** [keyword]` (used as Google Doc title)
   - **URL slug** from the metadata section: `**Slug:** [slug]` (used to find the spreadsheet row)
   - Clean both values (remove asterisks and label prefixes)
   - The slug should look like: `/cultured/keyword-guide/`

3. **Convert and upload** using the markdown-to-gdoc skill:
   - Execute bash script: `~/.claude/skills/markdown-to-gdoc/scripts/convert-and-upload.sh`
   - Parameters:
     * First argument: "david@david-peralta.com"
     * Second argument: The full path to the markdown file
     * Third argument: The extracted primary keyword (document title)
     * Fourth argument: "~/.claude/skills/markdown-to-gdoc/templates/seed-compliance.docx" (Seed brand template)
     * Fifth argument: "1lzlPnRC-ttFYDnBoTcIJE4OBHnhRRhaA" (p1 edits folder ID)
   - This single call handles: markdown → docx conversion (with Seed fonts/colors), upload to Google Drive with conversion to Google Docs format, placement in the p1 edits folder, and post-upload formatting (heading colors, link styling)
   - Parse the returned JSON to extract:
     * `id` - The document ID
     * `webViewLink` - The Google Docs link

4. **Find the row matching the URL slug** in the tracking spreadsheet:
   - Execute bash script: `~/.claude/skills/google-sheets/scripts/read-values.sh`
   - Parameters:
     * First argument: "david@david-peralta.com"
     * Second argument: "1VMNPMKCFG6an5UpteL5aUtm-VLgFgrSOFZDZE6h1ig8"
     * Third argument: "'p1 edits'!A:A"
   - Parse the returned JSON array
   - Iterate through the values to find the row where Column A matches the extracted URL slug
   - Store the row number for updating
   - If no matching row is found, report an error: "Error: Could not find URL slug '{slug}' in p1 edits sheet. Please verify the slug exists in Column A."

5. **Update the spreadsheet row** with the new information:
   - Execute bash script: `~/.claude/skills/google-sheets/scripts/write-values.sh`
   - Parameters:
     * First argument: "david@david-peralta.com"
     * Second argument: "1VMNPMKCFG6an5UpteL5aUtm-VLgFgrSOFZDZE6h1ig8"
     * Third argument: `'p1 edits'!B{row}:C{row}` where {row} is the matched row number
     * Fourth argument: JSON array: `[[doc_link, "Ready for Revisions"]]`
   - This updates Column B (Doc Link) and Column C (Status)

6. **Add date-stamped note** to the NotesComments column:
   - Get today's date and format as M/D (e.g., "11/20" for November 20th)
   - Execute bash script: `~/.claude/skills/google-sheets/scripts/write-values.sh`
   - Parameters:
     * First argument: "david@david-peralta.com"
     * Second argument: "1VMNPMKCFG6an5UpteL5aUtm-VLgFgrSOFZDZE6h1ig8"
     * Third argument: `'p1 edits'!F{row}` where {row} is the same matched row number
     * Fourth argument: JSON array: `[["{M/D}: ready for revisions"]]` (e.g., "5/22: ready for revisions")

7. **Provide feedback** to the user:
   - Confirm successful Google Doc creation with the document title
   - Confirm automatic movement to p1 edits folder
   - Display the Google Doc link (which now points to the doc in the correct folder)
   - Confirm spreadsheet update with the row number that was updated
   - Display the URL slug that was matched
   - Display success message: "✅ Phase 1 draft successfully created, organized, and tracked!"
   - Report any errors encountered during the process

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
- If the URL slug can't be extracted, report: "Error: Could not extract URL slug from metadata. Expected format: **Slug:** [slug]"
- If Google Doc creation fails, report the specific error from the script output and stop
- If document ID extraction fails, report: "Error: Could not extract document ID from response"
- If content insertion fails, report the error but note that the empty doc was created (provide manual edit instructions as fallback)
- If folder movement fails, report the error but note that the doc was created (provide manual move instructions as fallback)
- If no matching row is found for the URL slug, report: "Error: Could not find URL slug '{slug}' in p1 edits sheet. Verify the slug exists in Column A."
- If spreadsheet update fails, report the error but note that the Google Doc was created and moved
- Always provide clear, actionable feedback about what succeeded or failed

## Configuration
- Google Email: david@david-peralta.com
- p1 edits Folder ID: 1lzlPnRC-ttFYDnBoTcIJE4OBHnhRRhaA
- p1 edits Folder Link: https://drive.google.com/drive/folders/1lzlPnRC-ttFYDnBoTcIJE4OBHnhRRhaA
- Tracking Spreadsheet ID: 1VMNPMKCFG6an5UpteL5aUtm-VLgFgrSOFZDZE6h1ig8
- Tracking Spreadsheet Link: https://docs.google.com/spreadsheets/d/1VMNPMKCFG6an5UpteL5aUtm-VLgFgrSOFZDZE6h1ig8/
- Target Sheet: "p1 edits"

## Column Mapping
- Column A: Current URL (used for row matching)
- Column B: Doc Link (where Google Doc link is written)
- Column C: Status (written as "Ready for Revisions")
- Column D: (not modified by this command)
- Column E: Editor (not modified by this command)
- Column F: Notes/Comments (date-stamped notes written here)

## Required Skills
This command requires the following Claude Code skills:
1. **markdown-to-gdoc** - For converting markdown to formatted Google Docs with Seed brand styling (handles conversion, upload, and folder placement in one call)
2. **google-sheets** - For updating tracking spreadsheet

Ensure all skills are installed and credentials are configured at `~/.claude/skills/google-workspace-credentials/david@david-peralta.com.json`.

## Rules

1. **Never use `sed` for text processing on macOS.** BSD sed (macOS default) has incompatible syntax with GNU sed — especially `\!` escapes and multi-address blocks. Use Python instead for any string manipulation (frontmatter stripping, content escaping, text transformations) before passing content to Google Docs API calls. A silent sed failure produces an empty variable, which the API will "successfully" insert as nothing.

2. **Always use Python for YAML frontmatter stripping.** When preparing markdown content for Google Docs insertion, use this pattern:
   ```python
   python3 -c "
   with open('file.md') as f:
       lines = f.readlines()
   dashes = 0
   start = 0
   for i, line in enumerate(lines):
       if line.strip() == '---':
           dashes += 1
           if dashes == 2:
               start = i + 1
               break
   print(''.join(lines[start:]), end='')
   "
   ```

3. **Always verify doc content after insertion.** After a batch-update insertText call, check that the doc body length is > 100 chars. If it's near-empty, the insertion silently failed and must be retried.
