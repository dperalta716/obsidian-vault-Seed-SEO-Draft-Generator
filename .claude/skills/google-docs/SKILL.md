---
name: google-docs
description: This skill should be used for Google Docs operations including creating documents, editing text, formatting content, inserting tables and images, and exporting to PDF. Use when working with Google Docs for content creation, document editing, or document structure manipulation.
---

# Google Docs

## Overview

This skill provides comprehensive access to the Google Docs API v1 for creating, editing, and formatting Google Docs programmatically. Use this skill when working with document creation workflows, content formatting, table manipulation, or document export operations.

## Core Capabilities

### 1. Document Creation & Retrieval

**Create new documents:**
```bash
./scripts/create-doc.sh "user@example.com" "Document Title"
```

**Get document content:**
```bash
./scripts/get-doc.sh "user@example.com" "document_id"
```

**Inspect document structure:**
```bash
./scripts/inspect-structure.sh "user@example.com" "document_id" [detailed]
```

Use inspect-structure.sh before complex operations to find safe insertion points and understand document layout.

### 2. Text Operations

**Insert text at specific position:**
```bash
./scripts/insert-text.sh "user@example.com" "document_id" "index" "text to insert"
```

**Delete text range:**
```bash
./scripts/delete-text.sh "user@example.com" "document_id" "start_index" "end_index"
```

**Find and replace:**
```bash
./scripts/replace-text.sh "user@example.com" "document_id" "find_text" "replace_text" [match_case]
```

### 3. Formatting Operations

**Apply text formatting (bold, italic, font size, font family):**
```bash
./scripts/format-text.sh "user@example.com" "document_id" "start_index" "end_index" [bold] [italic] [font_size] [font_family]
```

**Example - Make text bold and 18pt:**
```bash
./scripts/format-text.sh "user@example.com" "$DOC_ID" 1 10 true null 18
```

### 4. Table Operations

**Insert table:**
```bash
./scripts/insert-table.sh "user@example.com" "document_id" "rows" "columns" "index"
```

**Add row to existing table:**
```bash
./scripts/insert-table-row.sh "user@example.com" "document_id" "table_start_index" "row_index" [insert_below]
```

**Note:** Table population requires structure parsing. See references/google-docs-api.md for advanced table workflows.

### 5. Image Operations

**Insert image from URL or Drive:**
```bash
./scripts/insert-image.sh "user@example.com" "document_id" "image_uri" "index" [width] [height]
```

### 6. Batch Operations

**Execute multiple operations atomically:**
```bash
./scripts/batch-update.sh "user@example.com" "document_id" "requests_json_or_file"
```

**Example:**
```bash
./scripts/batch-update.sh "user@example.com" "$DOC_ID" '[
  {"insertText": {"location": {"index": 1}, "text": "Title\n"}},
  {"updateTextStyle": {"range": {"startIndex": 1, "endIndex": 6},
    "textStyle": {"bold": true}, "fields": "bold"}}
]'
```

### 7. Export to PDF

**Export document to PDF and save to Drive:**
```bash
./scripts/export-to-pdf.sh "user@example.com" "document_id" [pdf_filename] [folder_id]
```

## Common Workflows

### Creating a Formatted Document

```bash
# 1. Create document
DOC_JSON=$(./scripts/create-doc.sh "user@example.com" "Project Report")
DOC_ID=$(echo "$DOC_JSON" | jq -r '.documentId')

# 2. Add formatted content in one batch
./scripts/batch-update.sh "user@example.com" "$DOC_ID" '[
  {"insertText": {"location": {"index": 1}, "text": "Project Report\n\nExecutive Summary\n\nThis project achieved all goals.\n"}},
  {"updateTextStyle": {"range": {"startIndex": 1, "endIndex": 15},
    "textStyle": {"bold": true, "fontSize": {"magnitude": 24, "unit": "PT"}},
    "fields": "bold,fontSize"}},
  {"updateParagraphStyle": {"range": {"startIndex": 1, "endIndex": 15},
    "paragraphStyle": {"alignment": "CENTER"}, "fields": "alignment"}}
]'
```

### Working with Tables

```bash
# 1. Inspect document to find end index
STRUCTURE=$(./scripts/inspect-structure.sh "user@example.com" "$DOC_ID")
END_INDEX=$(echo "$STRUCTURE" | jq '.body.content[-1].endIndex')

# 2. Insert table at end
./scripts/insert-table.sh "user@example.com" "$DOC_ID" 4 3 "$END_INDEX"

# 3. Get updated structure to find table cells
STRUCTURE=$(./scripts/inspect-structure.sh "user@example.com" "$DOC_ID" true)

# 4. Populate cells using batch-update (requires parsing structure)
# See references/google-docs-api.md for complete table population patterns
```

### Converting Markdown to Google Docs

To convert markdown to formatted Google Docs:

1. **Parse markdown** to extract:
   - Headings → bold text with larger font sizes
   - Bold/italic formatting → text styles
   - Lists → paragraph styling
   - Code blocks → monospace font
   - Links → link text style

2. **Build batchUpdate requests** with:
   - `insertText` for all content
   - `updateTextStyle` for formatting
   - `updateParagraphStyle` for alignment and spacing

3. **Execute single batch-update.sh** call with all requests

## Understanding Document Structure

Google Docs uses **index-based positioning**:
- **Indices start at 1** (not 0)
- **Structural elements** (tables, images) consume multiple indices
- **Document always ends** with a newline character

**Critical Best Practice:** Always run `inspect-structure.sh` before complex operations to:
1. Find safe insertion points
2. Locate existing tables and their cell positions
3. Determine document length
4. Understand element boundaries

## Helper Libraries

### Authentication (scripts/lib/auth.sh)
Handles OAuth token management:
- Reads from `~/.claude/skills/google-workspace-credentials/`
- Auto-refreshes expired tokens
- Independent from Google Workspace MCP server

### Batch Request Builders (scripts/lib/batch-requests.sh)
Functions for building batchUpdate requests:
- `build_insert_text_request(text, index)`
- `build_delete_content_request(start, end)`
- `build_replace_all_text_request(find, replace, match_case)`
- `build_insert_table_request(rows, cols, index)`
- `build_update_text_style_request(start, end, bold, italic, font_size, font_family)`
- `build_update_paragraph_style_request(start, end, alignment, spacing_mode)`
- `build_insert_inline_image_request(uri, index, width, height)`

Source these in custom scripts to build complex operations.

## Resources

### scripts/
Contains all operational scripts and helper libraries:
- Core operations: create-doc.sh, get-doc.sh, insert-text.sh, etc.
- Helper libraries: lib/auth.sh, lib/batch-requests.sh

All scripts are executable bash scripts that interact with Google Docs API v1.

### references/
Detailed API documentation:
- `google-docs-api.md` - Complete API reference with all batchUpdate operation types, best practices, and advanced patterns

## Error Handling

All scripts return JSON with error details on failure:

```bash
RESPONSE=$(./scripts/create-doc.sh "user@example.com" "My Doc")

if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
  echo "Error occurred:" >&2
  echo "$RESPONSE" | jq '.error' >&2
  exit 1
fi

DOC_ID=$(echo "$RESPONSE" | jq -r '.documentId')
```

## API Limitations

- **Rate limit:** 60 requests per minute per user
- **Document size:** 50 MB maximum
- **batchUpdate limit:** 200 operations per call
- **Complex operations:** Some operations (like table population) require document structure parsing

## When to Use This Skill

Trigger this skill for:
- "Create a Google Doc with this content"
- "Upload this markdown as a Google Doc"
- "Format the title as bold and centered"
- "Insert a table with this data"
- "Find and replace all instances of X with Y"
- "Export this doc to PDF"
- "Add an image to the document"
- Working with document editing workflows (like `/upload-to-gdocs-v3`)

## Further Documentation

See `references/google-docs-api.md` for:
- Complete batchUpdate operation reference
- Advanced table manipulation patterns
- Document structure deep dive
- Best practices and common pitfalls
- Official Google Docs API links
