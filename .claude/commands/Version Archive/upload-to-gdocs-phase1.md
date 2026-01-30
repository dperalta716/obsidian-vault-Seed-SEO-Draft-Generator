# upload-to-gdocs-phase1

Upload a Phase 1 revised SEO draft markdown file to Google Docs, automatically move it to the Phase 1 Revisions folder, and update the "Phase 1 Revisions" tracking spreadsheet using Google Workspace skills (MCP-independent).

## Usage
```
/upload-to-gdocs-phase1 <file-path>
```

## Description
This command automates the complete process for **Phase 1 Revisions** workflow:
1. Creating a Google Doc from a markdown SEO draft using the **google-docs skill**
2. **Automatically moving the doc to the Phase 1 Revisions folder** using the **google-drive skill**
3. **Finding and updating the existing row** in the "Phase 1 Revisions" spreadsheet tab using the **google-sheets skill**
4. **Adding date-stamped notes** in the NotesComments column
5. No manual folder organization or MCP server required!

## Key Differences from upload-to-gdocs-v3
- **Target Sheet**: "Phase 1 Revisions" (not "Phase 2 Tracking")
- **Lookup Method**: Searches for existing row by URL slug in Column A (doesn't append new rows)
- **Column Mapping**: Updates columns B (Doc Link), C (Status), E (NotesComments)
- **Target Folder**: Phase 1 Revisions folder (different folder ID)
- **Metadata Extraction**: Extracts URL slug from markdown file

## Implementation

When this command is invoked with a file path:

1. **Read the markdown file** at the provided path using the Read tool
   - Verify the file exists and is readable
   - Store the full content for later use

2. **Extract metadata** from the file
   - **Primary keyword** from line 3: `**Primary keyword:** [keyword]` (used as Google Doc title)
   - **URL slug** from the metadata section: `**Slug:** [slug]` (used to find the spreadsheet row)
   - Clean both values (remove asterisks and label prefixes)
   - The slug should look like: `/cultured/keyword-guide/`

3. **Create a Google Doc** using the google-docs skill:
   - Execute bash script: `/Users/david/Documents/Obsidian Vaults/claude-code-demo/.claude/skills/google-docs/scripts/create-doc.sh`
   - Parameters:
     * First argument: "david@david-peralta.com"
     * Second argument: The extracted primary keyword (document title)
   - Parse the returned JSON to extract:
     * `documentId` - The document ID
     * `documentUrl` - The full Google Docs link
   - The doc will initially be created empty in the root folder of Google Drive

4. **Add content to the document** using the google-docs skill:
   - Execute bash script: `/Users/david/Documents/Obsidian Vaults/claude-code-demo/.claude/skills/google-docs/scripts/insert-text.sh`
   - Parameters:
     * First argument: "david@david-peralta.com"
     * Second argument: The document ID (from step 3)
     * Third argument: 1 (insert at beginning of document)
     * Fourth argument: The full markdown content from the file
   - This adds all content to the document at once

5. **Move the document to Phase 1 Revisions folder** using the google-drive skill:
   - Execute bash script: `/Users/david/Documents/Obsidian Vaults/claude-code-demo/.claude/skills/google-drive/scripts/move-file.sh`
   - Parameters:
     * First argument: "david@david-peralta.com"
     * Second argument: The extracted document ID
     * Third argument: "1lzlPnRC-ttFYDnBoTcIJE4OBHnhRRhaA" (Phase 1 Revisions folder ID)
   - This moves the doc from the root folder to the Phase 1 Revisions folder
   - The document link remains the same after moving

6. **Find the row matching the URL slug** in the tracking spreadsheet:
   - Execute bash script: `/Users/david/Documents/Obsidian Vaults/claude-code-demo/.claude/skills/google-sheets/scripts/read-values.sh`
   - Parameters:
     * First argument: "david@david-peralta.com"
     * Second argument: "1VMNPMKCFG6an5UpteL5aUtm-VLgFgrSOFZDZE6h1ig8"
     * Third argument: "Phase 1 Revisions!A:A"
   - Parse the returned JSON array
   - Iterate through the values to find the row where Column A matches the extracted URL slug
   - Store the row number for updating
   - If no matching row is found, report an error: "Error: Could not find URL slug '{slug}' in Phase 1 Revisions sheet. Please verify the slug exists in Column A."

7. **Update the spreadsheet row** with the new information:
   - Execute bash script: `/Users/david/Documents/Obsidian Vaults/claude-code-demo/.claude/skills/google-sheets/scripts/write-values.sh`
   - Parameters:
     * First argument: "david@david-peralta.com"
     * Second argument: "1VMNPMKCFG6an5UpteL5aUtm-VLgFgrSOFZDZE6h1ig8"
     * Third argument: `Phase 1 Revisions!B{row}:C{row}` where {row} is the matched row number
     * Fourth argument: JSON array: `[[doc_link, "Ready for Review"]]`
   - This updates Column B (Doc Link) and Column C (Status)

8. **Add date-stamped note** to the NotesComments column:
   - Get today's date and format as M/D (e.g., "11/20" for November 20th)
   - Execute bash script: `/Users/david/Documents/Obsidian Vaults/claude-code-demo/.claude/skills/google-sheets/scripts/write-values.sh`
   - Parameters:
     * First argument: "david@david-peralta.com"
     * Second argument: "1VMNPMKCFG6an5UpteL5aUtm-VLgFgrSOFZDZE6h1ig8"
     * Third argument: `Phase 1 Revisions!E{row}` where {row} is the same matched row number
     * Fourth argument: JSON array: `[["{M/D}: ready for review"]]` (e.g., "11/20: ready for review")

9. **Provide feedback** to the user:
   - Confirm successful Google Doc creation with the document title
   - Confirm automatic movement to Phase 1 Revisions folder
   - Display the Google Doc link (which now points to the doc in the correct folder)
   - Confirm spreadsheet update with the row number that was updated
   - Display the URL slug that was matched
   - Display success message: "✅ Phase 1 draft successfully created, organized, and tracked!"
   - Report any errors encountered during the process

## Key Improvements Over v2
- **Skill-based implementation**: Uses google-docs, google-drive, and google-sheets skills
- **MCP-independent**: No dependency on Google Workspace MCP server
- **Token efficient**: Skills only load when needed, not in every conversation
- **Faster execution**: Direct API calls via bash scripts
- **Smart row matching**: Finds existing row by URL slug instead of appending

## Skill Script Paths

All scripts are located at:

**Google Docs Skill:**
- Create doc: `/Users/david/Documents/Obsidian Vaults/claude-code-demo/.claude/skills/google-docs/scripts/create-doc.sh`
- Insert text: `/Users/david/Documents/Obsidian Vaults/claude-code-demo/.claude/skills/google-docs/scripts/insert-text.sh`

**Google Drive Skill:**
- Move file: `/Users/david/Documents/Obsidian Vaults/claude-code-demo/.claude/skills/google-drive/scripts/move-file.sh`

**Google Sheets Skill:**
- Read values: `/Users/david/Documents/Obsidian Vaults/claude-code-demo/.claude/skills/google-sheets/scripts/read-values.sh`
- Write values: `/Users/david/Documents/Obsidian Vaults/claude-code-demo/.claude/skills/google-sheets/scripts/write-values.sh`

## Error Handling
- If the file doesn't exist or can't be read, report: "Error: File not found at {path}"
- If the primary keyword can't be extracted, report: "Error: Could not extract primary keyword from line 3. Expected format: **Primary keyword:** [keyword]"
- If the URL slug can't be extracted, report: "Error: Could not extract URL slug from metadata. Expected format: **Slug:** [slug]"
- If Google Doc creation fails, report the specific error from the script output and stop
- If document ID extraction fails, report: "Error: Could not extract document ID from response"
- If content insertion fails, report the error but note that the empty doc was created (provide manual edit instructions as fallback)
- If folder movement fails, report the error but note that the doc was created (provide manual move instructions as fallback)
- If no matching row is found for the URL slug, report: "Error: Could not find URL slug '{slug}' in Phase 1 Revisions sheet. Verify the slug exists in Column A."
- If spreadsheet update fails, report the error but note that the Google Doc was created and moved
- Always provide clear, actionable feedback about what succeeded or failed

## Configuration
- Google Email: david@david-peralta.com
- Phase 1 Revisions Folder ID: 1lzlPnRC-ttFYDnBoTcIJE4OBHnhRRhaA
- Phase 1 Revisions Folder Link: https://drive.google.com/drive/folders/1lzlPnRC-ttFYDnBoTcIJE4OBHnhRRhaA
- Tracking Spreadsheet ID: 1VMNPMKCFG6an5UpteL5aUtm-VLgFgrSOFZDZE6h1ig8
- Tracking Spreadsheet Link: https://docs.google.com/spreadsheets/d/1VMNPMKCFG6an5UpteL5aUtm-VLgFgrSOFZDZE6h1ig8/
- Target Sheet: "Phase 1 Revisions"

## Column Mapping
- Column A: Current URL (used for row matching)
- Column B: Doc Link (where Google Doc link is written)
- Column C: Status (written as "Ready for Review")
- Column D: Editor (not modified by this command)
- Column E: NotesComments (date-stamped notes written here)

## Required Skills
This command requires the following Claude Code skills:
1. **google-docs** - For creating Google Docs from markdown
2. **google-drive** - For moving documents to folders
3. **google-sheets** - For updating tracking spreadsheet

Ensure all skills are installed and credentials are configured at:
`/Users/david/Documents/Obsidian Vaults/claude-code-demo/.claude/skills/google-workspace-credentials/david@david-peralta.com.json`
