#!/bin/bash

# DataForSEO Keyword Suggestions Script
# Returns keyword suggestions that CONTAIN your seed keyword WITH search volume
# Uses DataForSEO Labs database for keyword expansion
#
# Usage: ./dataforseo-suggestions.sh "keyword" "language_code" "location" [limit]
# Example: ./dataforseo-suggestions.sh "sleep supplement" "en" "United States" 20
#
# Returns: keyword, search_volume, cpc, competition

# Check minimum arguments
if [ $# -lt 3 ]; then
    echo "Usage: $0 \"keyword\" \"language_code\" \"location\" [limit]"
    echo "Example: $0 \"sleep supplement\" \"en\" \"United States\" 20"
    exit 1
fi

# DataForSEO API credentials
USERNAME="david@david-peralta.com"
PASSWORD="98fc1f9a4b87e200"

# Parameters
KEYWORD="$1"
LANGUAGE_CODE="$2"
LOCATION="$3"
LIMIT="${4:-20}"  # Default to 20 results

# API endpoint (using .ai for token optimization)
ENDPOINT="https://api.dataforseo.com/v3/dataforseo_labs/google/keyword_suggestions/live.ai"

# Request payload
PAYLOAD="[{
    \"keyword\": \"$KEYWORD\",
    \"language_code\": \"$LANGUAGE_CODE\",
    \"location_name\": \"$LOCATION\",
    \"include_seed_keyword\": true,
    \"limit\": $LIMIT,
    \"order_by\": [\"keyword_info.search_volume,desc\"]
}]"

echo "🔍 Fetching keyword suggestions for: \"$KEYWORD\""
echo "📍 Location: $LOCATION | Language: $LANGUAGE_CODE | Limit: $LIMIT"
echo ""
echo "KEYWORD | VOLUME | CPC | COMPETITION"
echo "--------|--------|-----|------------"

# Make the API request and format results
# .ai endpoint returns flatter structure: .items[] directly
curl -s -u "$USERNAME:$PASSWORD" \
    -H "Content-Type: application/json" \
    -X POST \
    -d "$PAYLOAD" \
    "$ENDPOINT" | \
jq -r '
.items // [] |
.[] |
"\(.keyword) | \(.keyword_info.search_volume // 0) | $\(.keyword_info.cpc // 0 | . * 100 | floor / 100) | \(.keyword_info.competition // 0 | . * 100 | floor)%"
'

echo ""
echo "✅ Keyword suggestions with volume retrieved."
