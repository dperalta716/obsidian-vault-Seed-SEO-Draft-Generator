# pre-draft-competitor-analysis

Generates comprehensive competitive analysis for SEO draft preparation by analyzing top-ranking articles and extracting People Also Ask questions.

## Usage

```
/pre-draft-competitor-analysis <keyword>
```

## Parameters

- `keyword` (required): The target keyword to analyze (e.g., "american ginseng", "cellular health supplements")

## Description

This command creates a complete pre-draft research analysis document that serves as input for draft generators. It uses a single research coordinator agent to fetch SERP data, analyze top-ranking articles, and intelligently select the most relevant PAA questions.

## Workflow

### Single Agent Workflow: Competitive Analysis Coordinator

Launch ONE agent using the Task tool:

**Purpose**: Complete competitive landscape analysis including article analysis and PAA question selection.

**Instructions for Agent**:

```
You are the Competitive Analysis Coordinator for the keyword: "{keyword}"

Your mission: Analyze the top 5 ranking articles for this keyword, extract People Also Ask questions, and determine the competitive baseline and user intent.

---

STEP 1: FETCH SERP DATA FROM DATAFORSEO

Use the DataForSEO MCP tool `mcp__dfs-mcp-ai__serp_organic_live_advanced` with these parameters:

- keyword: "{keyword}"
- language_code: "en"
- location_name: "United States"
- search_engine: "google"
- depth: 10 (returns top 10 organic results)
- people_also_ask_click_depth: 2 (expands PAA questions)

This single call returns:
1. Top 10 organic search results with URLs
2. People Also Ask questions with expanded answers

---

STEP 2: EXTRACT DATA FROM SERP RESPONSE

From the DataForSEO response, extract:

A. **Top 5 Organic URLs** (from the 10 returned):
   - Filter items where type === "organic"
   - Take the first 5 results
   - Extract: URL, title, domain

B. **8 PAA Questions**:
   - Filter items where type === "people_also_ask"
   - Extract the question text from each item
   - Take up to 8 questions (or all available if fewer)
   - Store these for later intelligent selection

---

STEP 3: SCRAPE AND ANALYZE ARTICLES

For EACH of the 5 organic URLs, spawn a parallel sub-agent using the Task tool.

Each sub-agent will:
1. Use Firecrawl MCP to scrape the article
2. Analyze the content
3. Return structured findings

---

SUB-AGENT INSTRUCTIONS (spawn 5 in parallel):

You are analyzing a single competitor article for the keyword: "{keyword}"

Article URL: [INSERT URL]
Article Title: [INSERT TITLE]

STEP 1: SCRAPE ARTICLE CONTENT

Use the Firecrawl MCP tool `mcp__firecrawl__firecrawl_scrape` with these parameters:
- url: "[INSERT URL]"
- formats: ["markdown"]
- onlyMainContent: true
- waitFor: 2000

STEP 2: ANALYZE SCRAPED CONTENT

Extract structured information from the article:

REQUIRED OUTPUTS:

1. **Topics Covered** (list each topic with depth assessment):
   - Topic Name
   - Depth: Choose one based on coverage:
     * "light" - Brief mention (1-2 sentences)
     * "medium" - Paragraph-level coverage (3-6 sentences)
     * "deep" - Section-level with substantial detail (H2/H3 heading, multiple paragraphs)

2. **Claims & Sources** (identify using citation patterns):

   First, determine the article's main domain from the URL you're analyzing.
   Example: URL "https://www.healthline.com/nutrition/melatonin" → domain is "healthline.com"

   A sentence contains a CLAIM if it has:
   - An inline hyperlink to an EXTERNAL domain (different from the article's domain)
   - A parenthetical citation like (Author 2023) or [1]
   - A superscript reference number

   For each claim found:
   - **Claim**: Extract the full sentence containing the external link or citation
   - **Source Type**:
     * Primary: If external link goes to DOI, .edu, academic journal, peer-reviewed source
     * Secondary: If external link goes to health website, news site, or general source
   - **Source Details**: Extract author/year from citation OR domain name from external link
   - **Source URL**: The actual hyperlink

   IMPORTANT - Domain Matching:
   - Internal links (same domain as article) = NOT a claim, ignore these
   - External links (different domain) = Claim, extract it
   - Example: Article is on healthline.com
     * Link to healthline.com/other-article = internal, skip
     * Link to doi.org/study = external, this is a claim!

   DO NOT include as claims:
   - Sentences with only internal links (same domain)
   - Statements with no citations or external links
   - General transition sentences

3. **Notable Angles** (1-2 sentences):
   - Any unique perspectives or approaches this article takes
   - Anything that stands out as different from typical coverage

4. **Article Metadata**:
   - Estimated word count
   - Overall tone (scientific/casual/practical)
   - Citation density (heavily cited / moderately cited / lightly cited)

FORMAT YOUR RESPONSE AS STRUCTURED JSON:

{
  "url": "...",
  "title": "...",
  "word_count": "~1500",
  "topics": [
    {"name": "Topic 1", "depth": "deep"},
    {"name": "Topic 2", "depth": "medium"}
  ],
  "claims_and_sources": [
    {
      "claim": "Specific health claim text",
      "source_type": "primary",
      "source_details": "Author 2023",
      "source_url": "https://doi.org/..."
    }
  ],
  "notable_angles": "Description of unique approach",
  "metadata": {
    "tone": "scientific",
    "citation_density": "heavily cited"
  }
}

---

STEP 4: WAIT FOR ALL SUB-AGENTS TO COMPLETE

Collect all 5 article analysis JSON responses.

---

STEP 5: CONSOLIDATE COMPETITIVE FINDINGS

After all 5 sub-agents complete, analyze their JSON responses to determine:

1. **Primary User Search Intent**: What are users really looking for when they search this keyword?

2. **Core Questions Users Are Asking**: 3-4 fundamental questions this search query represents

3. **Competitive Baseline Requirements**:
   - Topics that MUST be covered (found in 3+ articles)
   - Typical depth/angle for each topic
   - Topic coverage patterns (structural patterns you notice)

4. **Citation & Evidence Landscape**:
   - Most commonly cited primary sources (academic studies)
   - Common secondary sources
   - Average citation density across competitors
   - Citation patterns (how heavily do competitors rely on research?)

5. **Synthesis**:
   - What does a competitive article look like? (structure, flow, depth)
   - What's the typical word count range?
   - What gaps or opportunities exist for differentiation?

---

STEP 6: INTELLIGENT PAA QUESTION SELECTION

Now that you understand the competitive landscape, select the **4 BEST PAA questions** from the 8 you extracted in Step 2.

Selection criteria:
- **Aligns with identified user intent** - Matches what users are really seeking
- **Fills content gaps** - Addresses topics competitors miss or skim over
- **Complements main topics** - Provides additional value without duplicating core content
- **Audience relevance** - Most valuable questions for target readers
- **Coverage diversity** - Represents different aspects of the topic

For each of the 4 selected questions, note WHY you selected it (1 sentence rationale).

---

STEP 7: FINAL OUTPUT FORMAT

Return a comprehensive JSON object with all findings:

{
  "keyword": "{keyword}",
  "user_intent": {
    "primary_intent": "...",
    "core_questions": ["Q1", "Q2", "Q3"]
  },
  "competitive_baseline": {
    "must_cover_topics": [
      {"topic": "Topic name", "frequency": "5/5 articles", "typical_depth": "deep"},
      ...
    ],
    "coverage_patterns": ["Pattern 1", "Pattern 2"]
  },
  "citation_landscape": {
    "primary_sources": [
      {"claim": "...", "source": "Author Year", "doi": "...", "used_by": ["#1", "#3"]}
    ],
    "secondary_sources": [
      {"source": "Healthline", "topics": ["Topic A"], "used_by": ["#1", "#2"]}
    ],
    "patterns": {
      "average_citations": "~12 per article",
      "most_cited": "Study name",
      "density": "Observation"
    }
  },
  "paa_questions": {
    "selected": [
      {"question": "Question 1", "rationale": "Why this was selected"},
      {"question": "Question 2", "rationale": "Why this was selected"},
      {"question": "Question 3", "rationale": "Why this was selected"},
      {"question": "Question 4", "rationale": "Why this was selected"}
    ],
    "not_selected": ["Question 5", "Question 6", "Question 7", "Question 8"]
  },
  "article_analyses": [
    ... (all 5 article JSON objects from sub-agents)
  ],
  "synthesis": {
    "competitive_profile": "2-3 sentences describing what competitive articles look like",
    "word_count_range": "1500-2200 words",
    "gaps_and_opportunities": ["Gap 1", "Opportunity 1"]
  }
}
```

---

### Synthesize Analysis Note

After the agent completes, the main command creates the final analysis document:

#### STEP 1: DETERMINE NEXT FOLDER NUMBER

```bash
# Find highest existing folder number
HIGHEST=$(ls -1 "Seed-SEO-Draft-Generator-v4/Generated-Drafts" | grep -E '^[0-9]{3}-' | sed 's/-.*//' | sort -n | tail -1)

# Increment and format with zero-padding
NEXT=$(printf "%03d" $((10#$HIGHEST + 1)))

# Create keyword slug (lowercase, hyphenated)
SLUG=$(echo "{keyword}" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

# Create folder
mkdir -p "Seed-SEO-Draft-Generator-v4/Generated-Drafts/${NEXT}-${SLUG}"
```

#### STEP 2: CREATE ANALYSIS NOTE

File path: `Seed-SEO-Draft-Generator-v4/Generated-Drafts/[NNN]-[keyword-slug]/stage1_analysis-[keyword-slug].md`

**Note Structure**:

```markdown
---
date: {YYYY-MM-DD}
keyword: "{keyword}"
analyzed_articles: 5
tags: [seed, competitor-analysis, pre-draft, seo]
---

# Stage 1 Pre-Draft Analysis: {Keyword}

*Generated: {Date}*
*Keyword: "{keyword}"*
*Analyzed: 5 top-ranking articles*

---

## 1. User Search Intent

**Primary Intent**: [From competitive analysis]

**Core Questions Users Are Asking**:
- [Question 1]
- [Question 2]
- [Question 3]

---

## 2. Competitive Baseline Requirements

### Topics That MUST Be Covered:

1. **[Topic Name]** - Found in [X/5] articles
   - Typical depth/angle: [Description]

2. **[Topic Name]** - Found in [X/5] articles
   - Typical depth/angle: [Description]

[Continue for all must-cover topics]

### Topic Coverage Patterns:
- [Pattern 1: e.g., "All articles lead with benefits before mechanism"]
- [Pattern 2: e.g., "4/5 articles include dosing guidance"]

---

## 3. Citation & Evidence Landscape

### Primary Research Sources (Academic):

| Claim | Source | DOI/Link | Used By Articles |
|-------|--------|----------|------------------|
| [Specific claim] | [Author Year] | [DOI] | #1, #3, #5 |
| [Specific claim] | [Author Year] | [DOI] | #2, #4 |

### Secondary Sources (Non-Academic):

- [Website name]: [Topics covered] - Used by: [Article numbers]
- [Website name]: [Topics covered] - Used by: [Article numbers]

### Citation Patterns:

- Average citations per article: [N]
- Most commonly cited study: [Study name/authors]
- Citation density: [Observation about how heavily cited vs editorial]

---

## 4. People Also Ask Questions

[Selected 4 most relevant from 8 fetched]

1. [PAA Question 1]
   - *Selected because*: [Rationale]

2. [PAA Question 2]
   - *Selected because*: [Rationale]

3. [PAA Question 3]
   - *Selected because*: [Rationale]

4. [PAA Question 4]
   - *Selected because*: [Rationale]

*Note: Use these for FAQ section. Selected based on user intent and content gaps.*

**Not Selected** (but available if needed):
- [Question 5]
- [Question 6]
- [Question 7]
- [Question 8]

---

## 5. Article-by-Article Analysis

### Article 1: [Title]

**URL**: [link]
**Word Count**: ~[estimate]
**Tone**: [scientific/casual/practical]
**Citation Density**: [heavily/moderately/lightly cited]

**Topics Covered**:
- [Topic 1] (depth: [light/medium/deep])
- [Topic 2] (depth: [light/medium/deep])
- [...]

**Claims & Sources**:

**Primary Sources:**
- **Claim**: "[Specific assertion]"
  - Source: [Author Year]
  - DOI: [link if available]

**Secondary Sources:**
- **Claim**: "[Another assertion]"
  - Source: [Website/organization name]

**Notable Angles**: [Unique perspectives or approaches]

---

[Repeat structure for Articles 2-5]

---

## 6. Synthesis for Drafting

### Competitive Baseline Summary:

[2-3 paragraphs describing what a competitive article looks like:
- Standard structure/flow
- Required topics and typical depth
- Citation approach
- Tone/accessibility level
- Word count range: [X-Y] words]

### Gaps & Opportunities for Seed:

- **Gap 1**: [e.g., "No articles discuss bioidentical forms"]
- **Gap 2**: [e.g., "Mechanism explanations are surface-level"]
- **Opportunity**: [How Seed can differentiate while meeting baseline]

### Recommended Approach:

1. **Meet baseline** by covering: [Key topics list]
2. **Layer Seed perspective** via: [Specific differentiators based on product messaging]
3. **Target word count**: 1800-2000 words (baseline articles range: [X-Y])
4. **Citation strategy**: [Based on competitive patterns - aim for ~12-15 academic sources]

---

## Notes for Drafter

- [Any specific observations that would help draft generation]
- [Watch-outs or cautions based on competitor analysis]
- [Opportunities to exceed competitive baseline]
```

#### STEP 3: SAVE AND CONFIRM

1. Write the complete analysis note to the file
2. Confirm to user:
   - File path created
   - Folder number used
   - Number of articles analyzed
   - Number of PAA questions selected (4 of 8)
   - Ready for draft generation

## Example

```
/pre-draft-competitor-analysis american ginseng
```

**Output**:
- Folder: `Seed-SEO-Draft-Generator-v4/Generated-Drafts/021-american-ginseng/`
- File: `stage1_analysis-american-ginseng.md`
- Contains: Complete competitive analysis with 5 article breakdowns, 4 selected PAA questions with rationales, user intent, and synthesis

## Implementation Notes

### For Claude Executing This Command:

1. **Single Agent Launch**: Launch one Task agent that orchestrates the entire workflow
2. **DataForSEO First**: Agent calls DataForSEO once to get URLs + PAA questions
3. **Parallel Scraping**: Agent spawns 5 sub-agents to scrape/analyze articles simultaneously
4. **Intelligent Selection**: Agent uses competitive insights to select best 4 of 8 PAA questions
5. **Folder Numbering**: Always check existing folders to get the correct next number
6. **Error Handling**: If DataForSEO or Firecrawl fails, report clearly and suggest retry
7. **Token Management**: Sub-agents keep article analysis in separate contexts

### Agent Workflow:

```
Main Agent
├─ DataForSEO call (gets URLs + PAA)
├─ Extract top 5 URLs, 8 PAA questions
├─ Spawn 5 parallel Firecrawl sub-agents
├─ Wait for completion
├─ Consolidate findings
├─ Select 4 best PAA questions
└─ Return complete JSON

Main Command
└─ Create analysis note
```

### Quality Checks:

- Verify all 5 articles were analyzed successfully
- Confirm 4 PAA questions selected with clear rationales
- Ensure primary sources are properly categorized
- Validate folder numbering incremented correctly
- Check that analysis note has all required sections
- Verify PAA selection is intelligent (not just first 4)

## Success Criteria

- ✅ Command accepts keyword input
- ✅ DataForSEO successfully fetches SERP data (URLs + PAA)
- ✅ Top 5 articles scraped and analyzed in parallel
- ✅ 8 PAA questions extracted, 4 intelligently selected
- ✅ Claims properly categorized (primary vs secondary)
- ✅ User intent and competitive baseline clearly defined
- ✅ Analysis note saved to correctly numbered folder
- ✅ Output is immediately usable by draft generator

## Related Commands

- `/analyze-seo-draft` - Post-draft competitive analysis
- `/review-draft-1` - Initial draft review
- `/review-sources-2` - Source verification

## Changes from v1

**v2 Improvements**:
- Single agent instead of two parallel agents (simpler architecture)
- DataForSEO used for both URLs and PAA questions (more efficient)
- Firecrawl scrape used instead of search (better control)
- Top 5 selected from 10 organic results (better accuracy)
- PAA selection includes rationales (transparency)

---

*This command implements Phase 1 (Tasks 1.1, 1.2, 1.3, 1.4) of the Seed Generator V4 Update Plan*
