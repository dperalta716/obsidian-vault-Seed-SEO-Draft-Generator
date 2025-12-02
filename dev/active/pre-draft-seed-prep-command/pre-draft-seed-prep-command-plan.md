# Pre-Draft Seed Prep Command - Implementation Plan

**Project**: `/pre-draft-seed-prep` Command Development
**Status**: Planning
**Created**: 2025-11-18
**Last Updated**: 2025-11-18

---

## Executive Summary

Create a new slash command `/pre-draft-seed-prep` that automates Seed-specific research and claim discovery for SEO article drafting. This command bridges the competitive analysis (stage1) and Gemini drafting by creating a comprehensive research package (stage2) containing all necessary Seed claims, external sources, product positioning, and narrative guidance.

**Key Value Proposition**:
- **Reduces Gemini cognitive load** by 85% - Gemini focuses on writing, not research
- **Maintains quality** through deterministic file access and compliance checking
- **Preserves Seed perspective** by pre-loading all product positioning and unique narratives
- **Enables complete citations** with all DOI links, authors, and years ready for inline use
- **Cost efficient** using direct file access instead of API calls

---

## Current State Analysis

### Existing Workflow

```
User provides keyword
  ↓
/pre-draft-competitor-analysis-v4
  ↓ Creates stage1_analysis-[keyword].md
  ↓ Contains: competitive baseline, user intent, PAA questions, external sources
  ↓
Gemini System Instructions (2025-10-16)
  ↓ Steps 1-6: Heavy research/discovery work
  ↓   - Product identification
  ↓   - Ingredient mapping
  ↓   - Claims doc searching
  ↓   - External research
  ↓   - Narrative development
  ↓   - Evidence gathering
  ↓ Steps after: Creative writing (outline, quote, draft)
  ↓
Final SEO article
```

### Pain Points

1. **Gemini overloaded with research**: Steps 2.5-6 require loading 50+ files (100k+ tokens)
2. **Inconsistent results**: Gemini might miss relevant claims or use wrong sources
3. **Token inefficiency**: Loads entire files when only portions needed
4. **Cognitive mismatch**: Research/discovery != creative writing strengths
5. **No compliance pre-check**: Claims might violate NO-NO words, discovered during drafting
6. **Citation assembly burden**: Gemini constructs DOI links from scattered sources

---

## Proposed Future State

### New Workflow

```
User provides keyword
  ↓
/pre-draft-competitor-analysis-v4
  ↓ Creates stage1_analysis-[keyword].md
  ↓
/pre-draft-seed-prep [keyword]  ← NEW COMMAND
  ↓ Reads stage1_analysis
  ↓ Identifies products & ingredients
  ↓ Reads relevant Claims docs (direct file access)
  ↓ Reads NPD Messaging & SciComms (all products)
  ↓ Discovers Seed claims (with complete DOI info)
  ↓ Fills gaps with external research
  ↓ Assembles 12-15 total claims
  ↓ Compliance checks all content
  ↓ Creates stage2_seed-prep-[keyword].md
  ↓
Gemini (Simplified Instructions)
  ↓ Reads stage1 + stage2 (two files only)
  ↓ Creates outline
  ↓ Writes draft using provided claims
  ↓ Generates citations list
  ↓
Final SEO article
```

### Benefits

✅ **Claude Code** handles research (its strength)
✅ **Gemini** handles writing (its strength)
✅ **85% token reduction** for Gemini (15k vs 100k)
✅ **Deterministic** - same input = consistent output
✅ **Complete citations** - all DOI links ready
✅ **Compliance-checked** - pre-validated content
✅ **Auditable** - see exactly what claims were chosen
✅ **Reproducible** - clear separation of concerns

---

## Implementation Phases

### Phase 1: Command Infrastructure (Days 1-2)
Create command scaffolding and basic workflow

### Phase 2: Research Logic (Days 3-5)
Implement product identification, file reading, and claim extraction

### Phase 3: Hybrid Research (Days 6-7)
Add external research capability and claim assembly

### Phase 4: Output Generation (Day 8)
Create stage2_seed-prep file with proper formatting

### Phase 5: Gemini Integration (Days 9-10)
Update Gemini instructions and test complete workflow

---

## Detailed Tasks

### PHASE 1: Command Infrastructure

#### Section 1.1: Command File Creation (Day 1, 3 hours)

**Task 1.1.1: Create Command File** [P0] [CRITICAL]
- Create `.claude/commands/pre-draft-seed-prep.md`
- Add frontmatter with description
- Define usage patterns
- Set up basic structure
- **Acceptance Criteria**:
  - File exists at correct path
  - Can be invoked with `/pre-draft-seed-prep [keyword]`
  - Accepts keyword parameter
- **Effort**: S
- **Dependencies**: None

**Task 1.1.2: Implement File Identification Logic** [P0] [CRITICAL]
- Read keyword parameter
- Construct path to stage1_analysis file
- Handle missing file errors gracefully
- **Acceptance Criteria**:
  - Finds stage1_analysis in Generated-Drafts/[NNN]-[keyword]/ folders
  - Returns clear error if not found
  - Suggests running /pre-draft-competitor-analysis-v4 first
- **Effort**: S
- **Dependencies**: 1.1.1

**Task 1.1.3: Set Up Agent Architecture** [P0] [CRITICAL]
- Define single orchestrating agent structure
- Create agent instructions template
- Plan sub-agent spawning if needed
- **Acceptance Criteria**:
  - Agent can be launched with Task tool
  - Clear instruction structure defined
  - Error handling framework in place
- **Effort**: M
- **Dependencies**: 1.1.1

#### Section 1.2: Output File Structure (Day 1, 2 hours)

**Task 1.2.1: Define stage2_seed-prep Schema** [P0] [CRITICAL]
- Design markdown structure with sections:
  - Product Identification
  - Seed's Unique Narrative
  - Complete Claims Package
  - Notes for Gemini
- Create template with placeholders
- **Acceptance Criteria**:
  - Schema documented in plan
  - Template ready for population
  - All required sections included
- **Effort**: S
- **Dependencies**: None

**Task 1.2.2: Implement File Writing** [P0] [CRITICAL]
- Write stage2 file to same folder as stage1
- Add YAML frontmatter with metadata
- Handle file write errors
- **Acceptance Criteria**:
  - File saved to Generated-Drafts/[NNN]-[keyword]/
  - Frontmatter includes date, keyword, products, claim counts
  - Overwrites existing stage2 if re-run
- **Effort**: S
- **Dependencies**: 1.2.1

---

### PHASE 2: Research Logic

#### Section 2.1: Competitive Analysis Parsing (Day 2, 4 hours)

**Task 2.1.1: Read stage1_analysis** [P0] [CRITICAL]
- Load complete file content
- Parse markdown structure
- Extract key sections
- **Acceptance Criteria**:
  - Can read stage1_analysis-[keyword].md
  - Extracts Section 1 (User Intent)
  - Extracts Section 2 (Competitive Baseline)
  - Extracts Section 3 (Citation Landscape)
  - Extracts Section 4 (PAA Questions)
- **Effort**: M
- **Dependencies**: 1.1.2

**Task 2.1.2: Identify Topics Needing Claims** [P0] [CRITICAL]
- Parse "must-cover topics" from Section 2
- Extract ingredient mentions
- Build topic list requiring evidence
- **Acceptance Criteria**:
  - Extracts all topics with "found in X/5 articles"
  - Identifies specific ingredients mentioned
  - Creates prioritized list of topics
- **Effort**: M
- **Dependencies**: 2.1.1

**Task 2.1.3: Parse External Sources** [P1]
- Extract citation table from Section 3
- Store for potential reuse in gap-filling
- Filter for academic sources only
- **Acceptance Criteria**:
  - Extracts all DOI links from Section 3
  - Categorizes as primary vs secondary sources
  - Stores with claim text and author/year
- **Effort**: M
- **Dependencies**: 2.1.1

#### Section 2.2: Product Identification (Day 3, 4 hours)

**Task 2.2.1: Map Ingredients to Products** [P0] [CRITICAL]
- Check which products contain identified ingredients
- Read Claims directory structure:
  - Claims/AM-02/
  - Claims/DM-02/
  - Claims/PM-02/
- Identify primary and secondary products
- **Acceptance Criteria**:
  - Correctly identifies primary product
  - Lists all products containing ingredients
  - Notes cross-product ingredients (PQQ, CoQ10, GABA)
- **Effort**: M
- **Dependencies**: 2.1.2

**Task 2.2.2: Load Product Claims Files** [P0] [CRITICAL]
- For primary product: read ALL Claims files
  - [PRODUCT]-General-Claims.md
  - [PRODUCT]-[Ingredient]-Claims.md for all ingredients
- For secondary products: read relevant ingredient files only
- **Acceptance Criteria**:
  - Loads complete General Claims for primary product
  - Loads all ingredient-specific Claims for mentioned ingredients
  - Handles missing files gracefully (some ingredients may not have Claims docs)
- **Effort**: L
- **Dependencies**: 2.2.1

**Task 2.2.3: Load NPD Messaging & SciComms** [P0] [CRITICAL]
- Read ALL NPD Messaging docs (all 3 products)
- Read SciComms files for identified product(s)
- **Acceptance Criteria**:
  - Loads AM-02, DM-02, PM-02 messaging docs
  - Loads SciComms Education files for relevant products
  - Stores complete content for narrative extraction
- **Effort**: M
- **Dependencies**: 2.2.1

#### Section 2.3: Seed Narrative Development (Day 4, 4 hours)

**Task 2.3.1: Extract Product Positioning** [P0] [CRITICAL]
- From NPD Messaging, extract for each product:
  - DM-02: Soil depletion, bidirectional microbiome, ViaCap®, bioavailability
  - PM-02: Precision dosing (0.5mg melatonin), sleep-gut-brain, dual-phase
  - AM-02: Sustained energy, gut-mitochondria, cellular optimization
- **Acceptance Criteria**:
  - Extracts all key positioning points for primary product
  - Identifies relevant angles for secondary products
  - Structures as "Standard Advice vs Seed's Angle"
- **Effort**: L
- **Dependencies**: 2.2.3

**Task 2.3.2: Extract SciComms Talking Points** [P1]
- Identify relevant educational narratives
- Filter for topic relevance (like review-draft-seed-perspective)
- Extract unique perspectives
- **Acceptance Criteria**:
  - Lists relevant SciComms sections
  - Filters out non-relevant content
  - Provides context for how to use in article
- **Effort**: M
- **Dependencies**: 2.2.3

**Task 2.3.3: Build Narrative Section** [P0] [CRITICAL]
- Synthesize "Seed's Unique Narrative" section
- Contrast with competitive standard advice
- Highlight key differentiators
- **Acceptance Criteria**:
  - Clear "Standard vs Seed" comparison
  - Specific positioning points listed
  - Actionable guidance for Gemini
- **Effort**: M
- **Dependencies**: 2.3.1, 2.3.2

---

### PHASE 3: Hybrid Research

#### Section 3.1: Seed Claims Extraction (Day 5, 6 hours)

**Task 3.1.1: Parse Claims Documents** [P0] [CRITICAL]
- For each loaded Claims file:
  - Extract individual claims (markdown sections)
  - Parse claim structure:
    - Claim text
    - Study link(s)
    - Author/year from links
    - Study dose
    - Product dose
    - Support level
    - Notes/caveats
- **Acceptance Criteria**:
  - Extracts all claims from General Claims files
  - Extracts all claims from ingredient-specific files
  - Preserves complete structure for each claim
- **Effort**: L
- **Dependencies**: 2.2.2

**Task 3.1.2: Match Claims to Topics** [P0] [CRITICAL]
- For each topic in competitive baseline:
  - Search extracted claims for relevance
  - Score relevance to topic
  - Select best matching claims
- **Acceptance Criteria**:
  - Each competitive baseline topic has associated Seed claims
  - Relevance scoring works correctly
  - Can identify when no Seed claims exist for topic (gap)
- **Effort**: L
- **Dependencies**: 3.1.1, 2.1.2

**Task 3.1.3: Structure Seed Claims for Output** [P0] [CRITICAL]
- For each matched claim:
  - Extract complete DOI link (https://doi.org/... format)
  - Parse author from link or text
  - Extract year from link or text
  - Include study dose, product dose, support level
  - Add source file reference
- **Acceptance Criteria**:
  - Every Seed claim has complete citation info
  - DOI links are working, complete URLs
  - Author and year correctly extracted
  - Ready for copy-paste into inline citations
- **Effort**: M
- **Dependencies**: 3.1.2

#### Section 3.2: Gap Identification & External Research (Day 6, 6 hours)

**Task 3.2.1: Identify Research Gaps** [P0] [CRITICAL]
- Compare competitive baseline topics against matched Seed claims
- List topics without Seed coverage
- Prioritize gaps by importance (from competitive analysis)
- **Acceptance Criteria**:
  - Clear list of topics needing external research
  - Gaps prioritized by competitive baseline frequency
  - Target: fill enough gaps to reach 12-15 total claims
- **Effort**: M
- **Dependencies**: 3.1.2

**Task 3.2.2: Mine Competitive Analysis Sources** [P0] [CRITICAL]
- For each gap topic:
  - Check Section 3 citation table for relevant sources
  - Filter for primary academic sources (DOI, PMC, PubMed, .edu)
  - Verify meets criteria:
    - Peer-reviewed
    - Recent (prefer last 10 years)
    - Relevant to specific gap topic
  - Extract: claim text, author, year, DOI link
- **Acceptance Criteria**:
  - Uses existing competitive analysis sources when suitable
  - Correctly filters for academic sources only
  - Extracts same structured info as Seed claims
- **Effort**: M
- **Dependencies**: 3.2.1, 2.1.3

**Task 3.2.3: Web Search for Additional Sources** [P1]
- For gaps not filled by competitive analysis:
  - Use WebSearch for academic sources
  - Target: meta-analyses, systematic reviews, recent studies
  - Extract structured citation info
- **Acceptance Criteria**:
  - Only searches when competitive analysis insufficient
  - Finds peer-reviewed academic sources
  - Extracts complete DOI, author, year info
- **Effort**: L
- **Dependencies**: 3.2.2

#### Section 3.3: Claims Assembly (Day 7, 4 hours)

**Task 3.3.1: Assemble Complete Claims Package** [P0] [CRITICAL]
- Combine Seed claims + external research
- Target total: 12-15 claims
- Ensure >50% from Seed database (maintains primary authority)
- **Acceptance Criteria**:
  - Total claims = 12-15
  - Seed claims ≥ 50% of total
  - All claims have complete citation info
  - Covers all major competitive baseline topics
- **Effort**: M
- **Dependencies**: 3.1.3, 3.2.2, 3.2.3

**Task 3.3.2: Categorize Claims by Topic** [P1]
- Tag each claim with relevant competitive baseline topic
- Group related claims together
- Suggest section placement
- **Acceptance Criteria**:
  - Each claim tagged with topic(s)
  - Claims logically grouped
  - Usage guidance provided for Gemini
- **Effort**: S
- **Dependencies**: 3.3.1

---

### PHASE 4: Output Generation

#### Section 4.1: Compliance Checking (Day 8, 3 hours)

**Task 4.1.1: Load Compliance Documents** [P0] [CRITICAL]
- Read NO-NO-WORDS.md
- Read What-We-Are-Not-Allowed-To-Say.md
- Build forbidden words/phrases list
- **Acceptance Criteria**:
  - Both compliance files loaded
  - Forbidden terms extracted
  - Rules understood and codified
- **Effort**: S
- **Dependencies**: None

**Task 4.1.2: Check Narrative Content** [P0] [CRITICAL]
- Scan "Seed's Unique Narrative" section
- Check for NO-NO words
- Verify proper ingredient attribution
- Flag any issues
- **Acceptance Criteria**:
  - Detects forbidden words in narrative
  - Verifies claims use "formulated with ingredients that..."
  - Provides clear warnings for violations
- **Effort**: M
- **Dependencies**: 4.1.1, 2.3.3

**Task 4.1.3: Check All Claims Text** [P0] [CRITICAL]
- Scan every claim text (both Seed and external)
- Check for compliance violations
- Verify no disease/cure language
- **Acceptance Criteria**:
  - Every claim checked against compliance rules
  - Flags problematic language
  - Suggests compliant alternatives where possible
- **Effort**: M
- **Dependencies**: 4.1.1, 3.3.1

#### Section 4.2: File Generation (Day 8, 3 hours)

**Task 4.2.1: Populate stage2_seed-prep Template** [P0] [CRITICAL]
- Fill in all sections:
  - YAML frontmatter (date, keyword, products, claim counts)
  - Product Identification
  - Seed's Unique Narrative
  - Complete Claims Package (all 12-15 claims)
  - Notes for Gemini
- Format markdown correctly
- **Acceptance Criteria**:
  - All sections populated with actual data
  - Markdown formatting correct
  - Claims formatted consistently
  - DOI links properly hyperlinked
- **Effort**: M
- **Dependencies**: All previous tasks

**Task 4.2.2: Write to File** [P0] [CRITICAL]
- Save to Generated-Drafts/[NNN]-[keyword]/stage2_seed-prep-[keyword].md
- Verify file written successfully
- Confirm in same folder as stage1_analysis
- **Acceptance Criteria**:
  - File saved to correct location
  - Can be read back successfully
  - Located next to stage1_analysis file
- **Effort**: S
- **Dependencies**: 4.2.1, 1.2.2

**Task 4.2.3: Generate Summary Output** [P1]
- Display summary to user:
  - File location
  - Products identified
  - Claim counts (Seed vs external)
  - Any compliance warnings
  - Next steps (use in Gemini)
- **Acceptance Criteria**:
  - Clear, informative summary
  - Highlights any issues
  - Provides actionable next steps
- **Effort**: S
- **Dependencies**: 4.2.2

---

### PHASE 5: Gemini Integration

#### Section 5.1: Update Gemini Instructions (Day 9, 4 hours)

**Task 5.1.1: Backup Current Instructions** [P0] [CRITICAL]
- Copy current Gemini instructions file
- Save as `.backup-YYYY-MM-DD` version
- Document what changed and why
- **Acceptance Criteria**:
  - Backup created with date stamp
  - Header added explaining changes
  - Original preserved completely
- **Effort**: S
- **Dependencies**: None

**Task 5.1.2: Simplify Gemini Steps** [P0] [CRITICAL]
- Remove Steps 2.5, 3, 4, 6 (now handled by Claude)
- Add Step to read stage2_seed-prep
- Update Input section to list both stage files
- **Acceptance Criteria**:
  - Instructions drastically simplified
  - Clear reference to both stage1 and stage2 files
  - Maintains compliance/style doc access
  - Preserves all creative steps (outline, quote, FAQ, writing)
- **Effort**: M
- **Dependencies**: 5.1.1

**Task 5.1.3: Update Claims Usage Guidance** [P0] [CRITICAL]
- Instruct Gemini to use provided claims from stage2
- Specify inline citation format: `([Author Year](DOI_URL))`
- Clarify >50% must be Seed database claims
- **Acceptance Criteria**:
  - Clear guidance on using stage2 claims
  - Citation format explicitly stated
  - Primary authority requirement maintained
- **Effort**: S
- **Dependencies**: 5.1.2

**Task 5.1.4: Add Example Usage** [P1]
- Include example of reading both prep docs
- Show how to use claims in draft
- Provide citation list example
- **Acceptance Criteria**:
  - Concrete examples provided
  - Reduces ambiguity for Gemini
  - Demonstrates expected workflow
- **Effort**: S
- **Dependencies**: 5.1.2

#### Section 5.2: End-to-End Testing (Day 10, 6 hours)

**Task 5.2.1: Test Command Execution** [P0] [CRITICAL]
- Run `/pre-draft-seed-prep` with existing competitive analysis
- Verify stage2 file created correctly
- Check all sections populated
- **Acceptance Criteria**:
  - Command executes without errors
  - stage2 file generated in correct location
  - All sections present and populated
  - Claims have complete DOI info
- **Effort**: M
- **Dependencies**: All Phase 1-4 tasks

**Task 5.2.2: Test Gemini Drafting** [P0] [CRITICAL]
- Upload both stage1 and stage2 to Gemini
- Upload compliance/style docs
- Request draft generation
- Verify quality and structure
- **Acceptance Criteria**:
  - Gemini can read both files
  - Uses provided claims correctly
  - Inline citations formatted properly
  - Citations list at end complete
  - Seed narrative incorporated
- **Effort**: L
- **Dependencies**: 5.2.1, 5.1.2

**Task 5.2.3: Compare to Current Workflow** [P0] [CRITICAL]
- Generate same article using old workflow
- Compare quality, claims usage, narrative
- Verify no degradation
- **Acceptance Criteria**:
  - New workflow maintains or improves quality
  - All Seed perspective checks still pass
  - Token usage reduced as expected (85%)
  - No missing critical content
- **Effort**: L
- **Dependencies**: 5.2.2

**Task 5.2.4: Test Edge Cases** [P1]
- Test with cross-product ingredients (PQQ, CoQ10)
- Test with minimal Seed claims (heavy external research)
- Test with compliance violations (verify caught)
- **Acceptance Criteria**:
  - Cross-product handling correct
  - External research fills gaps properly
  - Compliance checking works
- **Effort**: M
- **Dependencies**: 5.2.1

#### Section 5.3: Documentation (Day 10, 2 hours)

**Task 5.3.1: Update Command Documentation** [P0] [CRITICAL]
- Add usage examples to command file
- Document expected inputs/outputs
- Include troubleshooting section
- **Acceptance Criteria**:
  - Clear usage instructions
  - Examples for different scenarios
  - Common issues documented
- **Effort**: S
- **Dependencies**: 5.2.1

**Task 5.3.2: Update Workflow Documentation** [P1]
- Update Generated-Drafts/README.md
- Add new command to workflow
- Update CLAUDE.md if needed
- **Acceptance Criteria**:
  - Workflow docs reflect new command
  - Integration points clear
  - Benefits articulated
- **Effort**: S
- **Dependencies**: 5.2.3

---

## Risk Assessment & Mitigation

### Technical Risks

**Risk 1: File Parsing Complexity**
- **Impact**: High - Incorrect parsing = bad claims
- **Likelihood**: Medium
- **Mitigation**:
  - Extensive testing with all Claims file formats
  - Validate parsing against known good examples
  - Add detailed error logging

**Risk 2: DOI Link Extraction**
- **Impact**: High - Broken links = unusable citations
- **Likelihood**: Medium
- **Mitigation**:
  - Verify all extracted DOIs are complete URLs
  - Test link format with curl or similar
  - Validate against expected patterns

**Risk 3: Product Identification Accuracy**
- **Impact**: Medium - Wrong product = wrong positioning
- **Likelihood**: Low
- **Mitigation**:
  - Use multiple signals (ingredients, topics, keywords)
  - Default to checking all products if uncertain
  - Log decision reasoning for debugging

**Risk 4: External Research Quality**
- **Impact**: High - Bad sources = compliance issues
- **Likelihood**: Medium
- **Mitigation**:
  - Strict filtering for academic sources only
  - Prefer competitive analysis sources (pre-vetted)
  - Manual review of gap-fill sources in testing

### Integration Risks

**Risk 5: Gemini Behavior Change**
- **Impact**: High - Simplified instructions might confuse Gemini
- **Likelihood**: Medium
- **Mitigation**:
  - Gradual rollout with A/B testing
  - Keep old instructions available as fallback
  - Extensive prompt engineering iteration

**Risk 6: Token Usage Spike**
- **Impact**: Medium - stage2 file might be too large
- **Likelihood**: Low
- **Mitigation**:
  - Target 40-60k tokens for stage2 (vs 100k+ currently)
  - Optimize claim formatting for conciseness
  - Monitor actual token usage in testing

### Quality Risks

**Risk 7: Seed Perspective Dilution**
- **Impact**: Critical - Must maintain Seed's unique voice
- **Likelihood**: Low
- **Mitigation**:
  - Comprehensive testing against /review-draft-seed-perspective
  - Explicit narrative guidance in stage2
  - Regular quality spot-checks

**Risk 8: Compliance Violations**
- **Impact**: Critical - Non-compliant content unusable
- **Likelihood**: Low
- **Mitigation**:
  - Pre-check all stage2 content
  - Automated scanning for NO-NO words
  - Manual review of external sources

---

## Success Metrics

### Quantitative Metrics

1. **Token Reduction**: Gemini session uses ≤ 20k tokens (vs 100k+ baseline)
2. **Claim Accuracy**: 100% of claims have complete DOI, author, year
3. **Seed Authority**: ≥ 50% of claims from Seed database
4. **Compliance Pass Rate**: 100% of stage2 files pass compliance check
5. **Command Success Rate**: ≥ 95% successful executions without errors

### Qualitative Metrics

6. **Seed Perspective Preservation**: Drafts pass all 15 checks in /review-draft-seed-perspective
7. **Narrative Integration**: Seed's unique angles clearly present in stage2 output
8. **Citation Quality**: All inline citations properly formatted with working links
9. **Gemini Usability**: Simplified instructions produce expected output without confusion
10. **User Satisfaction**: David finds workflow improvement valuable

---

## Required Resources & Dependencies

### Technical Dependencies

- **Existing Commands**:
  - `/pre-draft-competitor-analysis-v4` (provides stage1_analysis)
  - `/review-draft-seed-perspective` (reference for Seed perspective checks)

- **Reference Files**:
  - All Claims docs (AM-02, DM-02, PM-02)
  - NPD Messaging docs (3 files)
  - SciComms Education files
  - Compliance docs (NO-NO-WORDS, What-We-Are-Not-Allowed-To-Say)

- **Tools**:
  - Claude Code (for command execution)
  - Gemini AI Studio (for drafting)
  - Bash (for file operations)
  - Markdown parsing capabilities

### Knowledge Dependencies

- **File Formats**: Understanding of Claims doc structure
- **Seed Positioning**: Deep knowledge of product differentiation
- **Compliance Rules**: Familiarity with forbidden language
- **Citation Formats**: APA, inline citation patterns

---

## Timeline Estimates

### By Phase

- **Phase 1** (Infrastructure): 2 days
- **Phase 2** (Research Logic): 3 days
- **Phase 3** (Hybrid Research): 2 days
- **Phase 4** (Output Generation): 1 day
- **Phase 5** (Integration & Testing): 2 days

**Total**: 10 working days

### By Effort Level

- **S (Small)**: 14 tasks × 2 hours = 28 hours
- **M (Medium)**: 20 tasks × 4 hours = 80 hours
- **L (Large)**: 6 tasks × 8 hours = 48 hours

**Total**: 156 hours (~20 working days at 8 hours/day)

**Note**: Timeline assumes sequential work. With parallel development (e.g., compliance checking while building research logic), could compress to 10-12 days.

---

## Next Steps

1. **Review & Approve Plan**: Confirm approach aligns with vision
2. **Set Up Task Tracking**: Use pre-draft-seed-prep-command-tasks.md checklist
3. **Begin Phase 1**: Create command file and basic structure
4. **Iterative Development**: Build, test, refine each phase
5. **Integration Testing**: Verify complete workflow with Gemini
6. **Production Rollout**: Replace old workflow once validated

---

**Last Updated**: 2025-11-18
**Next Review**: After Phase 1 completion
