#!/bin/bash
#
# create-store.sh
# Creates a new Google File Search store
#
# Usage: ./create-store.sh "Display Name"
#

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
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

# Function to print warning
warn() {
    echo -e "${YELLOW}$1${NC}"
}

# Check if display name provided
if [ -z "$1" ]; then
    error_exit "Display name required. Usage: $0 \"Display Name\""
fi

DISPLAY_NAME="$1"

# Read API key
API_KEY_FILE="$HOME/.claude/skills/gemini-api-key"
if [ ! -f "$API_KEY_FILE" ]; then
    error_exit "API key file not found: $API_KEY_FILE"
fi

API_KEY=$(cat "$API_KEY_FILE" | tr -d '\n\r')
if [ -z "$API_KEY" ]; then
    error_exit "API key file is empty: $API_KEY_FILE"
fi

info "Creating File Search store: $DISPLAY_NAME"

# API endpoint
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/fileSearchStores?key=${API_KEY}"

# Request body
REQUEST_BODY=$(cat <<EOF
{
  "displayName": "$DISPLAY_NAME"
}
EOF
)

# Make API call
info "Sending request to Gemini API..."
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST \
  "$ENDPOINT" \
  -H "Content-Type: application/json" \
  -d "$REQUEST_BODY")

# Split response and HTTP code
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
RESPONSE_BODY=$(echo "$RESPONSE" | sed '$d')

# Check HTTP status
if [ "$HTTP_CODE" != "200" ]; then
    error_exit "API request failed with HTTP $HTTP_CODE\nResponse: $RESPONSE_BODY"
fi

# Parse store name from response
STORE_NAME=$(echo "$RESPONSE_BODY" | jq -r '.name // empty')

if [ -z "$STORE_NAME" ]; then
    error_exit "Failed to extract store name from response\nResponse: $RESPONSE_BODY"
fi

# Validate store name format
if [[ ! "$STORE_NAME" =~ ^fileSearchStores/[a-zA-Z0-9]+$ ]]; then
    warn "Store name has unexpected format: $STORE_NAME"
fi

info "Store created successfully!"
info "Store Name: $STORE_NAME"
info "Display Name: $DISPLAY_NAME"

# Output full JSON response
echo "$RESPONSE_BODY"
