# Reference Store Setup - Context & Reference

**Last Updated**: 2025-11-18
**Status**: ✅ COMPLETED
**Session**: Implementation completed in single session on 2025-11-18

---

## Project Status: COMPLETE ✅

### Implementation Summary
Successfully created Google File Search store and uploaded all 62 Reference folder markdown files with structured metadata. All objectives achieved with 100% success rate.

**Store ID**: `fileSearchStores/seed-reference-materials-pr-jma5jhay17is`
**Files Uploaded**: 62/62 (100% success)
**Upload Duration**: 274 seconds (4 min 34 sec)
**Size**: 685 KB
**Cost**: ~$0.053 one-time indexing

---

## Project Context

### Purpose
Create a Google File Search store containing all 62 markdown files from the Reference/ directory with structured metadata for semantic retrieval. This is a focused, one-time setup task that creates the foundation for future AI-powered workflows.

### Scope
**Completed**:
- ✅ Created production File Search store
- ✅ Uploaded all 62 Reference folder files
- ✅ Added structured metadata (category, product, file_type, relative_path) to every file
- ✅ Validated upload success (62/62 active documents, 0 failed)
- ✅ Documented store details in STORE_SUMMARY.md
- ✅ Updated project CLAUDE.md with store reference

**Out of Scope** (Future Work):
- Integration with `/review-draft-seed-perspective` command (separate project in `dev/active/gemini-file-search-integration/`)
- Query optimization and testing (minimal testing done)
- Re-indexing workflows (documented in STORE_SUMMARY.md)
- Advanced features (caching, versioning, etc.)

### Difference from Broader Integration Project

**This Project** (`reference-store-setup`):
- Focus: Create the store and upload files
- Timeline: 4-6 hours over 1-2 days
- Deliverable: Working File Search store with all Reference files
- Scripts: 3 bash scripts (create, upload, bulk-upload)

**Broader Project** (`gemini-file-search-integration`):
- Focus: Full integration with review command
- Timeline: 10-11 days (3 phases)
- Deliverable: Complete workflow replacement with File Search
- Scripts: 9 bash scripts + new command + skill documentation

---

## Key Files & Locations

### Input Files

**Reference Folder**:
```
/Users/david/Documents/Obsidian Vaults/claude-code-demo/Seed-SEO-Draft-Generator-v4/Reference/
```

**Contents** (62 files, 948KB):
```
Reference/
├── Claims/
│   ├── AM-02/ (~15 files)
│   │   ├── AM-02-Cereboost-Claims.md
│   │   ├── AM-02-CoQ10-Claims.md
│   │   ├── AM-02-GABA-Claims.md
│   │   ├── AM-02-General-Claims.md
│   │   ├── AM-02-Niacin-Claims.md
│   │   ├── AM-02-PQQ-Claims.md
│   │   ├── AM-02-Process-Instructions.md
│   │   ├── AM-02-Quercetin-Claims.md
│   │   ├── AM-02-Riboflavin-Claims.md
│   │   ├── AM-02-Theacrine-Claims.md
│   │   ├── AM-02-Thiamine-Claims.md
│   │   ├── AM-02-Vitamin-B12-Claims.md
│   │   ├── AM-02-Vitamin-K2-Claims.md
│   │   └── AM-02-Folate-Claims.md
│   ├── DM-02/ (~25 files)
│   │   ├── DM-02-Biotin-Claims.md
│   │   ├── DM-02-Chromium-Claims.md
│   │   ├── DM-02-CoQ10-Claims.md
│   │   ├── DM-02-Copper-Claims.md
│   │   ├── DM-02-Folate-Claims.md
│   │   ├── DM-02-General-Claims.md
│   │   ├── DM-02-Iodine-Claims.md
│   │   ├── DM-02-Key-Benefits-Claims.md
│   │   ├── DM-02-Manganese-Claims.md
│   │   ├── DM-02-Molybdenum-Claims.md
│   │   ├── DM-02-Niacin-Claims.md
│   │   ├── DM-02-Pantothenic-Acid-Claims.md
│   │   ├── DM-02-PQQ-Claims.md
│   │   ├── DM-02-Riboflavin-Claims.md
│   │   ├── DM-02-Selenium-Claims.md
│   │   ├── DM-02-Thiamine-Claims.md
│   │   ├── DM-02-Vitamin-A-Claims.md
│   │   ├── DM-02-Vitamin-B12-Claims.md
│   │   ├── DM-02-Vitamin-B6-Claims.md
│   │   ├── DM-02-Vitamin-C-Claims.md
│   │   ├── DM-02-Vitamin-D-Claims.md
│   │   ├── DM-02-Vitamin-E-Claims.md
│   │   ├── DM-02-Vitamin-K1-Claims.md
│   │   └── DM-02-Zinc-Claims.md
│   └── PM-02/ (~12 files)
│       ├── PM-02-Formula-Overview.md
│       ├── PM-02-GABA-Claims.md
│       ├── PM-02-General-Claims.md
│       ├── PM-02-Melatonin-Claims.md
│       ├── PM-02-Niacin-Claims.md
│       ├── PM-02-PQQ-Claims.md
│       ├── PM-02-Product-Formulation.md
│       ├── PM-02-Riboflavin-Claims.md
│       ├── PM-02-Shoden-Claims.md
│       └── PM-02-Thiamine-Claims.md
├── NPD-Messaging/ (3 files)
│   ├── AM-02 Product Messaging Reference Documents.md
│   ├── DM-02 Product Messaging Reference Documents.md
│   └── PM-02 Product Messaging Reference Documents.md
├── SciComms Education Files/ (3 files)
│   ├── AM-02 SciComms Gut-Energy Education.md
│   ├── DM-02 Gut-Nutrition Education.md
│   └── PM-02 SciComms Gut-Sleep Education.md
├── Compliance/ (2 files)
│   ├── NO-NO-WORDS.md
│   └── What-We-Are-Not-Allowed-To-Say.md
└── Style/ (5 files)
    ├── 8-Sample-Reference-Blog-Articles.md
    ├── Seed-Tone-of-Voice-and-Structure.md
    ├── Tone-Guide.md
    ├── Tone-Guide-v2.md
    └── Tone-Guide-v2 1.md
```

**Files to SKIP**:
- `*.backup-YYYY-MM-DD` (backup files)
- `*.py` (Python scripts like `update_dm02_links.py`)
- `*.txt` (text files like `extract-hyperlinks-script.txt`)

### Output Files Created

**Project Directory**:
```
dev/active/reference-store-setup/
├── scripts/
│   ├── create-store.sh              ✅ Created, tested, working
│   ├── upload-file.sh               ✅ Created, tested, working
│   └── bulk-upload-reference.sh     ✅ Created, tested, working
├── REFERENCE_STORE_ID               ✅ Contains: fileSearchStores/seed-reference-materials-pr-jma5jhay17is
├── STORE_SUMMARY.md                 ✅ Complete documentation
├── upload-log-20251118-014630.txt   ✅ Full upload log (62/62 success)
├── reference-store-setup-plan.md    ✅ Original plan
├── reference-store-setup-context.md ✅ This file (updated)
└── reference-store-setup-tasks.md   ✅ Task checklist (updated)
```

**Also Updated**:
- `../../../CLAUDE.md` - Added Google File Search Store section

### API Key Storage

**Location**: `~/.claude/skills/gemini-api-key`
**Key**: `AIzaSyDSii2SLQEV4wxRxzfErwp4OSB1T4Y9PXo`
**Tier**: Paid (data NOT used for model training)
**Status**: ✅ Created and verified working

---

## Critical Technical Decisions

### Decision 1: Paid Tier API (LOCKED IN)
**Choice**: Use paid tier Gemini API
**Rationale**: Protects Seed proprietary content from being used for training
**Implications**:
- Data NOT used for model training ✅
- 30-day retention for abuse detection only
- Enterprise-grade privacy protections
- Slightly higher cost (but minimal for this use case)

### Decision 2: Two-Step Resumable Upload (LOCKED IN)
**Choice**: Use Google's resumable upload protocol
**Rationale**: Official API documentation specifies this approach
**Implementation**:
1. Step 1: Initiate upload (POST with headers, get upload URL)
2. Step 2: Upload file bytes to upload URL
**Implications**:
- More complex than simple POST
- More reliable for larger files
- Required by API design

### Decision 3: Metadata Structure (LOCKED IN)
**Choice**: 4 metadata fields per file
**Rationale**: Enables flexible filtering by product, category, and type
**Fields**:
1. `category` - Top-level directory (Claims/NPD-Messaging/SciComms/Compliance/Style)
2. `product` - Product line (AM-02/DM-02/PM-02/Cross-Product/N/A)
3. `file_type` - Specific file purpose (Ingredient-Claims/General-Claims/Messaging/etc.)
4. `relative_path` - Full path from Reference/ directory

**Example**:
```json
[
  {"key": "category", "string_value": "Claims"},
  {"key": "product", "string_value": "DM-02"},
  {"key": "file_type", "string_value": "Ingredient-Claims"},
  {"key": "relative_path", "string_value": "Claims/DM-02/DM-02-Biotin-Claims.md"}
]
```

### Decision 4: Store Naming (LOCKED IN)
**Choice**: "Seed Reference Materials - Production v1"
**Rationale**:
- Descriptive display name for UI
- "Production" indicates primary store
- "v1" allows for future versions if needed
**Implications**:
- Store ID will be auto-generated: `fileSearchStores/xxxxx`
- Display name can be updated later if needed

### Decision 5: Rate Limiting (LOCKED IN)
**Choice**: 2-second delay between file uploads
**Rationale**:
- Prevents API rate limiting
- Ensures reliable uploads
- Minimal impact on total time (62 files × 2s = 2 min)
**Implications**:
- Minimum upload time: ~2 minutes
- Total time: 5-30 minutes (depends on network)

---

## Dependencies

### External Services

**Google Gemini API**:
- Endpoint: `https://generativelanguage.googleapis.com/v1beta/`
- Version: v1beta (subject to change)
- Models: gemini-2.5-flash, gemini-2.5-pro (for queries)
- Authentication: API key via query parameter

**Required APIs**:
- File Search Stores API (create, get, list, delete)
- File Upload API (resumable upload)

### System Requirements

**Tools**:
- bash 4.0+ (scripting)
- curl (HTTP requests)
- jq (JSON parsing)
- file command (MIME type detection)

**Permissions**:
- Read access to Reference/ directory
- Write access to dev/active/reference-store-setup/
- Execute permission for scripts

**Network**:
- Internet connectivity
- Access to Google Cloud endpoints
- No firewall/proxy restrictions

---

## Integration Points

### With Existing System

**Reference Materials**:
- Read-only access to Reference/ directory
- No modifications to existing files
- Files remain in place (uploaded to cloud, not moved)

**Future Integration** (`gemini-file-search-integration`):
- This store will be used by `/review-draft-seed-perspective-gemini-file-search` command
- Store ID will be referenced in that command
- Query scripts from broader integration project will use this store

### With Gemini API

**Authentication Flow**:
1. Read API key from `~/.claude/skills/gemini-api-key`
2. Include in all API calls as `?key=${GEMINI_API_KEY}`

**Upload Flow**:
1. Create store (POST /fileSearchStores)
2. For each file:
   a. Initiate resumable upload (POST with headers)
   b. Extract upload URL from response
   c. Upload file bytes to upload URL
   d. Receive operation response

**Validation Flow**:
1. Get store details (GET /fileSearchStores/{id})
2. Check document counts
3. Test queries (if query script available)

---

## Data Model

### File Search Store Structure

**Store Object**:
```json
{
  "name": "fileSearchStores/abc123xyz",
  "displayName": "Seed Reference Materials - Production v1",
  "createTime": "2025-11-17T...",
  "updateTime": "2025-11-17T...",
  "activeDocumentsCount": 62,
  "pendingDocumentsCount": 0,
  "failedDocumentsCount": 0,
  "sizeBytes": 970000
}
```

### Document Metadata

**Metadata Array Format**:
```json
[
  {"key": "category", "string_value": "Claims"},
  {"key": "product", "string_value": "DM-02"},
  {"key": "file_type", "string_value": "Ingredient-Claims"},
  {"key": "relative_path", "string_value": "Claims/DM-02/DM-02-Biotin-Claims.md"}
]
```

**Metadata Extraction Logic**:

**Category** (from directory path):
```bash
if [[ $path == *"Claims/"* ]]; then category="Claims"
elif [[ $path == *"NPD-Messaging/"* ]]; then category="NPD-Messaging"
elif [[ $path == *"SciComms"* ]]; then category="SciComms"
elif [[ $path == *"Compliance/"* ]]; then category="Compliance"
elif [[ $path == *"Style/"* ]]; then category="Style"
fi
```

**Product** (from filename/path):
```bash
if [[ $filename == *"AM-02"* ]]; then product="AM-02"
elif [[ $filename == *"DM-02"* ]]; then product="DM-02"
elif [[ $filename == *"PM-02"* ]]; then product="PM-02"
elif [[ $filename == *"Cross-Product"* ]]; then product="Cross-Product"
else product="N/A"
fi
```

**File Type** (from filename patterns):
```bash
if [[ $filename == *"-General-Claims.md" ]]; then file_type="General-Claims"
elif [[ $filename =~ -[A-Z][a-z]+-Claims\.md$ ]]; then file_type="Ingredient-Claims"
elif [[ $filename == *"Formula-Overview"* || $filename == *"Product-Formulation"* ]]; then file_type="Formula"
elif [[ $filename == *"Product Messaging"* ]]; then file_type="Messaging"
elif [[ $filename == *"SciComms"* ]]; then file_type="Education"
elif [[ $filename == "NO-NO-WORDS.md" || $filename == *"Not-Allowed"* ]]; then file_type="Compliance"
elif [[ $filename == *"Tone-Guide"* || $filename == *"Tone-of-Voice"* ]]; then file_type="Tone-Guide"
elif [[ $filename == *"Sample"* ]]; then file_type="Sample-Articles"
else file_type="Other"
fi
```

---

## Testing Strategy

### Script Testing

**Unit Tests** (before bulk upload):
1. **create-store.sh**:
   - Test with valid display name
   - Test with special characters in name
   - Verify store ID returned
   - Check error handling for API failures

2. **upload-file.sh**:
   - Test with single small file
   - Test with metadata JSON
   - Test with large file (>100KB)
   - Verify operation response
   - Test error handling (file not found, bad metadata)

3. **bulk-upload-reference.sh**:
   - Dry-run mode with all files
   - Verify metadata extraction for each file
   - Upload 2-3 sample files
   - Check progress display
   - Verify error handling and continuation

### Integration Testing

**End-to-End Flow**:
1. Create test store
2. Upload 5-10 sample files from different categories
3. Verify document count
4. Check metadata in store
5. Delete test store

### Validation Testing

**Post-Upload Checks**:
1. Store shows 62 active documents
2. 0 pending/failed documents
3. Size approximately 948KB
4. Random sample of files queryable
5. Metadata filters work correctly

---

## Privacy & Compliance

### Data Protection

**What Gets Stored**:
- All content from 62 markdown files
- Vectorized embeddings of content
- Metadata (category, product, file_type, relative_path)
- Display names and file names

**Where It's Stored**:
- Google Cloud infrastructure (paid tier)
- Exact location: Not publicly specified
- Retention: Indefinite until manual deletion

**Who Can Access**:
- Only via your API key
- Google engineers for debugging (30-day retention)
- NOT used for model training (paid tier)

### Compliance Checklist

- [x] Paid tier API confirmed (protects IP)
- [ ] Data processing terms reviewed
- [ ] Privacy policy accepted
- [ ] Store deletion process documented
- [ ] Re-indexing procedure defined

---

## Cost Tracking

### One-Time Costs

**Initial Indexing**:
- Volume: ~500k tokens (estimated)
- Rate: $0.15 per 1M tokens
- Cost: 500k × $0.15/1M = **$0.075**

**Total Setup**: ~$0.08 (with overhead)

### Ongoing Costs

**Storage**:
- FREE (948KB << 1GB free tier limit)

**Queries**:
- FREE (queries themselves don't cost)
- Context tokens in responses: $0.075 per 1M input tokens
- Estimated: Minimal (<$0.01 per query)

**Re-indexing** (when files change):
- Only changed files need re-upload
- Cost: Minimal (few files × $0.15/1M tokens)

### Cost Comparison

| Item | This Project | Alternative (Loading Files) |
|------|-------------|---------------------------|
| Setup | $0.08 | $0 |
| Per Query | ~$0.01 | ~$0.30 |
| Storage | FREE | N/A |
| At 100 queries | ~$1.08 | ~$30 |
| At 1000 queries | ~$10.08 | ~$300 |

**Break-even**: After ~4 queries, File Search is cheaper than loading all files

---

## Troubleshooting Guide

### Common Issues

**Issue**: API key not found
**Solution**:
```bash
echo "AIzaSyDSii2SLQEV4wxRxzfErwp4OSB1T4Y9PXo" > ~/.claude/skills/gemini-api-key
chmod 600 ~/.claude/skills/gemini-api-key
```

**Issue**: Upload fails with 400 Bad Request
**Solution**:
1. Check metadata JSON is valid
2. Verify file exists and is readable
3. Check MIME type is supported (text/markdown)
4. Review API error message for details

**Issue**: Upload times out
**Solution**:
1. Check network connectivity
2. Verify file size < 100MB
3. Increase timeout in curl command
4. Retry with exponential backoff

**Issue**: Store shows failed documents
**Solution**:
1. Check upload log for errors
2. Identify failed files
3. Re-upload failed files individually
4. Investigate file-specific issues

**Issue**: Metadata filter returns no results
**Solution**:
1. Verify metadata was uploaded correctly
2. Check filter syntax (exact match required)
3. Try query without filter first
4. Review upload log for metadata

---

## Maintenance Plan

### When Reference Files Change

**Process**:
1. Identify changed/new/deleted files
2. For changed files:
   - Delete old version from store (if API supports)
   - Upload new version with same metadata
3. For new files:
   - Upload with appropriate metadata
4. For deleted files:
   - Remove from store (if API supports)
5. Verify document count is correct
6. Update STORE_SUMMARY.md

**Frequency**: As needed (when Reference folder changes)

### Quarterly Review

**Checklist**:
- [ ] Verify document count still correct
- [ ] Check for failed documents
- [ ] Review storage size
- [ ] Test sample queries
- [ ] Update documentation if needed

---

## Resources

### Documentation

**Official Google Docs**:
- Gemini API Docs: https://ai.google.dev/gemini-api/docs
- File Search Guide: https://ai.google.dev/gemini-api/docs/file-search
- API Reference: https://ai.google.dev/api/file-search/file-search-stores

**Internal Docs**:
- Main CLAUDE.md: Project-level instructions
- Reference folder: Source materials
- Broader integration plan: `dev/active/gemini-file-search-integration/`

### Support

**Google**:
- AI Developer Forum
- Stack Overflow (tag: google-gemini)
- GitHub Issues (for SDK)

**Internal**:
- This context document
- Plan document
- Tasks checklist

---

## Glossary

**File Search Store**: Container for indexed documents with vector embeddings
**Resumable Upload**: Two-step upload process (initiate → upload bytes)
**Metadata Filter**: Query parameter to filter results by custom metadata
**Grounding Metadata**: Citations showing which documents were used in response
**Vector Embedding**: Numerical representation of text for semantic search
**RAG**: Retrieval Augmented Generation - using external documents to enhance LLM responses

---

**Last Review**: 2025-11-17
**Next Review**: After completion

---

## Implementation Notes (Session 2025-11-18)

### Session Summary
Successfully completed entire Reference Store Setup project in single session. All 62 files uploaded with 100% success rate.

### Key Implementation Details

**Critical Bug Fixed in upload-file.sh**:
- Initial API request body format was incorrect
- Original: `{"file": {"displayName": "..."}, "customMetadata": [...]}`
- Corrected: `{"displayName": "...", "customMetadata": [...]}`
- Issue: API rejected the nested `file` object with 400 error
- Fix: Flattened structure to match actual API specification
- Lesson: Test with minimal request first, then add metadata

**Path Resolution Issue in bulk-upload-reference.sh**:
- Initial path calculation wrong (3 levels up instead of 4)
- Script location: `dev/active/reference-store-setup/scripts/`
- Needed 4 levels up to reach project root
- Fixed: `PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"`

**Metadata Extraction Pattern Refinement**:
- Initial regex too strict: `-[A-Z][a-z]+-Claims\.md$`
- Simplified: `*-Claims.md` (after checking specific patterns first)
- Order matters: Check `-General-Claims.md` BEFORE generic `-Claims.md`
- Catches all variations: CoQ10, GABA, B12, Vitamin-K2, etc.

### Performance Observations

**Upload Performance**:
- 62 files in 274 seconds (4 min 34 sec)
- Average: 4.4 seconds per file (including 2-sec rate limit)
- Actual upload: ~2.4 seconds per file
- No timeouts, no retries needed
- 100% success rate on first attempt

**API Behavior**:
- Store creation: <1 second
- Upload Step 1 (initiate): <1 second
- Upload Step 2 (bytes): 1-3 seconds per file
- No rate limit errors with 2-second delay

### Testing Strategy Used

**Incremental Validation**:
1. API key creation and connectivity test
2. create-store.sh with test store
3. upload-file.sh with single file to test store
4. bulk-upload dry-run to preview all metadata
5. Full production upload after all components verified

### Files Created This Session

```
dev/active/reference-store-setup/
├── scripts/
│   ├── create-store.sh              (142 lines)
│   ├── upload-file.sh               (147 lines)
│   └── bulk-upload-reference.sh     (249 lines)
├── REFERENCE_STORE_ID               (1 line - store ID)
├── STORE_SUMMARY.md                 (580 lines - comprehensive docs)
├── upload-log-20251118-014630.txt   (345 lines - full log)
└── reference-store-setup-context.md (this file - updated)
```

**Also Modified**:
- `~/.claude/skills/gemini-api-key` (created)
- `../../../CLAUDE.md` (added File Search Store section)

### Next Steps (Future Sessions)

✅ **This Project**: COMPLETE - No further action needed

**Future Work** (Separate Projects):
1. Integration with review command (`dev/active/gemini-file-search-integration/`)
2. Query script development
3. Quarterly maintenance (verify count, check for failures)
4. Re-index when Reference files change

### Commands to Remember

**Verify Store Health**:
```bash
cd dev/active/reference-store-setup
STORE_NAME=$(cat REFERENCE_STORE_ID)
API_KEY=$(cat ~/.claude/skills/gemini-api-key)
curl -s "https://generativelanguage.googleapis.com/v1beta/${STORE_NAME}?key=${API_KEY}" | jq
```

**Re-upload Single File** (if Reference file changes):
```bash
cd dev/active/reference-store-setup
STORE_NAME=$(cat REFERENCE_STORE_ID)
METADATA='[{"key":"category","string_value":"Claims"}...]'
./scripts/upload-file.sh "$STORE_NAME" "path/to/file.md" "$METADATA"
```

**Re-upload All Files** (if major changes):
```bash
cd dev/active/reference-store-setup
STORE_NAME=$(cat REFERENCE_STORE_ID)
./scripts/bulk-upload-reference.sh "$STORE_NAME"
```

---

**Last Updated**: 2025-11-18
**Implementation Status**: ✅ COMPLETE
**Next Review**: Quarterly maintenance (2026-02-18) or when Reference folder changes

---

## Related Skills Created

### gemini-file-search-seed-reference Skill (2025-11-18)

**Purpose**: Skill for accessing the File Search store via semantic queries

**Location**: `/.claude/skills/gemini-file-search-seed-reference/`

**Contents**:
- `SKILL.md` - Main skill documentation with query patterns
- `scripts/query-store.sh` - Query script for semantic search
- `references/store-reference.md` - Comprehensive reference documentation

**Key Features**:
- 6 common query patterns (ingredient claims, product positioning, compliance, etc.)
- Metadata filtering by category, product, file_type
- Guidance on when to use File Search vs. direct file access
- Natural language query support

**Status**: Created and packaged, needs API endpoint verification

**Integration**: Complements this store setup by providing easy access via semantic search

**See**: `/.claude/skills/gemini-file-search-seed-reference/SKILL_CREATION_NOTES.md` for full details

