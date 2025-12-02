# Pre-Draft Seed Prep Command - Task Checklist

**Last Updated**: 2025-11-18
**Status**: Not Started
**Current Phase**: Planning Complete

---

## Quick Reference

**Total Phases**: 5
**Estimated Duration**: 10 working days
**Total Tasks**: 40
**Completed**: 0/40

---

## PHASE 1: Command Infrastructure (Days 1-2)

### Section 1.1: Command File Creation (Day 1, 3 hours)

- [ ] **Task 1.1.1**: Create Command File [P0] [CRITICAL]
  - [ ] Create `.claude/commands/pre-draft-seed-prep.md`
  - [ ] Add frontmatter with description
  - [ ] Define usage patterns
  - [ ] Set up basic structure
  - **Status**: Not Started
  - **Effort**: S

- [ ] **Task 1.1.2**: Implement File Identification Logic [P0] [CRITICAL]
  - [ ] Read keyword parameter
  - [ ] Construct path to stage1_analysis file
  - [ ] Handle missing file errors gracefully
  - **Status**: Not Started
  - **Effort**: S
  - **Dependencies**: 1.1.1

- [ ] **Task 1.1.3**: Set Up Agent Architecture [P0] [CRITICAL]
  - [ ] Define single orchestrating agent structure
  - [ ] Create agent instructions template
  - [ ] Plan sub-agent spawning if needed
  - **Status**: Not Started
  - **Effort**: M
  - **Dependencies**: 1.1.1

### Section 1.2: Output File Structure (Day 1, 2 hours)

- [ ] **Task 1.2.1**: Define stage2_seed-prep Schema [P0] [CRITICAL]
  - [ ] Design markdown structure with sections
  - [ ] Create template with placeholders
  - [ ] Document schema in plan
  - **Status**: Not Started
  - **Effort**: S

- [ ] **Task 1.2.2**: Implement File Writing [P0] [CRITICAL]
  - [ ] Write stage2 file to same folder as stage1
  - [ ] Add YAML frontmatter with metadata
  - [ ] Handle file write errors
  - **Status**: Not Started
  - **Effort**: S
  - **Dependencies**: 1.2.1

**Phase 1 Gate**:
- [ ] Command file exists and can be invoked
- [ ] File identification works
- [ ] Output schema defined
- [ ] Basic file writing functional

---

## PHASE 2: Research Logic (Days 2-4)

### Section 2.1: Competitive Analysis Parsing (Day 2, 4 hours)

- [ ] **Task 2.1.1**: Read stage1_analysis [P0] [CRITICAL]
  - [ ] Load complete file content
  - [ ] Parse markdown structure
  - [ ] Extract key sections (1-4)
  - **Status**: Not Started
  - **Effort**: M
  - **Dependencies**: 1.1.2

- [ ] **Task 2.1.2**: Identify Topics Needing Claims [P0] [CRITICAL]
  - [ ] Parse "must-cover topics" from Section 2
  - [ ] Extract ingredient mentions
  - [ ] Build topic list requiring evidence
  - **Status**: Not Started
  - **Effort**: M
  - **Dependencies**: 2.1.1

- [ ] **Task 2.1.3**: Parse External Sources [P1]
  - [ ] Extract citation table from Section 3
  - [ ] Store for potential reuse in gap-filling
  - [ ] Filter for academic sources only
  - **Status**: Not Started
  - **Effort**: M
  - **Dependencies**: 2.1.1

### Section 2.2: Product Identification (Day 3, 4 hours)

- [ ] **Task 2.2.1**: Map Ingredients to Products [P0] [CRITICAL]
  - [ ] Check which products contain identified ingredients
  - [ ] Read Claims directory structure
  - [ ] Identify primary and secondary products
  - **Status**: Not Started
  - **Effort**: M
  - **Dependencies**: 2.1.2

- [ ] **Task 2.2.2**: Load Product Claims Files [P0] [CRITICAL]
  - [ ] For primary product: read ALL Claims files
  - [ ] For secondary products: read relevant ingredient files
  - [ ] Handle missing files gracefully
  - **Status**: Not Started
  - **Effort**: L
  - **Dependencies**: 2.2.1

- [ ] **Task 2.2.3**: Load NPD Messaging & SciComms [P0] [CRITICAL]
  - [ ] Read ALL NPD Messaging docs (all 3 products)
  - [ ] Read SciComms files for identified product(s)
  - [ ] Store complete content
  - **Status**: Not Started
  - **Effort**: M
  - **Dependencies**: 2.2.1

### Section 2.3: Seed Narrative Development (Day 4, 4 hours)

- [ ] **Task 2.3.1**: Extract Product Positioning [P0] [CRITICAL]
  - [ ] Extract DM-02 positioning (soil depletion, microbiome, etc.)
  - [ ] Extract PM-02 positioning (precision dosing, sleep-gut-brain, etc.)
  - [ ] Extract AM-02 positioning (sustained energy, gut-mitochondria, etc.)
  - **Status**: Not Started
  - **Effort**: L
  - **Dependencies**: 2.2.3

- [ ] **Task 2.3.2**: Extract SciComms Talking Points [P1]
  - [ ] Identify relevant educational narratives
  - [ ] Filter for topic relevance
  - [ ] Extract unique perspectives
  - **Status**: Not Started
  - **Effort**: M
  - **Dependencies**: 2.2.3

- [ ] **Task 2.3.3**: Build Narrative Section [P0] [CRITICAL]
  - [ ] Synthesize "Seed's Unique Narrative" section
  - [ ] Contrast with competitive standard advice
  - [ ] Highlight key differentiators
  - **Status**: Not Started
  - **Effort**: M
  - **Dependencies**: 2.3.1, 2.3.2

**Phase 2 Gate**:
- [ ] stage1_analysis successfully parsed
- [ ] Products correctly identified
- [ ] All relevant Claims/Messaging files loaded
- [ ] Seed narrative section drafted

---

## PHASE 3: Hybrid Research (Days 5-7)

### Section 3.1: Seed Claims Extraction (Day 5, 6 hours)

- [ ] **Task 3.1.1**: Parse Claims Documents [P0] [CRITICAL]
  - [ ] Extract individual claims from all loaded files
  - [ ] Parse claim structure (text, links, doses, etc.)
  - [ ] Preserve complete metadata
  - **Status**: Not Started
  - **Effort**: L
  - **Dependencies**: 2.2.2

- [ ] **Task 3.1.2**: Match Claims to Topics [P0] [CRITICAL]
  - [ ] For each competitive baseline topic, find relevant claims
  - [ ] Score relevance
  - [ ] Identify gaps (topics without Seed claims)
  - **Status**: Not Started
  - **Effort**: L
  - **Dependencies**: 3.1.1, 2.1.2

- [ ] **Task 3.1.3**: Structure Seed Claims for Output [P0] [CRITICAL]
  - [ ] Extract complete DOI links
  - [ ] Parse author and year
  - [ ] Include doses, support levels, caveats
  - **Status**: Not Started
  - **Effort**: M
  - **Dependencies**: 3.1.2

### Section 3.2: Gap Identification & External Research (Day 6, 6 hours)

- [ ] **Task 3.2.1**: Identify Research Gaps [P0] [CRITICAL]
  - [ ] Compare baseline topics against matched Seed claims
  - [ ] List topics without Seed coverage
  - [ ] Prioritize gaps by importance
  - **Status**: Not Started
  - **Effort**: M
  - **Dependencies**: 3.1.2

- [ ] **Task 3.2.2**: Mine Competitive Analysis Sources [P0] [CRITICAL]
  - [ ] Check Section 3 citation table for relevant sources
  - [ ] Filter for primary academic sources
  - [ ] Extract structured citation info
  - **Status**: Not Started
  - **Effort**: M
  - **Dependencies**: 3.2.1, 2.1.3

- [ ] **Task 3.2.3**: Web Search for Additional Sources [P1]
  - [ ] For gaps not filled by competitive analysis
  - [ ] Use WebSearch for academic sources
  - [ ] Extract complete citation info
  - **Status**: Not Started
  - **Effort**: L
  - **Dependencies**: 3.2.2

### Section 3.3: Claims Assembly (Day 7, 4 hours)

- [ ] **Task 3.3.1**: Assemble Complete Claims Package [P0] [CRITICAL]
  - [ ] Combine Seed claims + external research
  - [ ] Target 12-15 total claims
  - [ ] Ensure >50% from Seed database
  - **Status**: Not Started
  - **Effort**: M
  - **Dependencies**: 3.1.3, 3.2.2, 3.2.3

- [ ] **Task 3.3.2**: Categorize Claims by Topic [P1]
  - [ ] Tag each claim with relevant topics
  - [ ] Group related claims
  - [ ] Suggest section placement
  - **Status**: Not Started
  - **Effort**: S
  - **Dependencies**: 3.3.1

**Phase 3 Gate**:
- [ ] All Seed claims extracted with complete metadata
- [ ] Gaps identified and filled with external research
- [ ] 12-15 total claims assembled
- [ ] >50% from Seed database (primary authority)

---

## PHASE 4: Output Generation (Day 8)

### Section 4.1: Compliance Checking (Day 8, 3 hours)

- [ ] **Task 4.1.1**: Load Compliance Documents [P0] [CRITICAL]
  - [ ] Read NO-NO-WORDS.md
  - [ ] Read What-We-Are-Not-Allowed-To-Say.md
  - [ ] Build forbidden words/phrases list
  - **Status**: Not Started
  - **Effort**: S

- [ ] **Task 4.1.2**: Check Narrative Content [P0] [CRITICAL]
  - [ ] Scan "Seed's Unique Narrative" section
  - [ ] Check for NO-NO words
  - [ ] Verify proper ingredient attribution
  - **Status**: Not Started
  - **Effort**: M
  - **Dependencies**: 4.1.1, 2.3.3

- [ ] **Task 4.1.3**: Check All Claims Text [P0] [CRITICAL]
  - [ ] Scan every claim text
  - [ ] Check for compliance violations
  - [ ] Verify no disease/cure language
  - **Status**: Not Started
  - **Effort**: M
  - **Dependencies**: 4.1.1, 3.3.1

### Section 4.2: File Generation (Day 8, 3 hours)

- [ ] **Task 4.2.1**: Populate stage2_seed-prep Template [P0] [CRITICAL]
  - [ ] Fill YAML frontmatter
  - [ ] Populate all sections
  - [ ] Format markdown correctly
  - **Status**: Not Started
  - **Effort**: M
  - **Dependencies**: All previous tasks

- [ ] **Task 4.2.2**: Write to File [P0] [CRITICAL]
  - [ ] Save to Generated-Drafts/[NNN]-[keyword]/
  - [ ] Verify file written successfully
  - [ ] Confirm same folder as stage1
  - **Status**: Not Started
  - **Effort**: S
  - **Dependencies**: 4.2.1, 1.2.2

- [ ] **Task 4.2.3**: Generate Summary Output [P1]
  - [ ] Display summary to user
  - [ ] Show products, claim counts
  - [ ] Flag any compliance warnings
  - **Status**: Not Started
  - **Effort**: S
  - **Dependencies**: 4.2.2

**Phase 4 Gate**:
- [ ] Compliance check completed
- [ ] stage2_seed-prep file generated
- [ ] File saved in correct location
- [ ] User receives clear summary

---

## PHASE 5: Gemini Integration (Days 9-10)

### Section 5.1: Update Gemini Instructions (Day 9, 4 hours)

- [ ] **Task 5.1.1**: Backup Current Instructions [P0] [CRITICAL]
  - [ ] Copy current Gemini instructions
  - [ ] Save with date stamp
  - [ ] Document changes
  - **Status**: Not Started
  - **Effort**: S

- [ ] **Task 5.1.2**: Simplify Gemini Steps [P0] [CRITICAL]
  - [ ] Remove Steps 2.5, 3, 4, 6
  - [ ] Add Step to read stage2_seed-prep
  - [ ] Update Input section
  - **Status**: Not Started
  - **Effort**: M
  - **Dependencies**: 5.1.1

- [ ] **Task 5.1.3**: Update Claims Usage Guidance [P0] [CRITICAL]
  - [ ] Instruct to use provided claims
  - [ ] Specify inline citation format
  - [ ] Clarify >50% Seed database requirement
  - **Status**: Not Started
  - **Effort**: S
  - **Dependencies**: 5.1.2

- [ ] **Task 5.1.4**: Add Example Usage [P1]
  - [ ] Include example of reading both docs
  - [ ] Show claim usage in draft
  - [ ] Provide citation list example
  - **Status**: Not Started
  - **Effort**: S
  - **Dependencies**: 5.1.2

### Section 5.2: End-to-End Testing (Day 10, 6 hours)

- [ ] **Task 5.2.1**: Test Command Execution [P0] [CRITICAL]
  - [ ] Run `/pre-draft-seed-prep` with existing analysis
  - [ ] Verify stage2 file created
  - [ ] Check all sections populated
  - **Status**: Not Started
  - **Effort**: M
  - **Dependencies**: All Phase 1-4 tasks

- [ ] **Task 5.2.2**: Test Gemini Drafting [P0] [CRITICAL]
  - [ ] Upload both stage files to Gemini
  - [ ] Upload compliance/style docs
  - [ ] Request draft generation
  - [ ] Verify quality and structure
  - **Status**: Not Started
  - **Effort**: L
  - **Dependencies**: 5.2.1, 5.1.2

- [ ] **Task 5.2.3**: Compare to Current Workflow [P0] [CRITICAL]
  - [ ] Generate same article using old workflow
  - [ ] Compare quality, claims, narrative
  - [ ] Verify no degradation
  - **Status**: Not Started
  - **Effort**: L
  - **Dependencies**: 5.2.2

- [ ] **Task 5.2.4**: Test Edge Cases [P1]
  - [ ] Test cross-product ingredients
  - [ ] Test minimal Seed claims (heavy external)
  - [ ] Test compliance violations (verify caught)
  - **Status**: Not Started
  - **Effort**: M
  - **Dependencies**: 5.2.1

### Section 5.3: Documentation (Day 10, 2 hours)

- [ ] **Task 5.3.1**: Update Command Documentation [P0] [CRITICAL]
  - [ ] Add usage examples
  - [ ] Document inputs/outputs
  - [ ] Include troubleshooting
  - **Status**: Not Started
  - **Effort**: S
  - **Dependencies**: 5.2.1

- [ ] **Task 5.3.2**: Update Workflow Documentation [P1]
  - [ ] Update Generated-Drafts/README.md
  - [ ] Add command to workflow
  - [ ] Update CLAUDE.md if needed
  - **Status**: Not Started
  - **Effort**: S
  - **Dependencies**: 5.2.3

**Phase 5 Gate**:
- [ ] Gemini instructions updated
- [ ] End-to-end testing completed
- [ ] Quality matches or exceeds current workflow
- [ ] Documentation complete

---

## Production Rollout

- [ ] **Soft Launch** (Week 1)
  - [ ] Use on 25% of new articles
  - [ ] Monitor quality metrics
  - [ ] Gather feedback

- [ ] **Monitoring** (Weeks 1-2)
  - [ ] Track execution success rate
  - [ ] Monitor Gemini token usage
  - [ ] Verify /review-draft-seed-perspective pass rate
  - [ ] Address any issues

- [ ] **Full Rollout** (Week 3)
  - [ ] Use on 100% of new articles
  - [ ] Update workflows
  - [ ] Communicate changes

---

## Progress Tracking

### By Phase
- **Phase 1**: 0/5 tasks (0%)
- **Phase 2**: 0/9 tasks (0%)
- **Phase 3**: 0/8 tasks (0%)
- **Phase 4**: 0/6 tasks (0%)
- **Phase 5**: 0/12 tasks (0%)
- **Rollout**: 0/3 tasks (0%)

### By Priority
- **P0 (Critical)**: 0/32 tasks (0%)
- **P1 (High)**: 0/8 tasks (0%)

### By Effort
- **S (Small)**: 0/14 tasks (0%)
- **M (Medium)**: 0/19 tasks (0%)
- **L (Large)**: 0/7 tasks (0%)

---

## Notes & Blockers

### Current Blockers
*None*

### Notes
- Direct file access chosen over File Search for deterministic results
- Target: 12-15 claims (>50% from Seed database)
- Compliance pre-check required for all stage2 content
- Gemini instructions to be drastically simplified

### Next Session
**Start with**: Task 1.1.1 - Create Command File

---

**Last Updated**: 2025-11-18
**Next Review**: After each phase completion
