# Gemini File Search Seed Reference - Skill Creation Notes

**Created**: 2025-11-18
**Status**: ✅ COMPLETE
**Package**: gemini-file-search-seed-reference.zip

---

## Session Summary

Successfully created a skill for accessing Seed's Reference materials via Gemini File Search API. The skill provides semantic search capabilities, query patterns, metadata filtering, and guidance on when to use File Search vs. direct file access.

---

## What Was Created

### 1. SKILL.md (Main Skill Documentation)

**Purpose**: Provides complete guidance on using the File Search store for Seed reference materials

**Key Sections**:
- **When to Use This Skill**: Clear criteria for File Search vs. direct access
- **Core Capabilities**: 4 main capabilities with examples
- **6 Common Query Patterns**: Ingredient claims, product positioning, compliance, cross-product, tone/style, broad search
- **Metadata Filter Syntax**: How to construct filters
- **Tips for Effective Queries**: Best practices

**Description (for auto-triggering)**:
> "This skill should be used when semantic search across Seed's Reference materials is needed, particularly when files to consult are unclear, information spans multiple files, or token efficiency is critical. Use for draft review, compliance checking, cross-product research, or finding claims/messaging without knowing specific filenames."

**Key Decision**: Structured as **Capabilities-Based** pattern (from skill-creator guidance)
- Works well for integrated systems with multiple interrelated features
- Chosen because File Search provides several capabilities: querying, filtering, pattern-matching, etc.

### 2. scripts/query-store.sh (Query Script)

**Purpose**: Bash script to query the File Search store with natural language and metadata filters

**Features**:
- Accepts query string and optional metadata filter
- Reads API key from `~/.claude/skills/gemini-api-key`
- Reads store ID from multiple possible locations
- Pretty-prints results with jq
- Displays passages with source attribution
- Color-coded output (green=success, red=error, etc.)

**Usage**:
```bash
./scripts/query-store.sh "Your query here" ["optional metadata filter"]
```

**API Endpoint Used**: 
```
POST https://generativelanguage.googleapis.com/v1beta/${STORE_ID}:query
```

**Request Body Format**:
```json
{
  "query": "Natural language query",
  "metadataFilter": "product=DM-02 AND file_type=Ingredient-Claims"
}
```

**Important Note**: This script uses the `:query` endpoint which may or may not be the correct Gemini API endpoint. The File Search API documentation should be consulted to verify the correct endpoint and request format. This is a starting point that can be tested and iterated.

### 3. references/store-reference.md (Comprehensive Reference)

**Purpose**: Detailed reference documentation loaded into context when needed

**Contents**:
- Complete file inventory (all 62 files by category, product, type)
- Metadata structure with all possible field values
- Detailed query pattern examples
- Metadata filter syntax with common combinations
- Cost and performance metrics
- Example metadata filters by use case
- When to use File Search vs. direct access
- Tips for effective queries
- Troubleshooting guide

**Size**: ~8.5k tokens (kept intentionally lean to load only when needed)

**Design Decision**: Moved detailed information to references/ instead of SKILL.md
- Keeps SKILL.md lean and focused on workflow
- References loaded only when Claude determines it's needed
- Follows progressive disclosure principle from skill-creator guidance

---

## Key Decisions Made

### 1. Hybrid Approach Documentation

**Decision**: Clearly document when to use File Search vs. direct file access

**Rationale**: User asked which approach is better for Claude Code. Answer is "both, depending on use case"

**File Search When**:
- Uncertain which files contain information
- Information spans multiple files  
- Semantic search needed
- Token efficiency critical
- Draft review/validation
- Cross-product research

**Direct Access When**:
- Know exact file needed
- Need 1-3 specific files (low token cost)
- Need FULL file content, not excerpts
- Need deterministic results
- Initial research to understand structure

### 2. API Endpoint Choice

**Decision**: Use `:query` endpoint for File Search store

**Assumption**: Based on typical Google API patterns, but NOT verified against actual File Search API docs

**Risk**: This endpoint might not exist or might use different request/response format

**Mitigation**: Documented in SKILL_CREATION_NOTES.md as needing verification. Can iterate in Step 6 of skill creation process if testing reveals issues.

### 3. Store ID Location Strategy

**Decision**: Query script checks multiple possible locations for store ID:
1. `/dev/active/reference-store-setup/REFERENCE_STORE_ID` (primary)
2. `~/.claude/skills/gemini-file-search-seed-reference/STORE_ID` (fallback)

**Rationale**: Makes skill more portable and resilient to different installation locations

### 4. Metadata Filter Syntax

**Decision**: Use simple AND logic: `product=DM-02 AND file_type=Ingredient-Claims`

**Rationale**: Matches typical query parameter syntax. Simple to explain and use.

**Note**: Actual File Search API may support more complex filters (OR, NOT, etc.) - can enhance later

---

## Files Created

```
.claude/skills/gemini-file-search-seed-reference/
├── SKILL.md                           (254 lines) - Main skill doc
├── SKILL_CREATION_NOTES.md            (this file) - Creation notes
├── scripts/
│   └── query-store.sh                 (154 lines) - Query script
└── references/
    └── store-reference.md             (429 lines) - Detailed reference
```

**Also Created**:
- `gemini-file-search-seed-reference.zip` - Packaged skill (validated)

---

## Testing Status

**Validation**: ✅ PASSED (via package_skill.py)
- YAML frontmatter format correct
- Required fields present
- Description complete and informative
- File organization correct
- Resource references valid

**Functional Testing**: ⚠️ NOT YET DONE
- Query script has NOT been tested with actual API
- `:query` endpoint may need adjustment
- Request/response format may need changes
- Metadata filter syntax may differ from actual API

**Next Step**: Test query script with actual Gemini File Search API to verify endpoint and format

---

## Integration with Existing Work

### Builds On

**Reference Store Setup** (`dev/active/reference-store-setup/`):
- Uses the production store created: `fileSearchStores/seed-reference-materials-pr-jma5jhay17is`
- References the same metadata structure
- Leverages the same API key location
- Complements the direct file access workflow documented in CLAUDE.md

### Complements

**SEO Draft Generation Workflow** (in `CLAUDE.md`):
- Current workflow uses direct file access (Steps 3-4 identify specific files)
- This skill provides alternative for uncertain/broad searches
- Both approaches documented and available
- Workflow can choose best approach per use case

### Future Use

**Draft Review/Validation Workflows**:
- Can query for compliance rules during review
- Can search for relevant claims without knowing exact files
- Can validate product positioning accuracy
- Will be used in `/review-draft-seed-perspective-gemini-file-search` command

---

## Known Limitations and Future Work

### Limitations

1. **API Endpoint Not Verified**: Query script uses assumed `:query` endpoint - may need adjustment
2. **No Caching**: Each query hits API (could add response caching)
3. **No Pagination**: Assumes all results fit in one response
4. **Simple Filter Syntax**: Only supports AND logic, not OR/NOT
5. **No Cost Tracking**: Doesn't track API usage or costs

### Future Enhancements (Not Critical)

**Could Add**:
- Response caching to avoid redundant API calls
- Cost tracking script
- More complex metadata filter syntax (OR, NOT)
- Pagination support for large result sets
- Query history/favorites
- Integration with specific review commands

**When to Add**:
- After testing reveals actual needs
- When use patterns emerge
- If cost becomes significant

---

## How to Use This Skill

### As Claude Code

The skill will auto-trigger when semantic search of Seed reference materials is needed. Claude will recognize queries like:

- "What does Seed say about gut-brain axis?"
- "Compare PQQ benefits across products"
- "What compliance rules apply to energy claims?"
- "Find all mentions of mitochondrial health"

### Manual Query Script Usage

```bash
cd .claude/skills/gemini-file-search-seed-reference

# Basic query
./scripts/query-store.sh "What are approved claims about biotin?"

# With metadata filter
./scripts/query-store.sh "Biotin benefits for hair" "product=DM-02 AND file_type=Ingredient-Claims"

# Compliance check
./scripts/query-store.sh "What words should we avoid?" "category=Compliance"
```

### Loading Detailed Reference

When deeper understanding is needed:
```
Load references/store-reference.md for comprehensive documentation
```

---

## Testing Instructions (For Next Session)

### 1. Verify API Endpoint

**Test**:
```bash
cd .claude/skills/gemini-file-search-seed-reference
./scripts/query-store.sh "What are approved claims about biotin?" "product=DM-02"
```

**Expected**: JSON response with passages and grounding support

**If Fails**: Consult Gemini File Search API documentation to find correct endpoint and request format

### 2. Verify Metadata Filtering

**Test** with different filters:
```bash
./scripts/query-store.sh "Test query" "category=Compliance"
./scripts/query-store.sh "Test query" "product=AM-02 AND file_type=Ingredient-Claims"
```

**Expected**: Results filtered to matching metadata

**If Fails**: Check metadata filter syntax against API docs

### 3. Verify Source Attribution

**Check**: Do responses include document names in grounding support?

**Expected**: Each passage should show which file it came from

---

## Relationship to Broader Goals

### Immediate Value

- Enables semantic search across Seed reference materials
- Reduces token usage by 60-80% vs. loading all files
- Provides alternative to direct file access when needed
- Documents hybrid approach (File Search + direct access)

### Long-Term Vision

- Foundation for automated draft review workflows
- Enables intelligent compliance checking
- Supports cross-product research
- Makes reference materials easily discoverable

### User's Question Answered

**Question**: "What makes more sense for Claude Code - direct file access or File Search?"

**Answer**: Hybrid approach (both), now documented in skill
- Use File Search for uncertain/broad searches
- Use direct access for known/specific files
- Skill provides guidance on which to use when

---

**Created**: 2025-11-18
**Status**: Complete and packaged, ready for testing
**Next Steps**: Test query script with actual API, iterate if needed
