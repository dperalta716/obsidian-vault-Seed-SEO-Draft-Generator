#!/bin/bash

# Helper functions for building Google Docs batchUpdate requests

# Insert text request
build_insert_text_request() {
  local TEXT="$1"
  local INDEX="$2"

  jq -n \
    --arg text "$TEXT" \
    --argjson index "$INDEX" \
    '{
      insertText: {
        text: $text,
        location: {index: $index}
      }
    }'
}

# Delete content range request
build_delete_content_request() {
  local START_INDEX="$1"
  local END_INDEX="$2"

  jq -n \
    --argjson start "$START_INDEX" \
    --argjson end "$END_INDEX" \
    '{
      deleteContentRange: {
        range: {
          startIndex: $start,
          endIndex: $end
        }
      }
    }'
}

# Replace all text request (find and replace)
build_replace_all_text_request() {
  local FIND="$1"
  local REPLACE="$2"
  local MATCH_CASE="${3:-false}"

  jq -n \
    --arg find "$FIND" \
    --arg replace "$REPLACE" \
    --argjson matchCase "$MATCH_CASE" \
    '{
      replaceAllText: {
        containsText: {
          text: $find,
          matchCase: $matchCase
        },
        replaceText: $replace
      }
    }'
}

# Insert table request
build_insert_table_request() {
  local ROWS="$1"
  local COLS="$2"
  local INDEX="$3"

  jq -n \
    --argjson rows "$ROWS" \
    --argjson cols "$COLS" \
    --argjson index "$INDEX" \
    '{
      insertTable: {
        rows: $rows,
        columns: $cols,
        location: {index: $index}
      }
    }'
}

# Insert table row request
build_insert_table_row_request() {
  local TABLE_START_INDEX="$1"
  local ROW_INDEX="$2"
  local INSERT_BELOW="${3:-true}"

  jq -n \
    --argjson tableStart "$TABLE_START_INDEX" \
    --argjson rowIndex "$ROW_INDEX" \
    --argjson insertBelow "$INSERT_BELOW" \
    '{
      insertTableRow: {
        tableCellLocation: {
          tableStartLocation: {index: $tableStart},
          rowIndex: $rowIndex,
          columnIndex: 0
        },
        insertBelow: $insertBelow
      }
    }'
}

# Update text style request
build_update_text_style_request() {
  local START_INDEX="$1"
  local END_INDEX="$2"
  local BOLD="${3:-null}"
  local ITALIC="${4:-null}"
  local FONT_SIZE="${5:-null}"
  local FONT_FAMILY="${6:-null}"

  local STYLE=$(jq -n \
    --argjson bold "$BOLD" \
    --argjson italic "$ITALIC" \
    --argjson fontSize "$FONT_SIZE" \
    --arg fontFamily "$FONT_FAMILY" \
    '{
      bold: $bold,
      italic: $italic
    } + (if $fontSize != null then {fontSize: {magnitude: $fontSize, unit: "PT"}} else {} end) + (if $fontFamily != "" and $fontFamily != "null" then {fontFamily: $fontFamily} else {} end)')

  local FIELDS="bold,italic"
  [[ "$FONT_SIZE" != "null" ]] && FIELDS+=",fontSize"
  [[ "$FONT_FAMILY" != "null" && -n "$FONT_FAMILY" ]] && FIELDS+=",weightedFontFamily"

  jq -n \
    --argjson start "$START_INDEX" \
    --argjson end "$END_INDEX" \
    --argjson style "$STYLE" \
    --arg fields "$FIELDS" \
    '{
      updateTextStyle: {
        range: {
          startIndex: $start,
          endIndex: $end
        },
        textStyle: $style,
        fields: $fields
      }
    }'
}

# Update paragraph style request
build_update_paragraph_style_request() {
  local START_INDEX="$1"
  local END_INDEX="$2"
  local ALIGNMENT="${3:-null}"
  local SPACING_MODE="${4:-null}"

  local STYLE="{}"
  local FIELDS=""

  if [[ "$ALIGNMENT" != "null" && -n "$ALIGNMENT" ]]; then
    STYLE=$(echo "$STYLE" | jq --arg align "$ALIGNMENT" '. + {alignment: $align}')
    FIELDS="alignment"
  fi

  if [[ "$SPACING_MODE" != "null" && -n "$SPACING_MODE" ]]; then
    STYLE=$(echo "$STYLE" | jq --arg spacing "$SPACING_MODE" '. + {spacingMode: $spacing}')
    [[ -n "$FIELDS" ]] && FIELDS+=","
    FIELDS+="spacingMode"
  fi

  jq -n \
    --argjson start "$START_INDEX" \
    --argjson end "$END_INDEX" \
    --argjson style "$STYLE" \
    --arg fields "$FIELDS" \
    '{
      updateParagraphStyle: {
        range: {
          startIndex: $start,
          endIndex: $end
        },
        paragraphStyle: $style,
        fields: $fields
      }
    }'
}

# Insert inline image request
build_insert_inline_image_request() {
  local IMAGE_URI="$1"
  local INDEX="$2"
  local WIDTH="${3:-null}"
  local HEIGHT="${4:-null}"

  local SIZE_SPEC="{}"
  if [[ "$WIDTH" != "null" && "$HEIGHT" != "null" ]]; then
    SIZE_SPEC=$(jq -n \
      --argjson width "$WIDTH" \
      --argjson height "$HEIGHT" \
      '{width: {magnitude: $width, unit: "PT"}, height: {magnitude: $height, unit: "PT"}}')
  fi

  jq -n \
    --arg uri "$IMAGE_URI" \
    --argjson index "$INDEX" \
    --argjson size "$SIZE_SPEC" \
    '{
      insertInlineImage: {
        uri: $uri,
        location: {index: $index}
      }
    } + (if ($size | length) > 0 then {insertInlineImage: (.insertInlineImage + {objectSize: $size})} else {} end)'
}

# Insert page break request
build_insert_page_break_request() {
  local INDEX="$1"

  jq -n \
    --argjson index "$INDEX" \
    '{
      insertPageBreak: {
        location: {index: $index}
      }
    }'
}
