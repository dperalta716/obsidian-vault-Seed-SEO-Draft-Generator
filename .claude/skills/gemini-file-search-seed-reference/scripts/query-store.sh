#!/bin/bash
#
# query-store.sh
# Query the Gemini File Search store for Seed reference materials
#
# Usage: ./query-store.sh "Your query here" ["optional metadata filter"]
#
# Examples:
#   ./query-store.sh "What are approved claims about biotin?"
#   ./query-store.sh "Biotin benefits for hair" "product=DM-02 AND file_type=Ingredient-Claims"
#   ./query-store.sh "What compliance rules apply?" "category=Compliance"
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
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

# Check arguments
if [ -z "$1" ]; then
    error_exit "Query required. Usage: $0 \"Your query here\" [\"metadata filter\"]"
fi

QUERY="$1"
METADATA_FILTER="${2:-}"

# Read API key
API_KEY_FILE="$HOME/.claude/skills/gemini-api-key"
if [ ! -f "$API_KEY_FILE" ]; then
    error_exit "API key file not found: $API_KEY_FILE"
fi

API_KEY=$(cat "$API_KEY_FILE" | tr -d '\n\r')
if [ -z "$API_KEY" ]; then
    error_exit "API key file is empty: $API_KEY_FILE"
fi

# Read store ID from the reference-store-setup directory
# Try multiple possible locations
STORE_ID_FILE1="/Users/david/Documents/Obsidian Vaults/claude-code-demo/Seed-SEO-Draft-Generator-v4/dev/active/reference-store-setup/REFERENCE_STORE_ID"
STORE_ID_FILE2="$HOME/.claude/skills/gemini-file-search-seed-reference/STORE_ID"

if [ -f "$STORE_ID_FILE1" ]; then
    STORE_ID=$(cat "$STORE_ID_FILE1" | tr -d '\n\r')
elif [ -f "$STORE_ID_FILE2" ]; then
    STORE_ID=$(cat "$STORE_ID_FILE2" | tr -d '\n\r')
else
    error_exit "Store ID file not found. Tried:\n  $STORE_ID_FILE1\n  $STORE_ID_FILE2"
fi

if [ -z "$STORE_ID" ]; then
    error_exit "Store ID file is empty"
fi

info "Querying File Search Store"
info "Store: $STORE_ID"
info "Query: $QUERY"
if [ -n "$METADATA_FILTER" ]; then
    info "Filter: $METADATA_FILTER"
fi
echo ""

# Build request body using generateContent endpoint with File Search tool
if [ -n "$METADATA_FILTER" ]; then
    REQUEST_BODY=$(cat <<EOF
{
  "contents": [{
    "parts":[{"text": "$QUERY"}]
  }],
  "tools": [{
    "file_search": {
      "file_search_store_names": ["$STORE_ID"],
      "metadata_filter": "$METADATA_FILTER"
    }
  }]
}
EOF
)
else
    REQUEST_BODY=$(cat <<EOF
{
  "contents": [{
    "parts":[{"text": "$QUERY"}]
  }],
  "tools": [{
    "file_search": {
      "file_search_store_names": ["$STORE_ID"]
    }
  }]
}
EOF
)
fi

# API endpoint for querying - use generateContent with gemini-2.5-flash
QUERY_ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${API_KEY}"

# Make query request
info "Sending query to Gemini API..."
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST \
  "$QUERY_ENDPOINT" \
  -H "Content-Type: application/json" \
  -d "$REQUEST_BODY")

# Split response and HTTP code
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
RESPONSE_BODY=$(echo "$RESPONSE" | sed '$d')

# Check HTTP status
if [ "$HTTP_CODE" != "200" ]; then
    error_exit "API request failed with HTTP $HTTP_CODE\nResponse: $RESPONSE_BODY"
fi

# Pretty print the full response
echo "$RESPONSE_BODY" | jq '.'

# Extract and display key information
echo ""
info "=== Query Results ==="

# Extract the answer text
ANSWER=$(echo "$RESPONSE_BODY" | jq -r '.candidates[0].content.parts[0].text' 2>/dev/null || echo "")

if [ -z "$ANSWER" ] || [ "$ANSWER" = "null" ]; then
    warn "No answer generated for this query"
else
    echo -e "${CYAN}=== Answer ===${NC}"
    echo "$ANSWER"
    echo ""

    # Extract grounding metadata (sources)
    info "=== Sources Used ==="

    # Check if grounding chunks exist
    CHUNK_COUNT=$(echo "$RESPONSE_BODY" | jq '.candidates[0].groundingMetadata.groundingChunks | length' 2>/dev/null || echo "0")

    if [ "$CHUNK_COUNT" = "0" ] || [ "$CHUNK_COUNT" = "null" ]; then
        warn "No grounding sources found"
    else
        info "Used $CHUNK_COUNT source chunk(s)"
        echo ""

        # Display source documents
        echo "$RESPONSE_BODY" | jq -r '.candidates[0].groundingMetadata.groundingChunks[].retrievedContext.title' 2>/dev/null | sort -u | while read -r SOURCE; do
            if [ -n "$SOURCE" ] && [ "$SOURCE" != "null" ]; then
                echo -e "${BLUE}• ${NC}$SOURCE"
            fi
        done

        echo ""
        echo ""
        info "=== Detailed Source Excerpts (with Study Links & Citations) ==="
        echo ""

        # Display each grounding chunk with full text
        for i in $(seq 0 $((CHUNK_COUNT - 1))); do
            echo -e "${CYAN}=== Source Chunk $((i + 1)) ===${NC}"

            # Extract source file
            SOURCE=$(echo "$RESPONSE_BODY" | jq -r ".candidates[0].groundingMetadata.groundingChunks[$i].retrievedContext.title" 2>/dev/null || echo "Unknown")

            # Extract full text (includes study links, doses, claims, etc.)
            CHUNK_TEXT=$(echo "$RESPONSE_BODY" | jq -r ".candidates[0].groundingMetadata.groundingChunks[$i].retrievedContext.text" 2>/dev/null || echo "")

            echo -e "${BLUE}Source File:${NC} $SOURCE"
            echo ""

            if [ -n "$CHUNK_TEXT" ] && [ "$CHUNK_TEXT" != "null" ]; then
                echo "$CHUNK_TEXT"
            else
                warn "No text content in this chunk"
            fi

            echo ""
            echo -e "${BLUE}────────────────────────────────────────────────────────────────${NC}"
            echo ""
        done
    fi
fi
