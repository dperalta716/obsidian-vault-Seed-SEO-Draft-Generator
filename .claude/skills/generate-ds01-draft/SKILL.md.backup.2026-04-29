---
name: Generate DS-01 Draft
description: End-to-end SEO article generation for Seed Health DS-01 content. Runs competitor analysis, then generates a compliance-checked, voice-calibrated draft with academic citations.
argument-hint: keyword (e.g., "probiotics for bloating")
user-invocable: true
---

# Generate DS-01 Draft

Generate a complete SEO-optimized article draft for Seed Health's DS-01 Daily Synbiotic content. This skill runs the full pipeline: competitor analysis first, then article generation using the analysis as input.

## Usage

```
/generate-ds01-draft probiotics for bloating
```

The keyword argument is required. The skill handles everything else automatically.

---

## PHASE 1: Pre-Draft Competitor Analysis

### Step 1.1: Fetch SERP Data

Run the DataForSEO shell script to get organic results and PAA questions:

```bash
cd Seed-SEO-Draft-Generator-v4 && ./dataforseo-json.sh "$ARGUMENTS" "en" "United States"
```

Parse the JSON response:
- Extract top 5 organic URLs (filter `type === "organic"`, take first 5)
- Extract up to 8 PAA questions (filter `type === "people_also_ask"`)

### Step 1.2: Scrape & Analyze Top 5 Articles

Spawn 5 parallel sub-agents. Each sub-agent:

1. Scrapes one article using firecrawl:
```bash
/Users/david/Documents/Obsidian Vaults/claude-code-demo/.claude/skills/firecrawl-scraper/scripts/firecrawl-scrape.sh "[URL]" "markdown" "true" "2000"
```

2. Extracts structured analysis:
   - **Topics covered** with depth assessment (light/medium/deep)
   - **Claims & sources**: Only sentences with external hyperlinks or citations
     - Primary = DOI, .edu, academic journal links
     - Secondary = health websites, news sources
     - Extract COMPLETE working URLs (https://doi.org/... or https://pmc.ncbi.nlm.nih.gov/...)
     - Never return partial identifiers like "PMC7019700"
   - **Notable angles**: Unique perspectives this article takes
   - **Metadata**: Word count estimate, tone, citation density

### Step 1.3: Consolidate Findings

After all 5 sub-agents complete, synthesize:

1. **Primary User Search Intent** and core questions
2. **Competitive Baseline Requirements**: Topics in 3+ articles = must-cover
3. **Citation & Evidence Landscape**: Academic sources table with DOIs
4. **Intelligent PAA Selection**: Choose 4 best of 8 questions with rationales
5. **Gaps & Opportunities**: Where Seed can differentiate

### Step 1.4: Create Analysis Document

Determine the next folder number:
```bash
HIGHEST=$(ls -1 Generated-Drafts 2>/dev/null | grep -E '^[0-9]{3}-' | sed 's/-.*//' | sort -n | tail -1)
NEXT=$(printf "%03d" $((10#${HIGHEST:-0} + 1)))
SLUG=$(echo "$ARGUMENTS" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
mkdir -p "Generated-Drafts/${NEXT}-${SLUG}"
```

Save to: `Generated-Drafts/[NNN]-[slug]/stage1_analysis-[slug].md`

Use this structure:
```markdown
---
date: [TODAY]
keyword: "[keyword]"
analyzed_articles: 5
tags: [seed, competitor-analysis, pre-draft, seo]
---

# Stage 1 Pre-Draft Analysis: [Keyword]

## 1. User Search Intent
## 2. Competitive Baseline Requirements
## 3. Citation & Evidence Landscape
## 4. People Also Ask Questions
## 5. Article-by-Article Analysis
## 6. Synthesis for Drafting
```

---

## PHASE 2: Draft Generation

After Phase 1 completes, read the stage1_analysis document and ALL reference files, then generate the article.

### Reference Files (Read ALL)

**Tier 1 - Evidence Authority & SciCare Perspective:**
- `Phase 1 Reference Files/Ds-01 Science Reference File.md`
- `Phase 1 Reference Files/SEO Article Sprint - SciCare POV - DS-01 - General.md`
- `Phase 1 Reference Files/Ds-01 PDP.md`

**Supporting Documents:**
- `Phase 1 Reference Files/What we are and are not allowed to say when writing for Seed.md`
- `Phase 1 Reference Files/Seed Tone of Voice and Structure.md`
- `Phase 1 Reference Files/8 Sample Reference Blog Articles.md`
- `Reference/Compliance/NO-NO-WORDS.md`
- `Phase 1 Draft Revsions/Phase 1 Reference Files/seed strains.md`

### Step 2.1: Internal Processing (Think, Don't Write Yet)

**A. Extract from stage1_analysis:**
- Section 1: User intent and core questions
- Section 2: Must-cover topics (competitive baseline)
- Section 3: Pre-vetted academic sources with DOIs (Tier 2 citation pool)
- Section 4: Selected PAA questions (for FAQs)

**B. Identify Seed's Unique Angles:**
- Find 2-3 pieces of "standard advice" from competitive baseline
- Cross-reference against SciCare POV and DS-01 Science Ref
- Where conflicts/nuances exist, draft a Dirk Gevers, Ph.D. quote (1-3 sentences)
- Frame Seed's view as their specific approach, not the only correct view
- Prioritize SciCare POV above all other sources

**C. Build Evidence Strategy:**
- Tier 1 (USE FIRST): Studies from DS-01 Science Ref and SciCare POV
- Tier 2 (USE NEXT): Pre-vetted academic sources from stage1_analysis Section 3
- Target ~1 citation per 75-100 words. Max 20-23 total sources.
- Cite: study results, quantitative data, mechanisms, health claims, SciCare positions, safety info
- Do NOT cite: basic definitions, common biological processes, transitions, general advice
- ONLY peer-reviewed academic sources with working doi.org links
- Compliance check: all claims align with SciCare POV, no violations of Compliance Rules

**D. Develop Outline:**
- Overview, Introduction, 3-5 H2 body sections, The Key Insight, FAQs
- Must address competitive baseline requirements
- Layer Seed's unique angles on top of baseline

### Step 2.2: Write the Article

#### Voice & Tone Target

Model the voice on these patterns from published Seed articles on seed.com/cultured:

**Sentence-level patterns:**
- Use "you" and "your" in nearly every paragraph
- Always use contractions (don't, you're, it's, won't, isn't)
- Use parenthetical asides liberally: "(even if that sounds counterintuitive)", "(yes, really)", "(which, fair enough)", "(aka, more comfortable poops.)"
- Self-aware moments: "And no, your microbes won't text you when things are working."
- Casual transitions: "Here's the thing...", "Let's be real...", "But here's where it gets interesting..."

**Paragraph-level patterns:**
- Maximum 2-3 sentences per paragraph, no exceptions
- One concept per sentence
- Lead with plain language, then introduce scientific terms
- Average sentence length under 25 words (mix 10-15 and 20-25 word sentences)
- Active voice 90% of the time

**Section-level patterns:**
- Each H2 section: 300-500 words max
- Introductions answer the primary question in the first 1-2 paragraphs
- Body sections address baseline topics with Seed's unique angle layered on
- The Key Insight closes with a warm, grounding line (not a strategy summary)

**What NOT to do:**
- No emoji
- No internal links to other seed.com articles (added after the fact)
- No bold callout boxes (Pro Tip, TL;DR, etc. -- added after the fact)
- No words/phrases from the NO-NO WORDS list
- Never call probiotics "supplements"
- No product spec dumps (don't list "24 strains at 53.6 billion AFU" in one sentence)
- No more than 1 rhetorical question per 500 words
- No academic or clinical tone -- you're a knowledgeable friend, not a professor

**DS-01 Mentions:**
- 1-3 natural mentions, all hyperlinked to https://seed.com/daily-synbiotic
- Format: [DS-01® Daily Synbiotic](https://seed.com/daily-synbiotic)
- Keep mentions casual and brief -- don't dump product specs
- Position as complementary to food-based approaches, never a replacement

**Dirk Gevers, Ph.D. Quote:**
- 1-2 quotes total, each 1-3 sentences
- Attribute as: says **Dirk Gevers, Ph.D.** or explains **Dirk Gevers, Ph.D.**
- Must reinforce a genuine Seed differentiator (strain specificity, precision approach, microbiome science)
- Not generic wellness advice

### Step 2.3: Article Structure

The complete draft file must contain, in order:

#### 1. SEO Metadata

```markdown
## SEO Metadata

- **Primary Keyword:** [exact keyword]
- **SEO Title Options:**
  1. "[Title 1]" ([N] chars)
  2. "[Title 2]" ([N] chars)
  3. "[Title 3]" ([N] chars)
- **Slug:** [keyword-slug]-guide
- **Meta Description:** [160 chars max, includes keyword]
- **Article Description:** [300 chars max, for social sharing]
- **H1:** [Benefit-oriented, with colon subtitle. Varied -- NOT "What Science Says" formulas]
- **Written by:** [LEAVE BLANK]
- **Reviewed By:** [LEAVE BLANK]
```

**H1 Style Guide** (model after published seed.com articles):
- Good: "Probiotic Rich Foods: Your Complete Guide to What Works and What Doesn't"
- Good: "Apple Cider Vinegar for Gut Health: Separating the Hype From the Evidence"
- Good: "Artificial Sweeteners and Your Gut Microbiome: How Zero-Calorie Isn't Zero-Impact"
- Avoid: repetitive "What Science Actually Says/Shows" patterns
- Each H1 should feel unique and benefit-oriented

#### 2. The Article (1800-2200 words)

```
# [H1 -- same as metadata H1]

### Overview
[3-5 bullet points summarizing key takeaways]

[Engaging Introduction -- immediately answer primary user question]

## [Body H2 Sections -- 3-5 sections with H3 subsections]

## The Key Insight
[2-3 paragraphs, 150-200 words, ends with a warm grounding line]

## Frequently Asked Questions

### [PAA Question 1 from stage1_analysis]
[100-150 words]

### [PAA Question 2]
[100-150 words]

### [PAA Question 3]
[100-150 words]

### [PAA Question 4]  (optional -- 3 minimum)
[100-150 words]
```

#### 3. Citations

```markdown
## Citations

1. [APA format entry]. [DOI link]
2. [APA format entry]. [DOI link]
```

- Numbered, alphabetical by author last name
- Every entry includes working doi.org link
- In-text format: `([Author Year](DOI_URL))` -- NO comma between Author and Year
- Multiple citations: `([Author1 Year1](DOI1), [Author2 Year2](DOI2))`

### Step 2.4: Compliance Self-Check

Before saving, verify:
- [ ] No words from NO-NO WORDS list
- [ ] Probiotics never called "supplements"
- [ ] No forbidden medical claims (treat, cure, diagnose, prevent, boost, heal, fix)
- [ ] All DS-01 mentions hyperlinked to https://seed.com/daily-synbiotic
- [ ] Claims attributed to ingredients, not the product itself
- [ ] Strain names use PREFERRED column from seed strains reference
- [ ] Word count is 1800-2200
- [ ] All citation DOI links present

### Step 2.5: Save Draft

Save to: `Generated-Drafts/[NNN]-[slug]/v1-[slug]-claude-draft.md`

(Same folder created in Phase 1.)

Add YAML frontmatter:
```yaml
---
date: [TODAY]
keyword: "[keyword]"
version: v1
status: draft
tags: [seed, seo-draft, ds-01, phase-1]
---
```

---

## Completion Output

After saving both files, confirm:

```
Phase 1 complete: stage1_analysis-[slug].md
Phase 2 complete: v1-[slug]-claude-draft.md

Folder: Generated-Drafts/[NNN]-[slug]/
Word count: ~[N] words
Citations: [N] academic sources
DS-01 mentions: [N]
Compliance: Checked

Ready for review with /review-draft-seed-perspective or /review-draft-1-v2
```
