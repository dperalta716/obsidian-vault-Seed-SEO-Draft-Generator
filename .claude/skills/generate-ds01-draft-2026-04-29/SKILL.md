---
name: Generate DS-01 Draft (2026 Messaging)
description: End-to-end SEO article generation for Seed Health DS-01 content using the April 2026 messaging reference files. Runs competitor analysis, then generates a compliance-checked, voice-calibrated draft with academic citations.
argument-hint: keyword (e.g., "probiotics for bloating")
user-invocable: true
---

# Generate DS-01 Draft (2026 Messaging)

Generate a complete SEO-optimized article draft for Seed Health's DS-01 Daily Synbiotic content. This skill runs the full pipeline: competitor analysis first, then article generation using the analysis as input.

## Usage

```
/generate-ds01-draft-2026-04-29 probiotics for bloating
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

**Tier 1 - Science & Claims Authority:**
- `Reference/2026-03 DS-01 Updated Messaging Reference Files/POV_ 27APR2026.md`
  (General science perspective: probiotic definitions, transient nature, mechanisms, fermented foods, gut-brain axis, AFU vs CFU, disease discussion guidance, DS-01 clinical evidence, acclimation)
- `Reference/2026-03 DS-01 Updated Messaging Reference Files/New MRD/DS-01® Messaging + Positioning Reference Document • Claims Library.md`
  (Approved claims with disclaimers — the ABSOLUTE AUTHORITY for what can be said about DS-01)

**Tier 2 - Messaging Strategy:**
- `Reference/2026-03 DS-01 Updated Messaging Reference Files/New MRD/DS-01® Messaging + Positioning Reference Document • Product Positioning.md`
  (Consumer journey framework, messaging pillars, barriers & motivators)
- `Reference/2026-03 DS-01 Updated Messaging Reference Files/New MRD/DS-01® Messaging + Positioning Reference Document • Timeline of Benefits + Mechanisms.md`
  (Phased benefits: Restore/Rebalance/Optimize with proof points and mechanisms)
- `Reference/2026-03 DS-01 Updated Messaging Reference Files/New MRD/DS-01® Messaging + Positioning Reference Document • Product Topline messaging.md`
  (Product descriptions, headlines, formulation topline)

**Tier 3 - Voice, Style & Compliance:**
- `Reference/2026-03 DS-01 Updated Messaging Reference Files/Tone of Voice 2026.md`
  (Brand voice: "The Inspiring Scientist" — Grounding/Illuminating/Intriguing)
- `Reference/2026-03 DS-01 Updated Messaging Reference Files/COPYStyleGuide_27APRIL2026.md`
  (Technical writing standards: terminology, punctuation, trademarks, disclaimers)
- `Reference/2026-03 DS-01 Updated Messaging Reference Files/New MRD/DS-01® Messaging + Positioning Reference Document - disclaimer cheat sheet.md`
  (Mandatory disclaimer symbols and citation formatting)
- `Reference/Compliance/NO-NO-WORDS.md`
  (Words and phrases to avoid)
- `Phase 1 Reference Files/What we are and are not allowed to say when writing for Seed.md`
  (Phrase-level compliance: prohibited terms with approved alternatives)

### Step 2.1: Internal Processing (Think, Don't Write Yet)

**A. Extract from stage1_analysis:**
- Section 1: User intent and core questions
- Section 2: Must-cover topics (competitive baseline)
- Section 3: Pre-vetted academic sources with DOIs (citation pool)
- Section 4: Selected PAA questions (for FAQs)

**B. Identify Seed's Unique Angles:**
- Find 2-3 pieces of "standard advice" from competitive baseline
- Cross-reference against the POV document and Claims Library
- Where conflicts or nuances exist, draft a Dirk Gevers, Ph.D. quote (1-3 sentences)
- Frame Seed's view as their specific approach, not the only correct view
- Use the Consumer Journey messaging pillars from Product Positioning to align angles with the appropriate stage

**C. Build Evidence Strategy:**
- Tier 1 (USE FIRST): Claims and citations from the Claims Library (Allegretti et al. 2026 n=350 is the landmark study — citation ¹ is always reserved for this trial)
- Tier 2 (USE NEXT): Citations from the POV document and Timeline of Benefits
- Tier 3 (SUPPLEMENT): Pre-vetted academic sources from stage1_analysis Section 3
- Target ~1 citation per 75-100 words. Max 20-23 total sources.
- Cite: study results, quantitative data, mechanisms, health claims, safety info
- Do NOT cite: basic definitions, common biological processes, transitions, general advice
- ONLY peer-reviewed academic sources with working doi.org links
- All DS-01 product claims MUST use EXACT language from Claims Library
- All claims MUST include required disclaimers per the Disclaimer Cheatsheet

**D. Develop Outline:**
- Overview, Introduction, 3-5 H2 body sections, The Key Insight, FAQs
- Must address competitive baseline requirements
- Layer Seed's unique angles on top of baseline
- Use the Timeline of Benefits phasing (Restore/Rebalance/Optimize) when discussing what to expect from DS-01

### Step 2.2: Write the Article

#### Voice & Tone Target

Embody **"The Inspiring Scientist"** personality from the 2026 Tone of Voice guide. The voice has three pillars:

**Grounding** — Clear, concise, human. Confident, never casual. Cut through complexity. Resist exaggeration and superlatives.
- Write like a brilliant mentor: clear, direct, empowering
- Use "you" more than "we"
- Balance technical credibility with emotional relevance

**Illuminating** — Translate information into understanding. Educational without being didactic.
- Use progressive disclosure (don't overwhelm)
- Use analogy to build bridges ("Like an operating system for your body...")
- Lead with meaning, not mechanisms

**Intriguing** — Spark curiosity. Tilt the frame, uncover what others overlook.
- Lead with the angle no one expects
- Say the thing others won't, confidently
- Make the offbeat magnetic, not alienating

**Sentence-level patterns:**
- Use "you" and "your" in nearly every paragraph
- Always use contractions (don't, you're, it's, won't, isn't)
- Use parenthetical asides: "(even if that sounds counterintuitive)", "(yes, really)", "(which, fair enough)"
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
- No bold callout boxes (Pro Tip, TL;DR, etc.)
- No words/phrases from the NO-NO WORDS list
- Never call probiotics "supplements"
- No product spec dumps (don't list "24 strains at 53.6 billion AFU" in one sentence)
- No more than 1 rhetorical question per 500 words
- No academic or clinical tone — you're an inspiring scientist, not a professor
- No exclamation points unless they serve a precise purpose (per COPYStyleGuide)
- Use "microbiome" for the entire ecology, "microbiota" for specific microbes
- Oxford commas always
- Em dashes without spaces on either side
- Do NOT call out individual strain names — refer to formulation-level attributes ("24-strain probiotic + prebiotic", "clinically validated formulation") not individual strains
- Do NOT use genus/species names of individual strains in the draft text (Lactobacillus/Bifidobacterium genera are acceptable when discussing mechanisms broadly, per the Timeline of Benefits)

**DS-01 Mentions:**
- 1-3 natural mentions, all hyperlinked to https://seed.com/daily-synbiotic
- Format: [DS-01® Daily Synbiotic](https://seed.com/daily-synbiotic)
- Keep mentions casual and brief — don't dump product specs
- Position as complementary to food-based approaches, never a replacement
- Use ONLY approved claim language from the Claims Library when making product-specific claims
- Include required disclaimers per the Disclaimer Cheatsheet
- Key evidence asset: Allegretti et al. 2026 clinical trial (n=350, 6-week RCT) — this is the landmark DS-01 study

**Dirk Gevers, Ph.D. Quote:**
- 1-2 quotes total, each 1-3 sentences
- Attribute as: says **Dirk Gevers, Ph.D.** or explains **Dirk Gevers, Ph.D.**
- Must reinforce a genuine Seed differentiator (clinical validation, precision approach, microbiome science)
- Not generic wellness advice
- Do NOT focus quotes on individual strains

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
- [ ] All DS-01 product claims use EXACT language from Claims Library
- [ ] Required disclaimers present for all claims (per Disclaimer Cheatsheet)
- [ ] DS-01® uses ® symbol; other products use correct trademark (™ or ®) per COPYStyleGuide
- [ ] No individual strain names called out — formulation-level language only
- [ ] "Microbiome" vs "microbiota" used correctly per COPYStyleGuide
- [ ] Oxford commas used throughout
- [ ] Em dashes without spaces
- [ ] Bacteria genus/species italicized where used (per COPYStyleGuide)
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
tags: [seed, seo-draft, ds-01, 2026-messaging]
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
Compliance: Checked (Claims Library language verified, disclaimers present)

Ready for review with /review-draft-seed-perspective or /review-draft-1-v2
```
