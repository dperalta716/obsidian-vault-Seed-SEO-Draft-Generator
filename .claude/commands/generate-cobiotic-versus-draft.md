# generate-cobiotic-versus-draft

Generate a complete Cobiotic competitor comparison article draft using Gemini 3 Pro Preview, save to the Drafts folder, and optionally upload to Google Docs.

## Usage

```
/generate-cobiotic-versus-draft <product> "<keyword>"
```

## Parameters

- `product` (required): Product code - `dm02`, `pm02`, or `am02`
- `keyword` (required): The competitor comparison keyword in quotes

## Examples

```
/generate-cobiotic-versus-draft dm02 "Metagenics vs Pure Encapsulations multivitamin"
/generate-cobiotic-versus-draft dm02 "Ritual vs Thorne multivitamin"
/generate-cobiotic-versus-draft pm02 "Natrol vs Olly sleep supplement"  (future)
/generate-cobiotic-versus-draft am02 "Thesis vs Qualia nootropic"       (future)
```

## Workflow

When this command is invoked:

### STEP 1: VALIDATE INPUTS

1. **Validate product code**: Must be `dm02`, `pm02`, or `am02`
   - Currently only `dm02` is supported
   - If `pm02` or `am02` is requested, inform user that skill is not yet available

2. **Validate keyword format**: Should contain "vs" or "versus"
   - Warn if format seems incorrect but proceed if user confirms

### STEP 2: DETERMINE SKILL PATH

Based on the product code, construct the skill path:

```bash
PRODUCT="$1"  # dm02, pm02, or am02
SKILL_DIR="/Users/david/Documents/Obsidian Vaults/claude-code-demo/.claude/skills/gemini-${PRODUCT}-draft"
SCRIPT_PATH="${SKILL_DIR}/scripts/gemini-generate.sh"
```

Verify the skill exists before proceeding.

### STEP 3: DETERMINE NEXT FOLDER NUMBER

Scan the `Drafts - NPD vs Competitor/` directory for the next available number:

```bash
DRAFTS_DIR="Drafts - NPD vs Competitor"

# Find highest existing folder number (format: NNN - Name)
HIGHEST=$(ls -1 "$DRAFTS_DIR" 2>/dev/null | grep -E '^[0-9]{3}' | sed 's/^\([0-9]\{3\}\).*/\1/' | sort -n | tail -1)

# If no folders exist, start at 001
if [ -z "$HIGHEST" ]; then
  NEXT="001"
else
  NEXT=$(printf "%03d" $((10#$HIGHEST + 1)))
fi
```

### STEP 4: CREATE KEYWORD SLUG

Convert the keyword to a URL-friendly slug:

```bash
# Convert to lowercase, replace "vs" with "-vs-", replace spaces with hyphens
SLUG=$(echo "$KEYWORD" | tr '[:upper:]' '[:lower:]' | sed 's/ vs /-vs-/g' | tr ' ' '-' | tr -cd 'a-z0-9-')
```

Example: "Metagenics vs Pure Encapsulations multivitamin" → "metagenics-vs-pure-encapsulations-multivitamin"

### STEP 5: CREATE DRAFT FOLDER

Create the numbered folder:

```bash
# Create title case version for folder name (simplified - just use the keyword)
FOLDER_NAME="${NEXT} - ${KEYWORD_TITLE}"
mkdir -p "Drafts - NPD vs Competitor/${FOLDER_NAME}"
```

Example: `003 - Metagenics vs Pure Encapsulations/`

### STEP 6: CALL GEMINI SKILL

Execute the skill script:

```bash
RESULT=$("${SCRIPT_PATH}" "${KEYWORD}")
```

Parse the JSON response:
- Check `success` field
- If `false`, report error and stop
- If `true`, extract `article` content and `word_count`

**Important**: This step may take 1-3 minutes due to Gemini's thinking process and grounding searches.

### STEP 7: FORMAT AND SAVE DRAFT

If generation successful:

1. **Add metadata header** to ensure upload compatibility:
```markdown
**Primary keyword:** {keyword}

{rest of generated article content}
```

2. **Save to file**:
```bash
FILE_PATH="Drafts - NPD vs Competitor/${FOLDER_NAME}/v1-${SLUG}.md"
```

### STEP 8: REPORT SUCCESS

Display to user:
- ✅ Folder created: `Drafts - NPD vs Competitor/[NNN] - [Keyword]/`
- ✅ File saved: `v1-[slug].md`
- 📊 Word count: [N] words
- ⏰ Generated at: [timestamp]

### STEP 9: OFFER GOOGLE DOCS UPLOAD

Ask: "Would you like me to upload this draft to Google Docs?"

If yes, invoke:
```
/upload-to-gdocs-v3 "Drafts - NPD vs Competitor/${FOLDER_NAME}/v1-${SLUG}.md"
```

This uploads to:
- **Folder**: NPD Drafts (`1JWFAoYKwsD2zTtypjs2gb34F0jAvv2bD`)
- **Spreadsheet**: Phase 2 Tracking (`1VMNPMKCFG6an5UpteL5aUtm-VLgFgrSOFZDZE6h1ig8`)

## Error Handling

| Error | Action |
|-------|--------|
| Invalid product code | List valid options, ask to retry |
| Skill not found | Inform user skill not yet created |
| API failure | Report error, suggest retry |
| Empty generation | Report, suggest different keyword |
| Folder creation fails | Report filesystem error |

## Supported Products

| Product | Status | Skill |
|---------|--------|-------|
| `dm02` | ✅ Ready | `gemini-dm02-draft` |
| `pm02` | 🔜 Coming | `gemini-pm02-draft` |
| `am02` | 🔜 Coming | `gemini-am02-draft` |

## Notes

- Generation takes 1-3 minutes (Gemini thinking + grounding)
- Gemini uses real-time Google Search for current competitor info
- Articles follow mandatory comparison structure from system instructions
- Draft includes `**Primary keyword:**` line for upload compatibility
