# stage2-generate-draft

Generates a complete SEO-optimized article draft from a Stage 1 competitive analysis, following Seed's drafting methodology with 3-tier citation strategy.

## Usage

```
/stage2-generate-draft <keyword>
```

## Parameters

- `keyword` (required): The target keyword that has an existing stage1_analysis file (e.g., "best supplements for sleep")

## Description

This command takes the output of `/pre-draft-competitor-analysis-v4` and generates a complete SEO article draft. It replaces the external Gemini workflow by executing the full drafting process in Claude, including evidence gathering from Reference files, citation building, and Seed voice application.

## Workflow

### STEP 1: LOCATE STAGE1 ANALYSIS

Find the existing analysis file:

```bash
# Find the folder containing this keyword
ls -la Generated-Drafts/ | grep -i "[keyword-slug]"
```

Expected file: `Generated-Drafts/[NNN]-[keyword-slug]/stage1_analysis-[keyword-slug].md`

If the file doesn't exist, STOP and inform the user they need to run `/pre-draft-competitor-analysis-v4` first.

---

### STEP 2: PARSE STAGE1 ANALYSIS

Read the stage1_analysis file and extract:

**From Section 1 (User Search Intent)**:
- Primary user intent
- Core questions users are asking (3-4 questions)

**From Section 2 (Competitive Baseline Requirements)**:
- Topics that MUST be covered (with frequency like "5/5 articles")
- Typical depth/angle for each topic
- Topic coverage patterns

**From Section 3 (Citation & Evidence Landscape)**:
- Primary Research Sources table (Claim, Source, DOI/Link, Used By)
- This becomes the Tier 2 citation pool
- Note citation patterns (average per article, most cited, density)

**From Section 4 (People Also Ask Questions)**:
- The 4 selected PAA questions with rationales
- These become the FAQ section questions

**From Section 6 (Synthesis for Drafting)**:
- Gaps & Opportunities for Seed
- Recommended approach
- Notes for Drafter

---

### STEP 3: PRODUCT IDENTIFICATION

Based on the keyword and competitive baseline topics, determine which Seed products are relevant:

**Product-Ingredient Mapping**:
- **PM-02 Sleep + Restore**: Melatonin, GABA, Magnesium, Ashwagandha (Shoden), Glycine, PQQ, B vitamins
- **DM-02 Daily Multivitamin**: Full vitamin/mineral spectrum, CoQ10, PQQ, Biotin, Vitamin D, Zinc, etc.
- **AM-02 Energy + Focus**: CoQ10, PQQ, GABA, Cereboost, Theacrine, Quercetin, B vitamins

**Cross-Product Ingredients**:
- PQQ: All three products
- CoQ10: AM-02, DM-02
- GABA: PM-02, AM-02
- B vitamins: All three products

**Decision Logic**:
1. If keyword clearly maps to one product (e.g., "supplements for sleep" → PM-02), proceed
2. If keyword could apply to multiple products (e.g., "B vitamins for energy"), use AskUserQuestion:

```
Which Seed product(s) should this article focus on?
- PM-02 Sleep + Restore (sleep, relaxation, recovery)
- DM-02 Daily Multivitamin (general nutrition, daily wellness)
- AM-02 Energy + Focus (energy, cognition, focus)
- Multiple products (cover cross-product benefits)
```

---

### STEP 4: PARALLEL EVIDENCE GATHERING

Launch sub-agents to gather evidence from Reference files.

**SUB-AGENT 1: Claims Document Reader**

```
You are gathering evidence from Seed's Claims documents for the keyword: "{keyword}"
Relevant product(s): {identified_products}

Read the following files and extract:
1. Approved health claims with exact language
2. Primary studies (Author, Year, DOI)
3. Dose information
4. Mechanisms of action

Files to read (based on identified products):

FOR PM-02:
- Reference/Claims/PM-02/PM-02-General-Claims.md
- Reference/Claims/PM-02/PM-02-[Ingredient]-Claims.md (for each relevant ingredient)

FOR DM-02:
- Reference/Claims/DM-02/DM-02-General-Claims.md
- Reference/Claims/DM-02/DM-02-[Ingredient]-Claims.md (for each relevant ingredient)

FOR AM-02:
- Reference/Claims/AM-02/AM-02-General-Claims.md
- Reference/Claims/AM-02/AM-02-[Ingredient]-Claims.md (for each relevant ingredient)

ALWAYS READ:
- Reference/Claims/Cross-Product-General-Claims.md

Return a structured list of:
{
  "claims": [
    {
      "ingredient": "...",
      "claim": "Exact approved claim language",
      "studies": [
        {"author": "...", "year": "...", "doi": "https://doi.org/...", "finding": "..."}
      ],
      "dose_info": "...",
      "mechanism": "..."
    }
  ],
  "total_studies_found": N
}
```

**SUB-AGENT 2: Messaging Document Reader**

```
You are extracting Seed's unique positioning for the keyword: "{keyword}"
Relevant product(s): {identified_products}

Read the following NPD Messaging documents:
- Reference/NPD-Messaging/PM-02 Product Messaging Reference Documents.md
- Reference/NPD-Messaging/DM-02 Product Messaging Reference Documents.md
- Reference/NPD-Messaging/AM-02 Product Messaging Reference Documents.md

Extract:
1. Seed's unique angles vs. standard advice
2. Key differentiators for this topic
3. Approved product positioning language
4. Cross-product themes (microbiome connection, precision dosing, bioavailable forms)

Return:
{
  "unique_angles": ["..."],
  "differentiators": ["..."],
  "approved_language": ["..."],
  "cross_product_themes": ["..."]
}
```

**SUB-AGENT 3: Supporting Documents Reader**

```
Read the following supporting documents:

1. Reference/Compliance/What-We-Are-Not-Allowed-To-Say.md
   - Extract forbidden claims and language patterns

2. Reference/Compliance/NO-NO-WORDS.md
   - Extract the list of words/phrases to avoid

3. Reference/Style/Seed-Tone-of-Voice-and-Structure.md
   - Extract tone guidelines, structure requirements, voice characteristics

4. Reference/Style/8-Sample-Reference-Blog-Articles.md (read first 2000 lines for patterns)
   - Note introduction styles, transition phrases, citation integration

Return:
{
  "forbidden_claims": ["..."],
  "no_no_words": ["..."],
  "tone_guidelines": {
    "voice": "...",
    "structure": "...",
    "techniques": ["..."]
  },
  "sample_patterns": {
    "intro_style": "...",
    "transitions": ["..."]
  }
}
```

---

### STEP 5: BUILD CITATION POOL

Consolidate citations using the 3-tier hierarchy:

**TIER 1 (Primary - ALWAYS USE FIRST)**:
- All DOIs from Claims documents gathered in Step 4
- These are pre-approved and authoritative

**TIER 2 (Secondary - USE NEXT)**:
- Academic sources from Stage1 Section 3 citation table
- ONLY use sources from academic journals (pubmed, pmc, doi.org)
- DO NOT use secondary sources (NIH fact sheets, health websites)

**TIER 3 (Tertiary - IF GAPS REMAIN)**:
If Tiers 1-2 don't cover a topic identified in the competitive baseline:

```bash
# Search PubMed for additional sources
./.claude/skills/pubmed-research/scripts/pubmed-search.sh "topic meta-analysis" 5 relevance

# Verify any new DOI before using
./.claude/skills/pubmed-research/scripts/pubmed-verify-doi.sh "10.xxxx/yyyy"

# Get abstract to verify claim matches
./.claude/skills/pubmed-research/scripts/pubmed-fetch.sh <pmid>
```

**Citation Pool Target**: 12-16 academic sources total

Create a master citation list:
```
{
  "tier1_citations": [...],  // From Claims docs
  "tier2_citations": [...],  // From Stage1 analysis (academic only)
  "tier3_citations": [...],  // From PubMed (if needed)
  "total": N
}
```

---

### STEP 6: DEVELOP SEED'S UNIQUE NARRATIVE

Using evidence gathered in Steps 4-5:

1. **Identify Standard Advice** (from Stage1 Section 2 & 5):
   - What do competitors commonly recommend?
   - What dosages/forms do they suggest?

2. **Contrast with Seed's Approach** (from Messaging docs):
   - How does Seed's philosophy differ?
   - What unique angles can we take?

3. **Create Dirk Gevers, Ph.D. Quote**:
   - Maximum 1-2 sentences
   - Focus on ONE key differentiator
   - Use simpler language
   - Highlight the "why" behind Seed's approach

   Example format:
   > "At Seed, we focus on [specific approach] because [scientific rationale]. Rather than [standard advice], our research shows [unique insight]." — Dirk Gevers, Ph.D.

---

### STEP 7: CREATE ARTICLE OUTLINE

Structure per Tone Guide:

```markdown
### Overview
- 3 bullet points summarizing key takeaways

## [Engaging H2 for Introduction]
- Immediately answer primary user question
- Hook to continue reading
- ~200-250 words

## [H2: Main Topic 1 - Highest frequency from baseline]
- Cover competitive baseline requirement
- Layer Seed's unique perspective
- Include relevant citations
- ~300-400 words

## [H2: Main Topic 2]
- ~300-400 words

## [H2: Main Topic 3]
- ~300-400 words

## [H2: Optional Topic 4 - if needed for word count]
- ~250-300 words

## The Key Insight
- Paragraph-form summary
- Reinforce Seed's unique perspective
- ~150-200 words

## Frequently Asked Questions
- 4 questions from Stage1 PAA selections
- 100-150 words per answer
```

**Outline Design Principles**:
- Lead with ingredient story, not product pitch
- Address competitive baseline topics first
- Layer Seed perspective on top of baseline
- Include tonal prompts for complex sections: [Use Analogy], [Explain Simply]

---

### STEP 8: GENERATE DRAFT

Write the full article following these requirements:

**Tone/Voice**:
- Embody "knowledgeable and empathetic friend" persona
- Use direct address ("you," "your")
- Always use contractions
- Occasional rhetorical questions (max 1 per 500 words)
- Explain complex concepts with analogies before technical terms

**Content Development**:
- Frame around ingredient narrative, not product pitch
- Layering approach:
  1. Lead with ingredient science
  2. Address competitive baseline topics
  3. Layer Seed's unique perspective
  4. Connect to products naturally (mentions, not pitches)

**Evidence Integration**:
- Format: `([Author Year](DOI_URL))` - NO comma between Author and Year
- Entire (Author Year) block must be hyperlinked
- Multiple citations: `([Author1 Year1](DOI_URL1), [Author2 Year2](DOI_URL2))`
- Target ~1 citation per 75-100 words for key claims
- Don't cite basic definitions or common knowledge

**Product Links** (when mentioned):
- `[PM-02® Sleep + Restore](https://seed.com/sleep-restore)`
- `[AM-02® Energy + Focus](https://seed.com/energy-focus)`
- `[DM-02® Daily Multivitamin](https://seed.com/daily-multivitamin)`

**Word Count Target**: 1800-2200 words

---

### STEP 9: SIMPLIFICATION PASS

After drafting, perform mandatory simplification:

1. **Sentence Length**:
   - Break any sentence over 30 words into two
   - Target average under 25 words
   - Replace semicolons with periods

2. **Language Accessibility**:
   - Replace academic jargon with plain language
   - Define technical terms immediately after introducing
   - Use common words over complex synonyms

3. **Paragraph Structure**:
   - Split any paragraph with 4+ sentences
   - Max 2-3 sentences per paragraph
   - Add transition sentences between complex concepts

4. **Readability Checks**:
   - Apply "grandmother test"
   - Target 7th-8th grade reading level
   - Ensure logical progression of ideas

---

### STEP 10: GENERATE OUTPUTS

Create the final output document with these sections:

**1. SEO Metadata**:
```markdown
## SEO Metadata

**Primary keyword**: {keyword}
**SEO Title Options** (50-60 characters):
1. [Title option 1]
2. [Title option 2]
3. [Title option 3]

**Slug**: {keyword-slug}-guide
**Meta Description** (160 characters max): [Description]
**Article Description** (300 characters max): [Longer description]
**Written by**: [LEAVE BLANK]
**Expert Reviewer**: [LEAVE BLANK]
```

**2. Full Article**:
- Complete article with all sections
- All citations properly formatted and hyperlinked
- Product mentions with trademark symbols and links

**3. Citations List**:
```markdown
## Citations

1. [APA format citation with DOI link]
2. [APA format citation with DOI link]
...
```
- Alphabetical by author last name
- Include working doi.org links

---

### STEP 11: SAVE OUTPUT

Save to: `Generated-Drafts/[NNN]-[keyword-slug]/v1-[keyword-slug].md`

The folder should already exist from Stage 1. Save the draft there.

---

## Example

```
/stage2-generate-draft best supplements for sleep
```

**Output**:
- Reads: `Generated-Drafts/040-best-supplements-for-sleep/stage1_analysis-best-supplements-for-sleep.md`
- Identifies: PM-02 as primary product
- Gathers: Evidence from PM-02 Claims docs + NPD Messaging
- Generates: 1800-2200 word draft with Seed voice
- Saves: `Generated-Drafts/040-best-supplements-for-sleep/v1-best-supplements-for-sleep.md`

---

## Implementation Notes

### For Claude Executing This Command:

1. **Sequential Execution**: Steps 1-3 must complete before launching parallel agents
2. **Parallel Agents**: Steps 4's sub-agents can run simultaneously
3. **Product Confirmation**: If multiple products apply, MUST ask user before proceeding
4. **Citation Verification**: Only verify Tier 3 (PubMed-found) citations
5. **Compliance Check**: Cross-reference all claims against NO-NO WORDS and Compliance Rules
6. **Word Count**: Track throughout drafting - aim for 1800-2200, max 2500
7. **Simplification**: MANDATORY - always perform Step 9 before finalizing

### Quality Checks:

- ✅ All competitive baseline topics covered
- ✅ 12-16 academic citations included
- ✅ Tier 1 (Claims docs) citations prioritized
- ✅ Seed's unique perspective layered throughout
- ✅ Dirk Gevers quote included naturally
- ✅ FAQs use Stage1 PAA questions
- ✅ Product mentions include ® and links
- ✅ No NO-NO WORDS used
- ✅ Reading level 7th-8th grade
- ✅ Paragraphs max 2-3 sentences
- ✅ Word count in target range

---

## Success Criteria

- ✅ Reads existing stage1 analysis
- ✅ Identifies correct product(s) - prompts if ambiguous
- ✅ Gathers evidence from Claims + Messaging docs
- ✅ Uses 3-tier citation hierarchy
- ✅ Only verifies Tier 3 citations (PubMed finds)
- ✅ Generates 1800-2200 word article
- ✅ Applies Seed voice and simplification pass
- ✅ Outputs to correct folder with v1 naming
- ✅ Includes SEO metadata and citation list
- ✅ FAQs use PAA questions from Stage1

---

## Related Commands

- `/pre-draft-competitor-analysis-v4` - Must run first to create stage1 analysis
- `/review-draft-1` - Post-draft review
- `/review-sources-2` - Source verification

---

## Changelog

**v1.0** (2025-12-01):
- Initial implementation
- Replaces external Gemini workflow
- 3-tier citation strategy with PubMed fallback
- Parallel sub-agent architecture for evidence gathering
- Product identification with user confirmation for ambiguous cases
