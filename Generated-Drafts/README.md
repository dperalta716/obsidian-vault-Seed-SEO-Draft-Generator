# Seed SEO Article Generation & Review Workflow

This folder contains all SEO articles for Seed Health's NPD products (PM-02, DM-02, AM-02). Each article goes through a comprehensive generation and review process to ensure it meets Seed's scientific standards, brand voice, and compliance requirements.

---

## Complete Workflow Overview

There are **two main paths** for creating articles:

### Path A: Brand New Article Generation → Review & Polish
For creating fresh SEO articles from scratch

### Path B: Competitive Revision Workflow
For improving existing articles based on competitive analysis

---

# PATH A: Brand New Article Generation

## Step 1: Generate Initial Draft

**Method**: Use the main SEO article generation workflow defined in the project's `CLAUDE.md`

**What you get**: v1 draft saved in `/Generated-Drafts/[NNN]-[keyword-slug]/v1-[keyword-slug].md`

**Typical specs**:
- 1,500-1,800 words (max 2,000)
- 12-15 academic citations
- SEO optimized with metadata
- Seed brand voice applied
- Product claims from Claims documents

---

## Step 2: Review Seed Scientific Perspective

**Command**: `/review-draft-seed-perspective`

**Usage**:
```
/review-draft-seed-perspective                    # Reviews most recent draft
/review-draft-seed-perspective filename.md       # Reviews specific file
/review-draft-seed-perspective melatonin         # Reviews by keyword
```

**What it checks** (15 criteria, Letter Grade A-F):

### A. Claims Document Usage (5 checks)
- ✅ Uses Claims docs as PRIMARY authority (>50% citations)
- ✅ Cites specific studies with proper DOI links
- ✅ Health claims substantively supported by Claims docs
- ✅ Dose information matches Claims substantiation
- ✅ Claims properly attributed to ingredients (not product)

### B. NPD Messaging Alignment (5 checks - PRODUCT SPECIFIC)

**For DM-02 (Daily Multivitamin):**
- ✅ Addresses soil depletion/nutrient gaps narrative
- ✅ Emphasizes bidirectional microbiome-nutrition relationship
- ✅ Discusses ViaCap® precision delivery system
- ✅ Highlights bioavailability (methylfolate vs folic acid)
- ✅ Critiques mass-market multivitamins

**For PM-02 (Sleep + Restore):**
- ✅ Emphasizes bioidentical/precision melatonin dosing (0.5mg vs 5-10mg)
- ✅ Explains sleep-gut-brain axis connection
- ✅ Discusses dual-phase release mechanism
- ✅ Critiques high-dose melatonin standard practice
- ✅ "Not overloading the system" philosophy

**For AM-02 (Energy + Focus):**
- ✅ Emphasizes sustained energy without crash/stimulants
- ✅ Explains gut-mitochondria axis connection
- ✅ Focuses on cellular energy optimization (not caffeine)
- ✅ Highlights nootropic cognitive benefits
- ✅ Critiques traditional stimulant-based energy products

### C. SciComms Education Integration (5 checks)
- ✅ Incorporates relevant talking points (smart relevance detection)
- ✅ Uses product-specific narratives where applicable
- ✅ Cites additional sources from SciComms docs if relevant
- ✅ Reflects Seed's educational angle
- ✅ Expert quotes align with Seed's unique perspective

**Grading Scale**:
- **A (13-15 passed)**: Excellent - Ready for quality review
- **B (10-12 passed)**: Good - Minor gaps to address
- **C (7-9 passed)**: Needs significant work on Seed perspective
- **D (4-6 passed)**: Major misalignment - substantial rewrite
- **F (0-3 passed)**: Complete rewrite needed

**Output**:
- Detailed report with all failures and recommendations
- Option to auto-fix issues by category
- Saves as `v2-seed-perspective-reviewed.md` if fixes applied

**Decision Point**:
- **Grade A-B**: Proceed to Step 3
- **Grade C-F**: Fix issues and re-run this step before proceeding

---

## Step 3: Quality & Compliance Review

**Command**: `/review-draft-1-v2` (or `/review-draft-1` for original version)

**Usage**:
```
/review-draft-1-v2                                # Reviews most recent draft
/review-draft-1-v2 v2-seed-perspective-reviewed.md
```

**What it checks**:

This is a comprehensive two-tier review:

### PRIMARY TIER (40% weight) - Seed Scientific Perspective
- All 15 checks from Step 2 (Claims, Messaging, SciComms)
- Ensures Seed's unique perspective is maintained

### SECONDARY TIER (60% weight) - Quality & Compliance

**Citations (7 checks)**:
- Proper format: `([Author Year](DOI_URL))`
- No comma between Author and Year
- All DOIs link to correct papers
- Citations section in APA format, alphabetical
- 12-15 total citations (target range)
- In-text citations match Citations section
- Academic sources only (no blogs, news sites)

**Tone of Voice (8 checks)**:
- Conversational "knowledgeable friend" voice
- Uses "you/your" throughout
- Contractions present (don't, you're, it's)
- 7th-8th grade reading level
- Sentence length under 25 words average
- Paragraphs 2-3 sentences max
- Plain language before technical terms
- Analogies and metaphors used

**Compliance (6 checks)**:
- No forbidden words from NO-NO-WORDS.md
- No disease/cure claims
- Product links include ® symbols
- Proper disclaimer language
- No overpromising
- Follows What-We-Are-Not-Allowed-To-Say.md

**Structure (5 checks)**:
- Overview section (3 bullets)
- Engaging introduction
- Proper H2/H3 hierarchy
- FAQ section present
- Key Insight or summary section

**SEO Elements (4 checks)**:
- Primary keyword in title, meta, URL
- Keyword density appropriate
- Internal links to Seed articles
- Meta description compelling and under 160 chars

**Combined Grading**:
- **PRIMARY score** (Seed perspective): 40% of total
- **SECONDARY score** (Quality/compliance): 60% of total
- **Overall Grade**: A-F based on combined weighted score

**Output**:
- Comprehensive report with all checks
- Prioritized list of issues to fix
- Option to auto-fix applicable issues
- Saves as `v3-draft-reviewed.md` if fixes applied

---

## Step 4: Verify Sources (DOI Links)

**Command**: `/review-sources-2-v2`

**Usage**:
```
/review-sources-2-v2                              # Reviews most recent draft
/review-sources-2-v2 v3-draft-reviewed.md
/review-sources-2-v2 melatonin                   # Reviews by keyword
```

**What it does**:
1. Extracts ALL citations from your draft
2. Verifies each DOI link using dual-method approach:
   - **Primary**: WebFetch (fast, efficient)
   - **Fallback**: Firecrawl scraper (if WebFetch blocked/fails)
3. Detects issues:
   - **Non-existent DOIs**: Link returns "DOI NOT FOUND" error
   - **Wrong paper DOIs**: Link works but leads to different article
4. Searches for and finds correct studies
5. Updates EVERY instance throughout article (Citations section + inline references)

**Key Feature - Intelligent Fallback**:
- If WebFetch is blocked by a publisher → automatically tries Firecrawl
- Reports which method successfully retrieved each paper
- Ensures higher success rate for verification

**Output**:
- Detailed report showing:
  - Valid citations ✅
  - Fixed citations with old vs new DOI
  - Which fetch method was used for each
- Saves as `v4-sources-verified.md` (preserves original)

---

## Step 5: Verify Claims Against Sources

**Command**: `/review-claims-3-v2`

**Usage**:
```
/review-claims-3-v2                               # Reviews most recent draft
/review-claims-3-v2 v4-sources-verified.md
/review-claims-3-v2 melatonin
```

**What it does**:
1. Extracts ALL sentences containing citations
2. Fetches and analyzes each cited source using dual-method:
   - **Primary**: WebFetch
   - **Fallback**: Firecrawl (if WebFetch fails)
3. Categorizes each claim:
   - **✅ Supported**: Source directly supports the claim
   - **⚠️ Partially Supported**: General support with minor caveats (usually kept as-is)
   - **❌ Unsupported**: Source doesn't support or contradicts claim
   - **🔒 Inaccessible**: Neither fetch method could retrieve source

4. For unsupported claims, recommends action:
   - **MODIFY**: Adjust claim to match source (preserves Seed tone)
   - **REPLACE**: Find new source that supports the claim
   - **REMOVE**: Delete claim if non-essential and unsupported

**CRITICAL - Tone Preservation**:
All modifications maintain:
- 7th-8th grade reading level
- "Knowledgeable and empathetic friend" voice
- Plain language before technical terms
- Direct address ("you/your")
- Conversational feel with contractions

**Examples of Proper Modifications**:
- ❌ "Magnesium affects ATP synthesis for energy"
- ✅ "Your cells need magnesium to make energy"

- ❌ "Demonstrates a statistically significant anxiety reduction"
- ✅ "Can help reduce anxiety in meaningful ways"

**Output**:
- Claims verification report with:
  - Support status for each claim
  - Fetch method used for each source
  - Specific recommendations for fixes
- Interactive selection of which changes to apply
- Saves as `v5-claims-verified.md` if changes applied

---

## Path A Summary

```
1. Generate v1 draft
   ↓
2. /review-draft-seed-perspective → v2 (Seed alignment)
   ↓
3. /review-draft-1-v2 → v3 (Quality/compliance)
   ↓
4. /review-sources-2-v2 → v4 (DOI verification)
   ↓
5. /review-claims-3-v2 → v5 (Claims verification)
   ↓
6. Ready for publication
```

**Files in folder after Path A**:
```
📁 Generated-Drafts/001-keyword-slug/
├── v1-keyword-slug.md                    (original)
├── v2-seed-perspective-reviewed.md       (Seed alignment fixes)
├── v3-draft-reviewed.md                  (Quality/compliance fixes)
├── v4-sources-verified.md                (DOI corrections)
└── v5-claims-verified.md                 (Claims fixes, ready for publication)
```

---

# PATH B: Competitive Revision Workflow

For improving existing articles based on competitive SERP analysis.

## Step 1: Competitive Analysis

**Command**: `/analyze-seo-draft <original-draft-path>`

**Usage**:
```
/analyze-seo-draft /Draft Optimizations/001-Signs Probiotics/Signs probiotics are working.md
```

**What it does**:
1. Extracts primary keyword from draft's SEO metadata
2. Analyzes current citation count
3. Searches and fetches top 3-4 competing articles
4. Performs in-depth competitive comparison
5. Generates recommendations organized by priority:
   - 🔴 HIGH PRIORITY: Must-have improvements
   - 🟡 MEDIUM PRIORITY: Should-have additions
   - 🟢 NICE-TO-HAVE: Optional enhancements
6. Asks which improvements to implement
7. **Automatically creates** `Drafting Instructions.md` in same folder

**Output**:
- Competitive analysis report showing:
  - Where your draft excels
  - Where competitors have advantages
  - Concrete recommendations (8-12 items)
- `Drafting Instructions.md` file with:
  - Content trimming strategy
  - Detailed instructions for each addition
  - Citation management plan
  - Word count guidance
  - Tone reminders
  - Final checklist

---

## Step 2: Create Revised Draft

**Done externally** (Gemini, human writer, etc.)

**Input**:
- Original draft file
- `Drafting Instructions.md` (auto-created in Step 1)

**Drafter's task**:
- Implement all approved improvements
- Trim content as instructed
- Manage citations (remove/add)
- Match Seed's tone and voice

**Save as**: `[original-name]-revised v1.md` in same folder

**Example**:
```
Original: Signs probiotics are working.md
Revised:  Signs Probiotics Are working-revised v1.md
```

---

## Step 3: Quality Assessment & Correction

**Command**: `/phase-1-revised-draft-editor <revised-v1-path>`

**Usage**:
```
/phase-1-revised-draft-editor /Draft Optimizations/001-Signs Probiotics/Signs Probiotics Are working-revised v1.md
```

**What it does**:
1. **Automatically locates** in same folder:
   - Original draft (oldest .md file by modification date)
   - Drafting Instructions.md
   - Your revised v1 file

2. **Performs 3-part quality assessment**:

   **A. Adherence to Instructions (/100)**
   - Were all HIGH priority additions made?
   - Were MEDIUM priority additions made?
   - Were NICE-TO-HAVE additions made?
   - Was trimming executed properly?
   - Was citation management followed?

   **B. Language Preservation (/100)**
   - Were unchanged sections kept intact?
   - Were expert quotes preserved (with correct attribution)?
   - Were specific details maintained (strain names, statistics)?
   - Were factual errors introduced?

   **C. Tone Consistency (/100)**
   - Do new sections match Seed's voice?
   - Conversational "knowledgeable friend" tone?
   - Accessibility maintained (7th-8th grade)?
   - Personality and empathy present?

3. **Generates assessment report**:
   - Overall grade (combined score)
   - 🚨 Critical issues (misattributions, factual errors)
   - ⚠️ High priority improvements
   - 📝 Medium priority suggestions
   - ✅ What worked well

4. **Interactive selection**: "What corrections should I implement in v2?"

5. **Creates corrected v2**:
   - Fixes selected issues
   - Restores lost content
   - Adjusts citation count to target (15-17)
   - Saves as `[name]-revised v2.md`

**Output**:
- Quality assessment with 3 scores
- Detailed recommendations
- Corrected v2 file implementing selected fixes
- v1 preserved unchanged for comparison

---

## Path B Summary

```
1. /analyze-seo-draft [original.md]
   ↓ Auto-creates Drafting Instructions.md

2. External drafter creates v1 using instructions
   ↓ Save as [name]-revised v1.md

3. /phase-1-revised-draft-editor [v1.md]
   ↓ Quality assessment → Select fixes → Creates v2

4. v2 ready for final review
   ↓ Optional: Run through Path A review steps
```

**Files in folder after Path B**:
```
📁 Draft Optimizations/001-keyword-slug/
├── keyword-slug.md                       (original)
├── Drafting Instructions.md              (auto-created)
├── keyword-slug-revised v1.md            (from external drafter)
└── keyword-slug-revised v2.md            (corrected by Claude)
```

---

## Combining Both Paths

You can run a revised draft through Path A reviews:

```
Path B (Competitive Revision):
1. /analyze-seo-draft → Drafting Instructions
2. External drafter → revised v1
3. /phase-1-revised-draft-editor → revised v2

Then Path A (Quality Reviews):
4. /review-draft-seed-perspective → revised v3-seed-perspective
5. /review-draft-1-v2 → revised v4-draft-reviewed
6. /review-sources-2-v2 → revised v5-sources-verified
7. /review-claims-3-v2 → revised v6-claims-verified
```

This ensures competitive improvements + Seed alignment + quality/compliance + source accuracy + claims verification.

---

## File Naming Conventions

### Path A (New Articles)
```
v1-[keyword-slug].md                    # Initial generation
v2-seed-perspective-reviewed.md         # After Seed alignment
v3-draft-reviewed.md                    # After quality/compliance review
v4-sources-verified.md                  # After DOI verification
v5-claims-verified.md                   # After claims check (ready for publication)
```

### Path B (Revisions)
```
[keyword-slug].md                       # Original draft
Drafting Instructions.md                # Auto-created by analysis
[keyword-slug]-revised v1.md            # From external drafter
[keyword-slug]-revised v2.md            # Corrected by Claude
```

### Combined Workflow
```
[keyword-slug]-revised v2.md            # Start here (after competitive revision)
[keyword-slug]-revised v3-seed-perspective.md
[keyword-slug]-revised v4-draft-reviewed.md
[keyword-slug]-revised v5-sources-verified.md
[keyword-slug]-revised v6-claims-verified.md
```

---

## Folder Structure

```
📁 Generated-Drafts/
├── README.md                           # This file
├── 001-keyword-slug-1/
│   ├── v1-keyword-slug-1.md
│   ├── v2-seed-perspective-reviewed.md
│   ├── v3-draft-reviewed.md
│   ├── v4-sources-verified.md
│   └── v5-claims-verified.md
├── 002-keyword-slug-2/
│   └── ... (all versions)
└── 003-keyword-slug-3/
    └── ... (all versions)
```

---

## Quick Command Reference

| Command | Purpose | When to Use |
|---------|---------|-------------|
| `/review-draft-seed-perspective` | Check Seed alignment (A-F grade) | First review of new draft |
| `/review-sources-2-v2` | Verify DOI links | After Seed perspective check |
| `/review-claims-3-v2` | Verify claims match sources | After source verification |
| `/review-draft-1-v2` | Comprehensive quality/compliance | Final polish before publication |
| `/analyze-seo-draft` | Competitive SERP analysis | To improve existing draft |
| `/phase-1-revised-draft-editor` | Quality check revised draft | After external revision |

---

## Tips for Success

### Path A (New Articles)
1. **Always run `/review-draft-seed-perspective` FIRST**
   - Don't waste time on quality if Seed perspective is wrong
   - Fix fundamental issues before polishing

2. **Source verification catches common errors**
   - Wrong DOIs from copy-paste mistakes
   - Non-existent DOIs from typos
   - Save time vs. manual verification

3. **Claims verification preserves voice**
   - Automatic fixes maintain Seed's tone
   - Technical accuracy + accessibility

4. **Final review is comprehensive**
   - Catches everything in one pass
   - Weighted scoring prioritizes Seed perspective

### Path B (Competitive Revisions)
1. **Drafting Instructions are auto-created**
   - No need to manually save them
   - Always in the same folder as draft

2. **External drafter needs both files**
   - Original draft + Instructions
   - Clear, specific implementation guidance

3. **Quality assessment is objective**
   - 3 measurable criteria
   - Identifies exact issues to fix

4. **v1 is always preserved**
   - Safe to iterate
   - Can compare versions

### General Tips
1. **Version numbers increment automatically**
   - Never overwrite originals
   - Easy to track progress

2. **All files stay in same folder**
   - Easy version control
   - Everything together for comparison

3. **Dual-fetch methods improve reliability**
   - WebFetch primary, Firecrawl fallback
   - Higher success rate for source verification

4. **Interactive selection gives control**
   - Choose which fixes to apply
   - Not all-or-nothing

---

## Workflow Decision Tree

```
Do you have an existing draft that needs improvement?
│
├─ NO → Use Path A (New Article Generation)
│   │
│   └─ Follow steps 1-5 sequentially
│       Grade A-B on each step before proceeding
│
└─ YES → Use Path B (Competitive Revision)
    │
    ├─ Run /analyze-seo-draft
    ├─ External drafter creates v1
    ├─ Run /phase-1-revised-draft-editor
    │
    └─ Optional: Run through Path A reviews for final polish
```

---

## Related Documentation

- **Project workflow**: `/Seed-SEO-Draft-Generator-v4/CLAUDE.md`
- **Phase 1 revisions**: `/Phase 1 Draft Revisions/README.md`
- **Command details**: `/.claude/commands/`
- **Reference materials**: `/Reference/` (Claims, Messaging, Style, Compliance)

---

## Version History

**Current Version**: 2.0 (Created 2025-01-13)

**Major Features**:
- Path A: Complete new article generation workflow
- Path B: Competitive revision workflow
- Dual-method source fetching (WebFetch + Firecrawl)
- Auto-created Drafting Instructions
- Smart relevance detection for SciComms
- Tone-preserving claim modifications
- Comprehensive quality assessment

**Commands Integrated**:
- `/review-draft-seed-perspective`
- `/review-sources-2-v2`
- `/review-claims-3-v2`
- `/review-draft-1-v2`
- `/analyze-seo-draft`
- `/phase-1-revised-draft-editor`
