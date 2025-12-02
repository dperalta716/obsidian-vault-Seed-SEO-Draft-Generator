# Pre-Draft Seed Prep Command - Context & Reference

**Last Updated**: 2025-11-18

---

## Project Context

### Purpose

Create `/pre-draft-seed-prep` command to handle all Seed-specific research and claim discovery, generating a comprehensive research package that allows Gemini to focus purely on creative writing instead of research.

### Business Driver

Current Gemini workflow requires loading 50+ reference files (100k+ tokens) and performing heavy research work (product mapping, claim discovery, external research). This creates:
- Cognitive overload for Gemini
- Inconsistent results
- Token inefficiency
- Difficulty reproducing quality

Solution: Claude Code handles research (its strength), Gemini handles writing (its strength).

---

## Key Files & Locations

### Input Files

**Stage 1 Competitive Analysis**:
```
Generated-Drafts/[NNN]-[keyword]/stage1_analysis-[keyword].md
```
- Created by `/pre-draft-competitor-analysis-v4`
- Contains: competitive baseline, user intent, PAA questions, external sources
- Structure:
  - Section 1: User Search Intent
  - Section 2: Competitive Baseline Requirements
  - Section 3: Citation & Evidence Landscape
  - Section 4: People Also Ask Questions
  - Section 5: Article-by-Article Analysis
  - Section 6: Synthesis for Drafting

### Reference Files (Direct Access)

**Claims Documents**:
```
Reference/Claims/
├── AM-02/
│   ├── AM-02-General-Claims.md
│   ├── AM-02-[Ingredient]-Claims.md (14 files)
├── DM-02/
│   ├── DM-02-General-Claims.md
│   ├── DM-02-[Ingredient]-Claims.md (24 files)
├── PM-02/
│   ├── PM-02-General-Claims.md
│   ├── PM-02-[Ingredient]-Claims.md (11 files)
└── Cross-Product-General-Claims.md
```

**NPD Messaging**:
```
Reference/NPD-Messaging/
├── AM-02 Product Messaging Reference Documents.md
├── DM-02 Product Messaging Reference Documents.md
└── PM-02 Product Messaging Reference Documents.md
```

**SciComms Education**:
```
Reference/SciComms Education Files/
├── AM-02 SciComms [...] Education.md
├── DM-02 SciComms [...] Education.md
└── PM-02 SciComms [...] Education.md
```

**Compliance**:
```
Reference/Compliance/
├── NO-NO-WORDS.md
└── What-We-Are-Not-Allowed-To-Say.md
```

### Output File

**Stage 2 Seed Prep**:
```
Generated-Drafts/[NNN]-[keyword]/stage2_seed-prep-[keyword].md
```
- Created by `/pre-draft-seed-prep`
- Contains: product mapping, Seed narrative, 12-15 claims with DOIs, Gemini guidance

### Command File

**Command Location**:
```
.claude/commands/pre-draft-seed-prep.md
```

### Gemini Instructions

**Current (To Be Updated)**:
```
Gemini Drafting Instructions/2025-10-16-Gemini-System-Instructions.md
```

**New Version**:
```
Gemini Drafting Instructions/2025-11-18-Gemini-System-Instructions-v2.md
```

---

## Critical Technical Decisions

### Decision 1: Direct File Access vs File Search (LOCKED IN)

**Choice**: Use direct file access to read Reference/ folder files

**Rationale**:
- **Deterministic & Complete**: Get FULL file content, never miss DOI links
- **No API costs**: Free vs ~$0.10/article with File Search
- **Faster**: No API roundtrips, just local reads
- **Predictable**: File structure is known and stable
- **Complete handoff**: Gemini needs full context, not filtered excerpts

**When to use File Search instead**:
- Ad-hoc queries ("What does Seed say about X?")
- Review workflows (grading, compliance checking)
- Cross-product comparisons
- When you DON'T know which files to read

### Decision 2: Hybrid Claims Approach (LOCKED IN)

**Choice**: Combine Seed database claims + external research

**Target**: 12-15 total claims
- ≥50% from Seed Claims docs (maintains primary authority)
- Remainder from external academic sources (fills competitive baseline gaps)

**External Research Priority**:
1. First: Check competitive analysis Section 3 (pre-vetted sources)
2. If insufficient: Use web search for academic sources
3. Always filter for: peer-reviewed, recent (last 10 years), primary sources only

### Decision 3: Output Format (LOCKED IN)

**Structure**: Markdown file with sections:
- YAML frontmatter (metadata)
- Product Identification
- Seed's Unique Narrative
- Complete Claims Package (12-15 claims, each with full citation info)
- Notes for Gemini

**Each Claim Includes**:
- Claim text
- Source (Seed database or external)
- Author + Year
- Complete DOI link (https://doi.org/... or https://pmc.ncbi.nlm.nih.gov/...)
- Study dose (if applicable)
- Product dose (if applicable)
- Support level
- Caveats/notes
- Source file reference
- Usage guidance

### Decision 4: Seed Narrative Extraction (LOCKED IN)

**Extract from NPD Messaging** product-specific positioning:
- **DM-02**: Soil depletion, bidirectional microbiome-nutrition, ViaCap® delivery, bioavailability
- **PM-02**: Precision melatonin dosing (0.5mg), sleep-gut-brain axis, dual-phase release
- **AM-02**: Sustained energy (not stimulants), gut-mitochondria axis, cellular optimization

**Extract from SciComms** educational narratives (filtered for relevance)

**Format as**: "Standard Advice vs Seed's Contrasting Perspective"

### Decision 5: Compliance Pre-Check (LOCKED IN)

**Check ALL stage2 content** against:
- NO-NO-WORDS.md (forbidden terms)
- What-We-Are-Not-Allowed-To-Say.md (compliance rules)
- Proper ingredient attribution ("formulated with ingredients that..." not "product supports...")
- No disease/cure claims

**Action**: Flag violations before outputting file

### Decision 6: Product Identification Logic (LOCKED IN)

**Method**:
1. Extract ingredients/topics from competitive baseline
2. Check which products contain those ingredients (scan Claims directory)
3. Identify primary product (most relevant) and secondary products
4. Note cross-product ingredients (PQQ, CoQ10, GABA)

**Load Strategy**:
- Primary product: ALL Claims files (General + all ingredients)
- Secondary products: Only relevant ingredient files
- Always load: ALL NPD Messaging (3 files), relevant SciComms

---

## Integration Points

### With Existing Workflows

**Depends On**:
- `/pre-draft-competitor-analysis-v4` → Creates stage1_analysis input

**Feeds Into**:
- Gemini drafting → Uses stage2_seed-prep as research package

**Similar To**:
- `/review-draft-seed-perspective` → Same Seed perspective extraction logic

**Validates With**:
- `/review-draft-seed-perspective` → Final drafts should pass all 15 checks

### With Gemini

**Gemini Receives**:
- stage1_analysis-[keyword].md (competitive baseline, PAA)
- stage2_seed-prep-[keyword].md (Seed research package)
- Direct access to Compliance docs (for drafting)
- Direct access to Style docs (for tone/voice)

**Gemini No Longer Needs**:
- Product identification (done by Claude)
- Claims doc searching (claims pre-selected)
- External research (already gathered)
- Narrative development (pre-articulated)

**Gemini Still Does**:
- Create article outline
- Draft Dirk Gevers quote
- Select 4 FAQ questions from PAA
- Write article with Seed's voice
- Apply tone/readability guidelines
- Generate citations list

---

## Data Model

### stage1_analysis Structure

```markdown
## 1. User Search Intent
- Primary Intent: [text]
- Core Questions: [list]

## 2. Competitive Baseline Requirements
### Topics That MUST Be Covered:
1. [Topic] - Found in X/5 articles
   - Typical depth/angle: [description]

## 3. Citation & Evidence Landscape
### Primary Research Sources:
| Claim | Source | DOI/Link | Used By |

## 4. People Also Ask Questions
1. [Question] - Selected because: [rationale]
```

### stage2_seed-prep Structure

```markdown
---
date: YYYY-MM-DD
keyword: "[keyword]"
primary_product: [AM-02|DM-02|PM-02]
secondary_products: [[list]]
total_claims: 14
seed_claims: 9
external_claims: 5
---

## PRODUCT IDENTIFICATION
Primary Product: [...]
Relevant Ingredients: [...]
Cross-Product Ingredients: [...]

## SEED'S UNIQUE NARRATIVE
### Standard Advice (from Competitors)
[What competitors say]

### Seed's Contrasting Perspective
[Seed's unique angles]

### Key Angles to Weave Throughout Article
1. [Angle with source]
2. [...]

## COMPLETE CLAIMS PACKAGE (14 Total)

### CLAIM 1: [Claim Name]
**Category**: Seed Database | External Research
**Source File**: [filename if Seed]
**Supports Topic**: [competitive baseline topic]

**Claim Text**: "[the actual claim]"

**Citation Info**:
- **Author**: [Last name]
- **Year**: [YYYY]
- **DOI Link**: [complete URL]
- **Study Dose**: [if applicable]
- **Support Level**: High|Medium|Low

**Additional Context**: [key details]
**Notes/Caveats**: [warnings, limitations]
**Usage Guidance**: [when/how to use in article]

[Repeat for all 12-15 claims]

## CLAIMS BREAKDOWN SUMMARY
Total: 14
From Seed: 9 (64%)
From External: 5 (36%)

## NOTES FOR GEMINI DRAFTER
[Guidance on using this package]
```

### Claims Document Structure

**General Claims Files**:
```markdown
# [PRODUCT]-General-Claims.md

## Claim 1: [Name]
### Claim
✅ [Claim text]

### Substantiation
[Detailed explanation]

### Study Link
[URL(s)]

### Notes/Caveats
[Additional info]
```

**Ingredient Claims Files**:
```markdown
# [PRODUCT]-[Ingredient]-Claims.md

## Study 1: [Study Name]
**Link**: [URL]

### Claims
✅ [Claim 1]
✅ [Claim 2]

### Study Dose
[Amount used in study]

### Dose Matched
Yes|No|Partial

### Support for Claim
High|Medium|Low

### Notes/Caveats
[Warnings, context]

## [PRODUCT] Product Information
- Dose: [amount]
- % DV: [percentage]
```

---

## Query Patterns

### Product Identification Pattern

```bash
# Extract ingredients from competitive baseline
INGREDIENTS=$(grep -A 5 "must-cover topics" stage1_analysis.md | parse_topics)

# Check which products contain these ingredients
for PRODUCT in AM-02 DM-02 PM-02; do
  for INGREDIENT in $INGREDIENTS; do
    if [ -f "Reference/Claims/${PRODUCT}/${PRODUCT}-${INGREDIENT}-Claims.md" ]; then
      echo "$PRODUCT contains $INGREDIENT"
    fi
  done
done
```

### Claims Extraction Pattern

```bash
# Read all General Claims
cat Reference/Claims/DM-02/DM-02-General-Claims.md

# Parse into structured claims
# Each claim has: title, claim text, substantiation, study links, notes

# Extract DOI from study links
# Pattern: https://doi.org/... or https://pmc.ncbi.nlm.nih.gov/... or https://pubmed.ncbi.nlm.nih.gov/...

# Parse author/year from text or link
```

### External Research Pattern

```bash
# For gap topic not covered by Seed:

# 1. Check competitive analysis Section 3
if source_in_section3(gap_topic):
  if is_academic_source(source) and is_recent(source):
    use_source()
  fi
fi

# 2. If not found, web search
if still_need_source:
  web_search("${gap_topic} academic study peer-reviewed")
  filter_for_primary_sources()
fi
```

---

## Testing Strategy

### Unit Testing

**Test File Parsing**:
- Read and parse all Claims file formats
- Extract claims correctly from both General and Ingredient files
- Handle missing files gracefully

**Test Product Identification**:
- Correctly map ingredients to products
- Identify cross-product ingredients
- Handle edge cases (no matching products, multiple matches)

**Test Claims Extraction**:
- Extract complete DOI links
- Parse author and year correctly
- Preserve all claim metadata

**Test Compliance Checking**:
- Detect NO-NO words
- Flag improper attribution
- Catch disease/cure language

### Integration Testing

**End-to-End Flows**:
1. stage1_analysis → stage2_seed-prep generation → verify output
2. stage2_seed-prep → Gemini drafting → verify article quality
3. Complete workflow → /review-draft-seed-perspective grading → verify passes all checks

**Test Cases**:
- DM-02 article (primary: multivitamin)
- PM-02 article (primary: sleep)
- AM-02 article (primary: energy)
- Cross-product ingredient (PQQ appears in all three)
- Minimal Seed claims (heavy external research needed)
- Compliance violation (verify caught and flagged)

### Performance Testing

**Metrics**:
- Command execution time: < 60 seconds
- stage2 file size: 40-60k tokens (vs 100k+ currently loaded)
- Gemini token usage: ≤ 20k (vs 100k+ baseline)
- Claim assembly: 12-15 total, >50% from Seed

---

## Troubleshooting Guide

### Common Issues

**Issue**: stage1_analysis not found
**Solution**:
- Verify `/pre-draft-competitor-analysis-v4` was run first
- Check keyword spelling matches folder name
- Ensure file exists in Generated-Drafts/[NNN]-[keyword]/

**Issue**: No Seed claims found for topic
**Solution**:
- Expected for some topics - will use external research
- Verify Claims files loaded correctly
- Check ingredient name variations (e.g., "vitamin D" vs "Vitamin-D")

**Issue**: Incomplete DOI links extracted
**Solution**:
- Verify Claims files have complete URLs
- Check regex patterns for DOI extraction
- Manually inspect source Claims file

**Issue**: Wrong product identified
**Solution**:
- Review ingredient mapping logic
- Check for cross-product ingredients (might be multiple products)
- Verify competitive baseline parsing is correct

**Issue**: Compliance violations flagged
**Solution**:
- Review flagged text in stage2 output
- Check against NO-NO-WORDS and compliance rules
- Revise narrative or claim wording
- May need to adjust Claims source selection

**Issue**: External research quality concerns
**Solution**:
- Verify sources are peer-reviewed academic
- Check publication dates (prefer last 10 years)
- Review competitive analysis Section 3 first
- Use web search only as last resort

---

## Resources

### Documentation

**Internal**:
- `/review-draft-seed-perspective` command (similar logic for Seed perspective extraction)
- `Gemini Drafting Instructions/2025-10-16-Gemini-System-Instructions.md` (current workflow)
- `Generated-Drafts/README.md` (workflow overview)

**Reference Materials**:
- All files in `Reference/` directory
- Claims file formats and structures
- NPD Messaging positioning docs
- Compliance rules

### Code References

**Similar Commands**:
- `/pre-draft-competitor-analysis-v4` (stage1 generation)
- `/review-draft-seed-perspective` (Seed perspective checking)
- `/review-claims-3-v2` (claims verification)

**File Reading Patterns**:
```bash
# Read all files in directory
for file in Reference/Claims/DM-02/*.md; do
  cat "$file"
done

# Check file exists before reading
if [ -f "path/to/file.md" ]; then
  cat "path/to/file.md"
fi

# Parse markdown sections
awk '/^## Claim [0-9]+/,/^## /' file.md
```

---

## Glossary

**Stage1 Analysis**: Competitive baseline analysis created by `/pre-draft-competitor-analysis-v4`

**Stage2 Seed Prep**: Research package created by `/pre-draft-seed-prep` (this command)

**Seed Database Claims**: Claims from Reference/Claims/ files (Seed's approved sources)

**External Research**: Academic sources found outside Seed's database to fill gaps

**Primary Authority**: >50% of claims must come from Seed database

**Cross-Product Ingredient**: Ingredient that appears in multiple Seed products (PQQ, CoQ10, GABA)

**Compliance Pre-Check**: Scanning stage2 content against NO-NO words and compliance rules

**Hybrid Research**: Combining Seed claims + external research for complete coverage

**Direct File Access**: Reading Reference/ files directly vs. using File Search API

**Competitive Baseline**: Topics that MUST be covered (from competitive analysis)

---

**Last Updated**: 2025-11-18
**Next Review**: After Phase 1 completion
