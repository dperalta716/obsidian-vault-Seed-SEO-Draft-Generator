# upload-to-gdocs-v3

Upload a SEO draft markdown file to Google Docs, automatically move it to the NPD drafts folder, and update the tracking spreadsheet using Google Workspace skills (MCP-independent).

## Usage
```
/upload-to-gdocs-v3 <file-path>
```

## Description
This command automates the complete process of:
1. Creating a Google Doc from a markdown SEO draft using the **google-docs skill**
2. **Automatically moving the doc to the NPD drafts folder** using the **google-drive skill**
3. Updating the Phase 2 Tracking spreadsheet using the **google-sheets skill**
4. **Adding date-stamped notes** in the Notes/Comments column
5. No manual folder organization or MCP server required!

## Implementation

When this command is invoked with a file path:

1. **Read the markdown file** at the provided path using the Read tool
   - Verify the file exists and is readable
   - Store the full content for later use

2. **Extract the primary keyword** from the metadata
   - Look for line 3 of the file, formatted as `**Primary keyword:** [keyword]`
   - Clean the extracted keyword (remove asterisks and "Primary keyword:" prefix)
   - This keyword will be used as the Google Doc title

3. **Create a Google Doc** using the google-docs skill:
   - Execute bash script: `~/.claude/skills/google-docs/scripts/create-doc.sh`
   - Parameters:
     * First argument: "david@david-peralta.com"
     * Second argument: The extracted primary keyword (document title)
   - Parse the returned JSON to extract:
     * `documentId` - The document ID
     * `documentUrl` - The full Google Docs link
   - The doc will initially be created empty in the root folder of Google Drive

4. **Add content to the document** using the google-docs skill:
   - Execute bash script: `~/.claude/skills/google-docs/scripts/insert-text.sh`
   - Parameters:
     * First argument: "david@david-peralta.com"
     * Second argument: The document ID (from step 3)
     * Third argument: 1 (insert at beginning of document)
     * Fourth argument: The full markdown content from the file
   - This adds all content to the document at once

5. **Move the document to NPD drafts folder** using the google-drive skill:
   - Execute bash script: `~/.claude/skills/google-drive/scripts/move-file.sh`
   - Parameters:
     * First argument: "david@david-peralta.com"
     * Second argument: The extracted document ID
     * Third argument: "1JWFAoYKwsD2zTtypjs2gb34F0jAvv2bD" (NPD drafts folder ID)
   - This moves the doc from the root folder to the NPD drafts folder
   - The document link remains the same after moving

6. **Find the next available row** in the tracking spreadsheet:
   - Execute bash script: `~/.claude/skills/google-sheets/scripts/read-values.sh`
   - Parameters:
     * First argument: "david@david-peralta.com"
     * Second argument: "1VMNPMKCFG6an5UpteL5aUtm-VLgFgrSOFZDZE6h1ig8"
     * Third argument: "Phase 2 Tracking!B:B"
   - Parse the returned JSON array
   - Iterate through the values to find the first empty cell
   - The row number of the first empty cell is where we'll add our new entry

7. **Update the spreadsheet** with the new entry:
   - Execute bash script: `~/.claude/skills/google-sheets/scripts/write-values.sh`
   - Parameters:
     * First argument: "david@david-peralta.com"
     * Second argument: "1VMNPMKCFG6an5UpteL5aUtm-VLgFgrSOFZDZE6h1ig8"
     * Third argument: `Phase 2 Tracking!B{row}:F{row}` where {row} is the next empty row number
     * Fourth argument: JSON array: `[[keyword, "", "", doc_link, "Ready for Review"]]`
     * Note: Columns C (MSV) and D (KD) are left empty as placeholders

8. **Add date-stamped note** to the Notes/Comments column:
   - Get today's date and format as M/D (e.g., "10/23" for October 23rd)
   - Execute bash script: `~/.claude/skills/google-sheets/scripts/write-values.sh`
   - Parameters:
     * First argument: "david@david-peralta.com"
     * Second argument: "1VMNPMKCFG6an5UpteL5aUtm-VLgFgrSOFZDZE6h1ig8"
     * Third argument: `Phase 2 Tracking!K{row}` where {row} is the same row number from step 7
     * Fourth argument: JSON array: `[["{M/D}: ready for review"]]` (e.g., "10/23: ready for review")

9. **Provide feedback** to the user:
   - Confirm successful Google Doc creation with the document title
   - Confirm automatic movement to NPD drafts folder
   - Display the Google Doc link (which now points to the doc in the correct folder)
   - Confirm spreadsheet update with the row number that was updated
   - Display success message: "✅ Document successfully created, organized, and tracked!"
   - Report any errors encountered during the process

## Key Improvements Over v2
- **Skill-based implementation**: Uses google-docs, google-drive, and google-sheets skills
- **MCP-independent**: No dependency on Google Workspace MCP server
- **Token efficient**: Skills only load when needed, not in every conversation
- **Faster execution**: Direct API calls via bash scripts
- **Same functionality**: Identical behavior to v2, just using skills

## Skill Script Paths

All scripts are located in the user's Claude skills directory:

**Google Docs Skill:**
- Create doc: `~/.claude/skills/google-docs/scripts/create-doc.sh`
- Insert text: `~/.claude/skills/google-docs/scripts/insert-text.sh`

**Google Drive Skill:**
- Move file: `~/.claude/skills/google-drive/scripts/move-file.sh`

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
1. **google-docs** - For creating Google Docs from markdown
2. **google-drive** - For moving documents to folders
3. **google-sheets** - For updating tracking spreadsheet

Ensure all skills are installed and credentials are configured at `~/.claude/skills/google-workspace-credentials/david@david-peralta.com.json`.
