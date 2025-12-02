# Reference Store Setup - Strategic Implementation Plan

**Last Updated**: 2025-11-17
**Project**: Seed SEO Draft Generator v4
**Objective**: Create Google File Search store and upload all Reference folder materials for semantic retrieval

---

## Executive Summary

### Problem Statement
The Reference folder contains 62 markdown files (948KB) with critical Seed product information across Claims, NPD Messaging, SciComms education, Compliance rules, and Style guides. These materials need to be made available for semantic retrieval via Google's Gemini File Search API to enable intelligent content workflows.

### Proposed Solution
Create a dedicated File Search store named "seed-reference-materials-v1" and bulk upload all 62 files with structured metadata that enables:
- Product-specific filtering (AM-02, DM-02, PM-02)
- Category-based retrieval (Claims, Messaging, Style, etc.)
- Semantic search across all reference materials
- Persistent storage for future AI-powered workflows

### Business Value
- **Immediate**: Foundation for semantic document retrieval
- **Future**: Enables the `/review-draft-seed-perspective` File Search integration (60-80% token reduction)
- **Cost**: ~$0.08 one-time indexing cost
- **Storage**: FREE (948KB well under 1GB limit)
- **Queries**: FREE (unlimited semantic searches)

### Implementation Approach
Single-phase implementation focused exclusively on store creation and initial file upload:
1. Create bash scripts for store management
2. Create File Search store
3. Bulk upload all 62 files with metadata
4. Validate and document results

---

## Current State Analysis

### Reference Folder Structure

**Total Files**: 62 markdown files
**Total Size**: 948KB (~500k tokens estimated)

**Directory Breakdown**:
```
Reference/
├── Claims/
│   ├── AM-02/ (~15 files) - Focus + Energy ingredient claims
│   ├── DM-02/ (~25 files) - Daily Multivitamin ingredient claims
│   └── PM-02/ (~12 files) - Sleep + Restore ingredient claims
├── NPD-Messaging/ (3 files) - Product positioning documents
├── SciComms Education Files/ (3 files) - Educational talking points
├── Compliance/ (2 files) - NO-NO words and compliance rules
└── Style/ (5 files) - Tone guides and sample articles
```

### File Naming Patterns

**Claims Files**:
- Pattern: `{PRODUCT}-{INGREDIENT}-Claims.md`
- Examples: `DM-02-Biotin-Claims.md`, `PM-02-Melatonin-Claims.md`
- Special: `{PRODUCT}-General-Claims.md`, `{PRODUCT}-Formula-Overview.md`

**Product Messaging**:
- Pattern: `{PRODUCT} Product Messaging Reference Documents.md`
- Products: AM-02, DM-02, PM-02

**SciComms**:
- Pattern: `{PRODUCT} SciComms {Topic} Education.md`
- Examples: `DM-02 Gut-Nutrition Education.md`

### Existing Infrastructure

**API Key**: Available at `~/.claude/skills/gemini-api-key`
- Key: `AIzaSyDSii2SLQEV4wxRxzfErwp4OSB1T4Y9PXo`
- Tier: Paid (data NOT used for training)
- Status: Confirmed working

**Related Work**:
- Folder: `dev/active/gemini-file-search-integration/`
- Contains: Broader integration plan for review command
- This task: Creates the foundational store that integration will use

---

## Proposed Future State

### Target Architecture

**File Search Store**:
- Name: `seed-reference-materials-v1`
- Display Name: "Seed Reference Materials - Production v1"
- Location: Google Cloud (paid tier)
- Retention: Indefinite until manual deletion

**Indexed Content**:
- All 62 markdown files from Reference/ directory
- Structured metadata for intelligent filtering
- Vector embeddings for semantic search
- Full-text content searchable

**Metadata Structure**:

Each file tagged with 4 metadata fields:

```json
[
  {
    "key": "category",
    "string_value": "Claims|NPD-Messaging|SciComms|Compliance|Style"
  },
  {
    "key": "product",
    "string_value": "AM-02|DM-02|PM-02|Cross-Product|N/A"
  },
  {
    "key": "file_type",
    "string_value": "Ingredient-Claims|General-Claims|Formula|Messaging|Education|Compliance|Tone-Guide|Sample-Articles"
  },
  {
    "key": "relative_path",
    "string_value": "Claims/DM-02/DM-02-Biotin-Claims.md"
  }
]
```

### Metadata Extraction Logic

**Category** (from directory):
- `Claims/*` → "Claims"
- `NPD-Messaging/*` → "NPD-Messaging"
- `SciComms Education Files/*` → "SciComms"
- `Compliance/*` → "Compliance"
- `Style/*` → "Style"

**Product** (from filename/path):
- Contains "AM-02" → "AM-02"
- Contains "DM-02" → "DM-02"
- Contains "PM-02" → "PM-02"
- `Cross-Product-General-Claims.md` → "Cross-Product"
- Otherwise → "N/A"

**File Type** (from filename):
- `*-{Ingredient}-Claims.md` → "Ingredient-Claims"
- `*-General-Claims.md` → "General-Claims"
- `*-Formula-Overview.md` OR `*-Product-Formulation.md` → "Formula"
- `*Product Messaging*.md` → "Messaging"
- `*SciComms*.md` → "Education"
- `NO-NO-WORDS.md` OR `What-We-Are-Not-Allowed*.md` → "Compliance"
- `Tone-Guide*.md` OR `*Tone-of-Voice*.md` → "Tone-Guide"
- `*Sample*.md` → "Sample-Articles"

### Query Examples (Future Use)

**Retrieve DM-02 Biotin Claims**:
```bash
./query-store.sh "seed-reference-materials-v1" \
  "What are the approved health claims for biotin in DM-02?" \
  "product=DM-02 AND file_type=Ingredient-Claims"
```

**Retrieve PM-02 Messaging**:
```bash
./query-store.sh "seed-reference-materials-v1" \
  "What is Seed's unique positioning for PM-02 sleep product?" \
  "product=PM-02 AND category=NPD-Messaging"
```

**Retrieve Compliance Rules**:
```bash
./query-store.sh "seed-reference-materials-v1" \
  "What words and phrases must we avoid in content?" \
  "category=Compliance"
```

---

## Implementation Phases

### PHASE 1: Script Development (Day 1, 2-3 hours)

**Objective**: Create bash scripts for store creation and file upload

#### Section 1.1: Setup and Authentication (30 min)

**Task 1.1.1**: Verify API Key [P0] [CRITICAL]
- [ ] Check file exists: `~/.claude/skills/gemini-api-key`
- [ ] Verify key format and length
- [ ] Test API connectivity with simple GET request
- [ ] Document any authentication issues

**Acceptance Criteria**:
- API key file readable
- Key format validated
- Test API call succeeds (GET /fileSearchStores)

**Effort**: S

#### Section 1.2: Create Store Script (45 min)

**Task 1.2.1**: Write create-store.sh [P0] [CRITICAL]

**Script Location**: `dev/active/reference-store-setup/scripts/create-store.sh`

**Requirements**:
- Accept display name as argument
- Read API key from `~/.claude/skills/gemini-api-key`
- POST to `https://generativelanguage.googleapis.com/v1beta/fileSearchStores?key=${KEY}`
- Request body: `{"displayName": "DISPLAY_NAME"}`
- Parse response JSON for `name` field
- Return store name (format: `fileSearchStores/abc123xyz`)
- Handle errors gracefully with clear messages

**Acceptance Criteria**:
- [ ] Script executable (chmod +x)
- [ ] Successfully creates store
- [ ] Returns store ID
- [ ] Error handling for:
  - Missing API key
  - Network errors
  - API errors (rate limits, auth failures)
- [ ] Logs request/response for debugging

**Test Command**:
```bash
./scripts/create-store.sh "test-store-$(date +%s)" | jq -r '.name'
# Should return: fileSearchStores/xxxxx
```

**Effort**: M

**Dependencies**: 1.1.1

#### Section 1.3: Upload File Script (1 hour)

**Task 1.3.1**: Write upload-file.sh [P0] [CRITICAL]

**Script Location**: `dev/active/reference-store-setup/scripts/upload-file.sh`

**Requirements**:

Based on official API documentation, implement **two-step resumable upload**:

**Step 1 - Initiate Upload**:
```bash
curl -X POST \
  "https://generativelanguage.googleapis.com/upload/v1beta/${STORE_NAME}:uploadToFileSearchStore?key=${KEY}" \
  -H "X-Goog-Upload-Protocol: resumable" \
  -H "X-Goog-Upload-Command: start" \
  -H "X-Goog-Upload-Header-Content-Length: ${FILE_SIZE}" \
  -H "X-Goog-Upload-Header-Content-Type: ${MIME_TYPE}" \
  -H "Content-Type: application/json" \
  -d "{
    \"file\": {
      \"displayName\": \"${DISPLAY_NAME}\"
    },
    \"customMetadata\": ${METADATA_JSON}
  }"
```

Extract upload URL from `X-Goog-Upload-URL` header in response.

**Step 2 - Upload File Bytes**:
```bash
curl -X POST \
  "${UPLOAD_URL}" \
  -H "Content-Length: ${FILE_SIZE}" \
  -H "X-Goog-Upload-Offset: 0" \
  -H "X-Goog-Upload-Command: upload, finalize" \
  --data-binary "@${FILE_PATH}"
```

**Script Interface**:
```bash
./upload-file.sh STORE_NAME FILE_PATH METADATA_JSON [DISPLAY_NAME]
```

**Metadata JSON Format**:
```json
[
  {"key": "category", "string_value": "Claims"},
  {"key": "product", "string_value": "DM-02"},
  {"key": "file_type", "string_value": "Ingredient-Claims"},
  {"key": "relative_path", "string_value": "Claims/DM-02/DM-02-Biotin-Claims.md"}
]
```

**Acceptance Criteria**:
- [ ] Implements two-step resumable upload correctly
- [ ] Extracts upload URL from headers
- [ ] Uploads file bytes successfully
- [ ] Accepts metadata as JSON string
- [ ] Auto-detects MIME type (text/markdown for .md files)
- [ ] Uses display name or falls back to filename
- [ ] Returns operation response
- [ ] Error handling for:
  - File not found
  - Invalid metadata JSON
  - Upload failures
  - API errors

**Test Command**:
```bash
# Test with a single file
METADATA='[{"key":"category","string_value":"Test"}]'
./scripts/upload-file.sh "fileSearchStores/xxx" "Reference/Style/Tone-Guide.md" "$METADATA"
```

**Effort**: L

**Dependencies**: 1.2.1

#### Section 1.4: Bulk Upload Script (45 min)

**Task 1.4.1**: Write bulk-upload-reference.sh [P0] [CRITICAL]

**Script Location**: `dev/active/reference-store-setup/scripts/bulk-upload-reference.sh`

**Requirements**:

1. **Find all markdown files**:
```bash
find Reference -type f -name "*.md" | sort
```

2. **For each file**:
   - Extract relative path from `Reference/`
   - Determine category from directory
   - Determine product from filename/path
   - Determine file_type from filename pattern
   - Build metadata JSON array
   - Call `upload-file.sh` with file and metadata
   - Implement 2-second delay between uploads (rate limiting)
   - Track success/failure counts

3. **Progress Display**:
```
Uploading file 1/62: Claims/AM-02/AM-02-Cereboost-Claims.md
  Category: Claims, Product: AM-02, Type: Ingredient-Claims
  ✓ Success (operation: operations/abc123)

Uploading file 2/62: Claims/DM-02/DM-02-Biotin-Claims.md
  Category: Claims, Product: DM-02, Type: Ingredient-Claims
  ✓ Success (operation: operations/def456)
...
```

4. **Final Summary**:
```
=====================================
Bulk Upload Complete
=====================================
Total Files: 62
Successful: 62
Failed: 0
Duration: 5m 30s
Store Name: fileSearchStores/abc123xyz
=====================================
```

**Acceptance Criteria**:
- [ ] Finds all 62 markdown files
- [ ] Correctly extracts metadata for each file
- [ ] Uploads files sequentially with rate limiting
- [ ] Shows progress for each file
- [ ] Tracks success/failure counts
- [ ] Generates final summary report
- [ ] Saves upload log to file
- [ ] Handles errors gracefully (continues on failure)

**Test Command**:
```bash
# Dry run mode
./scripts/bulk-upload-reference.sh "fileSearchStores/xxx" --dry-run

# Actual upload
./scripts/bulk-upload-reference.sh "fileSearchStores/xxx"
```

**Effort**: L

**Dependencies**: 1.3.1

---

### PHASE 2: Store Creation and Upload (Day 1-2, 30-60 min)

**Objective**: Execute scripts to create store and upload all files

#### Section 2.1: Create Production Store (5 min)

**Task 2.1.1**: Execute store creation [P0] [CRITICAL]

**Commands**:
```bash
cd dev/active/reference-store-setup

# Create store
STORE_NAME=$(./scripts/create-store.sh "Seed Reference Materials - Production v1" | jq -r '.name')

# Verify creation
echo "Store created: $STORE_NAME"

# Save to file
echo "$STORE_NAME" > REFERENCE_STORE_ID
```

**Acceptance Criteria**:
- [ ] Store created successfully
- [ ] Store ID saved to `REFERENCE_STORE_ID`
- [ ] Store name format validated: `fileSearchStores/xxxxx`

**Effort**: S

**Dependencies**: Task 1.2.1

#### Section 2.2: Execute Bulk Upload (10-30 min)

**Task 2.2.1**: Upload all 62 files [P0] [CRITICAL]

**Commands**:
```bash
cd dev/active/reference-store-setup

# Read store ID
STORE_NAME=$(cat REFERENCE_STORE_ID)

# Execute bulk upload
./scripts/bulk-upload-reference.sh "$STORE_NAME" | tee upload-log-$(date +%Y%m%d-%H%M%S).txt
```

**Acceptance Criteria**:
- [ ] All 62 files uploaded successfully
- [ ] No failures in upload log
- [ ] Upload log saved with timestamp
- [ ] Progress displayed during upload
- [ ] Final summary shows 62/62 success

**Estimated Time**:
- 62 files × 2 seconds rate limit = ~2 minutes minimum
- Plus upload time: 5-30 minutes total (depends on network)

**Effort**: M

**Dependencies**: Task 2.1.1, Task 1.4.1

---

### PHASE 3: Validation and Documentation (Day 2, 30-45 min)

**Objective**: Verify upload success and document results

#### Section 3.1: Store Validation (15 min)

**Task 3.1.1**: Verify store contents [P0] [CRITICAL]

**Commands**:
```bash
# Get store details
STORE_NAME=$(cat REFERENCE_STORE_ID)

curl -X GET \
  "https://generativelanguage.googleapis.com/v1beta/${STORE_NAME}?key=${API_KEY}" \
  | jq '.'
```

**Check**:
- [ ] `activeDocumentsCount`: Should be 62
- [ ] `pendingDocumentsCount`: Should be 0
- [ ] `failedDocumentsCount`: Should be 0
- [ ] `sizeBytes`: Should be ~970,000 (948KB)

**Acceptance Criteria**:
- [ ] Store shows 62 active documents
- [ ] No pending or failed documents
- [ ] Size approximately correct
- [ ] Store metadata complete

**Effort**: S

**Dependencies**: Task 2.2.1

**Task 3.1.2**: Test semantic queries [P0] [CRITICAL]

**Test Queries**:

1. **Biotin claims for DM-02**:
```bash
./scripts/query-store.sh "$STORE_NAME" \
  "What are the approved health claims for biotin?" \
  "product=DM-02 AND file_type=Ingredient-Claims"
```

Expected: Should return content from `DM-02-Biotin-Claims.md`

2. **PM-02 positioning**:
```bash
./scripts/query-store.sh "$STORE_NAME" \
  "What is Seed's unique positioning for PM-02?" \
  "product=PM-02 AND category=NPD-Messaging"
```

Expected: Should return content from PM-02 messaging document

3. **Compliance rules**:
```bash
./scripts/query-store.sh "$STORE_NAME" \
  "What words should we avoid in content?" \
  "category=Compliance"
```

Expected: Should return content from NO-NO-WORDS.md and compliance file

**Acceptance Criteria**:
- [ ] All 3 test queries return relevant content
- [ ] Grounding metadata shows correct source files
- [ ] Response includes citations
- [ ] Metadata filtering works correctly

**Effort**: S

**Dependencies**: Task 3.1.1

**Note**: This task requires the query script from the broader integration plan. If not available, validation can be done via direct API calls or deferred.

#### Section 3.2: Documentation (30 min)

**Task 3.2.1**: Create summary documentation [P1]

**File**: `dev/active/reference-store-setup/STORE_SUMMARY.md`

**Contents**:
```markdown
# Reference Store Summary

**Created**: 2025-11-17
**Store Name**: fileSearchStores/xxxxx
**Display Name**: Seed Reference Materials - Production v1

## Contents

**Total Files**: 62
**Total Size**: 948KB (~500k tokens)
**Indexing Cost**: $0.075 (500k tokens × $0.15/1M)

## File Breakdown

### By Category
- Claims: 45 files (AM-02: 15, DM-02: 25, PM-02: 12)
- NPD-Messaging: 3 files
- SciComms: 3 files
- Compliance: 2 files
- Style: 5 files

### By Product
- AM-02: 16 files (15 claims + 1 messaging)
- DM-02: 26 files (25 claims + 1 messaging)
- PM-02: 13 files (12 claims + 1 messaging)
- Cross-Product: 1 file
- N/A: 6 files (SciComms, Compliance, Style)

## Metadata Structure

All files tagged with:
- category (Claims/NPD-Messaging/SciComms/Compliance/Style)
- product (AM-02/DM-02/PM-02/Cross-Product/N/A)
- file_type (specific file purpose)
- relative_path (path from Reference/)

## Query Examples

[Include 5-10 example queries with expected results]

## Maintenance

**Re-indexing**: When Reference files change:
1. Identify changed files
2. Delete old versions from store (if API supports)
3. Re-upload changed files
4. Verify document count remains correct

**Monitoring**: Check quarterly:
- Document count still 62
- No failed documents
- Storage size within limits
```

**Acceptance Criteria**:
- [ ] Summary document complete
- [ ] Includes store name and creation date
- [ ] Lists file breakdown by category and product
- [ ] Includes example queries
- [ ] Documents maintenance procedures

**Effort**: S

**Dependencies**: Task 3.1.2

**Task 3.2.2**: Update main CLAUDE.md [P1]

Add reference to the store in project CLAUDE.md:

```markdown
## Google File Search Store

**Reference Materials Store**:
- Store ID: (see `dev/active/reference-store-setup/REFERENCE_STORE_ID`)
- Contents: All 62 Reference folder files
- Created: 2025-11-17
- Purpose: Semantic retrieval of Seed product information
- Documentation: `dev/active/reference-store-setup/STORE_SUMMARY.md`
```

**Acceptance Criteria**:
- [ ] CLAUDE.md updated with store information
- [ ] Links to documentation files
- [ ] Brief description of purpose

**Effort**: XS

**Dependencies**: Task 3.2.1

---

## Risk Assessment and Mitigation

### Technical Risks

**Risk 1: Upload Failures**
- **Severity**: MEDIUM
- **Probability**: LOW-MEDIUM
- **Impact**: Incomplete store, missing files

**Mitigation**:
- Implement retry logic in upload script (3 attempts)
- Log all failures with details
- Continue uploading remaining files on single failure
- Provide clear error messages

**Detection**:
- Check `failedDocumentsCount` in store details
- Review upload log for errors
- Verify document count = 62

**Recovery**:
- Re-run bulk upload for failed files only
- Manual upload of problematic files
- Investigate file-specific issues

**Risk 2: API Rate Limiting**
- **Severity**: LOW
- **Probability**: LOW
- **Impact**: Upload timeouts, failed requests

**Mitigation**:
- Implement 2-second delay between uploads
- Exponential backoff on 429 errors
- Monitor API usage during upload

**Detection**:
- 429 HTTP status codes
- Upload timeouts
- Error messages in logs

**Recovery**:
- Increase delay between uploads
- Resume from last successful upload
- Spread uploads over longer timeframe

**Risk 3: Metadata Extraction Errors**
- **Severity**: LOW
- **Probability**: MEDIUM
- **Impact**: Incorrect filtering, poor discoverability

**Mitigation**:
- Implement dry-run mode to preview metadata
- Log metadata for each file
- Manual review of metadata before upload
- Test queries to verify metadata accuracy

**Detection**:
- Queries return unexpected files
- Missing files in filtered queries
- Review upload log metadata

**Recovery**:
- Document metadata errors
- Create correction plan
- May require re-upload with corrected metadata

**Risk 4: File Path Issues**
- **Severity**: LOW
- **Probability**: LOW
- **Impact**: Files not found, upload failures

**Mitigation**:
- Validate all file paths before upload
- Use absolute paths in scripts
- Test with sample files first
- Check file existence before upload attempt

**Detection**:
- "File not found" errors
- Failed uploads
- Missing files in store

**Recovery**:
- Fix path issues in script
- Re-run upload for affected files

### Business Risks

**Risk 5: Data Privacy / IP Protection**
- **Severity**: HIGH
- **Probability**: VERY LOW (already mitigated)
- **Impact**: Seed proprietary data used for training

**Mitigation** (ALREADY IN PLACE):
- ✅ Using paid tier API key
- ✅ Data NOT used for model training
- ✅ 30-day retention for abuse detection only
- ✅ Can delete store at any time

**Validation**:
- Confirm API key is paid tier
- Review Google's data processing terms
- Document privacy protections

**Risk 6: Cost Overruns**
- **Severity**: LOW
- **Probability**: VERY LOW
- **Impact**: Unexpected charges

**Mitigation**:
- Estimate: 500k tokens × $0.15/1M = $0.075
- Monitor actual usage
- Set budget alerts in Google Cloud Console
- Storage is FREE (under 1GB)
- Queries are FREE

**Validation**:
- Check billing after upload
- Verify charges match estimate
- Document actual cost

### Implementation Risks

**Risk 7: Script Bugs**
- **Severity**: MEDIUM
- **Probability**: MEDIUM
- **Impact**: Failed uploads, data loss

**Mitigation**:
- Test each script individually
- Start with dry-run mode
- Test with 1-2 files before bulk upload
- Implement robust error handling
- Log all operations

**Detection**:
- Script errors during execution
- Unexpected behavior
- Failed uploads

**Recovery**:
- Fix bugs in scripts
- Re-run affected operations
- Manual intervention if needed

---

## Success Metrics

### Completion Metrics

**Store Creation**:
- ✅ Store created successfully
- ✅ Store ID documented
- ✅ Store accessible via API

**File Upload**:
- ✅ All 62 files uploaded
- ✅ 0 failed documents
- ✅ Total size ~948KB
- ✅ Upload completed in <1 hour

**Metadata Quality**:
- ✅ All files tagged with 4 metadata fields
- ✅ Category correctly assigned (100% accuracy)
- ✅ Product correctly assigned (100% accuracy)
- ✅ File type correctly assigned (100% accuracy)

**Validation**:
- ✅ Store shows 62 active documents
- ✅ 0 pending/failed documents
- ✅ Test queries return relevant results
- ✅ Metadata filtering works correctly

### Quality Metrics

**Discoverability**:
- Semantic queries return relevant documents
- Metadata filters work as expected
- No false negatives in test queries
- Response times acceptable (<5 seconds)

**Documentation**:
- Store summary complete and accurate
- Upload log saved and reviewable
- Example queries documented
- Maintenance procedures defined

**Cost Efficiency**:
- Actual cost ≤ $0.10 (within estimate)
- Storage FREE (under 1GB)
- Queries FREE (unlimited)

---

## Required Resources and Dependencies

### API Access

**Google Gemini API**:
- ✅ API Key: `AIzaSyDSii2SLQEV4wxRxzfErwp4OSB1T4Y9PXo`
- ✅ Tier: Paid (data NOT used for training)
- ✅ Billing: Enabled
- ✅ Status: Confirmed working

**Endpoints Required**:
- `POST /v1beta/fileSearchStores` (create store)
- `POST /upload/v1beta/{store}:uploadToFileSearchStore` (upload files)
- `GET /v1beta/fileSearchStores/{id}` (get store details)

### Development Tools

**Required**:
- bash 4.0+ (for scripts)
- curl (for HTTP requests)
- jq (for JSON parsing)
- file command (for MIME type detection)

**Optional**:
- Python 3.x (if curl issues arise)
- Node.js (for alternative implementation)

### Storage and Files

**Input**:
- Reference/ directory (948KB, 62 files)
- Read access to all markdown files

**Output**:
- `dev/active/reference-store-setup/` directory
- Scripts: ~3KB
- Documentation: ~10KB
- Logs: ~50KB

### Network

**Bandwidth**:
- Upload: ~1MB total (948KB files + overhead)
- Minimal download (JSON responses)

**Connectivity**:
- Stable internet connection required
- Google Cloud endpoints accessible
- No firewall/proxy issues

---

## Timeline Estimates

### Phase 1: Script Development
**Estimated Duration**: 2-3 hours

**Breakdown**:
- Task 1.1.1 (API Verification): 15 min
- Task 1.2.1 (Create Store Script): 45 min
- Task 1.3.1 (Upload File Script): 60 min
- Task 1.4.1 (Bulk Upload Script): 45 min
- Testing and debugging: 15-45 min

**Dependencies**: None (can start immediately)

### Phase 2: Store Creation and Upload
**Estimated Duration**: 30-60 min

**Breakdown**:
- Task 2.1.1 (Create Store): 5 min
- Task 2.2.1 (Bulk Upload): 10-30 min
  - Minimum: 2 min (rate limiting)
  - Upload time: 5-25 min (network dependent)
  - Buffer: 3-5 min

**Dependencies**: Phase 1 complete

### Phase 3: Validation and Documentation
**Estimated Duration**: 30-45 min

**Breakdown**:
- Task 3.1.1 (Store Validation): 10 min
- Task 3.1.2 (Test Queries): 5-15 min (depends on query script availability)
- Task 3.2.1 (Summary Doc): 10 min
- Task 3.2.2 (Update CLAUDE.md): 5 min

**Dependencies**: Phase 2 complete

### Total Timeline
**Best Case**: 3 hours
**Expected**: 4 hours
**Worst Case**: 5 hours (with debugging and issues)

**Timeline with Contingency**: 5-6 hours over 1-2 days

---

## Next Steps

### Immediate Actions
1. Review and approve this plan
2. Verify API key access
3. Create script directory structure
4. Begin Task 1.1.1 (API verification)

### Phase Gates

**Phase 1 Gate** (Before proceeding to Phase 2):
- [ ] All scripts written and executable
- [ ] Scripts tested with sample data
- [ ] No critical bugs identified
- [ ] Dry-run mode tested successfully

**Phase 2 Gate** (Before proceeding to Phase 3):
- [ ] Store created successfully
- [ ] At least 90% of files uploaded (56+/62)
- [ ] No blocking errors
- [ ] Upload log available for review

**Phase 3 Gate** (Project completion):
- [ ] Store shows 62 active documents
- [ ] 0 failed documents
- [ ] Documentation complete
- [ ] Store ID saved and accessible

---

## Appendix

### API Endpoints Reference

**Base URL**: `https://generativelanguage.googleapis.com/v1beta/`

**Create Store**:
```
POST /fileSearchStores?key=${API_KEY}
Body: {"displayName": "DISPLAY_NAME"}
Response: {name: "fileSearchStores/xxxxx", ...}
```

**Upload File (Step 1 - Initiate)**:
```
POST /upload/v1beta/{storeName}:uploadToFileSearchStore?key=${API_KEY}
Headers:
  X-Goog-Upload-Protocol: resumable
  X-Goog-Upload-Command: start
  X-Goog-Upload-Header-Content-Length: FILE_SIZE
  X-Goog-Upload-Header-Content-Type: MIME_TYPE
Body: {file: {displayName: "..."}, customMetadata: [...]}
Response Headers: X-Goog-Upload-URL: UPLOAD_URL
```

**Upload File (Step 2 - Upload Bytes)**:
```
POST UPLOAD_URL
Headers:
  Content-Length: FILE_SIZE
  X-Goog-Upload-Offset: 0
  X-Goog-Upload-Command: upload, finalize
Body: [binary file data]
Response: {operation: {...}}
```

**Get Store**:
```
GET /fileSearchStores/{storeName}?key=${API_KEY}
Response: {name, displayName, activeDocumentsCount, ...}
```

### Pricing Reference

**File Search Pricing** (as of 2025-11):
- Indexing: $0.15 per 1M tokens (one-time)
- Storage: FREE (up to 1GB free tier, then tiered pricing)
- Queries: FREE
- Context tokens in responses: Charged at normal rate ($0.075/1M input)

**Estimated Cost for This Project**:
- 500k tokens × $0.15/1M = **$0.075** (one-time)
- Storage: **$0** (948KB << 1GB)
- Future queries: **$0**
- Total upfront: **~$0.08**

### File Naming Conventions

**Claims Files** follow pattern:
- `{PRODUCT}-{INGREDIENT}-Claims.md`
- Product: AM-02, DM-02, PM-02
- Ingredient: Biotin, Niacin, PQQ, etc.
- Special cases: General-Claims, Formula-Overview, Product-Formulation

**Exceptions to watch for**:
- `Cross-Product-General-Claims.md` (product = "Cross-Product")
- `AM-02-Process-Instructions.md` (file_type = "Process-Instructions")
- Backup files: `*.md.backup-YYYY-MM-DD` (should skip these)
- Python scripts: `update_dm02_links.py` (not markdown, skip)

---

**Last Review**: 2025-11-17
**Next Review**: After Phase 1 completion
