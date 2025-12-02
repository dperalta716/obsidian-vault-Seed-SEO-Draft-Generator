#!/bin/bash
#
# upload-file.sh
# Uploads a file to a Google File Search store using resumable upload
#
# Usage: ./upload-file.sh STORE_NAME FILE_PATH METADATA_JSON [DISPLAY_NAME]
#
# Example:
#   METADATA='[{"key":"category","string_value":"Test"}]'
#   ./upload-file.sh "fileSearchStores/xxx" "file.md" "$METADATA" "My File"
#

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print error and exit
error_exit() {
    echo -e "${RED}ERROR: $1${NC}" >&2
    exit 1
}

# Function to print info
info() {
    echo -e "${GREEN}$1${NC}"
}

# Function to print debug
debug() {
    echo -e "${BLUE}DEBUG: $1${NC}" >&2
}

# Check arguments
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    error_exit "Usage: $0 STORE_NAME FILE_PATH METADATA_JSON [DISPLAY_NAME]"
fi

STORE_NAME="$1"
FILE_PATH="$2"
METADATA_JSON="$3"
DISPLAY_NAME="${4:-$(basename "$FILE_PATH")}"

# Validate file exists
if [ ! -f "$FILE_PATH" ]; then
    error_exit "File not found: $FILE_PATH"
fi

# Read API key
API_KEY_FILE="$HOME/.claude/skills/gemini-api-key"
if [ ! -f "$API_KEY_FILE" ]; then
    error_exit "API key file not found: $API_KEY_FILE"
fi

API_KEY=$(cat "$API_KEY_FILE" | tr -d '\n\r')
if [ -z "$API_KEY" ]; then
    error_exit "API key file is empty: $API_KEY_FILE"
fi

# Validate metadata JSON
if ! echo "$METADATA_JSON" | jq empty 2>/dev/null; then
    error_exit "Invalid metadata JSON: $METADATA_JSON"
fi

# Get file info
FILE_SIZE=$(stat -f%z "$FILE_PATH" 2>/dev/null || stat -c%s "$FILE_PATH" 2>/dev/null)
MIME_TYPE="text/markdown"  # For .md files

info "Uploading file: $FILE_PATH"
info "Display Name: $DISPLAY_NAME"
info "Size: $FILE_SIZE bytes"
info "Store: $STORE_NAME"

# ===== STEP 1: Initiate Resumable Upload =====
debug "Step 1: Initiating resumable upload..."

UPLOAD_ENDPOINT="https://generativelanguage.googleapis.com/upload/v1beta/${STORE_NAME}:uploadToFileSearchStore?key=${API_KEY}"

REQUEST_BODY=$(cat <<EOF
{
  "displayName": "$DISPLAY_NAME",
  "customMetadata": $METADATA_JSON
}
EOF
)

# Make initiation request and save headers
TEMP_HEADERS=$(mktemp)
TEMP_RESPONSE=$(mktemp)

HTTP_CODE=$(curl -s -w "%{http_code}" -D "$TEMP_HEADERS" -o "$TEMP_RESPONSE" -X POST \
  "$UPLOAD_ENDPOINT" \
  -H "X-Goog-Upload-Protocol: resumable" \
  -H "X-Goog-Upload-Command: start" \
  -H "X-Goog-Upload-Header-Content-Length: $FILE_SIZE" \
  -H "X-Goog-Upload-Header-Content-Type: $MIME_TYPE" \
  -H "Content-Type: application/json" \
  -d "$REQUEST_BODY")

# Check HTTP status
if [ "$HTTP_CODE" != "200" ]; then
    RESPONSE_BODY=$(cat "$TEMP_RESPONSE")
    rm -f "$TEMP_HEADERS" "$TEMP_RESPONSE"
    error_exit "Step 1 failed with HTTP $HTTP_CODE\nResponse: $RESPONSE_BODY"
fi

# Extract upload URL from headers
UPLOAD_URL=$(grep -i "^x-goog-upload-url:" "$TEMP_HEADERS" | cut -d' ' -f2- | tr -d '\r\n')

if [ -z "$UPLOAD_URL" ]; then
    cat "$TEMP_HEADERS" >&2
    cat "$TEMP_RESPONSE" >&2
    rm -f "$TEMP_HEADERS" "$TEMP_RESPONSE"
    error_exit "Failed to extract upload URL from response headers"
fi

rm -f "$TEMP_HEADERS" "$TEMP_RESPONSE"

debug "Upload URL: $UPLOAD_URL"

# ===== STEP 2: Upload File Bytes =====
debug "Step 2: Uploading file bytes..."

TEMP_UPLOAD_RESPONSE=$(mktemp)

UPLOAD_HTTP_CODE=$(curl -s -w "%{http_code}" -o "$TEMP_UPLOAD_RESPONSE" -X POST \
  "$UPLOAD_URL" \
  -H "Content-Length: $FILE_SIZE" \
  -H "X-Goog-Upload-Offset: 0" \
  -H "X-Goog-Upload-Command: upload, finalize" \
  --data-binary "@$FILE_PATH")

UPLOAD_RESPONSE=$(cat "$TEMP_UPLOAD_RESPONSE")
rm -f "$TEMP_UPLOAD_RESPONSE"

# Check HTTP status (200 or 201 are success)
if [ "$UPLOAD_HTTP_CODE" != "200" ] && [ "$UPLOAD_HTTP_CODE" != "201" ]; then
    error_exit "Step 2 failed with HTTP $UPLOAD_HTTP_CODE\nResponse: $UPLOAD_RESPONSE"
fi

info "Upload successful!"

# Parse and display operation info if available
OPERATION_NAME=$(echo "$UPLOAD_RESPONSE" | jq -r '.name // empty' 2>/dev/null)
if [ -n "$OPERATION_NAME" ]; then
    info "Operation: $OPERATION_NAME"
fi

# Output full response
echo "$UPLOAD_RESPONSE"
