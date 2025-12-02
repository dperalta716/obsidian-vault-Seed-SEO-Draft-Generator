#!/bin/bash

# Firecrawl Crawl - Multi-page content extraction
# Usage: ./firecrawl-crawl.sh "https://example.com" [limit] [maxDepth]
# Example: ./firecrawl-crawl.sh "https://firecrawl.dev/blog" 10 0

if [ $# -lt 1 ]; then
    echo "Usage: $0 <url> [limit] [maxDepth]"
    echo "Example: $0 \"https://example.com/blog\" 10 0"
    echo ""
    echo "Parameters:"
    echo "  url: Starting URL to crawl (required)"
    echo "  limit: Max pages to crawl (default: 10, max: 10000)"
    echo "  maxDepth: Discovery depth - 0=sitemap only (default: 0)"
    echo ""
    echo "⚠️  IMPORTANT: Start with limit=10 and maxDepth=0 for safety!"
    echo "   Large crawls can take minutes and cost many tokens."
    exit 1
fi

# Firecrawl API credentials
API_KEY="fc-cd7004139b5f40fd8ea663beb0c22972"
ENDPOINT="https://api.firecrawl.dev/v2/crawl"

# Parameters
URL="$1"
LIMIT="${2:-10}"
MAX_DEPTH="${3:-0}"

echo "🕷️  Firecrawl Crawl (Async)"
echo "🌐 URL: $URL"
echo "📊 Limit: $LIMIT pages"
echo "🔍 Max depth: $MAX_DEPTH"
echo ""
echo "⏳ Starting crawl job..."

# Build JSON payload
PAYLOAD=$(cat <<EOF
{
  "url": "$URL",
  "limit": $LIMIT,
  "scrapeOptions": {
    "formats": ["markdown"],
    "onlyMainContent": true
  }
}
EOF
)

# Make API request
RESPONSE=$(curl -s -X POST "$ENDPOINT" \
    -H "Authorization: Bearer $API_KEY" \
    -H "Content-Type: application/json" \
    -d "$PAYLOAD")

# Extract job ID and display instructions
echo "$RESPONSE" | jq -r '
if .success == true then
    "✅ Crawl job started successfully!\n",
    "📋 Job ID: \(.id)\n",
    "\n",
    "To check status, run:",
    "  ./firecrawl-crawl-status.sh \(.id)\n",
    "\nThe crawl is running in the background. Check status in 30-60 seconds."
else
    "❌ Error: " + (.error // "Unknown error")
end
'
