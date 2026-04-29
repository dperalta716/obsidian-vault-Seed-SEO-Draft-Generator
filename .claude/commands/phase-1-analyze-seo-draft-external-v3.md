# phase-1-analyze-seo-draft-external-v3

Performs competitive analysis of a published Seed blog article against top-ranking competitors and generates revision instructions for an **external human drafter** (Phase 1 content improvements). **v3 changes from v2: (1) Removes interactive recommendation approval step — auto-proceeds with all recommendations. (2) Adds comprehensive citation requirements — no placeholders, peer-reviewed sources only, explicit source hierarchy and in-text format.**

## Usage

```
/phase-1-analyze-seo-draft-external-v3 <url_or_path> <primary_keyword>
```

## Parameters

- `url_or_path` (required): Full URL or page path (e.g., `/cultured/article-slug`) of the published Seed article
- `primary_keyword` (required): The primary keyword to analyze (e.g., "probiotics for gut health")

## Description

This command automates a comprehensive SEO competitive analysis workflow for Phase 1 content revisions:

1. **Scrapes the published article** from seed.com using Firecrawl
2. **Creates organized folder** with sequential numbering in Phase 1 Draft Revisions
3. **Analyzes citation count** (no target enforcement - preserves all existing citations)
4. **Searches and fetches** the top 3-4 competing articles for that keyword
5. **Consults Seed's Seed 2026 Reference Files** to identify unique scientific perspectives and compliance restrictions (MANDATORY)
6. **Performs in-depth analysis** comparing the published article to competitors through Seed's scientific lens
7. **Validates recommendations through SEO safety checklist** to prevent harm to existing SEO elements (MANDATORY)
8. **Outputs a structured comparison** highlighting strengths, gaps, and SEO-safe Seed-aligned recommendations
9. **Auto-proceeds with ALL recommendations** (no interactive pause — v3 change)
10. **Generates detailed instructions** for the content drafter with bolding and citation requirements
11. Includes strategic analysis context (Seed 2026 Reference Files, competitive landscape, strengths/gaps) at the TOP of the drafting instructions
12. **NEW in v3**: All citations are real peer-reviewed sources with DOI links (no placeholders)

## Workflow

### Step 1: Scrape Published Article & Setup

1. **Process URL**:
   - If user provides page path (e.g., `/cultured/probiotics-guide`), prepend `https://www.seed.com`
   - If full URL provided, use as-is

2. **Scrape Article**:
   - Use firecrawl skill to scrape the complete article content
   - Ensure citations list at bottom is included
   - **Do NOT include images** - Remove any image markdown syntax from the scraped content
   - Save complete markdown content (text only)

3. **Create Numbered Folder**:
   - Look in `Seed-SEO-Draft-Generator-v4/Phase 1 Draft Revisions/`
   - Find highest numbered folder (e.g., if `003-article` exists, next is `004`)
   - Create new folder: `[NNN]-[primary-keyword]/`
   - Example: `004-probiotics-gut-health/`

4. **Save Scraped Article**:
   - Save to: `[NNN]-[primary-keyword]/[primary-keyword]-currently-published.md`
   - Example: `004-probiotics-gut-health/probiotics-gut-health-currently-published.md`

5. **Analyze Current State**:
   - Use the primary keyword provided by user (don't extract from article metadata)
   - Count existing citations (looking for DOI links and academic sources)
   - Note: **No target enforcement** - preserve ALL existing citations even if >15

### Step 2: Competitive Research

- Perform web search using the exact primary keyword (no modifications)
- Identify top 3-4 ranking articles from reputable sources
- Use WebFetch to analyze each competitor for:
  - Content structure and topics covered
  - Evidence approach (citations, studies mentioned)
  - Unique angles and positioning
  - Practical information (dosages, food sources, warnings)
  - Tone and target audience
  - Specific supplements or ingredients discussed

### Step 2.5: Consult Seed's 2026 Reference Files (MANDATORY)

**CRITICAL**: Before making ANY recommendations, you MUST consult Seed's reference files to understand their unique scientific perspectives.

**Required Files to Review**:
- `Reference/2026-03 DS-01 Updated Messaging Reference Files/POV_ 27APR2026.md` (Primary — general science perspective)
- `Reference/2026-03 DS-01 Updated Messaging Reference Files/New MRD/DS-01® Messaging + Positioning Reference Document • Claims Library.md` (Approved claims + disclaimers)
- `Phase 1 Reference Files/What we are and are not allowed to say when writing for Seed.md` (Phrase-level compliance)
- `Reference/2026-03 DS-01 Updated Messaging Reference Files/Tone of Voice 2026.md` (Brand voice)

**How to Use the Reference Files**:

1. **Identify Competitor Topics**: From Step 2, list topics competitors cover that might have Seed-specific perspectives

2. **Check the POV Document**: Review for Seed's positions on:
   - Probiotic definition (viability + dosage + evidence required)
   - Transient nature (probiotics don't colonize — they interact and exit)
   - Fermented foods vs probiotics (fermented foods don't necessarily meet probiotic criteria)
   - Gut-brain axis (serotonin story is oversimplified)
   - AFU vs CFU (AFU counts viable but non-culturable cells — more precise than CFU)
   - Disease discussion (separate general research from product context, avoid implied claims)
   - Acclimation (mild GI discomfort is normal when starting a potent probiotic)

3. **Check the Claims Library**: Verify what DS-01 can claim:
   - Bloating + gas claims (with required disclaimers)
   - Regularity claims
   - ViaCap® survivability claims
   - Potency comparison claims (24x, 18x, 13x)
   - Timeline claims (1 week, 2 weeks, 4 weeks, 6 weeks)

4. **Flag Conflicts**: Compare competitor recommendations against Seed's positions

**Required Output for Step 3**:

Create a brief summary (3-5 bullet points) documenting:

1. **Key Seed Perspectives Found**: List 2-3 topics where Seed has unique scientific positions
2. **Conflicts Identified**: Note any competitor recommendations that contradict Seed's stance
3. **Reframing Needed**: Flag topics that need Seed-aligned framing
4. **Topics to Avoid**: List any topics Seed cannot address due to lack of clinical data or POV guidance

**Important**: This step is MANDATORY. Do not proceed to Step 3 without completing reference file review.

### Step 3: Comparative Analysis Output

Generate a structured report with these sections:

#### Where Your Article Excels
- Scientific depth and novel approaches
- Evidence quality and citation strength
- Narrative coherence and storytelling
- Brand voice and accessibility
- Unique content elements not found in competitors

#### Where Competitors Have Advantages
- Popular topics or supplements you're missing
- Practical information (dosages, timing, food sources)
- Safety warnings and drug interactions
- Cost-benefit discussions
- User-friendly elements (lists, tables, FAQs)

#### Concrete Recommendations for Improvement
- Numbered list of 8-12 specific improvements
- Each with clear rationale and implementation notes
- Priority indicators (quick wins vs. major additions)
- Citation requirements for new content

#### SEO Evaluation of Recommendations (MANDATORY)

**CRITICAL**: Before presenting recommendations, run each one through this SEO safety checklist to prevent harm to existing SEO elements.

**For Each Recommendation, Verify**:

1. **Existing Headers (H2/H3)**:
   - Does NOT remove or replace headers that contain the primary keyword
   - Does NOT suggest removing keywords from existing headers
   - NEW headers don't need forced keyword insertion (natural language is fine)

2. **Keyword Presence**:
   - Recommendation maintains or improves overall keyword presence in article
   - Does NOT dilute keyword density by adding large blocks of off-topic content
   - New content includes semantic keywords naturally (not forced)

3. **Meta Elements**:
   - Does NOT suggest changing title tags, meta descriptions, or URL slugs
   - NEVER recommend: "Update SEO title to..." or "Change URL to..."

4. **Internal Links**:
   - Does NOT remove existing internal links
   - Can suggest adding NEW internal links to relevant Seed content

5. **Readability & User Intent**:
   - Does NOT add keyword stuffing or unnatural phrasing
   - Maintains alignment with primary keyword's search intent
   - Additions serve user needs, not just SEO manipulation

**If a Recommendation Fails SEO Check**:
- **Revise it** to preserve SEO elements
- **Remove it** if it can't be salvaged without SEO harm
- **Document** any removed recommendations and why

### Step 4: Auto-Proceed with All Recommendations

**Do NOT pause for user input.** Automatically proceed with ALL recommendations generated in Step 3. Do not ask "What changes should we implement?" or wait for approval. Move directly to generating the Drafting Instructions.

### Step 5: Generate Drafter Instructions for Phase 1 Revisions

Based on ALL improvements identified in Step 3, create detailed implementation instructions.

#### Document Structure Requirements (NEW in v2)

**CRITICAL**: The Drafting Instructions document MUST include strategic analysis context at the TOP, followed by the drafter instructions. Use this exact structure:

```markdown
# Strategic Analysis Context

## Seed Seed 2026 Reference Files Summary

### Key Seed Perspectives Found
- [List 2-3 topics where Seed has unique scientific positions relevant to this article]

### Conflicts Identified
- [Note any competitor recommendations that contradict Seed's stance]

### Topics to Handle Carefully
- [List topics requiring special framing or that Seed cannot address]

---

## Competitive Landscape Analysis

### Competitors Analyzed
- **[Competitor 1 Name/Source]**: [Brief description of their angle/approach]
- **[Competitor 2 Name/Source]**: [Brief description]
- **[Competitor 3 Name/Source]**: [Brief description]
- **[Competitor 4 Name/Source]**: [Brief description]

---

## Where Your Article Excels
- [Bullet point 1 - specific strength]
- [Bullet point 2 - specific strength]
- [Bullet point 3 - specific strength]
- [Continue as needed]

---

## Where Competitors Have Advantages
- [Bullet point 1 - specific gap/advantage]
- [Bullet point 2 - specific gap/advantage]
- [Bullet point 3 - specific gap/advantage]
- [Continue as needed]

---

## Content Gaps Identified
- [Specific missing element 1]
- [Specific missing element 2]
- [Specific missing element 3]
- [Continue as needed]

---
---

# Drafting Instructions

[The actual drafting instructions for the human drafter follow below]

---

[INSTRUCTIONS START HERE]
```

#### Reference Files Header
```
CRITICAL REFERENCE REQUIREMENT:

**Before writing ANY new content**, you MUST consult the following Seed reference files:

**Primary Reference (2026 Messaging)**:
- POV_ 27APR2026.md (general science perspective)
- DS-01® Claims Library (approved claims + disclaimers)
- DS-01® Product Positioning (consumer journey + messaging pillars)
- DS-01® Timeline of Benefits + Mechanisms (phased benefits)

**Brand Voice & Compliance**:
- Tone of Voice 2026.md
- COPYStyleGuide_27APRIL2026.md
- What we are and are not allowed to say when writing for Seed.md
- NO-NO-WORDS.md

Continue to draft according to Seed's 2026 tone of voice and compliance guidelines.
```

#### Formatting Requirements
```
CRITICAL FORMATTING INSTRUCTIONS:

1. **BOLD all new additions or revisions** - Any text you add or modify must be bolded
2. **Leave original text unbolded** - Existing content that remains unchanged stays in regular text
3. **Citation Formatting (CRITICAL)**:

   **NO PLACEHOLDER CITATIONS.** Every recommendation that includes a new health claim MUST have the actual citation found and inserted. Do NOT write "[citation needed]", "[add citation here]", or any placeholder text. If a citation is required, find it and include it. If you cannot find a suitable peer-reviewed source for a claim, flag it explicitly as "Unable to find peer-reviewed source for this claim — consider removing or rewording."

   **Source Quality Rules (MANDATORY — Peer-Reviewed Only):**
   - ONLY peer-reviewed academic sources are acceptable (published in journals indexed in PubMed, PMC, or equivalent)
   - **DO NOT USE** as direct citations: NIH fact sheets, WebMD articles, Healthline, health blogs, news articles, Mayo Clinic pages, Cleveland Clinic pages, or any non-peer-reviewed source — even if competitors cite them
   - Prioritize: meta-analyses, systematic reviews, randomized controlled trials, and cohort studies (in that order)
   - Prefer recent studies (last 10 years) unless a foundational/landmark study is more appropriate
   - Every citation MUST include a working DOI link

   **Source Hierarchy:**
   - **First:** Check the existing article's citation list — reuse and build on sources already cited in the published article
   - **Second:** Search for new peer-reviewed studies from PubMed/PMC if gaps remain
   - For every new source, obtain: DOI link, first author last name, publication year, journal name

   **What to Cite vs. What NOT to Cite:**
   - **CITE:** Specific study results, quantitative data (percentages, dosages, effect sizes), specific mechanisms of action, direct health claims linking ingredient to benefit, safety/contraindication information, novel or potentially controversial claims
   - **DO NOT CITE:** Basic definitions widely understood, common biological processes, broad transitional sentences, common health/lifestyle advice

   **In-Text Citation Format:**
   - Format: `([Author Year](DOI_URL))`
   - `Author` = last name of first author. `Year` = publication year. **No comma** between Author and Year.
   - The **entire `(Author Year)` text** must be hyperlinked to the source's `doi.org` URL
   - Multiple sources for same claim: `([Author1 Year1](DOI_URL1), [Author2 Year2](DOI_URL2))`
   - Example: `([Zhang 2021](https://doi.org/10.1016/j.example))`

   **End-of-Article Citation List:**
   - Analyze the existing citation format at the bottom of the article and match it exactly
   - **BOLD** any new sources added
   - Label new sources with "(New Source)" tag at the end
   - Ensure new citations are formatted identically to existing ones (except for bolding and tag)
   - Every citation (existing and new) MUST include: Author(s), Year, **Full Paper Title**, _Journal Name_, Volume(Issue), Pages, and **DOI link**
   - Do NOT use abbreviated journal-only format (e.g., "Author et al. J Clin Gastroenterol. 2014;48:407-413") — always include the full paper title and a clickable DOI URL
   - Verify DOI links are working

4. **Preserve ALL existing citations** - Do not remove any citations, even if total exceeds 15
5. **Follow SEO best practices** - Maintain keyword optimization, readability, and user intent alignment
```

#### For Each Improvement:
- **Clear placement instructions** (which section, before/after what content)
- **Specific content requirements** (what to write, how much detail)
- **Citation format in recommendations** (CRITICAL): Each "Citation to use" line MUST include the FULL citation details:
  `- Author(s). (Year). Full Paper Title. _Journal Name_, Volume(Issue), Pages. DOI_URL`
  Do NOT use abbreviated format like `([Author Year](DOI)) — brief description`. The drafter needs the complete reference to verify and insert correctly.
- **Bolding reminder** (bold all new content)
- **Tone reminders** (maintain conversational, knowledgeable friend voice)

#### Final Checklist:
- [ ] All new health claims have actual peer-reviewed citations (NO placeholders)
- [ ] New content properly bolded
- [ ] New citations marked as "New Source" in citations list
- [ ] ALL existing citations preserved
- [ ] In-text citations use `([Author Year](DOI_URL))` format
- [ ] All citation sources are peer-reviewed (no NIH fact sheets, WebMD, blogs, news articles)
- [ ] Maintains SEO best practices (keywords, readability, intent)
- [ ] Safety/interaction information included where relevant
- [ ] Citations have working DOI links
- [ ] Maintains unique Seed perspective and Seed 2026 Reference Files

### Step 6: Save Drafting Instructions

After generating the detailed drafter instructions, automatically save them to a markdown file:

- **File location**: Same folder as the scraped article
- **File name**: `Drafting Instructions.md`
- **Format**: Complete markdown file with strategic context at TOP, then drafter instructions
- **Confirmation**: Notify user where the file was saved

**Example**: If analyzing article saved to `/Phase 1 Draft Revisions/004-probiotics-gut-health/`, save instructions to `/Phase 1 Draft Revisions/004-probiotics-gut-health/Drafting Instructions.md`

**Important**: Always create this file automatically - do not ask the user if they want it created.

### Step 7: Create Google Doc

After saving the Drafting Instructions to Obsidian, create a Google Doc with the same content using the **google-docs skill** located at `~/.claude/skills/google-docs/` (see the skill's `SKILL.md` for full API reference).

1. **Create the Google Doc** titled with the primary keyword
2. **Populate it** with the full Drafting Instructions content (strategic context + drafting instructions)
3. **Report the Google Doc link** to the user

**Important**: This step is MANDATORY. Do not skip Google Doc creation.

### Final Quality Checklist

Before saving, verify:
- [ ] **Strategic context sections included at TOP** (Seed 2026 Reference Files, Competitive Landscape, Excels, Advantages, Gaps)
- [ ] Drafter instructions are clear and actionable
- [ ] ALL existing citations preserved in guidance
- [ ] **NO placeholder citations** — every recommendation requiring a citation has a real, properly formatted citation with DOI link
- [ ] **All new citations are peer-reviewed academic sources** — no NIH fact sheets, WebMD, Healthline, blogs, or news articles
- [ ] **In-text citations use correct format**: `([Author Year](DOI_URL))`
- [ ] Content guidance aligns with Seed's Seed 2026 Reference Files
- [ ] No forbidden terms from no-no words list suggested
- [ ] Maintains SEO best practices guidance
- [ ] Tone guidance matches Seed's knowledgeable friend voice

## Example

```
/phase-1-analyze-seo-draft-external-v3 /cultured/probiotics-for-gut-health "probiotics for gut health"
```

or

```
/phase-1-analyze-seo-draft-external-v3 https://www.seed.com/cultured/signs-probiotics-are-working "signs probiotics are working"
```

## Output Format

The command provides:
1. Scraped article saved to numbered folder in Phase 1 Draft Revisions
2. Initial citation count (no target enforcement)
3. Competitive landscape summary
4. **Seed Perspective Summary** (from Seed 2026 Reference Files consultation) documenting unique positions and conflicts
5. Detailed comparative analysis through Seed's scientific lens
6. **SEO Review Summary** showing recommendations validated against SEO safety checklist
7. Auto-proceeds with all recommendations (no interactive pause)
8. Formatted drafter instructions with:
   - **Strategic analysis context at TOP** (NEW in v2)
   - Clear implementation guidance for human drafter
9. Drafting Instructions.md file automatically saved in article folder
10. **NEW in v3**: Google Doc automatically created with the Drafting Instructions content and link reported to user

## Key Differences from Other Commands

| Aspect | external-v1 | external-v2 | external-v3 (this command) | claude-v1 | claude-v2 |
|--------|-------------|-------------|----------------------------|-----------|-----------|
| Output | Instructions for human drafter | Instructions + strategic context | Instructions + strategic context | Revised article | Revised article + strategic context |
| Final file | `Drafting Instructions.md` | `Drafting Instructions.md` | `Drafting Instructions.md` + **Google Doc** | `v2-revised-[keyword].md` | `v2-revised-[keyword].md` |
| Who drafts | Human drafter (Sydni) | Human drafter (Sydni) | Human drafter (Sydni) | Claude directly | Claude directly |
| Strategic context | No | Yes | **Yes** | No | Yes |
| Auto-proceed | N/A | No (pauses for approval) | **Yes (no pause)** | N/A | N/A |
| Citation quality | Basic format matching | Basic format matching | **Peer-reviewed only, no placeholders, explicit format** | Basic | Basic |

## Notes

- **Phase 1 Specific**: Designed for revisions to existing published Seed articles (not NPD content)
- Uses Firecrawl skill for reliable article scraping
- Always uses exact keyword provided by user (not extracted from article)
- Sequential folder numbering keeps revisions organized
- **Preserves all existing citations** - no removal even if count >15
- **Bolding system** clearly marks new vs. existing content in guidance
- **MANDATORY Seed 2026 Reference Files consultation** (Step 2.5) - prevents recommendations that contradict Seed's scientific positions
- **MANDATORY SEO safety evaluation** (Step 3) - prevents recommendations that harm existing SEO elements
- **v2**: Final document includes strategic analysis context (Seed 2026 Reference Files summary, competitive landscape, strengths, gaps) at the TOP for drafter context
- **NEW in v3**: No interactive pause — auto-proceeds with all recommendations
- **NEW in v3**: Comprehensive citation requirements — peer-reviewed only, no placeholders, explicit in-text format `([Author Year](DOI_URL))`, source hierarchy (existing article citations first, then new PubMed/PMC research)
- **NEW in v3**: Automatically creates Google Doc using google-docs skill and reports link to user
- Maintains Seed's unique scientific perspective and brand voice
- Focuses on SEO best practices throughout revision process
