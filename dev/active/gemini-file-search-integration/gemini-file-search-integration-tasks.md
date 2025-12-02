# Gemini File Search Integration - Task Checklist

**Last Updated**: 2025-11-18
**Status**: Phase 1 Infrastructure Complete, Command Integration Pending
**Current Phase**: Pre-Phase 1 (Command Integration)

---

## Quick Reference

**Total Phases**: 2 (Phase 1 infrastructure complete in separate project)
**Estimated Duration**: 6-7 days
**Total Tasks**: 23 remaining (11 infrastructure tasks already complete)
**Completed**: 11/34 (32%)

---

## ✅ INFRASTRUCTURE COMPLETE (reference-store-setup)

**Status**: ✅ Completed 2025-11-18
**Duration**: 3.5 hours (single session)
**Project**: See `dev/active/reference-store-setup/` for complete details

### Completed Deliverables

✅ **Production File Search Store**:
- Store ID: `fileSearchStores/seed-reference-materials-pr-jma5jhay17is`
- 62/62 files uploaded successfully
- 0 failed documents
- 685 KB total size

✅ **Scripts Created**:
- `create-store.sh` - Store creation
- `upload-file.sh` - Single file upload with metadata
- `bulk-upload-reference.sh` - Bulk upload with automatic metadata extraction

✅ **Query Skill Created**:
- Location: `.claude/skills/gemini-file-search-seed-reference/`
- Query script operational
- 6 query patterns documented
- Metadata filtering working

✅ **Documentation Complete**:
- STORE_SUMMARY.md - Comprehensive store documentation
- README.md - Project overview
- HANDOFF_NOTES.md - Session notes
- SKILL.md - Skill documentation with usage patterns

**See**: `dev/active/reference-store-setup/reference-store-setup-tasks.md` for detailed task breakdown

---

## PHASE 1: Partial Command Implementation (Days 1-3)

### Section 1: Command Development (Days 1-2, 16 hours)

- [ ] **Task 1.1**: Create Command File [P0] [CRITICAL]
  - [ ] Create: `.claude/commands/review-draft-seed-perspective-gemini-file-search.md`
  - [ ] Implement: Step 1 (file identification) - same as original
  - [ ] Implement: Step 2 (product auto-detection) - same as original
  - [ ] Implement: Step 3 (File Search retrieval) - NEW
  - [ ] Implement: Step 4 (Grade 5 Claims checks) - adapted from original
  - [ ] Implement: Step 5 (Report with retrieval stats) - NEW
  - [ ] Implement: Step 6 (Apply fixes for Claims) - same as original
  - **Status**: Not Started
  - **Effort**: L
  - **Dependencies**: Infrastructure complete (reference-store-setup)

- [ ] **Task 1.2**: File Search Query Logic [P0] [CRITICAL]
  - [ ] Read production store ID from `dev/active/reference-store-setup/REFERENCE_STORE_ID`
  - [ ] Extract from article: keyword, ingredients, H2 headings, product
  - [ ] Build intelligent Claims query using patterns from skill
  - [ ] Execute query via `.claude/skills/gemini-file-search-seed-reference/scripts/query-store.sh`
  - [ ] Parse response correctly
  - [ ] Extract claims text from response
  - [ ] Extract grounding metadata (sources used)
  - **Status**: Not Started
  - **Effort**: L
  - **Dependencies**: 1.1

### Section 2: Claims Grading & Reporting (Day 2, 8 hours)

- [ ] **Task 1.3**: Claims Grading Implementation [P0] [CRITICAL]
  - [ ] Implement: Check 1 (PRIMARY authority >50% from Claims)
  - [ ] Implement: Check 2 (Specific DOI links to studies)
  - [ ] Implement: Check 3 (Health claims substantively supported)
  - [ ] Implement: Check 4 (Dose information matches Claims)
  - [ ] Implement: Check 5 (Claims attributed to correct ingredients)
  - [ ] Verify: Same results as original command
  - **Status**: Not Started
  - **Effort**: M
  - **Dependencies**: 1.2

- [ ] **Task 1.4**: Report Generation [P0] [CRITICAL]
  - [ ] Show: Retrieval statistics (docs retrieved, token usage, savings %)
  - [ ] Show: Source files used (from groundingMetadata)
  - [ ] Show: Check results (X/5 passed)
  - [ ] Show: Detailed findings per check
  - [ ] Show: Phase 1 status note (Claims only, more checks coming)
  - **Status**: Not Started
  - **Effort**: M
  - **Dependencies**: 1.3

### Section 3: Testing & Benchmarking (Day 3, 4 hours)

- [ ] **Task 1.5**: Cross-Product Testing [P0] [CRITICAL]
  - [ ] Test: DM-02 article (multivitamin topic)
  - [ ] Test: PM-02 article (sleep/melatonin topic)
  - [ ] Test: AM-02 article (energy/focus topic)
  - [ ] Test: Cross-product ingredient (PQQ/CoQ10/GABA)
  - [ ] For each: Measure token usage
  - [ ] For each: Verify retrieval relevance
  - [ ] For each: Compare grading vs original
  - [ ] For each: Confirm no false negatives
  - **Status**: Not Started
  - **Effort**: M
  - **Dependencies**: 1.4

- [ ] **Task 1.6**: Performance Benchmarking [P0] [CRITICAL]
  - [ ] Run: 5+ test reviews
  - [ ] Measure: Average token usage (File Search)
  - [ ] Measure: Average token usage (Original)
  - [ ] Calculate: Token reduction percentage
  - [ ] Measure: Execution time (both commands)
  - [ ] Calculate: Speed improvement factor
  - [ ] Calculate: Cost per review (both)
  - [ ] Verify: ≥60% token reduction
  - [ ] Verify: ≥2x speed improvement
  - [ ] Verify: 100% grading accuracy
  - **Status**: Not Started
  - **Effort**: M
  - **Dependencies**: 1.5

**Phase 1 Gate**:
- [ ] Command created and functional
- [ ] Claims checks work identically to original
- [ ] Performance benchmarks met (≥60% token reduction)
- [ ] No content missed in test cases
- [ ] Cross-product testing passed
- [ ] Decision: Proceed to Phase 2

---

## PHASE 2: Full Feature Parity (Days 4-6)

**NOTE**: Original Phase 2 (production indexing) is COMPLETE. This is full command integration with all 15 checks.

### Section 1: NPD Messaging Integration (Days 4-5, 14 hours)

- [ ] **Task 2.1**: NPD Messaging Query Implementation [P0] [CRITICAL]
  - [ ] Implement: Query 2 (NPD Messaging retrieval)
  - [ ] Include: Product context in query
  - [ ] Retrieve: Positioning, differentiators, narratives
  - [ ] Retrieve: Dirk Gevers quote suggestions
  - [ ] Parse: Response and extract messaging
  - **Status**: Not Started
  - **Effort**: M
  - **Dependencies**: Phase 1 complete

- [ ] **Task 2.2**: Product-Specific Checks (6-10) [P0] [CRITICAL]
  - [ ] Implement: DM-02 checks (soil depletion, bidirectional microbiome, ViaCap, bioavailability, mass-market critique)
  - [ ] Implement: PM-02 checks (precision dosing, sleep-gut-brain, dual-phase, high-dose critique, not overloading)
  - [ ] Implement: AM-02 checks (sustained energy, gut-mitochondria, cellular energy, nootropic, stimulant critique)
  - [ ] Verify: All checks match original command logic
  - **Status**: Not Started
  - **Effort**: L
  - **Dependencies**: 2.1

### Section 2: SciComms Integration (Day 5, 6 hours)

- [ ] **Task 2.3**: SciComms Query Implementation [P0] [CRITICAL]
  - [ ] Implement: Query 3 (SciComms retrieval)
  - [ ] Filter: Relevance to article topic
  - [ ] Retrieve: Talking points, narratives, sources
  - **Status**: Not Started
  - **Effort**: M
  - **Dependencies**: 2.2

- [ ] **Task 2.4**: SciComms Checks (11-15) [P0] [CRITICAL]
  - [ ] Implement: Check 11 (Relevant talking points)
  - [ ] Implement: Check 12 (Product narratives)
  - [ ] Implement: Check 13 (Additional sources)
  - [ ] Implement: Check 14 (Educational angle)
  - [ ] Implement: Check 15 (Dirk quote alignment)
  - **Status**: Not Started
  - **Effort**: L
  - **Dependencies**: 2.3

### Section 3: Complete Grading & Features (Day 5, 4 hours)

- [ ] **Task 2.5**: Complete Grading System [P0] [CRITICAL]
  - [ ] Verify: All 15 checks functional
  - [ ] Implement: Letter grade (A-F) calculation
  - [ ] Generate: Report with all 3 sections (A, B, C)
  - [ ] Assign: Priority levels correctly
  - [ ] Generate: Fix recommendations for all checks
  - **Status**: Not Started
  - **Effort**: M
  - **Dependencies**: 2.4

- [ ] **Task 2.6**: Advanced Features [P1]
  - [ ] Feature 1: Show retrieval sources from grounding metadata
  - [ ] Feature 2: Cache store ID with fallback
  - [ ] Feature 3: Error handling for missing/inaccessible store
  - [ ] Feature 4: Token usage comparison display
  - **Status**: Not Started
  - **Effort**: M
  - **Dependencies**: 2.5

### Section 4: Final Testing & Documentation (Day 6, 6 hours)

- [ ] **Task 2.7**: Comprehensive Testing [P0] [CRITICAL]
  - [ ] Test Matrix: 3 products × 3 lengths × 2 topic types
  - [ ] For each: Verify all 15 checks match original
  - [ ] For each: Verify no content missed
  - [ ] For each: Verify token usage in range
  - [ ] For each: Verify faster execution
  - [ ] For each: Verify 100% grading accuracy
  - [ ] Document: Test results for all cases
  - **Status**: Not Started
  - **Effort**: L
  - **Dependencies**: 2.6

- [ ] **Task 2.8**: Performance Analysis [P0] [CRITICAL]
  - [ ] Run: 10+ reviews across all products
  - [ ] Calculate: Average token usage
  - [ ] Calculate: Token reduction percentage
  - [ ] Calculate: Average execution time
  - [ ] Calculate: Speed improvement factor
  - [ ] Calculate: Cost per review
  - [ ] Calculate: Monthly cost savings
  - [ ] Generate: Performance comparison report
  - **Status**: Not Started
  - **Effort**: M
  - **Dependencies**: 2.7

- [ ] **Task 2.9**: Documentation Updates [P0] [CRITICAL]
  - [ ] Complete: Command documentation
  - [ ] Update: Main CLAUDE.md with command reference
  - [ ] Create: Troubleshooting guide
  - [ ] Document: Query pattern best practices
  - [ ] Document: When to use File Search command vs original
  - **Status**: Not Started
  - **Effort**: M
  - **Dependencies**: 2.8

- [ ] **Task 2.10**: Knowledge Transfer [P1]
  - [ ] Create: "How to Use" guide for new command
  - [ ] Document: When to use File Search vs original
  - [ ] Document: Maintenance procedures (re-indexing when files change)
  - [ ] Document: Cost monitoring and optimization
  - **Status**: Not Started
  - **Effort**: S
  - **Dependencies**: 2.9

**Phase 2 Gate**:
- [ ] All 15 checks functional and accurate
- [ ] Comprehensive testing passed
- [ ] Documentation complete
- [ ] Ready for production rollout

---

## Production Rollout

- [ ] **Soft Launch** (Week 1)
  - [ ] Use on 25% of reviews
  - [ ] Monitor metrics closely
  - [ ] Gather user feedback

- [ ] **Monitoring** (Week 1-2)
  - [ ] Track: Usage metrics
  - [ ] Track: Performance metrics
  - [ ] Track: Cost metrics
  - [ ] Track: Quality metrics
  - [ ] Address: Any issues found

- [ ] **Full Rollout** (Week 3)
  - [ ] Use on 100% of reviews
  - [ ] Update workflows
  - [ ] Communicate changes
  - [ ] Continue monitoring

- [ ] **Optimization** (Ongoing)
  - [ ] Refine queries based on usage
  - [ ] Improve performance
  - [ ] Update documentation
  - [ ] Quarterly re-indexing

---

## Progress Tracking

### By Phase
- **Infrastructure**: ✅ 11/11 tasks (100%) - COMPLETE
- **Phase 1 (Partial Command)**: 0/6 tasks (0%)
- **Phase 2 (Full Command)**: 0/10 tasks (0%)
- **Rollout**: 0/4 tasks (0%)

### Overall Progress
- **Completed**: 11/27 command tasks (41%)
- **With Infrastructure**: 11/38 total tasks (29%)

### By Priority
- **P0 (Critical)**: 0/15 remaining (11/26 total complete)
- **P1 (High)**: 0/4 remaining (0/4 complete)

### By Effort
- **S (Small)**: Varies by task
- **M (Medium)**: Varies by task
- **L (Large)**: Varies by task

---

## Notes & Blockers

### Current Blockers
*None* - Infrastructure complete, ready for command development

### Notes
- ✅ Infrastructure complete: Store operational, 62 files indexed, query skill available
- ✅ API key confirmed: AIzaSyDSii2SLQEV4wxRxzfErwp4OSB1T4Y9PXo
- ✅ Data privacy: Full protection, NOT used for training
- Target metrics: 60-80% token reduction, 2-5x speed improvement
- Original command remains as fallback
- Store ID: `fileSearchStores/seed-reference-materials-pr-jma5jhay17is`

### Next Session
**Start with**: Task 1.1 - Create Command File

**Prerequisites**: Review existing store and skill documentation before starting

---

**Last Updated**: 2025-11-18
**Next Review**: After Phase 1 completion (partial command)
