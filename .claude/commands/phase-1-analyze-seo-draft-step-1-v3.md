# phase-1-analyze-seo-draft-step-1-v3

Performs competitive analysis of a published Seed blog article against top-ranking competitors, then **directly drafts the revisions** based on your selected recommendations. **v3 adds strategic analysis context at the top of the final document.**

## Usage

```
/phase-1-analyze-seo-draft-step-1-v3 <url_or_path> <primary_keyword>
```

## Parameters

- `url_or_path` (required): Full URL or page path (e.g., `/cultured/article-slug`) of the published Seed article
- `primary_keyword` (required): The primary keyword to analyze (e.g., "probiotics for gut health")

## Description

This command automates a comprehensive SEO competitive analysis workflow for Phase 1 content revisions, then **directly drafts the revised article** (instead of generating instructions for a separate drafter):

1. **Scrapes the published article** from seed.com using Firecrawl
2. **Creates organized folder** with sequential numbering in Phase 1 Draft Revisions
3. **Analyzes citation count** (no target enforcement - preserves all existing citations)
4. **Searches and fetches** the top 3-4 competing articles for that keyword
5. **Consults Seed's SciCare POV** to identify unique scientific perspectives and compliance restrictions (MANDATORY)
6. **Performs in-depth analysis** comparing the published article to competitors through Seed's scientific lens
7. **Validates recommendations through SEO safety checklist** to prevent harm to existing SEO elements (MANDATORY)
8. **Outputs a structured comparison** highlighting strengths, gaps, and SEO-safe Seed-aligned recommendations
9. **Asks for your feedback** on which improvements to implement
10. **Directly drafts the revised article** with your selected improvements (bolding new content)
11. **NEW in v3**: Includes strategic analysis context (SciCare POV, competitive landscape, strengths/gaps) at the TOP of the final document

## Reference Files

All reference files are located at:
```
Seed-SEO-Draft-Generator-v4/Phase 1 Draft Revsions/Phase 1 Reference Files/
```

**Available Files**:
- `SciCare POV - Complete.md` - Primary reference for Seed's scientific positions
- `Seed Tone of Voice and Article Structure.md` - Brand voice guidelines
- `What we are and are not allowed to say when writing for Seed.md` - Compliance rules
- `no-no words.md` - Forbidden terms and phrases
- `Ds-01 PDP.md` - DS-01 product page content
- `Ds-01 Science Reference File.md` - DS-01 scientific background
- `seed strains.md` - Strain information

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

### Step 2.5: Consult Seed's SciCare POV (MANDATORY)

**CRITICAL**: Before making ANY recommendations, you MUST consult Seed's reference files to understand their unique scientific perspectives.

**Primary Reference File**:
```
Seed-SEO-Draft-Generator-v4/Phase 1 Draft Revsions/Phase 1 Reference Files/SciCare POV - Complete.md
```

**Additional Reference Files**:
```
Seed-SEO-Draft-Generator-v4/Phase 1 Draft Revsions/Phase 1 Reference Files/What we are and are not allowed to say when writing for Seed.md
Seed-SEO-Draft-Generator-v4/Phase 1 Draft Revsions/Phase 1 Reference Files/Seed Tone of Voice and Article Structure.md
```

**How to Use SciCare POV**:

1. **Identify Competitor Topics**: From Step 2, list topics competitors cover that might have Seed-specific perspectives

2. **Search SciCare POV**: Use Grep tool to search for those topics in the SciCare POV document
   - Example: `Grep pattern="fermented food|probiotic food"` searching in SciCare POV - Complete.md

3. **Extract Seed's Position**: For each topic found:
   - Read the relevant section (usually 5-20 lines of context)
   - Note Seed's scientific stance
   - Identify any restrictions (e.g., "not studied in this population")
   - Document compliance-safe framing

4. **Flag Conflicts**: Compare competitor recommendations against Seed's positions

**Common Topics to Check** (search these patterns in SciCare POV):

- **Fermented foods/probiotic foods**: Search `fermented food|yogurt|kefir|kimchi`
  - Key issue: Seed distinguishes "Live Dietary Microbes (LDM)" vs. probiotics scientifically
  - Fermented foods ≠ probiotics (varying amounts, no defined dose, no demonstrated specific benefits)

- **Die-off reactions**: Search `die-off|herxheimer`
  - Key issue: Seed's stance is this is scientifically unsubstantiated for probiotics

- **Colonization**: Search `colonization|transient`
  - Key issue: Seed emphasizes probiotics are transient, don't colonize long-term

- **SIBO**: Search `SIBO|small intestinal bacterial overgrowth`
  - Key issue: Check if DS-01 studied in this population; cannot comment if not

- **Side effects/acclimation**: Search `side effect|acclimation|adjustment`
  - Key issue: Seed frames as "temporary acclimation period" confined to GI system

- **Prebiotics**: Search `prebiotic`
  - Key issue: Seed's specific framing of food sources ("small amounts") vs. supplements ("precise doses")

- **Dosing/CFUs**: Search `dose|CFU`
  - Key issue: Check Seed's recommendations and studied dosages

- **CFU vs AFU**: Search `AFU|CFU|colony forming`
  - Key issue: Seed's position is "AFU is a more precise measurement than CFU" (not "more accurate")

- **Specific conditions**: Search condition name (e.g., `IBS|IBD|constipation|diarrhea`)
  - Key issue: Verify what DS-01 has/hasn't been studied for

**Analysis Questions to Answer**:

- Does this competitor topic align with Seed's scientific stance?
- Would this recommendation contradict Seed's compliance guidelines?
- Does Seed frame this topic differently than standard industry messaging?
- Has DS-01/PDS-08 been studied for this specific use case?
- Are there any restrictions on what Seed can/cannot claim?

**Required Output for Step 3**:

Create a brief summary (3-5 bullet points) documenting:

1. **Key Seed Perspectives Found**: List 2-3 topics where Seed has unique scientific positions
2. **Conflicts Identified**: Note any competitor recommendations that contradict Seed's stance
3. **Reframing Needed**: Flag topics that need Seed-aligned framing
4. **Topics to Avoid**: List any topics Seed cannot address due to lack of clinical data

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

### Step 4: Interactive Feedback

Present analysis and ask: **"Which of these recommendations should I incorporate into the revised draft?"**

Wait for user to specify which recommendations to proceed with.

### Step 5: Direct Revision Drafting

Based on user's selected improvements, **directly draft the revised article**.

#### Before Drafting - Load Reference Files

Read and apply guidance from:
```
Seed-SEO-Draft-Generator-v4/Phase 1 Draft Revsions/Phase 1 Reference Files/
├── SciCare POV - Complete.md (Seed's scientific positions)
├── Seed Tone of Voice and Article Structure.md (brand voice)
├── What we are and are not allowed to say when writing for Seed.md (compliance)
├── no-no words.md (forbidden terms)
├── Ds-01 PDP.md (product info)
├── Ds-01 Science Reference File.md (scientific background)
└── seed strains.md (strain details)
```

#### Document Structure Requirements (NEW in v3)

**CRITICAL**: The final v2-revised document MUST include strategic analysis context at the TOP, followed by the revised article. Use this exact structure:

```markdown
# Strategic Analysis Context

## Seed SciCare POV Summary

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

# Revised Article

[The actual revised article content with bolded new additions follows below]

---

[ARTICLE CONTENT STARTS HERE]
```

#### Drafting Requirements

1. **BOLD all new additions or revisions** - Any text you add or modify must be bolded using `**text**`
2. **Leave original text unbolded** - Existing content that remains unchanged stays in regular text
3. **Preserve ALL existing citations** - Do not remove any citations, even if total exceeds 15

#### Citation Formatting (CRITICAL - MATCH EXISTING FORMAT EXACTLY)

**Step 1: Analyze Existing Citation Format**
- Before adding ANY new citations, carefully examine the existing citations list at the bottom of the article
- Note the EXACT formatting pattern used (author names, year placement, punctuation, DOI format, etc.)

**Step 2: Match the Format Precisely**
- Your new citations MUST use the IDENTICAL format as existing citations
- Pay attention to:
  * Author name format (et al. placement, initials vs. full names)
  * Year placement (parentheses or not)
  * Punctuation after each element
  * Title capitalization
  * Journal name format (abbreviated or full)
  * DOI presentation (just link, or "DOI:" prefix)

**Step 3: Add New Citations**
- **BOLD** any new sources in the citations list
- Label new sources with "(New Source)" tag at the end
- Example: **Smith et al. (2023). Article title. Journal Name. https://doi.org/... (New Source)**

#### Content Guidelines

1. **Maintain Seed's Tone**: Write as a knowledgeable, empathetic friend explaining complex science in accessible terms
2. **Apply SciCare POV**: Ensure all new content aligns with Seed's unique scientific perspectives identified in Step 2.5
3. **Compliance Check**: Cross-reference new content against "What we are and are not allowed to say" and "no-no words"
4. **SEO Best Practices**: Maintain keyword optimization, readability, and user intent alignment
5. **Readability**: Keep paragraphs to 2-3 sentences, use 7th-8th grade reading level

#### For Each Selected Recommendation:

- Integrate the improvement naturally into the article flow
- Bold all new text
- Add supporting citations where health claims are made
- Maintain the article's existing structure unless specifically adding new sections

### Step 6: Save Revised Draft

After completing the revision:

1. **File location**: Same folder as the scraped article
2. **File name**: `v2-revised-[primary-keyword].md`
3. **Example**: If analyzing article saved to `/Phase 1 Draft Revisions/004-probiotics-gut-health/`, save revised draft to `/Phase 1 Draft Revisions/004-probiotics-gut-health/v2-revised-probiotics-gut-health.md`

**Confirmation**: Notify user where the file was saved and provide a summary of changes made.

### Final Quality Checklist

Before saving, verify:
- [ ] **Strategic context sections included at TOP** (SciCare POV, Competitive Landscape, Excels, Advantages, Gaps)
- [ ] All new content is properly **bolded**
- [ ] ALL existing citations preserved
- [ ] New citations match existing format exactly
- [ ] New citations labeled with "(New Source)"
- [ ] Content aligns with Seed's SciCare POV
- [ ] No forbidden terms from no-no words list
- [ ] Maintains SEO best practices (keywords, readability, intent)
- [ ] New health claims have supporting citations
- [ ] Tone matches Seed's knowledgeable friend voice

## Example

```
/phase-1-analyze-seo-draft-step-1-v3 /cultured/probiotics-for-gut-health "probiotics for gut health"
```

or

```
/phase-1-analyze-seo-draft-step-1-v3 https://www.seed.com/cultured/signs-probiotics-are-working "signs probiotics are working"
```

## Output Format

The command provides:
1. Scraped article saved to numbered folder in Phase 1 Draft Revisions
2. Initial citation count (no target enforcement)
3. Competitive landscape summary
4. **Seed Perspective Summary** (from SciCare POV consultation) documenting unique positions and conflicts
5. Detailed comparative analysis through Seed's scientific lens
6. **SEO Review Summary** showing recommendations validated against SEO safety checklist
7. Interactive recommendation selection
8. **Directly drafted revised article** with:
   - **Strategic analysis context at TOP** (NEW in v3)
   - Bolded new content throughout
9. `v2-revised-[keyword].md` file automatically saved in article folder

## Key Differences from v1 and v2

| Aspect | v1 | v2 | v3 (this command) |
|--------|-----|-----|-------------------|
| Output | Drafting instructions for separate drafter | Directly drafted revised article | Directly drafted revised article |
| Final file | `Drafting Instructions.md` | `v2-revised-[keyword].md` | `v2-revised-[keyword].md` |
| Who drafts | Human drafter or separate AI | This command directly | This command directly |
| Workflow | Analysis → Instructions → Manual drafting | Analysis → Selection → Automatic drafting | Analysis → Selection → Automatic drafting |
| **Strategic context in output** | ❌ Not included | ❌ Not included | ✅ **Included at TOP of document** |

## Notes

- **Phase 1 Specific**: Designed for revisions to existing published Seed articles (not NPD content)
- Uses Firecrawl skill for reliable article scraping
- Always uses exact keyword provided by user (not extracted from article)
- Sequential folder numbering keeps revisions organized
- **Preserves all existing citations** - no removal even if count >15
- **Bolding system** clearly marks new vs. existing content
- **MANDATORY SciCare POV consultation** (Step 2.5) - prevents recommendations that contradict Seed's scientific positions
- **MANDATORY SEO safety evaluation** (Step 3) - prevents recommendations that harm existing SEO elements
- Reference files located at `Phase 1 Draft Revsions/Phase 1 Reference Files/`
- Directly drafts revisions instead of generating instructions
- **NEW in v3**: Final document includes strategic analysis context (SciCare POV summary, competitive landscape, strengths, gaps) at the TOP for reviewer context
