---
name: google-drive
description: This skill should be used for Google Drive file and folder operations including searching, uploading, downloading, moving files between folders, managing permissions, and exporting Google Workspace files to different formats. Use when working with Drive files, organizing documents, managing file sharing, or integrating Drive with other workflows.
---

# Google Drive

## Overview

Provides comprehensive access to Google Drive API v3 for file management, folder operations, sharing, and file format conversions. This skill includes all essential Drive operations plus critical functionality like moving files between folders (required for document upload workflows) and exporting Google Workspace files to various formats.

## When to Use This Skill

- Searching for files or folders in Google Drive
- Uploading or downloading files
- Moving files between folders (critical for upload-to-gdocs workflows)
- Copying, renaming, or deleting files
- Managing file permissions and sharing settings
- Exporting Google Docs/Sheets/Slides to PDF, DOCX, XLSX, etc.
- Listing folder contents
- Checking file metadata and permissions
- Organizing Drive files programmatically

## Available Operations

All operations are implemented as bash scripts in the `scripts/` directory. Each script uses shared authentication from `scripts/lib/auth.sh`.

### File Search & Discovery

#### 1. Search Files

Search for files using Google Drive query syntax.

**Script:** `scripts/search-files.sh`

**Usage:**
```bash
./scripts/search-files.sh "user@example.com" "name contains 'report'" [max_results]
```

**Parameters:**
- `user_email` (required) - Google account email
- `query` (required) - Drive API query string (e.g., "name contains 'report'", "mimeType='application/pdf'")
- `max_results` (optional) - Maximum number of results to return (default: 100)

**Query Examples:**
- `"name contains 'quarterly report'"` - Files with "quarterly report" in name
- `"mimeType='application/pdf'"` - All PDF files
- `"'1ABC123' in parents"` - Files in specific folder
- `"modifiedTime > '2025-01-01T00:00:00'"` - Files modified after date
- `"trashed=false and starred=true"` - Starred files not in trash

**Returns:** JSON array of file objects with id, name, mimeType, size, modifiedTime, webViewLink.

#### 2. List Files in Folder

List all files and subfolders within a specific folder.

**Script:** `scripts/list-files.sh`

**Usage:**
```bash
./scripts/list-files.sh "user@example.com" [folder_id] [max_results]
```

**Parameters:**
- `user_email` (required)
- `folder_id` (optional) - Folder ID to list (default: "root" for My Drive)
- `max_results` (optional) - Maximum results (default: 1000)

**Returns:** JSON array of files/folders with metadata.

### File Metadata & Content

#### 3. Get File Metadata

Get detailed metadata for a specific file.

**Script:** `scripts/get-file.sh`

**Usage:**
```bash
./scripts/get-file.sh "user@example.com" "file_id"
```

**Returns:** JSON object with file metadata including id, name, mimeType, size, parents, permissions, sharing settings.

#### 4. Download File Content

Download binary content or export Google Workspace files.

**Script:** `scripts/download-file.sh`

**Usage:**
```bash
./scripts/download-file.sh "user@example.com" "file_id" [output_path]
```

**Parameters:**
- `user_email` (required)
- `file_id` (required)
- `output_path` (optional) - Local file path to save (default: current directory with original filename)

**Behavior:**
- For binary files (PDF, images, etc.): Downloads as-is
- For Google Docs: Automatically exports to DOCX
- For Google Sheets: Automatically exports to XLSX
- For Google Slides: Automatically exports to PPTX

**Returns:** Success message with local file path.

#### 5. Export File to Format

Export Google Workspace files to specific formats.

**Script:** `scripts/export-file.sh`

**Usage:**
```bash
./scripts/export-file.sh "user@example.com" "file_id" "mime_type" [output_path]
```

**Parameters:**
- `user_email` (required)
- `file_id` (required)
- `mime_type` (required) - Target format MIME type
- `output_path` (optional) - Local save path

**Supported Export Formats:**

| File Type | Export MIME Type | Extension |
|-----------|------------------|-----------|
| Google Docs | `application/pdf` | .pdf |
| Google Docs | `application/vnd.openxmlformats-officedocument.wordprocessingml.document` | .docx |
| Google Docs | `text/plain` | .txt |
| Google Docs | `text/html` | .html |
| Google Sheets | `application/pdf` | .pdf |
| Google Sheets | `application/vnd.openxmlformats-officedocument.spreadsheetml.sheet` | .xlsx |
| Google Sheets | `text/csv` | .csv |
| Google Slides | `application/pdf` | .pdf |
| Google Slides | `application/vnd.openxmlformats-officedocument.presentationml.presentation` | .pptx |

**Returns:** Exported file content written to output path.

### File Creation & Upload

#### 6. Create File

Create a new text-based file in Drive.

**Script:** `scripts/create-file.sh`

**Usage:**
```bash
./scripts/create-file.sh "user@example.com" "filename.txt" "file content" [parent_folder_id] [mime_type]
```

**Parameters:**
- `user_email` (required)
- `filename` (required)
- `content` (required) - Text content for the file
- `parent_folder_id` (optional) - Parent folder ID (default: "root")
- `mime_type` (optional) - MIME type (default: "text/plain")

**Returns:** JSON object with created file id, name, and webViewLink.

#### 7. Upload File

Upload a local file to Google Drive.

**Script:** `scripts/upload-file.sh`

**Usage:**
```bash
./scripts/upload-file.sh "user@example.com" "local_file_path" [parent_folder_id] [mime_type]
```

**Parameters:**
- `user_email` (required)
- `local_file_path` (required) - Path to file on local filesystem
- `parent_folder_id` (optional) - Destination folder ID (default: "root")
- `mime_type` (optional) - MIME type (auto-detected if not specified)

**Returns:** JSON object with uploaded file details.

### File Management

#### 8. Move File ⭐ CRITICAL

Move a file from one folder to another. **Essential for upload-to-gdocs workflows.**

**Script:** `scripts/move-file.sh`

**Usage:**
```bash
./scripts/move-file.sh "user@example.com" "file_id" "new_folder_id"
```

**Parameters:**
- `user_email` (required)
- `file_id` (required) - ID of file to move
- `new_folder_id` (required) - Destination folder ID

**Process:**
1. Retrieves current parent folder ID
2. Removes file from current parent
3. Adds file to new parent
4. Returns updated file metadata

**Important:** This operation modifies the `parents` property, effectively moving the file in Drive's folder hierarchy.

**Returns:** JSON object with file id, name, and updated parents array.

#### 9. Copy File

Create a copy of an existing file.

**Script:** `scripts/copy-file.sh`

**Usage:**
```bash
./scripts/copy-file.sh "user@example.com" "file_id" "new_name" [parent_folder_id]
```

**Parameters:**
- `user_email` (required)
- `file_id` (required) - Source file to copy
- `new_name` (required) - Name for the copy
- `parent_folder_id` (optional) - Destination folder (default: same as source)

**Returns:** JSON object with copied file details.

#### 10. Update File Metadata

Rename a file or update its description.

**Script:** `scripts/update-metadata.sh`

**Usage:**
```bash
./scripts/update-metadata.sh "user@example.com" "file_id" [new_name] [description]
```

**Parameters:**
- `user_email` (required)
- `file_id` (required)
- `new_name` (optional) - New filename
- `description` (optional) - File description

**Note:** At least one of `new_name` or `description` must be provided.

**Returns:** JSON object with updated file metadata.

#### 11. Delete File

Permanently delete a file from Drive.

**Script:** `scripts/delete-file.sh`

**Usage:**
```bash
./scripts/delete-file.sh "user@example.com" "file_id"
```

**Warning:** This permanently deletes the file. It cannot be recovered from trash.

**Returns:** Success confirmation message.

### Permission Management

#### 12. List File Permissions

Get all permissions for a file.

**Script:** `scripts/list-permissions.sh`

**Usage:**
```bash
./scripts/list-permissions.sh "user@example.com" "file_id"
```

**Returns:** JSON array of permission objects showing who has access and their role (owner, writer, reader).

#### 13. Create Permission (Share File)

Grant access to a file or folder.

**Script:** `scripts/create-permission.sh`

**Usage:**
```bash
./scripts/create-permission.sh "user@example.com" "file_id" "email@example.com" "role" [type]
```

**Parameters:**
- `user_email` (required)
- `file_id` (required)
- `email_or_domain` (required) - Email address or domain to share with
- `role` (required) - Permission level: "reader", "writer", or "commenter"
- `type` (optional) - Permission type: "user" (default), "group", "domain", or "anyone"

**Examples:**
- Share with specific user: `./scripts/create-permission.sh "user@example.com" "file_id" "colleague@example.com" "writer" "user"`
- Share with anyone: `./scripts/create-permission.sh "user@example.com" "file_id" "" "reader" "anyone"`
- Share with domain: `./scripts/create-permission.sh "user@example.com" "file_id" "company.com" "reader" "domain"`

**Returns:** JSON object with created permission details.

#### 14. Delete Permission (Unshare File)

Remove access permission from a file.

**Script:** `scripts/delete-permission.sh`

**Usage:**
```bash
./scripts/delete-permission.sh "user@example.com" "file_id" "permission_id"
```

**Parameters:**
- `user_email` (required)
- `file_id` (required)
- `permission_id` (required) - ID of permission to remove (get from list-permissions)

**Returns:** Success confirmation message.

## Authentication

All scripts use shared authentication via `scripts/lib/auth.sh`.

**Credential Location:** `~/.claude/skills/google-workspace-credentials/{user_email}.json`

**Required Scopes:**
- `https://www.googleapis.com/auth/drive` - Full Drive access
- `https://www.googleapis.com/auth/drive.file` - Per-file access (alternative)

**Token Management:**
- Access tokens expire after ~1 hour
- Scripts automatically refresh tokens using refresh_token
- Updated tokens are saved back to credential file
- Independent from Google Workspace MCP server

## Error Handling

All scripts return structured error messages as JSON:

```json
{
  "error": {
    "code": 404,
    "message": "File not found"
  }
}
```

**Common Error Codes:**
- 400 - Bad request (invalid parameters)
- 401 - Unauthorized (token expired or invalid)
- 403 - Forbidden (insufficient permissions)
- 404 - Not found (file/folder doesn't exist)
- 429 - Rate limit exceeded

## Common Workflows

### Upload and Organize Documents

```bash
# 1. Upload a document
FILE_JSON=$(./scripts/upload-file.sh "user@example.com" "./report.pdf")
FILE_ID=$(echo "$FILE_JSON" | jq -r '.id')

# 2. Move to specific folder
./scripts/move-file.sh "user@example.com" "$FILE_ID" "1JWFAoYKwsD2zTtypjs2gb34F0jAvv2bD"

# 3. Share with team
./scripts/create-permission.sh "user@example.com" "$FILE_ID" "team@company.com" "writer" "group"
```

### Find and Export Reports

```bash
# 1. Search for monthly reports
RESULTS=$(./scripts/search-files.sh "user@example.com" "name contains 'Monthly Report' and mimeType='application/vnd.google-apps.document'")

# 2. Export first result to PDF
FILE_ID=$(echo "$RESULTS" | jq -r '.[0].id')
./scripts/export-file.sh "user@example.com" "$FILE_ID" "application/pdf" "./report.pdf"
```

### Organize Files into Folders

```bash
# 1. Search for unorganized files
FILES=$(./scripts/search-files.sh "user@example.com" "'root' in parents and mimeType='application/pdf'")

# 2. Move each to archive folder
echo "$FILES" | jq -r '.[].id' | while read FILE_ID; do
  ./scripts/move-file.sh "user@example.com" "$FILE_ID" "archive_folder_id"
done
```

## API Documentation

Full API reference: https://developers.google.com/drive/api/v3/reference
