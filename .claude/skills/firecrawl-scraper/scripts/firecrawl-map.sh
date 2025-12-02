#!/bin/bash

# Firecrawl Map - Discover URLs on a website
# Usage: ./firecrawl-map.sh "https://example.com" [search_term] [limit]
# Example: ./firecrawl-map.sh "https://firecrawl.dev" "docs" 50

if [ $# -lt 1 ]; then
    echo "Usage: $0 <url> [search_term] [limit]"
    echo "Example: $0 \"https://example.com\" \"blog\" 50"
    echo ""
    echo "Parameters:"
    echo "  url: Website to map (required)"
    echo "  search_term: Filter URLs containing this term (optional)"
    echo "  limit: Maximum URLs to return (optional, default: 5000)"
    exit 1
fi

# Firecrawl API credentials
API_KEY="fc-cd7004139b5f40fd8ea663beb0c22972"
ENDPOINT="https://api.firecrawl.dev/v2/map"

# Parameters
URL="$1"
SEARCH_TERM="${2:-}"
LIMIT="${3:-5000}"

echo "🗺️  Firecrawl Map"
echo "🌐 URL: $URL"
[ -n "$SEARCH_TERM" ] && echo "🔍 Search filter: $SEARCH_TERM"
echo "📊 Limit: $LIMIT"
echo ""

# Build JSON payload
if [ -n "$SEARCH_TERM" ]; then
    PAYLOAD=$(cat <<EOF
{
  "url": "$URL",
  "search": "$SEARCH_TERM",
  "limit": $LIMIT
}
EOF
)
else
    PAYLOAD=$(cat <<EOF
{
  "url": "$URL",
  "limit": $LIMIT
}
EOF
)
fi

# Make API request
curl -s -X POST "$ENDPOINT" \
    -H "Authorization: Bearer $API_KEY" \
    -H "Content-Type: application/json" \
    -d "$PAYLOAD" | jq -r '
if .success == true then
    "=== DISCOVERED URLS ===\n",
    (.links | length | "Found \(.) URLs\n"),
    "\n",
    (.links[] | "• \(.url)")
else
    "❌ Error: " + (.error // "Unknown error")
end
'

echo ""
echo "✅ Map complete"
