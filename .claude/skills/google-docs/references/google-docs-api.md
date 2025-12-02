# Google Docs API Reference

This document provides detailed reference information for working with the Google Docs API v1.

## API Base URL

```
https://docs.googleapis.com/v1
```

## Document Structure

### Understanding Index-Based Positioning

Google Docs uses **character indices** to identify positions in a document. Every character, including structural elements like tables and images, occupies index positions.

**Key Points:**
- Indices start at 1 (not 0)
- The document always ends with a newline character at index `n-1`
- Structural elements (tables, images) consume multiple indices
- Text runs are contiguous ranges of characters

**Example:**
```
Index:  1   2   3   4   5   6   7   8
Text:   H   e   l   l   o   \n  W   o
Index:  9  10  11  12  13
Text:   r   l   d   \n  \n
```

### Document Elements

Documents consist of these structural elements:

1. **Paragraph** - Text with styling and formatting
2. **Table** - Grid structure with rows and cells
3. **TableOfContents** - Auto-generated TOC
4. **SectionBreak** - Page or section boundaries
5. **PageBreak** - Explicit page breaks

### Table Structure

Tables are nested structures:
- **Table** → Contains rows
- **TableRow** → Contains cells
- **TableCell** → Contains content (paragraphs, nested tables)

Each element has `startIndex` and `endIndex` properties.

## batchUpdate Operations

All document modifications use the `batchUpdate` endpoint:

```
POST /documents/{documentId}:batchUpdate
```

### Core Text Operations

#### insertText
Insert text at a specific index.

```json
{
  "insertText": {
    "text": "Hello World",
    "location": {"index": 1}
  }
}
```

#### deleteContentRange
Remove text between indices.

```json
{
  "deleteContentRange": {
    "range": {
      "startIndex": 1,
      "endIndex": 10
    }
  }
}
```

#### replaceAllText
Find and replace throughout the document.

```json
{
  "replaceAllText": {
    "containsText": {
      "text": "old text",
      "matchCase": false
    },
    "replaceText": "new text"
  }
}
```

### Table Operations

#### insertTable
Create a new table.

```json
{
  "insertTable": {
    "rows": 3,
    "columns": 4,
    "location": {"index": 1}
  }
}
```

#### insertTableRow
Add a row to existing table.

```json
{
  "insertTableRow": {
    "tableCellLocation": {
      "tableStartLocation": {"index": 5},
      "rowIndex": 1,
      "columnIndex": 0
    },
    "insertBelow": true
  }
}
```

#### insertTableColumn
Add a column to existing table.

```json
{
  "insertTableColumn": {
    "tableCellLocation": {
      "tableStartLocation": {"index": 5},
      "rowIndex": 0,
      "columnIndex": 1
    },
    "insertRight": true
  }
}
```

### Styling Operations

#### updateTextStyle
Apply text formatting.

```json
{
  "updateTextStyle": {
    "range": {
      "startIndex": 1,
      "endIndex": 10
    },
    "textStyle": {
      "bold": true,
      "italic": false,
      "fontSize": {
        "magnitude": 12,
        "unit": "PT"
      },
      "foregroundColor": {
        "color": {
          "rgbColor": {
            "red": 1.0,
            "green": 0.0,
            "blue": 0.0
          }
        }
      }
    },
    "fields": "bold,italic,fontSize,foregroundColor"
  }
}
```

**Available Text Style Fields:**
- `bold`, `italic`, `underline`, `strikethrough`
- `fontSize` - Size in points
- `fontFamily` - Font name
- `foregroundColor` - Text color
- `backgroundColor` - Highlight color
- `link` - Hyperlink URL
- `baselineOffset` - Superscript/subscript

#### updateParagraphStyle
Apply paragraph formatting.

```json
{
  "updateParagraphStyle": {
    "range": {
      "startIndex": 1,
      "endIndex": 50
    },
    "paragraphStyle": {
      "alignment": "CENTER",
      "lineSpacing": 150,
      "spacingMode": "COLLAPSE_LISTS"
    },
    "fields": "alignment,lineSpacing,spacingMode"
  }
}
```

**Alignment Values:** `START`, `CENTER`, `END`, `JUSTIFIED`

### Image Operations

#### insertInlineImage
Add an image from URL or Drive.

```json
{
  "insertInlineImage": {
    "uri": "https://example.com/image.png",
    "location": {"index": 1},
    "objectSize": {
      "height": {
        "magnitude": 200,
        "unit": "PT"
      },
      "width": {
        "magnitude": 300,
        "unit": "PT"
      }
    }
  }
}
```

**Image Sources:**
- Public URLs (https://)
- Google Drive files (use Drive file ID)

### Page Structure

#### insertPageBreak
Force a new page.

```json
{
  "insertPageBreak": {
    "location": {"index": 100}
  }
}
```

#### insertSectionBreak
Create sections with different headers/footers.

```json
{
  "insertSectionBreak": {
    "location": {"index": 100},
    "sectionType": "NEXT_PAGE"
  }
}
```

**Section Types:** `CONTINUOUS`, `NEXT_PAGE`, `EVEN_PAGE`, `ODD_PAGE`

## Best Practices

### 1. Always Use inspect-structure.sh First

Before inserting elements, inspect the document structure to find:
- Safe insertion indices
- Existing table positions
- Document length

```bash
./inspect-structure.sh "user@example.com" "doc_id" true
```

### 2. Execute Operations in Reverse Order

When making multiple insertions, work from **end to start** to avoid index shifts:

```json
{
  "requests": [
    {"insertText": {"location": {"index": 100}, "text": "Last"}},
    {"insertText": {"location": {"index": 50}, "text": "Middle"}},
    {"insertText": {"location": {"index": 1}, "text": "First"}}
  ]
}
```

### 3. Batch Operations When Possible

Combine multiple operations in a single batchUpdate for efficiency:

```bash
./batch-update.sh "user@example.com" "doc_id" '[
  {"insertText": {"location": {"index": 1}, "text": "Title\n"}},
  {"updateTextStyle": {"range": {"startIndex": 1, "endIndex": 6}, "textStyle": {"bold": true}, "fields": "bold"}}
]'
```

### 4. Handle Tables Carefully

Tables are complex structures. Use inspect-structure.sh to find:
- Table start index
- Row/cell positions
- Safe insertion points within cells

### 5. Error Handling

Always check for errors in responses:

```bash
if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
  echo "$RESPONSE" | jq '.error' >&2
  exit 1
fi
```

## Common Patterns

### Creating a Formatted Document

```bash
# 1. Create document
DOC_JSON=$(./create-doc.sh "user@example.com" "My Document")
DOC_ID=$(echo "$DOC_JSON" | jq -r '.documentId')

# 2. Build batch requests
REQUESTS='[
  {"insertText": {"location": {"index": 1}, "text": "My Title\n\nBody text here.\n"}},
  {"updateTextStyle": {"range": {"startIndex": 1, "endIndex": 9}, "textStyle": {"bold": true, "fontSize": {"magnitude": 18, "unit": "PT"}}, "fields": "bold,fontSize"}},
  {"updateParagraphStyle": {"range": {"startIndex": 1, "endIndex": 9}, "paragraphStyle": {"alignment": "CENTER"}, "fields": "alignment"}}
]'

# 3. Execute
./batch-update.sh "user@example.com" "$DOC_ID" "$REQUESTS"
```

### Working with Tables

```bash
# 1. Inspect document to find safe index
STRUCTURE=$(./inspect-structure.sh "user@example.com" "$DOC_ID")
END_INDEX=$(echo "$STRUCTURE" | jq '.body.content[-1].endIndex')

# 2. Insert table at end
./insert-table.sh "user@example.com" "$DOC_ID" 3 4 "$END_INDEX"

# 3. Get updated structure to find table cells
STRUCTURE=$(./inspect-structure.sh "user@example.com" "$DOC_ID" true)

# 4. Insert text into cells (requires parsing structure to find cell indices)
# Use batch-update.sh with calculated cell indices
```

## API Limits

- **Requests per minute:** 60 (per user)
- **Requests per day:** Unlimited
- **Document size:** 50 MB maximum
- **batchUpdate requests:** 200 operations per call

## Further Reading

- [Google Docs API Documentation](https://developers.google.com/docs/api)
- [Document Structure Guide](https://developers.google.com/docs/api/concepts/structure)
- [batchUpdate Reference](https://developers.google.com/docs/api/reference/rest/v1/documents/batchUpdate)
