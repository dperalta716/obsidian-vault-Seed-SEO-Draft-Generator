# phase-1-analyze-seo-draft-step-1

Performs competitive analysis of a published Seed blog article against top-ranking competitors and generates revision instructions for Phase 1 content improvements.

## Usage

```
/phase-1-analyze-seo-draft-step-1 <url_or_path> <primary_keyword>
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
5. **Consults Seed's SciCare POV** to identify unique scientific perspectives and compliance restrictions (MANDATORY)
6. **Performs in-depth analysis** comparing the published article to competitors through Seed's scientific lens
7. **Validates recommendations through SEO safety checklist** to prevent harm to existing SEO elements (MANDATORY)
8. **Outputs a structured comparison** highlighting strengths, gaps, and SEO-safe Seed-aligned recommendations
9. **Asks for your feedback** on which improvements to implement
10. **Generates detailed instructions** for the content drafter with bolding and citation requirements

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

**Required File to Review**:
- **Primary Reference**: SciCare POV - Complete.md

**Additional Reference Files**:
- What we are and are not allowed to say when writing for Seed.md
- Seed Tone of Voice and Article Structure.md

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

- ✅ Does this competitor topic align with Seed's scientific stance?
- ✅ Would this recommendation contradict Seed's compliance guidelines?
- ✅ Does Seed frame this topic differently than standard industry messaging?
- ✅ Has DS-01/PDS-08 been studied for this specific use case?
- ✅ Are there any restrictions on what Seed can/cannot claim?

**Required Output for Step 3**:

Create a brief summary (3-5 bullet points) documenting:

1. **Key Seed Perspectives Found**: List 2-3 topics where Seed has unique scientific positions
   - Example: "Fermented foods: Seed distinguishes LDM vs. probiotics; cannot casually recommend as 'probiotic foods'"

2. **Conflicts Identified**: Note any competitor recommendations that contradict Seed's stance
   - Example: "Competitors recommend fermented foods as probiotic alternatives; this contradicts Seed's scientific position"

3. **Reframing Needed**: Flag topics that need Seed-aligned framing
   - Example: "If addressing fermented foods, must clarify they're NOT probiotics scientifically"

4. **Topics to Avoid**: List any topics Seed cannot address due to lack of clinical data
   - Example: "SIBO: DS-01 not studied in this population; avoid detailed discussion"

**Example Output**:

> **Seed Perspective Summary:**
>
> 1. **Fermented Foods**: Competitors casually list yogurt/kefir as "probiotic foods." Per SciCare POV (lines 1993-2036), Seed distinguishes these as "Live Dietary Microbes" that are NOT technically probiotics. If recommending, must clarify scientific distinction and link to Seed's article.
>
> 2. **SIBO**: Competitors discuss SIBO connection to probiotics. Per SciCare POV (lines 2094-2178), DS-01 has NOT been studied in SIBO populations; Seed cannot comment on efficacy. Avoid detailed SIBO discussion or reframe as "persistent symptoms may signal other conditions - consult physician."
>
> 3. **Transient Nature**: Seed emphasizes probiotics are transient visitors, not colonizers (lines 343, 553-556). This is a key differentiator to weave into recommendations.

**Important**: This step is MANDATORY. Do not proceed to Step 3 without completing SciCare POV review. Missing this step leads to recommendations that contradict Seed's scientific positions.

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
   - ✅ Does NOT remove or replace headers that contain the primary keyword
   - ✅ Does NOT suggest removing keywords from existing headers
   - ✅ NEW headers don't need forced keyword insertion (natural language is fine)
   - ❌ BAD: "Change 'How Probiotics Support Gut Health' to 'Understanding the Science'"
   - ✅ GOOD: "Add new H3 'Timing Your Probiotic Dose' under existing 'How to Take Probiotics' section"

2. **Keyword Presence**:
   - ✅ Recommendation maintains or improves overall keyword presence in article
   - ✅ Does NOT dilute keyword density by adding large blocks of off-topic content
   - ✅ New content includes semantic keywords naturally (not forced)

3. **Meta Elements**:
   - ✅ Does NOT suggest changing title tags, meta descriptions, or URL slugs
   - ❌ NEVER recommend: "Update SEO title to..." or "Change URL to..."

4. **Internal Links**:
   - ✅ Does NOT remove existing internal links
   - ✅ Can suggest adding NEW internal links to relevant Seed content

5. **Readability & User Intent**:
   - ✅ Does NOT add keyword stuffing or unnatural phrasing
   - ✅ Maintains alignment with primary keyword's search intent
   - ✅ Additions serve user needs, not just SEO manipulation

**If a Recommendation Fails SEO Check**:
- **Revise it** to preserve SEO elements (e.g., "Add content AFTER existing H2 instead of replacing it")
- **Remove it** if it can't be salvaged without SEO harm
- **Document** any removed recommendations and why

**Final Validation**:
- Review the complete list of 8-12 recommendations
- Ensure at least 50% maintain or enhance SEO elements
- Flag any high-risk recommendations for user awareness

**Example Output**:

> **SEO Review Summary:**
> - ✅ 10/12 recommendations are SEO-safe
> - ⚠️ Revised Recommendation #4: Changed from "replace H2" to "add new subsection under existing H2" to preserve keyword in header
> - ❌ Removed original Recommendation #7: Would have removed internal link to high-value Seed article

### Step 4: Interactive Feedback

Present analysis and ask: **"What changes should we implement into this article?"**

Wait for user to specify which recommendations to proceed with.

### Step 5: Generate Drafter Instructions for Phase 1 Revisions

Based on selected improvements, create detailed implementation instructions including:

#### Reference Files Header
```
CRITICAL REFERENCE REQUIREMENT:

**Before writing ANY new content**, you MUST consult the following Seed reference files to extract Seed's unique scientific perspectives, especially the SciCare POV:

**Primary Reference (SciCare Perspective)**:
- SciCare POV - Complete.md

**Brand Voice & Compliance**:
- Seed Tone of Voice and Structure.txt
- 8 Sample Reference Blog Articles.txt
- What we are and are not allowed to say when writing for Seed.txt
- no-no words.csv

**Product Reference (DS-01)**:
- Ds-01 PDP.txt
- Ds-01 Science Reference File.txt
- seed strains.csv

Continue to draft according to Seed's established tone of voice and compliance guidelines.
```

#### Formatting Requirements
```
CRITICAL FORMATTING INSTRUCTIONS:

1. **BOLD all new additions or revisions** - Any text you add or modify must be bolded
2. **Leave original text unbolded** - Existing content that remains unchanged stays in regular text
3. **Citation Formatting (CRITICAL - MATCH EXISTING FORMAT EXACTLY)**:

   **Step 1: Analyze Existing Citation Format**
   - Before adding ANY new citations, carefully examine the existing citations list at the bottom of the article
   - Note the EXACT formatting pattern used (author names, year placement, punctuation, DOI format, etc.)
   - Common formats you might encounter:
     * "Author et al. (Year). Title. Journal. DOI link."
     * "Author Last Name, First Initial. (Year). Title. Journal Name, Volume(Issue), pages. DOI link."
     * "Last Name et al. Year. Title. Journal. DOI."

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
   - **BOLD** any new sources
   - Label new sources with "(New Source)" tag at the end
   - Example (match your article's actual format):
     * If existing format is: "Smith et al. (2023). Article title. Journal Name. https://doi.org/..."
     * Then new citation should be: **Smith et al. (2023). Article title. Journal Name. https://doi.org/... (New Source)**

   **Step 4: Verify Consistency**
   - After adding new citations, scan the entire citations list
   - Ensure new citations are indistinguishable from existing ones (except for bolding and "New Source" tag)
   - Fix any formatting discrepancies immediately

4. **Preserve ALL existing citations** - Do not remove any citations, even if total exceeds 15
5. **Follow SEO best practices** - Maintain keyword optimization, readability, and user intent alignment
```

#### For Each Improvement:
- **Clear placement instructions** (which section, before/after what content)
- **Specific content requirements** (what to write, how much detail)
- **Citation needs** (what claims must be cited)
- **Bolding reminder** (bold all new content)
- **Tone reminders** (maintain conversational, knowledgeable friend voice)

#### Final Checklist:
- [ ] All new health claims have citations
- [ ] New content properly bolded
- [ ] New citations marked as "New Source" in citations list
- [ ] ALL existing citations preserved
- [ ] Maintains SEO best practices (keywords, readability, intent)
- [ ] Safety/interaction information included where relevant
- [ ] Citations properly formatted with DOI links
- [ ] Maintains unique Seed perspective and SciCare POV

### Step 6: Save Drafting Instructions

After generating the detailed drafter instructions, automatically save them to a markdown file:

- **File location**: Same folder as the scraped article
- **File name**: `Drafting Instructions.md`
- **Format**: Complete markdown file with all sections from Step 5
- **Confirmation**: Notify user where the file was saved

**Example**: If analyzing article saved to `/Phase 1 Draft Revisions/004-probiotics-gut-health/`, save instructions to `/Phase 1 Draft Revisions/004-probiotics-gut-health/Drafting Instructions.md`

**Important**: Always create this file automatically - do not ask the user if they want it created.

## Example

```
/phase-1-analyze-seo-draft-step-1 /cultured/probiotics-for-gut-health "probiotics for gut health"
```

or

```
/phase-1-analyze-seo-draft-step-1 https://www.seed.com/cultured/signs-probiotics-are-working "signs probiotics are working"
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
8. Formatted drafter instructions ready for implementation
9. Drafting Instructions.md file automatically saved in article folder

## Notes

- **Phase 1 Specific**: Designed for revisions to existing published Seed articles (not NPD content)
- Uses Firecrawl skill for reliable article scraping
- Always uses exact keyword provided by user (not extracted from article)
- Sequential folder numbering keeps revisions organized
- **Preserves all existing citations** - no removal even if count >15
- **Bolding system** clearly marks new vs. existing content
- **MANDATORY SciCare POV consultation** (Step 2.5) - prevents recommendations that contradict Seed's scientific positions
- **MANDATORY SEO safety evaluation** (Step 3) - prevents recommendations that harm existing SEO elements
- SEO checklist validates headers, keyword presence, meta elements, internal links, and readability
- Prevents common SEO mistakes: removing keywords from headers, breaking internal links, keyword stuffing
- SciCare POV contains Seed's evidence-based positions, compliance restrictions, and scientific distinctions
- Common topics requiring SciCare POV check: fermented foods, SIBO, die-off reactions, colonization, dosing, CFU vs AFU
- Maintains Seed's unique scientific perspective and brand voice
- Focuses on SEO best practices throughout revision process
- Emphasizes evidence-based content additions with proper citations
