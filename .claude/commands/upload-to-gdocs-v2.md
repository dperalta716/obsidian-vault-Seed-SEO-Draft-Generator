# upload-to-gdocs-v2

Upload a SEO draft markdown file to Google Docs, automatically move it to the NPD drafts folder, and update the tracking spreadsheet.

## Usage
```
/upload-to-gdocs-v2 <file-path>
```

## Description
This enhanced command automates the complete process of:
1. Creating a Google Doc from a markdown SEO draft
2. **Automatically moving the doc to the NPD drafts folder** (NEW!)
3. Updating the Phase 2 Tracking spreadsheet with the keyword, doc link, and status
4. **Adding date-stamped notes** in the Notes/Comments column (NEW!)
5. No manual folder organization required!

## Implementation

When this command is invoked with a file path:

1. **Read the markdown file** at the provided path using the Read tool
   - Verify the file exists and is readable
   - Store the full content for later use

2. **Extract the primary keyword** from the metadata
   - Look for line 3 of the file, formatted as `**Primary keyword:** [keyword]`
   - Clean the extracted keyword (remove asterisks and "Primary keyword:" prefix)
   - This keyword will be used as the Google Doc title

3. **Create a Google Doc** using the Google Workspace MCP:
   - Use `mcp__google-workspace__create_doc` with:
     - `user_google_email`: "david@david-peralta.com"
     - `title`: The extracted primary keyword
     - `content`: The full markdown content from the file
   - The doc will initially be created in the root folder of Google Drive
   - Capture the returned document ID and link

4. **Extract the document ID** from the returned link:
   - Parse the Google Docs link to extract the document ID
   - Format: `https://docs.google.com/document/d/{DOCUMENT_ID}/edit`
   - Extract the ID between `/d/` and `/edit`

5. **Move the document to NPD drafts folder** using the Google Drive MCP:
   - Use `mcp__google-drive__moveItem` with:
     - `itemId`: The extracted document ID
     - `destinationFolderId`: "1JWFAoYKwsD2zTtypjs2gb34F0jAvv2bD"
   - This moves the doc from the root folder to the NPD drafts folder
   - The document link remains the same after moving

6. **Find the next available row** in the tracking spreadsheet:
   - Use `mcp__google-workspace__read_sheet_values` with:
     - `user_google_email`: "david@david-peralta.com"
     - `spreadsheet_id`: "1VMNPMKCFG6an5UpteL5aUtm-VLgFgrSOFZDZE6h1ig8"
     - `range_name`: "Phase 2 Tracking!B:B"
   - Iterate through the returned values to find the first empty cell
   - The row number of the first empty cell is where we'll add our new entry

7. **Update the spreadsheet** with the new entry:
   - Use `mcp__google-workspace__modify_sheet_values` with:
     - `user_google_email`: "david@david-peralta.com"
     - `spreadsheet_id`: "1VMNPMKCFG6an5UpteL5aUtm-VLgFgrSOFZDZE6h1ig8"
     - `range_name`: `Phase 2 Tracking!B{row}:F{row}` where {row} is the next empty row number
     - `values`: [[keyword, "", "", doc_link, "Ready for Review"]]
     - Note: Columns C (MSV) and D (KD) are left empty as placeholders

8. **Add date-stamped note** to the Notes/Comments column:
   - Get today's date and format as M/D (e.g., "9/18" for September 18th)
   - Use `mcp__google-workspace__modify_sheet_values` with:
     - `user_google_email`: "david@david-peralta.com"
     - `spreadsheet_id`: "1VMNPMKCFG6an5UpteL5aUtm-VLgFgrSOFZDZE6h1ig8"
     - `range_name`: `Phase 2 Tracking!K{row}` where {row} is the same row number from step 7
     - `values`: [["{M/D}: ready for review"]] (e.g., "9/18: ready for review")

9. **Provide feedback** to the user:
   - Confirm successful Google Doc creation with the document title
   - Confirm automatic movement to NPD drafts folder
   - Display the Google Doc link (which now points to the doc in the correct folder)
   - Confirm spreadsheet update with the row number that was updated
   - Display success message: "✅ Document successfully created, organized, and tracked!"
   - Report any errors encountered during the process

## Key Improvements Over v1
- **Automatic folder organization**: No manual steps required
- **Seamless integration**: Uses both Google Workspace MCP and Google Drive MCP
- **Preserved links**: Document links remain valid after moving
- **Date-stamped tracking**: Automatically adds today's date in M/D format to Notes/Comments
- **Complete automation**: From creation to organization to tracking with timestamps

## Error Handling
- If the file doesn't exist or can't be read, report: "Error: File not found at {path}"
- If the primary keyword can't be extracted, report: "Error: Could not extract primary keyword from line 3. Expected format: **Primary keyword:** [keyword]"
- If Google Doc creation fails, report the specific error from the API and stop
- If document ID extraction fails, report: "Error: Could not extract document ID from link {link}"
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

## Required MCP Servers
This command requires both:
1. **Google Workspace MCP**: For creating docs and updating spreadsheets
2. **Google Drive MCP**: For moving documents to folders

Ensure both are installed and configured with appropriate authentication.