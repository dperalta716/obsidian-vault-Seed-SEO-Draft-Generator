---
name: google-sheets
description: This skill should be used for Google Sheets operations including reading/writing data, creating spreadsheets, batch operations, formatting cells, managing rows/columns, sorting, and data validation. Use when working with spreadsheet data, content performance reporting, analytics workflows, or any task requiring Google Sheets manipulation.
---

# Google Sheets

## Overview

Provides comprehensive access to Google Sheets API v4 for spreadsheet data operations, formatting, and structure management. This skill enables reading, writing, and manipulating spreadsheet data with support for batch operations, cell formatting, row/column management, sorting, and data validation.

## When to Use This Skill

Use this skill for:
- Reading data from Google Sheets for analysis or reporting
- Writing or appending data to spreadsheets (analytics, tracking, logs)
- Creating new spreadsheets or sheets within existing spreadsheets
- Batch operations on multiple ranges for performance
- Formatting cells (bold, colors, backgrounds)
- Managing spreadsheet structure (add/delete rows, copy sheets)
- Sorting data ranges
- Setting data validation rules
- Content performance reporting workflows (e.g., `/fay-ga-monthly`, `/fay-content-performance`)
- Any workflow requiring programmatic spreadsheet access

## Core Operations

### 1. List Spreadsheets

List all Google Sheets accessible to the user (uses Drive API).

**Script:** `scripts/list-spreadsheets.sh`

**Usage:**
```bash
./scripts/list-spreadsheets.sh "user@example.com" [max_results]
```

**Parameters:**
- `user_email` (required) - User's Google email address
- `max_results` (optional) - Maximum number of spreadsheets to return (default: 25)

**Returns:** JSON array of spreadsheet objects with id, name, modifiedTime, and webViewLink

**Example:**
```bash
./scripts/list-spreadsheets.sh "david@david-peralta.com" 10
```

### 2. Get Spreadsheet Info

Retrieve metadata about a specific spreadsheet including all sheets within it.

**Script:** `scripts/get-spreadsheet-info.sh`

**Usage:**
```bash
./scripts/get-spreadsheet-info.sh "user@example.com" "spreadsheet_id"
```

**Parameters:**
- `user_email` (required) - User's Google email address
- `spreadsheet_id` (required) - ID of the spreadsheet

**Returns:** JSON object with spreadsheet properties and array of sheet properties

**Example:**
```bash
./scripts/get-spreadsheet-info.sh "david@david-peralta.com" "1A2B3C4D5E6F"
```

### 3. Read Values

Read values from a specific range in a Google Sheet.

**Script:** `scripts/read-values.sh`

**Usage:**
```bash
./scripts/read-values.sh "user@example.com" "spreadsheet_id" "Sheet1!A1:D10"
```

**Parameters:**
- `user_email` (required) - User's Google email address
- `spreadsheet_id` (required) - ID of the spreadsheet
- `range` (optional) - A1 notation range (default: "A1:Z1000")

**Returns:** JSON object with range and 2D array of values

**Example:**
```bash
./scripts/read-values.sh "david@david-peralta.com" "1A2B3C4D5E6F" "Performance!A1:F100"
```

### 4. Write Values

Write values to a specific range, overwriting existing content.

**Script:** `scripts/write-values.sh`

**Usage:**
```bash
./scripts/write-values.sh "user@example.com" "spreadsheet_id" "Sheet1!A1:B2" '[["value1","value2"],["value3","value4"]]'
```

**Parameters:**
- `user_email` (required) - User's Google email address
- `spreadsheet_id` (required) - ID of the spreadsheet
- `range` (required) - A1 notation range
- `values` (required) - JSON 2D array of values

**Returns:** JSON object with update details

**Example:**
```bash
./scripts/write-values.sh "david@david-peralta.com" "1A2B3C4D5E6F" "Data!A1:C1" '[["Date","Metric","Value"]]'
```

### 5. Append Values

Append rows to the end of a range (automatically finds the next empty row).

**Script:** `scripts/append-values.sh`

**Usage:**
```bash
./scripts/append-values.sh "user@example.com" "spreadsheet_id" "Sheet1!A1:B1" '[["new1","new2"],["new3","new4"]]'
```

**Parameters:**
- `user_email` (required) - User's Google email address
- `spreadsheet_id` (required) - ID of the spreadsheet
- `range` (required) - A1 notation range (table range to append to)
- `values` (required) - JSON 2D array of values to append

**Returns:** JSON object with appended range and update details

**Use case:** Adding new rows to tracking spreadsheets, logs, or data collection sheets

**Example:**
```bash
./scripts/append-values.sh "david@david-peralta.com" "1A2B3C4D5E6F" "Tracking!A:C" '[["2025-10-23","New Entry","100"]]'
```

### 6. Clear Values

Clear values from a range without deleting the cells.

**Script:** `scripts/clear-values.sh`

**Usage:**
```bash
./scripts/clear-values.sh "user@example.com" "spreadsheet_id" "Sheet1!A1:D10"
```

**Parameters:**
- `user_email` (required) - User's Google email address
- `spreadsheet_id` (required) - ID of the spreadsheet
- `range` (required) - A1 notation range to clear

**Returns:** JSON object with cleared range

**Example:**
```bash
./scripts/clear-values.sh "david@david-peralta.com" "1A2B3C4D5E6F" "Temp!A1:Z100"
```

### 7. Create Spreadsheet

Create a new Google Spreadsheet with optional sheet names.

**Script:** `scripts/create-spreadsheet.sh`

**Usage:**
```bash
./scripts/create-spreadsheet.sh "user@example.com" "Spreadsheet Title" ["Sheet1,Sheet2,Sheet3"]
```

**Parameters:**
- `user_email` (required) - User's Google email address
- `title` (required) - Title for the new spreadsheet
- `sheet_names` (optional) - Comma-separated list of sheet names to create

**Returns:** JSON object with spreadsheet ID, properties, sheets, and URL

**Example:**
```bash
./scripts/create-spreadsheet.sh "david@david-peralta.com" "Q4 Performance Report" "Summary,Details,Charts"
```

### 8. Create Sheet

Create a new sheet within an existing spreadsheet.

**Script:** `scripts/create-sheet.sh`

**Usage:**
```bash
./scripts/create-sheet.sh "user@example.com" "spreadsheet_id" "New Sheet Name"
```

**Parameters:**
- `user_email` (required) - User's Google email address
- `spreadsheet_id` (required) - ID of the existing spreadsheet
- `sheet_name` (required) - Name for the new sheet

**Returns:** JSON object with new sheet properties including sheet ID

**Example:**
```bash
./scripts/create-sheet.sh "david@david-peralta.com" "1A2B3C4D5E6F" "October Analysis"
```

## Batch Operations

Batch operations perform multiple actions in a single API call for improved performance and efficiency.

### 9. Batch Get

Retrieve values from multiple ranges in a single request.

**Script:** `scripts/batch-get.sh`

**Usage:**
```bash
./scripts/batch-get.sh "user@example.com" "spreadsheet_id" "Sheet1!A1:B2,Sheet1!D4:E5,Sheet2!A1:C3"
```

**Parameters:**
- `user_email` (required) - User's Google email address
- `spreadsheet_id` (required) - ID of the spreadsheet
- `ranges` (required) - Comma-separated list of A1 notation ranges

**Returns:** JSON object with array of valueRanges, each containing range and values

**Use case:** Efficiently reading multiple non-contiguous ranges (headers, summary rows, different sheets)

**Example:**
```bash
./scripts/batch-get.sh "david@david-peralta.com" "1A2B3C4D5E6F" "Summary!A1:C1,Data!A1:F100,Metrics!A1:B20"
```

### 10. Batch Update

Update values in multiple ranges in a single request.

**Script:** `scripts/batch-update.sh`

**Usage:**
```bash
./scripts/batch-update.sh "user@example.com" "spreadsheet_id" '[{"range":"Sheet1!A1:B2","values":[["a","b"],["c","d"]]},{"range":"Sheet2!A1","values":[["e"]]}]'
```

**Parameters:**
- `user_email` (required) - User's Google email address
- `spreadsheet_id` (required) - ID of the spreadsheet
- `data` (required) - JSON array of objects with `range` and `values` properties

**Returns:** JSON object with array of update responses

**Use case:** Updating multiple ranges efficiently (headers, totals, different sheets)

**Example:**
```bash
./scripts/batch-update.sh "david@david-peralta.com" "1A2B3C4D5E6F" '[{"range":"Summary!A1","values":[["Last Updated: 2025-10-23"]]},{"range":"Data!A1:C1","values":[["Date","Views","Clicks"]]}]'
```

### 11. Batch Clear

Clear values from multiple ranges in a single request.

**Script:** `scripts/batch-clear.sh`

**Usage:**
```bash
./scripts/batch-clear.sh "user@example.com" "spreadsheet_id" "Sheet1!A1:B2,Sheet1!D4:E5,Sheet2!A1:C3"
```

**Parameters:**
- `user_email` (required) - User's Google email address
- `spreadsheet_id` (required) - ID of the spreadsheet
- `ranges` (required) - Comma-separated list of A1 notation ranges

**Returns:** JSON object with array of cleared ranges

**Example:**
```bash
./scripts/batch-clear.sh "david@david-peralta.com" "1A2B3C4D5E6F" "Temp!A:Z,Scratch!A:Z"
```

## Advanced Operations

### 12. Copy Sheet

Copy a sheet to another spreadsheet or within the same spreadsheet.

**Script:** `scripts/copy-sheet.sh`

**Usage:**
```bash
./scripts/copy-sheet.sh "user@example.com" "source_spreadsheet_id" "sheet_id" "destination_spreadsheet_id"
```

**Parameters:**
- `user_email` (required) - User's Google email address
- `source_spreadsheet_id` (required) - ID of spreadsheet containing the sheet to copy
- `sheet_id` (required) - ID of the sheet to copy (numeric ID, not name)
- `destination_spreadsheet_id` (required) - ID of destination spreadsheet

**Returns:** JSON object with copied sheet properties

**Use case:** Duplicating templates, archiving data, creating backups

**Note:** To get sheet_id, use `get-spreadsheet-info.sh` and look for `sheets[].properties.sheetId`

**Example:**
```bash
# First get sheet IDs
./scripts/get-spreadsheet-info.sh "david@david-peralta.com" "1A2B3C4D5E6F" | jq '.sheets[].properties | {sheetId, title}'

# Then copy sheet
./scripts/copy-sheet.sh "david@david-peralta.com" "1A2B3C4D5E6F" "123456" "7G8H9I0J1K2L"
```

### 13. Format Cells

Apply formatting to cells (bold, italic, colors, background colors).

**Script:** `scripts/format-cells.sh`

**Usage:**
```bash
./scripts/format-cells.sh "user@example.com" "spreadsheet_id" "sheet_id" "start_row" "end_row" "start_col" "end_col" '{"bold":true,"textFormat":{"fontSize":12},"backgroundColor":{"red":0.9,"green":0.9,"blue":0.9}}'
```

**Parameters:**
- `user_email` (required) - User's Google email address
- `spreadsheet_id` (required) - ID of the spreadsheet
- `sheet_id` (required) - Numeric ID of the sheet (use `get-spreadsheet-info.sh`)
- `start_row` (required) - Starting row index (0-based)
- `end_row` (required) - Ending row index (exclusive)
- `start_col` (required) - Starting column index (0-based)
- `end_col` (required) - Ending column index (exclusive)
- `format_json` (required) - JSON object with formatting properties

**Format Properties:**
- `bold`: true/false
- `italic`: true/false
- `textFormat.fontSize`: number (points)
- `textFormat.foregroundColor`: {red, green, blue} (0-1 range)
- `backgroundColor`: {red, green, blue} (0-1 range)

**Returns:** JSON object with batch update response

**Use case:** Highlighting headers, color-coding data, emphasizing important cells

**Example:**
```bash
# Bold header row (row 0, columns A-F)
./scripts/format-cells.sh "david@david-peralta.com" "1A2B3C4D5E6F" "0" "0" "1" "0" "6" '{"bold":true,"backgroundColor":{"red":0.85,"green":0.85,"blue":0.85}}'
```

### 14. Add Rows

Insert new rows into a sheet.

**Script:** `scripts/add-rows.sh`

**Usage:**
```bash
./scripts/add-rows.sh "user@example.com" "spreadsheet_id" "sheet_id" "start_index" "num_rows"
```

**Parameters:**
- `user_email` (required) - User's Google email address
- `spreadsheet_id` (required) - ID of the spreadsheet
- `sheet_id` (required) - Numeric ID of the sheet
- `start_index` (required) - 0-based row index where to insert (rows shift down)
- `num_rows` (required) - Number of rows to insert

**Returns:** JSON object with batch update response

**Use case:** Making space for new data, inserting rows between existing data

**Example:**
```bash
# Insert 5 rows starting at row 10 (existing rows shift down)
./scripts/add-rows.sh "david@david-peralta.com" "1A2B3C4D5E6F" "0" "10" "5"
```

### 15. Delete Rows

Remove rows from a sheet.

**Script:** `scripts/delete-rows.sh`

**Usage:**
```bash
./scripts/delete-rows.sh "user@example.com" "spreadsheet_id" "sheet_id" "start_index" "num_rows"
```

**Parameters:**
- `user_email` (required) - User's Google email address
- `spreadsheet_id` (required) - ID of the spreadsheet
- `sheet_id` (required) - Numeric ID of the sheet
- `start_index` (required) - 0-based row index where to start deleting
- `num_rows` (required) - Number of rows to delete

**Returns:** JSON object with batch update response

**Use case:** Removing old data, cleaning up sheets, deleting temporary rows

**Example:**
```bash
# Delete 3 rows starting at row 20
./scripts/delete-rows.sh "david@david-peralta.com" "1A2B3C4D5E6F" "0" "20" "3"
```

### 16. Sort Range

Sort a range by a specific column.

**Script:** `scripts/sort-range.sh`

**Usage:**
```bash
./scripts/sort-range.sh "user@example.com" "spreadsheet_id" "sheet_id" "start_row" "end_row" "start_col" "end_col" "sort_col_index" "[ASCENDING|DESCENDING]"
```

**Parameters:**
- `user_email` (required) - User's Google email address
- `spreadsheet_id` (required) - ID of the spreadsheet
- `sheet_id` (required) - Numeric ID of the sheet
- `start_row` (required) - Starting row index (0-based)
- `end_row` (required) - Ending row index (exclusive)
- `start_col` (required) - Starting column index (0-based)
- `end_col` (required) - Ending column index (exclusive)
- `sort_col_index` (required) - Column index to sort by (0-based, relative to sheet)
- `sort_order` (optional) - "ASCENDING" or "DESCENDING" (default: "ASCENDING")

**Returns:** JSON object with batch update response

**Use case:** Sorting data by date, ranking by metrics, alphabetical ordering

**Example:**
```bash
# Sort rows 1-100 (excluding header row 0) by column B (index 1) in descending order
./scripts/sort-range.sh "david@david-peralta.com" "1A2B3C4D5E6F" "0" "1" "100" "0" "6" "1" "DESCENDING"
```

### 17. Set Data Validation

Apply data validation rules to a range (dropdown lists, number ranges, etc.).

**Script:** `scripts/set-data-validation.sh`

**Usage:**
```bash
./scripts/set-data-validation.sh "user@example.com" "spreadsheet_id" "sheet_id" "start_row" "end_row" "start_col" "end_col" '{"condition":{"type":"NUMBER_GREATER","values":[{"userEnteredValue":"0"}]},"showCustomUi":true}'
```

**Parameters:**
- `user_email` (required) - User's Google email address
- `spreadsheet_id` (required) - ID of the spreadsheet
- `sheet_id` (required) - Numeric ID of the sheet
- `start_row` (required) - Starting row index (0-based)
- `end_row` (required) - Ending row index (exclusive)
- `start_col` (required) - Starting column index (0-based)
- `end_col` (required) - Ending column index (exclusive)
- `validation_rule` (required) - JSON object with validation rule

**Common Validation Types:**
- `NUMBER_GREATER`: Number greater than value
- `NUMBER_BETWEEN`: Number within range
- `ONE_OF_LIST`: Dropdown list of specific values
- `DATE_AFTER`: Date after specified date
- `TEXT_CONTAINS`: Text contains substring

**Returns:** JSON object with batch update response

**Use case:** Enforcing data quality, creating dropdown menus, restricting input

**Example - Dropdown list:**
```bash
# Create dropdown with "Yes", "No", "N/A" options in column C, rows 2-50
./scripts/set-data-validation.sh "david@david-peralta.com" "1A2B3C4D5E6F" "0" "2" "50" "2" "3" '{"condition":{"type":"ONE_OF_LIST","values":[{"userEnteredValue":"Yes"},{"userEnteredValue":"No"},{"userEnteredValue":"N/A"}]},"showCustomUi":true,"strict":true}'
```

**Example - Number validation:**
```bash
# Require numbers between 0 and 100 in column D, rows 2-50
./scripts/set-data-validation.sh "david@david-peralta.com" "1A2B3C4D5E6F" "0" "2" "50" "3" "4" '{"condition":{"type":"NUMBER_BETWEEN","values":[{"userEnteredValue":"0"},{"userEnteredValue":"100"}]},"showCustomUi":true}'
```

## Authentication

All scripts automatically extract OAuth tokens from the Google Workspace credentials store using the shared authentication library.

**Credential Location:** `~/.claude/skills/google-workspace-credentials/{user_email}.json`

**Token Management:**
- Access tokens expire after ~1 hour
- Scripts automatically refresh expired tokens using the refresh token
- Refreshed tokens are written back to the credential file
- No manual intervention required

**Setup:**
If credentials are not found, they must be copied from the Google Workspace MCP server location:
```bash
mkdir -p ~/.claude/skills/google-workspace-credentials
cp ~/.google_workspace_mcp/credentials/*.json ~/.claude/skills/google-workspace-credentials/
```

## Error Handling

All scripts return JSON error objects if operations fail:

```json
{
  "error": {
    "code": 400,
    "message": "Description of what went wrong",
    "status": "INVALID_ARGUMENT"
  }
}
```

Common errors:
- **401 Unauthorized:** Token expired (automatically refreshed and retried)
- **403 Forbidden:** Insufficient permissions or rate limit exceeded
- **404 Not Found:** Spreadsheet or sheet ID does not exist
- **400 Bad Request:** Invalid range, malformed data, or invalid parameters

## Working with Sheet IDs vs. Range Names

**Sheet Names** (e.g., "Sheet1", "Data", "Summary"):
- Used in A1 notation ranges: `"Sheet1!A1:B10"`
- Used in read/write operations

**Sheet IDs** (e.g., 0, 123456, 987654):
- Numeric identifiers for sheets
- Required for: format-cells, add-rows, delete-rows, sort-range, set-data-validation, copy-sheet
- Obtained via `get-spreadsheet-info.sh`:
  ```bash
  ./scripts/get-spreadsheet-info.sh "user@example.com" "spreadsheet_id" | jq '.sheets[].properties | {sheetId, title}'
  ```

## API Documentation

Full Google Sheets API v4 reference: https://developers.google.com/sheets/api/reference/rest
