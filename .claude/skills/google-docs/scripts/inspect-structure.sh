#!/bin/bash

# Inspect Google Doc structure to find safe insertion points and understand layout
# Usage: ./inspect-structure.sh "user@example.com" "document_id" [detailed]

set -euo pipefail

USER_EMAIL="$1"
DOCUMENT_ID="$2"
DETAILED="${3:-false}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Get document
RESPONSE=$(curl -s \
  "https://docs.googleapis.com/v1/documents/${DOCUMENT_ID}" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}")

# Check for errors
if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
  echo "$RESPONSE" | jq '.error' >&2
  exit 1
fi

if [[ "$DETAILED" == "true" ]]; then
  # Return full structure
  echo "$RESPONSE" | jq '.'
else
  # Return summary with key structural information
  echo "$RESPONSE" | jq '{
    documentId,
    title,
    body: {
      content: [.body.content[] | {
        startIndex,
        endIndex,
        type: (
          if .paragraph then "paragraph"
          elif .table then "table"
          elif .sectionBreak then "sectionBreak"
          elif .tableOfContents then "tableOfContents"
          else "unknown"
          end
        ),
        details: (
          if .table then {
            rows: (.table.rows | length),
            columns: (.table.rows[0].tableCells | length),
            tableRows: [.table.rows[] | {
              startIndex: .startIndex,
              endIndex: .endIndex,
              cells: [.tableCells[] | {
                startIndex: .startIndex,
                endIndex: .endIndex
              }]
            }]
          }
          elif .paragraph then {
            elements: [.paragraph.elements[] | {
              startIndex: .startIndex,
              endIndex: .endIndex,
              textRun: .textRun.content
            }]
          }
          else null
          end
        )
      }]
    }
  }'
fi
