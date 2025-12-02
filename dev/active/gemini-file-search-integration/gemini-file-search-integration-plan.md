# Gemini File Search Integration - Strategic Implementation Plan

**Last Updated**: 2025-11-18
**Project**: Seed SEO Draft Generator v4
**Objective**: Integrate existing File Search store into review workflows for 60-80% token reduction

---

## Executive Summary

### Current State
✅ **Infrastructure Complete**: Google File Search store with all 62 Reference files is production-ready and accessible via `gemini-file-search-seed-reference` skill (completed 2025-11-18).

**Store Details**:
- Store ID: `fileSearchStores/seed-reference-materials-pr-jma5jhay17is`
- Contents: 62/62 files uploaded successfully (685 KB)
- Scripts: Available in `dev/active/reference-store-setup/`
- Query Skill: `.claude/skills/gemini-file-search-seed-reference/`

### Problem Statement
The `/review-draft-seed-perspective` command loads 50+ reference files (100-120k tokens) for every review. With the File Search store now operational, we can integrate semantic retrieval to reduce this to 10-20k tokens per review.

**Current Costs**:
- High operational costs (~$30/month for 100 reviews)
- Slow execution (10-15 seconds loading files)
- Loading irrelevant content (manual filtering required)

### Proposed Solution
Build `/review-draft-seed-perspective-gemini-file-search` command that:
1. Uses the **existing** File Search store for semantic retrieval
2. Implements same 15-check grading system
3. Achieves 60-80% token reduction
4. Maintains 100% accuracy vs. original command

### Business Value
- **Cost Savings**: $25/month (83% reduction from $30 to $5)
- **Performance**: 3-5x faster reviews (2-4 seconds vs 10-15 seconds)
- **Quality**: Better relevance through semantic search
- **Scalability**: No cost increase as volume grows

### Implementation Approach
Two-phase focused integration (NOT infrastructure build):
1. **Phase 1 (Days 1-3)**: Partial command with Claims checks only
2. **Phase 2 (Days 4-6)**: Full command with all 15 checks

---

## Current State Analysis

### Existing Architecture

**Command**: `/review-draft-seed-perspective`
**Location**: `.claude/commands/review-draft-seed-perspective.md`

**Current Workflow**:
1. Identify draft file to review
2. Auto-detect product (DM-02/PM-02/AM-02)
3. **Load all reference files** (50+ files, ~100-120k tokens)
4. Manually filter for relevance
5. Grade against 15 checks
6. Apply fixes

**Reference Materials Structure**:
```
Reference/
├── Claims/
│   ├── AM-02/ (~15 files)
│   ├── DM-02/ (~18 files)
│   └── PM-02/ (~12 files)
├── NPD-Messaging/ (~3 files)
├── SciComms Education Files/ (~3 files)
├── Compliance/ (~2 files)
└── Style/ (~5 files)
Total: ~60 files, ~500k tokens
```

**15 Grading Checks**:
- **Section A**: Claims Document Usage (5 checks)
- **Section B**: NPD Messaging Alignment (5 checks, product-specific)
- **Section C**: SciComms Education Integration (5 checks)

### Pain Points
1. ❌ **Token bloat**: Loading all files regardless of relevance
2. ❌ **Cost inefficiency**: Paying for unused tokens
3. ❌ **Slow execution**: File I/O overhead
4. ❌ **Manual filtering**: Step 3 "relevance analysis" is manual
5. ❌ **Maintenance burden**: Changes require reading all files

### Technology Constraints
- Must maintain exact same grading logic
- Cannot miss relevant content (no false negatives)
- Must preserve all 15 checks
- Paid tier Gemini API for data privacy

---

## Proposed Future State

### Target Architecture

**New Command**: `/review-draft-seed-perspective-gemini-file-search`
**Location**: `.claude/commands/review-draft-seed-perspective-gemini-file-search.md`

**New Workflow**:
1. Identify draft file to review
2. Auto-detect product (DM-02/PM-02/AM-02)
3. **Query File Search** for relevant content (10-20k tokens)
4. Receive pre-filtered, relevant sections
5. Grade against 15 checks (same logic)
6. Apply fixes

**Supporting Infrastructure**:
```
.claude/skills/gemini-file-search/
├── SKILL.md
├── scripts/
│   ├── lib/gemini-auth.sh
│   ├── create-store.sh
│   ├── upload-file.sh
│   ├── bulk-index.sh
│   ├── query-store.sh
│   ├── list-stores.sh
│   ├── get-store.sh
│   └── delete-store.sh
└── references/api-reference.md

~/.claude/skills/gemini-api-key (paid tier)
```

**File Search Store**:
- All 60 reference files indexed once
- Metadata: product, file_type, filename, relative_path
- Vector embeddings for semantic search
- Indefinite storage (until manual deletion)

### Key Improvements
1. ✅ **Token efficiency**: 80-90% reduction
2. ✅ **Cost savings**: $25/month reduction
3. ✅ **Speed**: 3-5x faster execution
4. ✅ **Smart retrieval**: Semantic search vs manual filtering
5. ✅ **Scalability**: Free queries, no marginal cost increase

### Privacy & Security
- **API Tier**: Paid (AIzaSyDSii2SLQEV4wxRxzfErwp4OSB1T4Y9PXo)
- **Data Usage**: NOT used for model training ✅
- **Retention**: 30 days for abuse detection only
- **Storage**: Google Cloud, indefinite until deletion
- **IP Protection**: Full enterprise-grade privacy

---

## Already Completed (reference-store-setup)

### ✅ Store Creation and Initial Indexing (2025-11-18)

**Production Store**:
- **Store ID**: `fileSearchStores/seed-reference-materials-pr-jma5jhay17is`
- **Status**: Production Ready
- **Upload Success**: 62/62 files (100%)
- **Failed Documents**: 0
- **Total Size**: 685 KB
- **Duration**: 274 seconds (4 min 34 sec)
- **Cost**: ~$0.053 one-time indexing

**Scripts Available**:
- `dev/active/reference-store-setup/scripts/create-store.sh`
- `dev/active/reference-store-setup/scripts/upload-file.sh`
- `dev/active/reference-store-setup/scripts/bulk-upload-reference.sh`

**Query Skill Created**:
- Location: `.claude/skills/gemini-file-search-seed-reference/`
- Query Script: Available and tested
- Documentation: Complete with 6 query patterns
- Metadata Filtering: Working

**Validation Complete**:
- ✅ 100% upload success rate
- ✅ Token reduction confirmed (60-80%)
- ✅ Metadata filtering working
- ✅ Query patterns documented and tested

**Documentation**:
- **Store Summary**: `dev/active/reference-store-setup/STORE_SUMMARY.md`
- **Setup Guide**: `dev/active/reference-store-setup/README.md`
- **Handoff Notes**: `dev/active/reference-store-setup/HANDOFF_NOTES.md`
- **Skill Documentation**: `.claude/skills/gemini-file-search-seed-reference/SKILL.md`

**See**: `dev/active/reference-store-setup/` for complete implementation details and all logs.

---

## Implementation Phases

### PHASE 1: Partial Command Implementation (Days 1-3)

**NOTE**: Original Phase 1 (POC and infrastructure setup) is COMPLETE. This is now Phase 1 of command integration.

**Objective**: Create partial review command with Claims checks using existing File Search store

**Deliverables**:
- New command: `/review-draft-seed-perspective-gemini-file-search`
- File Search query logic for Claims retrieval
- 5 Claims Document checks implemented
- Performance benchmarks vs. original command

**Success Criteria**:
- ✅ Command retrieves correct Claims for product from File Search
- ✅ All 5 Claims checks work identically to original
- ✅ 60%+ token reduction confirmed
- ✅ No relevant content missed
- ✅ Faster execution than original

### PHASE 2: Full Feature Parity (Days 4-6)

**NOTE**: Original Phase 2 (production indexing) is COMPLETE. This is the final phase for full command integration.

**Objective**: Complete all 15 checks and production-ready features

**Deliverables**:
- Complete command with all 15 checks
- NPD Messaging and SciComms queries
- Advanced features (source tracking, re-indexing)
- Complete documentation

**Success Criteria**:
- ✅ All 15 checks pass identically to original
- ✅ 60-80% token reduction confirmed
- ✅ No false negatives
- ✅ Faster execution
- ✅ Complete documentation

---

## Detailed Tasks

### SECTION 1: Environment Setup (Day 1, 2 hours)

#### Task 1.1: Store API Key [CRITICAL]
**Effort**: S
**Priority**: P0
**Dependencies**: None

**Acceptance Criteria**:
- [ ] File created: `~/.claude/skills/gemini-api-key`
- [ ] Contains paid tier key: `AIzaSyDSii2SLQEV4wxRxzfErwp4OSB1T4Y9PXo`
- [ ] File permissions set to 600 (read/write owner only)
- [ ] Key validated with test API call

**Implementation**:
```bash
echo "AIzaSyDSii2SLQEV4wxRxzfErwp4OSB1T4Y9PXo" > ~/.claude/skills/gemini-api-key
chmod 600 ~/.claude/skills/gemini-api-key
```

#### Task 1.2: Create Skill Directory Structure [CRITICAL]
**Effort**: S
**Priority**: P0
**Dependencies**: None

**Acceptance Criteria**:
- [ ] Directory created: `/.claude/skills/gemini-file-search/`
- [ ] Subdirectories: `scripts/`, `scripts/lib/`, `references/`
- [ ] All directories have correct permissions

**Implementation**:
```bash
mkdir -p /.claude/skills/gemini-file-search/scripts/lib
mkdir -p /.claude/skills/gemini-file-search/references
```

---

### SECTION 2: Core Script Development (Days 1-2, 8 hours)

#### Task 2.1: Authentication Helper [CRITICAL]
**Effort**: S
**Priority**: P0
**Dependencies**: 1.1

**Acceptance Criteria**:
- [ ] File: `scripts/lib/gemini-auth.sh`
- [ ] Function `get_gemini_api_key()` reads from `~/.claude/skills/gemini-api-key`
- [ ] Exports `GEMINI_API_KEY` environment variable
- [ ] Handles missing key file with clear error
- [ ] Script is executable (chmod +x)

**Verification**:
```bash
source scripts/lib/gemini-auth.sh
echo $GEMINI_API_KEY  # Should print key
```

#### Task 2.2: Create Store Script [CRITICAL]
**Effort**: S
**Priority**: P0
**Dependencies**: 2.1

**Acceptance Criteria**:
- [ ] File: `scripts/create-store.sh`
- [ ] Takes display name as argument
- [ ] Uses resumable upload protocol (verified from docs)
- [ ] Returns JSON with store name
- [ ] Handles API errors gracefully
- [ ] Script is executable

**Verification**:
```bash
./create-store.sh "test-store" | jq -r '.name'
# Should return: fileSearchStores/xxxxx
```

#### Task 2.3: Upload File Script [CRITICAL]
**Effort**: M
**Priority**: P0
**Dependencies**: 2.1

**Acceptance Criteria**:
- [ ] File: `scripts/upload-file.sh`
- [ ] Implements two-step resumable upload (verified from official docs)
- [ ] Step 1: Initiates upload, gets upload URL
- [ ] Step 2: Uploads file bytes with `--data-binary`
- [ ] Accepts optional metadata JSON array
- [ ] Validates file exists before upload
- [ ] Returns operation response
- [ ] Handles errors with clear messages

**Verification**:
```bash
./upload-file.sh "fileSearchStores/xxx" "test.md" '[{"key":"test","string_value":"value"}]'
# Should succeed with operation response
```

#### Task 2.4: Bulk Index Script [CRITICAL]
**Effort**: M
**Priority**: P0
**Dependencies**: 2.3

**Acceptance Criteria**:
- [ ] File: `scripts/bulk-index.sh`
- [ ] Takes store name, directory path, file pattern
- [ ] Uses `find` to locate all matching files
- [ ] Extracts metadata from file paths (product, file_type, filename, relative_path)
- [ ] Builds correct metadata JSON format: `[{"key":"...","string_value":"..."}]`
- [ ] Includes progress tracking (X/Y files)
- [ ] Includes 2-second rate limiting between uploads
- [ ] Reports success/failure count at end

**Verification**:
```bash
./bulk-index.sh "fileSearchStores/xxx" "test-dir" "*.md"
# Should upload all files with progress
```

#### Task 2.5: Query Store Script [CRITICAL]
**Effort**: M
**Priority**: P0
**Dependencies**: 2.1

**Acceptance Criteria**:
- [ ] File: `scripts/query-store.sh`
- [ ] Takes store name, query text, optional metadata filter
- [ ] Builds correct request JSON with file_search tool
- [ ] Uses `gemini-2.5-flash` model
- [ ] Includes metadata filter in request if provided
- [ ] Returns full response with grounding metadata
- [ ] Handles API errors

**Verification**:
```bash
./query-store.sh "fileSearchStores/xxx" "test query" "product=DM-02"
# Should return response with candidates and groundingMetadata
```

#### Task 2.6: List/Get/Delete Scripts
**Effort**: S
**Priority**: P1
**Dependencies**: 2.1

**Acceptance Criteria**:
- [ ] File: `scripts/list-stores.sh` - lists all stores
- [ ] File: `scripts/get-store.sh` - gets single store details
- [ ] File: `scripts/delete-store.sh` - deletes store with confirmation
- [ ] All scripts executable and handle errors

---

### SECTION 3: Documentation & POC Testing (Day 2-3, 4 hours)

#### Task 3.1: Skill Documentation [CRITICAL]
**Effort**: M
**Priority**: P0
**Dependencies**: 2.1-2.6

**Acceptance Criteria**:
- [ ] File: `SKILL.md` with complete frontmatter
- [ ] Documents all 9 scripts with usage examples
- [ ] Includes privacy/data protection information
- [ ] Includes pricing information
- [ ] Includes supported file formats
- [ ] Includes authentication setup

#### Task 3.2: API Reference
**Effort**: S
**Priority**: P1
**Dependencies**: None

**Acceptance Criteria**:
- [ ] File: `references/api-reference.md`
- [ ] Documents all endpoints with examples
- [ ] Includes authentication details
- [ ] Includes data storage information

#### Task 3.3: POC Testing [CRITICAL]
**Effort**: M
**Priority**: P0
**Dependencies**: 2.1-2.6

**Test Cases**:
- [ ] Test 1: Create POC store successfully
- [ ] Test 2: Upload single file with metadata
- [ ] Test 3: Bulk index 5-10 files from DM-02 Claims
- [ ] Test 4: Query for B vitamin claims, verify correct retrieval
- [ ] Test 5: Query with metadata filter "product=DM-02"
- [ ] Test 6: Verify store details show correct document count

**Measurements**:
- [ ] Token count for query response vs loading full files
- [ ] Confirm 60-80% reduction
- [ ] Verify all relevant content retrieved
- [ ] Verify citations present in groundingMetadata

---

### SECTION 4: Production Indexing (Day 4, 3 hours)

#### Task 4.1: Create Production Store [CRITICAL]
**Effort**: S
**Priority**: P0
**Dependencies**: 3.3 (POC validation)

**Acceptance Criteria**:
- [ ] Production store created: "seed-reference-materials-production"
- [ ] Store name saved to: `/.claude/skills/gemini-file-search/PRODUCTION_STORE_NAME`
- [ ] Store validated with get-store.sh

#### Task 4.2: Bulk Index All Reference Materials [CRITICAL]
**Effort**: L
**Priority**: P0
**Dependencies**: 4.1

**Acceptance Criteria**:
- [ ] Index Claims/ directory (~45 files)
- [ ] Index NPD-Messaging/ directory (~3 files)
- [ ] Index SciComms Education Files/ directory (~3 files)
- [ ] Index Compliance/ directory (~2 files)
- [ ] Index Style/ directory (~5 files)
- [ ] Total: ~60 files successfully indexed
- [ ] No failed uploads
- [ ] Store shows activeDocumentsCount: ~60

**Cost Tracking**:
- [ ] Record total tokens indexed
- [ ] Confirm indexing cost (~$0.08 for 500k tokens)

#### Task 4.3: Validation Queries
**Effort**: M
**Priority**: P0
**Dependencies**: 4.2

**Test Queries**:
- [ ] Query DM-02 Claims about gut bacteria producing vitamins
- [ ] Query PM-02 Claims about melatonin dosing
- [ ] Query AM-02 Claims about cellular energy
- [ ] Query NPD Messaging for DM-02 positioning
- [ ] Query SciComms for relevant talking points
- [ ] Verify each returns correct, relevant content

---

### SECTION 5: Partial Command Development (Days 5-6, 10 hours)

#### Task 5.1: Create Command File [CRITICAL]
**Effort**: L
**Priority**: P0
**Dependencies**: 4.3

**Acceptance Criteria**:
- [ ] File: `.claude/commands/review-draft-seed-perspective-gemini-file-search.md`
- [ ] Implements Steps 1-2 (file identification, product detection) same as original
- [ ] Implements Step 3: Smart Reference Retrieval via File Search
- [ ] Implements Step 4: Grade against first 5 checks (Claims only)
- [ ] Implements Step 5: Generate report with retrieval stats
- [ ] Implements Step 6: Apply fixes (Claims only)

#### Task 5.2: File Search Query Logic [CRITICAL]
**Effort**: L
**Priority**: P0
**Dependencies**: 5.1

**Acceptance Criteria**:
- [ ] Reads production store name from file
- [ ] Extracts from article: keyword, ingredients, H2 headings, product
- [ ] Builds intelligent query for Claims retrieval
- [ ] Includes all necessary context in query
- [ ] Parses File Search response correctly
- [ ] Extracts claims text from response
- [ ] Extracts grounding metadata (citations)

**Query Template**:
```
For an article about '${KEYWORD}' for ${PRODUCT}, retrieve:
1. General health claims from ${PRODUCT}-General-Claims.md
2. Ingredient-specific claims for: ${INGREDIENTS}
3. Include exact DOI links and study substantiation
4. Focus on claims relevant to: ${H2_HEADINGS}
5. Include dose information where applicable
```

#### Task 5.3: Claims Grading Implementation [CRITICAL]
**Effort**: M
**Priority**: P0
**Dependencies**: 5.2

**Acceptance Criteria**:
- [ ] Check 1: Uses Claims as PRIMARY authority (>50%)
- [ ] Check 2: Cites specific studies with DOI links
- [ ] Check 3: Health claims substantively supported
- [ ] Check 4: Dose information matches
- [ ] Check 5: Claims attributed to ingredients
- [ ] All checks produce same results as original command

#### Task 5.4: Report Generation with Stats [CRITICAL]
**Effort**: M
**Priority**: P0
**Dependencies**: 5.3

**Acceptance Criteria**:
- [ ] Shows retrieval statistics (documents retrieved, token usage, savings %)
- [ ] Lists which source files were used (from groundingMetadata)
- [ ] Shows check results (X/5 passed)
- [ ] Includes detailed findings for each check
- [ ] Notes Phase 2 status and what's remaining

---

### SECTION 6: Phase 2 Testing & Validation (Day 7, 4 hours)

#### Task 6.1: Cross-Product Testing [CRITICAL]
**Effort**: M
**Priority**: P0
**Dependencies**: 5.4

**Test Cases**:
- [ ] Test with DM-02 article (multivitamin topic)
- [ ] Test with PM-02 article (sleep/melatonin topic)
- [ ] Test with AM-02 article (energy/focus topic)
- [ ] Test with cross-product ingredient (PQQ, CoQ10, GABA)

**For Each Test**:
- [ ] Measure token usage
- [ ] Verify retrieval relevance
- [ ] Compare grading results with original command
- [ ] Confirm no false negatives

#### Task 6.2: Performance Benchmarking
**Effort**: M
**Priority**: P0
**Dependencies**: 6.1

**Metrics to Capture** (across 5+ test runs):
- [ ] Average token usage: File Search vs Original
- [ ] Token reduction percentage
- [ ] Execution time: File Search vs Original
- [ ] Speed improvement factor
- [ ] Cost per review: File Search vs Original

**Success Thresholds**:
- [ ] ≥60% token reduction
- [ ] ≥2x speed improvement
- [ ] 100% grading accuracy (vs original)

---

### SECTION 7: Full Implementation (Days 8-9, 12 hours)

#### Task 7.1: NPD Messaging Integration [CRITICAL]
**Effort**: L
**Priority**: P0
**Dependencies**: 6.2

**Acceptance Criteria**:
- [ ] Query 2: Retrieve NPD Messaging implemented
- [ ] Query includes product-specific context
- [ ] Retrieves positioning, differentiators, narratives
- [ ] Retrieves Dirk Gevers quote suggestions
- [ ] Checks 6-10 implemented (product-specific)
- [ ] DM-02 checks: soil depletion, bidirectional microbiome, ViaCap, bioavailability, mass-market critique
- [ ] PM-02 checks: precision dosing, sleep-gut-brain axis, dual-phase, high-dose critique, not overloading
- [ ] AM-02 checks: sustained energy, gut-mitochondria axis, cellular energy, nootropic benefits, stimulant critique

#### Task 7.2: SciComms Integration [CRITICAL]
**Effort**: L
**Priority**: P0
**Dependencies**: 7.1

**Acceptance Criteria**:
- [ ] Query 3: Retrieve SciComms implemented
- [ ] Query filters for relevance to article topic
- [ ] Retrieves talking points, narratives, pre-vetted sources
- [ ] Checks 11-15 implemented
- [ ] Check 11: Relevant talking points incorporated
- [ ] Check 12: Product-specific narratives used
- [ ] Check 13: Additional sources cited where relevant
- [ ] Check 14: Educational angle matches Seed approach
- [ ] Check 15: Dirk Gevers quote aligns with perspective

#### Task 7.3: Complete Grading System
**Effort**: M
**Priority**: P0
**Dependencies**: 7.2

**Acceptance Criteria**:
- [ ] All 15 checks functional
- [ ] Letter grade (A-F) calculated correctly
- [ ] Report shows all three sections (A, B, C)
- [ ] Priority levels assigned correctly
- [ ] Fix recommendations generated for all failed checks

#### Task 7.4: Advanced Features
**Effort**: M
**Priority**: P1
**Dependencies**: 7.3

**Acceptance Criteria**:
- [ ] Feature 1: Show retrieval sources from groundingMetadata
- [ ] Feature 2: Cache store name handling with fallback
- [ ] Feature 3: Error handling for missing/inaccessible store
- [ ] Feature 4: Token usage comparison displayed

---

### SECTION 8: Final Testing & Documentation (Day 10, 6 hours)

#### Task 8.1: Comprehensive Testing Suite [CRITICAL]
**Effort**: L
**Priority**: P0
**Dependencies**: 7.4

**Test Matrix**:
- [ ] Product: DM-02, PM-02, AM-02
- [ ] Length: 1500, 1800, 2000 words
- [ ] Topic: Ingredient-specific, general health
- [ ] Special: Cross-product ingredients

**Validation** (for each test):
- [ ] All 15 checks produce same results as original
- [ ] No relevant content missed
- [ ] Token usage within expected range (10-20k)
- [ ] Execution time faster than original
- [ ] Grading accuracy 100%

#### Task 8.2: Performance Analysis
**Effort**: M
**Priority**: P0
**Dependencies**: 8.1

**Final Metrics** (across 10+ reviews):
- [ ] Average token usage: [X]k
- [ ] Token reduction: [Y]%
- [ ] Average execution time: [Z] seconds
- [ ] Speed improvement: [N]x
- [ ] Cost per review: $[X]
- [ ] Monthly cost savings: $[Y]

**Report Format**:
```
Performance Comparison Report
=============================
                    Original    File Search   Improvement
Token Usage         120k        15k           87% reduction
Execution Time      12s         3s            4x faster
Cost per Review     $0.36       $0.05         86% reduction
Monthly Cost (100)  $36         $5            $31 savings
```

#### Task 8.3: Documentation Updates [CRITICAL]
**Effort**: M
**Priority**: P0
**Dependencies**: 8.2

**Acceptance Criteria**:
- [ ] Command documentation complete with all examples
- [ ] Update main CLAUDE.md with File Search skill reference
- [ ] Create troubleshooting guide for common issues
- [ ] Document re-indexing process for updated files
- [ ] Document store management (list, delete, cleanup)

#### Task 8.4: Knowledge Transfer
**Effort**: S
**Priority**: P1
**Dependencies**: 8.3

**Acceptance Criteria**:
- [ ] Create "How to Use" guide for end users
- [ ] Document when to use File Search vs original command
- [ ] Document maintenance procedures
- [ ] Document cost monitoring

---

## Risk Assessment and Mitigation

### Technical Risks

#### Risk 1: File Search Misses Relevant Content
**Severity**: HIGH
**Probability**: MEDIUM
**Impact**: Grading inaccuracy, false negatives

**Mitigation**:
- Comprehensive testing in Phase 2 before full rollout
- Query prompt engineering to maximize recall
- Metadata filtering to ensure product-specific retrieval
- Fallback to original command if confidence is low
- Keep original command available for comparison

**Detection**:
- Compare results with original command during testing
- Monitor for grading discrepancies
- User feedback on missed content

#### Risk 2: Query Formulation Doesn't Retrieve Right Documents
**Severity**: MEDIUM
**Probability**: MEDIUM
**Impact**: Incomplete retrieval, poor relevance

**Mitigation**:
- Iterate on query prompts during Phase 1 POC
- Use metadata filtering as safety net
- Include explicit document names in queries
- Test with diverse article types

**Validation**:
- Check groundingMetadata for expected documents
- Verify all product-specific content retrieved
- Test edge cases (cross-product ingredients)

#### Risk 3: API Rate Limiting or Costs
**Severity**: LOW
**Probability**: LOW
**Impact**: Service interruption, unexpected costs

**Mitigation**:
- Use 2-second delays in bulk upload
- Monitor API usage in Phase 2
- Set up cost alerts in Google Cloud Console
- Queries are free, only indexing costs

**Monitoring**:
- Track API call counts
- Monitor monthly billing
- Set budget alerts at $10, $20, $30

#### Risk 4: Breaking Changes to Gemini API
**Severity**: MEDIUM
**Probability**: LOW
**Impact**: Skill stops working

**Mitigation**:
- Pin to specific API version (v1beta)
- Monitor Google AI Developer changelog
- Keep original command working alongside
- Version lock dependencies

**Recovery**:
- Maintain original command as fallback
- Subscribe to API deprecation notices
- Test with new API versions before migrating

### Business Risks

#### Risk 5: Data Privacy Concerns
**Severity**: HIGH
**Probability**: LOW (mitigated)
**Impact**: IP leakage, competitive disadvantage

**Mitigation**:
- ✅ **ALREADY MITIGATED**: Using paid tier API
- Data NOT used for training
- 30-day retention for abuse detection only
- Can delete store at any time
- Documented in privacy section

**Validation**:
- Confirm paid tier status with API key
- Review Google's data processing terms
- Regular privacy compliance checks

#### Risk 6: Dependency on Google Infrastructure
**Severity**: MEDIUM
**Probability**: LOW
**Impact**: Service unavailability

**Mitigation**:
- Keep original command functional
- Monitor Google Cloud status page
- Have rollback plan
- Store backup of reference files locally

**Contingency**:
- If File Search unavailable, use original command
- Export indexed data periodically
- Maintain local copy of all reference materials

### Implementation Risks

#### Risk 7: Complexity Increases Maintenance Burden
**Severity**: LOW
**Probability**: MEDIUM
**Impact**: Harder to update, debug issues

**Mitigation**:
- Comprehensive documentation
- Clear separation of concerns (skill vs command)
- Keep original command as reference
- Document all query patterns

**Best Practices**:
- Update both commands when reference materials change
- Document query modification process
- Keep skill scripts simple and focused

---

## Success Metrics

### Performance Metrics

**Token Efficiency**:
- Target: ≥60% reduction
- Measure: Average tokens per review
- Baseline: 100-120k (original)
- Goal: 10-20k (File Search)

**Execution Speed**:
- Target: ≥2x faster
- Measure: Average execution time
- Baseline: 10-15 seconds (original)
- Goal: 2-5 seconds (File Search)

**Cost Savings**:
- Target: ≥70% reduction
- Measure: Monthly operational cost
- Baseline: ~$30/month (100 reviews)
- Goal: ~$5/month (100 reviews)

### Quality Metrics

**Grading Accuracy**:
- Target: 100% parity with original
- Measure: Check-by-check comparison
- Validation: All 15 checks produce identical results
- Tolerance: 0 false negatives allowed

**Content Completeness**:
- Target: 100% recall of relevant content
- Measure: Manual review of retrieved vs expected
- Validation: No missing Claims, NPD Messaging, or SciComms
- Tolerance: 0 missed critical content

### Adoption Metrics

**Usage**:
- Target: 100% of reviews use File Search after Phase 3
- Measure: Command usage tracking
- Timeline: 2 weeks post-launch

**User Satisfaction**:
- Target: Positive feedback on speed and accuracy
- Measure: Informal feedback, issue reports
- Goal: No major usability complaints

---

## Required Resources and Dependencies

### Technical Resources

**API Access**:
- ✅ Gemini API key (paid tier): `AIzaSyDSii2SLQEV4wxRxzfErwp4OSB1T4Y9PXo`
- ✅ Google Cloud billing enabled
- ✅ Gemini API enabled for project

**Development Tools**:
- bash 4.0+ (for scripts)
- curl (for API calls)
- jq (for JSON parsing)
- file command (for MIME type detection)

**Storage**:
- Local: 100MB for skill files
- Cloud: 1GB File Search storage (free tier)
- Reference materials: ~500k tokens

### External Dependencies

**Google Services**:
- Gemini API (generativelanguage.googleapis.com)
- File Search API (v1beta endpoints)
- Google Cloud billing

**API Stability**:
- Using v1beta endpoints (subject to change)
- Monitor for API updates
- Subscribe to Google AI Developer updates

### Knowledge Dependencies

**Documentation**:
- ✅ Official Gemini API docs reviewed
- ✅ File Search API reference consulted
- ✅ Bash script examples verified
- ✅ Authentication methods confirmed

**Domain Knowledge**:
- Understanding of RAG systems
- Vector embeddings concepts
- Semantic search principles
- Current command logic

---

## Timeline Estimates

### Infrastructure Phase: ✅ COMPLETE (reference-store-setup)
- Duration: 3.5 hours (single session, 2025-11-18)
- All scripts, store creation, file uploads, validation complete
- **Saved**: 22 hours from original estimate

### Phase 1: Partial Command (Days 1-3)
- Day 1-2: Command development (16 hours)
  - Task 1.1-1.2: Command file + query logic (8 hours)
  - Task 1.3-1.4: Grading + reporting (8 hours)
- Day 3: Testing + benchmarking (4 hours)
  - Task 1.5-1.6: Testing + performance (4 hours)

**Total: 20 hours**

### Phase 2: Full Implementation (Days 4-6)
- Day 4-5: NPD + SciComms + features (18 hours)
  - Task 2.1-2.2: NPD + SciComms integration (14 hours)
  - Task 2.3-2.4: Complete grading + features (4 hours)
- Day 6: Final testing + docs (6 hours)
  - Task 2.5-2.6: Testing, analysis, documentation (6 hours)

**Total: 24 hours**

### Grand Total: 44 hours (~6 working days)

**Contingency**: +20% = 53 hours (~7 days)

**Timeline with Contingency**: 6-7 working days (reduced from 10-11 days)

---

## Rollout Strategy

### Infrastructure Gate: ✅ COMPLETE
**Completed** (reference-store-setup):
- [x] Store created and validated
- [x] All 62 files indexed successfully
- [x] Token reduction ≥60% confirmed
- [x] Query skill operational
- [x] Documentation complete

### Phase 1 Completion Gate
**Required for Phase 2**:
- [ ] Command file created and functional
- [ ] Claims checks work identically to original
- [ ] Performance benchmarks meet targets (≥60% token reduction)
- [ ] No content missed in test cases
- [ ] Cross-product testing passed

**Decision Point**: Proceed to Phase 2 or refine Phase 1

### Phase 2 Completion Gate
**Required for Production**:
- [ ] All 15 checks functional and accurate
- [ ] NPD Messaging and SciComms integration working
- [ ] Comprehensive testing passed
- [ ] Documentation complete
- [ ] Performance analysis showing 60-80% token reduction

**Decision Point**: Production rollout or additional testing

### Production Rollout
1. **Soft Launch** (Week 1): Use on 25% of reviews
2. **Monitoring** (Week 1-2): Track metrics, gather feedback
3. **Full Rollout** (Week 3): Use on 100% of reviews
4. **Optimization** (Ongoing): Refine queries, improve performance

---

## Maintenance Plan

### Ongoing Activities

**Weekly**:
- [ ] Monitor API usage and costs
- [ ] Check for API errors or failures
- [ ] Review performance metrics

**Monthly**:
- [ ] Review query performance and relevance
- [ ] Update queries if needed
- [ ] Verify reference material changes indexed

**Quarterly**:
- [ ] Re-index all reference materials
- [ ] Review and optimize queries
- [ ] Update documentation
- [ ] Audit data privacy compliance

### Update Procedures

**When Reference Materials Change**:
1. Identify changed files
2. Re-upload changed files to File Search
3. Verify indexing successful
4. Test queries return updated content
5. Document changes

**When API Updates**:
1. Review changelog
2. Test with new API version
3. Update scripts if needed
4. Update documentation
5. Deploy changes

---

## Appendix

### API Endpoints Reference

**Base URL**: `https://generativelanguage.googleapis.com/v1beta/`

**Stores**:
- CREATE: `POST /fileSearchStores?key=${KEY}`
- GET: `GET /fileSearchStores/{id}?key=${KEY}`
- LIST: `GET /fileSearchStores?key=${KEY}`
- DELETE: `DELETE /fileSearchStores/{id}?key=${KEY}`

**Files**:
- UPLOAD: `POST /upload/v1beta/{store}:uploadToFileSearchStore?key=${KEY}`

**Query**:
- GENERATE: `POST /v1beta/models/gemini-2.5-flash:generateContent?key=${KEY}`

### Pricing Reference

**File Search**:
- Indexing: $0.15 per 1M tokens (one-time)
- Storage: FREE (up to 1GB)
- Queries: FREE
- Context tokens: Charged at normal rate ($0.075 per 1M input)

**Estimated Costs**:
- Setup: ~$0.08 (500k tokens × $0.15/1M)
- Monthly: ~$5 (100 reviews × 15k tokens × $0.075/1M / 2)

### Contact Information

**Technical Support**:
- Google AI Developer Forum
- Gemini API Documentation
- Stack Overflow (tag: google-gemini)

**Escalation**:
- Google Cloud Support (if paid support plan)
- GitHub Issues for SDK bugs

---

## Revision History

| Date | Version | Changes | Author |
|------|---------|---------|--------|
| 2025-11-13 | 1.0 | Initial plan created | Claude Code |
| 2025-11-18 | 2.0 | Updated to reflect Phase 1 completion (reference-store-setup) | Claude Code |

**Major Changes in v2.0**:
- Reframed from "infrastructure creation" to "command integration"
- Removed Phase 1 (POC) - now complete as separate project
- Renumbered remaining phases (old Phase 2 → new Phase 1, old Phase 3 → new Phase 2)
- Reduced timeline from 69 hours to 44 hours (10-11 days → 6-7 days)
- Added "Already Completed" section with reference-store-setup details
- Updated all dependencies to reference existing store and skill

---

**Next Steps**: Begin Phase 1 - Partial Command Implementation (Claims checks)
