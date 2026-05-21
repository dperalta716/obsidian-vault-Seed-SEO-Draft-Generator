# phase-1-analyze-seo-draft-external-mrd-compliant

Performs competitive analysis of a published Seed blog article against top-ranking competitors and generates revision instructions for an **external human drafter** (Phase 1 content improvements). **MRD-compliant version**: Uses 2026 DS-01 Messaging Reference Documents (Claims Library, Product Positioning, Timeline of Benefits, POV, Disclaimer Cheat Sheet) as primary authority. Includes Topic Appropriateness Gate, Objectivity & Implied Claims Guard, and SciCare POV Brief lookup.

## Usage

```
/phase-1-analyze-seo-draft-external-mrd-compliant <url_path_or_folder> <primary_keyword>
```

## Parameters

- `url_path_or_folder` (required): One of:
  - Full URL of the published Seed article (e.g., `https://www.seed.com/cultured/article-slug`)
  - Page path (e.g., `/cultured/article-slug`) — will prepend `https://www.seed.com`
  - Path to an existing Phase 1 Draft Revisions folder containing a `-currently-published.md` file (e.g., `025-probiotics-for-bad-breath`)
- `primary_keyword` (required): The primary keyword to analyze (e.g., "probiotics for gut health")

## Description

This command automates a comprehensive SEO competitive analysis workflow for Phase 1 content revisions:

1. **Loads the published article** — scrapes from seed.com OR reads from an existing folder's `-currently-published.md` file
2. **Creates organized folder** with sequential numbering in Phase 1 Draft Revisions (if scraping fresh)
3. **Analyzes citation count** (no target enforcement — preserves all existing citations)
4. **Checks for SciCare POV Brief** in `Reference/SciCare POV briefs/` for topic-specific Seed perspective
5. **Searches and fetches** the top 3-4 competing articles for that keyword
6. **Consults Seed's 2026 MRD documents** to identify unique scientific perspectives, compliance restrictions, and approved claims (MANDATORY)
7. **Applies Topic Appropriateness Gate** to determine whether and how DS-01 should appear in recommendations
8. **Performs in-depth analysis** comparing the published article to competitors through Seed's MRD-aligned scientific lens
9. **Validates recommendations through SEO safety checklist AND MRD compliance checklist** (MANDATORY)
10. **Outputs a structured comparison** highlighting strengths, gaps, and MRD-compliant Seed-aligned recommendations
11. **Auto-proceeds with ALL recommendations** (no interactive pause)
12. **Generates detailed instructions** for the content drafter with bolding and citation requirements
13. Includes strategic analysis context (MRD perspective, competitive landscape, strengths/gaps) at the TOP of the drafting instructions
14. All citations are real peer-reviewed sources with DOI links (no placeholders)
15. **Creates Google Doc** using google-docs skill

## Workflow

### Step 0: SciCare POV Brief Lookup

Before starting analysis, check if SciCare has provided a topic-specific POV brief for this keyword.

**Search** `Reference/SciCare POV briefs/` (including all subfolders) for a markdown file whose name matches or closely matches the keyword.

```bash
find "Reference/SciCare POV briefs" -name "*.md" -type f 2>/dev/null
```

**Matching logic:**
- Exact match: keyword is "probiotics for bad breath" → look for `probiotics for bad breath.md`
- Fuzzy match: if no exact match, check if any filename contains the keyword or vice versa
- If multiple matches, prefer the most specific one

**If a matching POV brief is found:**
1. Read the file in full
2. Extract: SciCare's POV/Key Takeaway, Suggested References, and any specific cautions
3. Log: `Found SciCare POV brief: [filename] — this will govern topic-specific Seed perspective`
4. This brief takes HIGHEST AUTHORITY for topic-specific claims and framing — it overrides general MRD principles where they conflict

**If no matching POV brief is found:**
- Log: `No SciCare POV brief found for this keyword — using MRD general principles + optional SciCare POV sections`
- Continue to Step 1

### Step 1: Load Published Article & Setup

**Option A — Existing folder provided:**
1. Look in `Phase 1 Draft Revisions/[folder-name]/` for a file ending in `-currently-published.md`
2. Read that file as the article content
3. Use the existing folder for all output (do NOT create a new folder)

**Option B — URL or path provided:**
1. If user provides page path (e.g., `/cultured/probiotics-guide`), prepend `https://www.seed.com`
2. If full URL provided, use as-is
3. Scrape using firecrawl skill. Do NOT include images.
4. Create numbered folder in `Phase 1 Draft Revisions/` (find highest number, add 1)
5. Save as `[NNN]-[primary-keyword]/[primary-keyword]-currently-published.md`

**Analyze Current State:**
- Use the primary keyword provided by user (don't extract from article metadata)
- Count existing citations (DOI links and academic sources)
- Note: **No target enforcement** — preserve ALL existing citations even if >15

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

### Step 2.5: Consult Seed's 2026 MRD Documents (MANDATORY)

**CRITICAL**: Before making ANY recommendations, you MUST consult Seed's MRD documents to understand their scientific perspectives, approved claims, and compliance restrictions.

**Required Files to Review:**

**Tier 1 — Science & Claims Authority:**
- `Reference/2026-03 DS-01 Updated Messaging Reference Files/POV_ 27APR2026.md` (General science perspective: probiotic definitions, transient nature, mechanisms, fermented foods, gut-brain axis, AFU vs CFU, disease discussion guidance, acclimation)
- `Reference/2026-03 DS-01 Updated Messaging Reference Files/New MRD/DS-01® Messaging + Positioning Reference Document • Claims Library.md` (Approved claims with disclaimers — ABSOLUTE AUTHORITY for what can be said about DS-01)

**Tier 2 — Messaging Strategy:**
- `Reference/2026-03 DS-01 Updated Messaging Reference Files/New MRD/DS-01® Messaging + Positioning Reference Document • Product Positioning.md` (Consumer journey framework, messaging pillars, barriers & motivators)
- `Reference/2026-03 DS-01 Updated Messaging Reference Files/New MRD/DS-01® Messaging + Positioning Reference Document • Timeline of Benefits + Mechanisms.md` (Phased benefits: Restore/Rebalance/Optimize)

**Tier 3 — Voice, Style & Compliance:**
- `Reference/2026-03 DS-01 Updated Messaging Reference Files/Tone of Voice 2026.md` (Brand voice: "The Inspiring Scientist")
- `Reference/2026-03 DS-01 Updated Messaging Reference Files/COPYStyleGuide_27APRIL2026.md` (Terminology, punctuation, trademarks, disclaimers)
- `Reference/2026-03 DS-01 Updated Messaging Reference Files/New MRD/DS-01® Messaging + Positioning Reference Document - disclaimer cheat sheet.md` (Mandatory disclaimer symbols)
- `Reference/Compliance/NO-NO-WORDS.md` (Forbidden terms)
- `Phase 1 Reference Files/What we are and are not allowed to say when writing for Seed.md` (Phrase-level compliance)

**Optional Supplementary — Old SciCare POV (Use ONLY when no POV brief exists AND the topic is not well-covered by MRD):**
- `Phase 1 Reference Files/SciCare-POV-Section-Index.md` — Read this FIRST to find relevant sections
- Then selectively load 1-3 relevant sections from `Phase 1 Reference Files/SEO Article Sprint - SciCare POV - DS-01 - General.md` using offset/limit from the Section Index
- Use this for topic-specific Seed perspective on conditions/topics NOT covered by the Claims Library (e.g., acid reflux, SIBO, skin conditions, UTIs, pregnancy)
- The MRD always takes authority over the old SciCare POV where they conflict

**How to Use the Reference Files:**

1. **Check POV Document** for Seed's positions on:
   - Probiotic definition (viability + dosage + evidence required)
   - Transient nature (probiotics don't colonize — they interact and exit)
   - Fermented foods vs probiotics (fermented foods don't necessarily meet probiotic criteria)
   - Gut-brain axis (serotonin story is oversimplified)
   - AFU vs CFU (AFU counts viable but non-culturable cells — "more precise" not "more accurate")
   - Disease discussion (separate general research from product context, avoid implied claims)
   - Acclimation (mild GI discomfort is normal — use "temporary acclimation period," NEVER "die-off")

2. **Check Claims Library** for what DS-01 can claim:
   - Bloating + gas claims (with required disclaimers)
   - Regularity claims
   - ViaCap® survivability claims
   - Potency comparison claims
   - Timeline claims (1 week, 2 weeks, 4 weeks, 6 weeks)
   - Key evidence: Allegretti et al. 2026 (n=350, 6-week RCT) — "the largest clinical trial for a probiotic on bloating + gas in healthy adults°µ"

3. **Check Product Positioning** for messaging pillars:
   - Awareness: "Proven Probiotic Standard"
   - Consideration: "Engineered to Survive" (ViaCap®)
   - Conversion: "Liberate Your Gut" (bloating/gas/regularity)
   - Retention: "Unlock the Potential" (systemic benefits)

4. **Apply Topic Appropriateness Gate** (CRITICAL):
   - Check: Does the article's topic fall within the Claims Library's scope?
   - If YES (bloating, regularity, gut health, microbiome, digestion) → DS-01 can be mentioned with approved Claims Library language
   - If PARTIALLY (immune, skin, micronutrient synthesis) → DS-01 can be mentioned for these specific benefits with †† disclaimers, but only in clearly separated context
   - If NO (specific diseases, conditions not in Claims Library, medications, alcohol recovery) → Do NOT recommend adding DS-01 positioning for that context. DS-01 may still appear in the article for its general gut health claims, but NOT positioned as relevant to the specific condition
   - If UNCERTAIN → Default to omission. Flag for the drafter: "Consult SciCare team (Chelsea Jackle) for topic-specific guidance"

5. **Flag Conflicts**: Compare competitor recommendations against Seed's MRD positions

6. **Map to Messaging Pillars**: Identify which Consumer Journey stage(s) are relevant

**Required Output for Step 3:**

Create a summary documenting:
1. **Key Seed Perspectives Found**: 2-3 topics where Seed's MRD positions differ from competitors
2. **Conflicts Identified**: Competitor recommendations that contradict Seed's stance
3. **Reframing Needed**: Topics that need Seed-aligned framing
4. **Topics to Avoid**: Topics Seed cannot address due to lack of Claims Library support or POV guidance
5. **Topic Appropriateness Assessment**: Whether and how DS-01 should appear in recommendations
6. **SciCare POV Brief Status**: Whether one was found and what it says (or "None found — using MRD general principles")

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

#### MRD Compliance Check on Recommendations (MANDATORY)

**CRITICAL**: Before presenting recommendations, run each one through BOTH the SEO safety checklist AND the MRD compliance checklist.

**SEO Safety Checklist (per v3):**

1. **Existing Headers**: Does NOT remove or replace headers containing the primary keyword
2. **Keyword Presence**: Maintains or improves keyword presence
3. **Meta Elements**: Does NOT suggest changing title tags, meta descriptions, or URL slugs
4. **Internal Links**: Does NOT remove existing internal links
5. **Readability & User Intent**: No keyword stuffing, maintains search intent alignment

**MRD Compliance Checklist (NEW):**

6. **No Implied Superiority**: Recommendations do NOT frame DS-01 as superior to the article's topic ingredient or as "addressing what X can't do." Use "different mechanism" framing.
7. **No Implied Synergy**: Recommendations do NOT position DS-01 as synergistic with the topic ingredient unless that specific combination appears in the Claims Library.
8. **Research/Product Separation**: General probiotic research and DS-01 product claims are in separate paragraphs in the recommended content.
9. **Claims Library Language**: Any DS-01 product claims in recommendations use EXACT language from the Claims Library.
10. **Required Disclaimers**: DS-01 claims include correct disclaimer symbols (°, µ, ††, **, †, *, Δ) per the Disclaimer Cheatsheet.
11. **No Individual Strain Names**: DS-01 references use formulation-level language ("24-strain probiotic + prebiotic," "clinically validated formulation"), NOT individual strain names.
12. **Hedging for Non-DS-01 Claims**: Uses "can support" / "may" / "research suggests" for non-DS-01 ingredient claims. Only Claims Library verbatim language gets definitive framing.
13. **Topic Appropriateness**: DS-01 only appears in contexts supported by the Claims Library.
14. **No Forbidden Vocabulary**: Does not use "reshape" (not in MRD), "boost" (no-no word), "supplement" (for probiotics), "colonize" (probiotics are transient), or "die-off" (unsubstantiated).
15. **"Bone Broth Test"**: Any DS-01 section reads as objective differentiation, not implied superiority or sales pitch.
16. **"Formulated to" Preserved**: Claims Library qualifiers ("formulated to target root causes") are not shortened to therapeutic claims ("targets root causes").
17. **Per-Claim Presentation**: Each benefit claim recommended has its own citation and disclaimer, not lumped with other claims.
18. **Citation Misattribution Guard**: Claims Library studies (Allegretti, Del Piano, Iemoli, Chakkalakal, Strozzi, Xiao) are ONLY used to support DS-01 claims, never for claims about the article's topic ingredient.

**If a Recommendation Fails Either Checklist:**
- **Revise it** to preserve SEO elements AND MRD compliance
- **Remove it** if it can't be salvaged
- **Document** any removed recommendations and why

### Step 4: Auto-Proceed with All Recommendations

**Do NOT pause for user input.** Automatically proceed with ALL recommendations generated in Step 3. Move directly to generating the Drafting Instructions.

### Step 5: Generate Drafter Instructions for Phase 1 Revisions

Based on ALL improvements identified in Step 3, create detailed implementation instructions.

#### Document Structure Requirements

**CRITICAL**: The Drafting Instructions document MUST include strategic analysis context at the TOP, followed by the drafter instructions. Use this exact structure:

```markdown
# Strategic Analysis Context

## Seed MRD Perspective Summary

### SciCare POV Brief Status
- [Found: filename — summary of key takeaway | Not found — using MRD general principles]

### Key Seed Perspectives Found (from 2026 MRD)
- [List 2-3 topics where Seed's positions differ from competitors]

### Topic Appropriateness Assessment
- [Whether DS-01 belongs in this article's context, and if so, which Claims Library claims are relevant]
- [Which messaging pillar(s) apply]

### Conflicts Identified
- [Competitor recommendations that contradict Seed's MRD stance]

### Topics to Handle Carefully
- [Topics requiring special framing, hedging, or that Seed cannot address]
- [If no SciCare POV brief exists: "No topic-specific SciCare POV available. Recommendations follow Seed's general MRD principles. If uncertain about Seed's position on [topic], consult the SciCare team (Chelsea Jackle)."]

---

## Competitive Landscape Analysis

### Competitors Analyzed
- **[Competitor 1]**: [Brief description]
- **[Competitor 2]**: [Brief description]
- **[Competitor 3]**: [Brief description]
- **[Competitor 4]**: [Brief description]

---

## Where Your Article Excels
- [Bullet points]

---

## Where Competitors Have Advantages
- [Bullet points]

---

## Content Gaps Identified
- [Bullet points]

---
---

# Drafting Instructions

[The actual drafting instructions follow below]

---

[INSTRUCTIONS START HERE]
```

#### Reference Files Header
```
CRITICAL REFERENCE REQUIREMENT:

**Before writing ANY new content**, you MUST consult the following Seed reference files:

**Primary Reference (2026 MRD — ABSOLUTE AUTHORITY for DS-01 claims):**
- POV_ 27APR2026.md (general science perspective)
- DS-01® Claims Library (approved claims + disclaimers — ALL DS-01 product claims MUST use exact language from this document)
- DS-01® Product Positioning (consumer journey + messaging pillars)
- DS-01® Timeline of Benefits + Mechanisms (phased benefits: Restore/Rebalance/Optimize)
- DS-01® Disclaimer Cheat Sheet (mandatory disclaimer symbols for all claim types)

**Brand Voice & Compliance:**
- Tone of Voice 2026.md ("The Inspiring Scientist" — Grounding/Illuminating/Intriguing)
- COPYStyleGuide_27APRIL2026.md (terminology, punctuation, trademarks)
- What we are and are not allowed to say when writing for Seed.md
- NO-NO-WORDS.md

**CRITICAL DS-01 RULES:**
- ALL DS-01 product claims must use EXACT language from the Claims Library
- ALL DS-01 claims must include required disclaimer symbols (°, µ, ††, **, †, *, Δ) per the Disclaimer Cheat Sheet
- Do NOT use individual strain names — use formulation-level language only ("24-strain probiotic + prebiotic")
- Do NOT use "reshape" for microbiome effects — approved alternatives: "transforms the gut°," "increases beneficial bacteria°"
- Do NOT call probiotics "supplements"
- Do NOT use "boost" for immune claims — use "support immune function"
- Do NOT use "die-off" or "detox reaction" — use "temporary acclimation period"
- Do NOT use "colonize" for probiotics — they are transient
- Use "can support" / "may" for non-DS-01 ingredient claims
- Preserve "formulated to" qualifiers exactly from Claims Library language
- Keep general probiotic research SEPARATE from DS-01 product claims (different paragraphs)
- Each DS-01 benefit claim gets its own citation and disclaimer — never lump multiple claims

Continue to draft according to Seed's 2026 tone of voice and compliance guidelines.
```

#### Formatting Requirements
```
CRITICAL FORMATTING INSTRUCTIONS:

1. **BOLD all new additions or revisions** — Any text you add or modify must be bolded
2. **Leave original text unbolded** — Existing content that remains unchanged stays in regular text
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
   - **Second:** Use the new peer-reviewed sources provided in these instructions
   - **Third:** Search for additional peer-reviewed studies from PubMed/PMC if gaps remain

   **CRITICAL — Citation Misattribution Guard:**
   - Claims Library studies (Allegretti 2026, Del Piano 2010, Iemoli 2012, Chakkalakal 2022, Strozzi 2008, Xiao 2006) are DS-01 evidence ONLY
   - NEVER use these citations to support claims about the article's topic food/drink/ingredient
   - Only cite Claims Library studies in sentences that explicitly reference DS-01 or its formulation

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
   - Do NOT use abbreviated journal-only format — always include the full paper title and a clickable DOI URL
   - Verify DOI links are working

4. **Preserve ALL existing citations** — Do not remove any citations, even if total exceeds 15
5. **Follow SEO best practices** — Maintain keyword optimization, readability, and user intent alignment
```

#### For Each Improvement:
- **Clear placement instructions** (which section, before/after what content)
- **Specific content requirements** (what to write, how much detail)
- **Citation format in recommendations** (CRITICAL): Each "Citation to use" line MUST include the FULL citation details:
  `- Author(s). (Year). Full Paper Title. _Journal Name_, Volume(Issue), Pages. DOI_URL`
- **Bolding reminder** (bold all new content)
- **Tone reminders** (maintain conversational, knowledgeable friend voice per "The Inspiring Scientist" persona)
- **MRD compliance notes** where applicable:
  - If the recommendation touches DS-01, specify which Claims Library claims to use and which disclaimers are required
  - If the recommendation discusses a condition not in the Claims Library, note that DS-01 should NOT be connected to it
  - If the recommendation discusses general probiotic science, remind the drafter to keep it in a separate paragraph from any DS-01 mentions

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
- [ ] Maintains unique Seed perspective per 2026 MRD
- [ ] No forbidden terms from NO-NO WORDS list suggested
- [ ] Probiotics never called "supplements"
- [ ] No "boost immunity" — use "support immune function"
- [ ] No "die-off reactions" — use "temporary acclimation period"
- [ ] No "colonization" language for probiotics — they are transient
- [ ] No "reshape" for microbiome effects — use MRD-approved language
- [ ] Fermented foods distinguished from probiotics (LDM framing per POV)
- [ ] **DS-01 product claims use EXACT Claims Library language**
- [ ] **Required disclaimers present** (°, µ, ††, **, †, *, Δ) on all DS-01 claims
- [ ] **No individual strain names** — formulation-level language only
- [ ] **No implied superiority** — DS-01 not framed as "better than" or "addresses what X can't"
- [ ] **No implied synergy** — DS-01 not positioned as synergistic with topic ingredient
- [ ] **General research separated from DS-01 claims** (different paragraphs)
- [ ] **"Formulated to" qualifiers preserved** from Claims Library language
- [ ] **"Can support" / "may"** used for non-DS-01 ingredient claims
- [ ] **Each benefit claim presented separately** with own citation and disclaimer
- [ ] **Citation Misattribution Guard**: Claims Library studies only used for DS-01, never for topic ingredient
- [ ] **Topic appropriateness verified** — DS-01 not placed in contexts outside Claims Library scope
- [ ] **"Bone broth test" passed** — any DS-01 section reads as objective differentiation, not sales pitch
- [ ] **Medication spacing** framed as "consult your doctor" not blanket "2 hours apart"
- [ ] Maintains conversational, knowledgeable friend tone per "The Inspiring Scientist" persona
- [ ] Short paragraphs (2-3 sentences max)
- [ ] Average sentence length under 25 words

### Step 6: Save Drafting Instructions

After generating the detailed drafter instructions, automatically save them:

- **If existing folder was provided**: Save to that folder as `Drafting Instructions MRD.md`
- **If new folder was created**: Save to that folder as `Drafting Instructions.md`
- **Format**: Complete markdown file with strategic context at TOP, then drafter instructions
- **Confirmation**: Notify user where the file was saved

### Step 7: Create Google Doc

After saving the Drafting Instructions, create a Google Doc with the same content using the **google-docs skill** located at `~/.claude/skills/google-docs/`.

1. **Create the Google Doc** titled with the primary keyword
2. **Populate it** with the full Drafting Instructions content
3. **Report the Google Doc link** to the user

### Final Quality Checklist

Before saving, verify:
- [ ] **Strategic context sections included at TOP** (MRD Perspective, Competitive Landscape, Excels, Advantages, Gaps)
- [ ] **SciCare POV Brief status documented** (found or not found)
- [ ] **Topic Appropriateness Assessment included** (whether DS-01 belongs in this context)
- [ ] Drafter instructions are clear and actionable
- [ ] ALL existing citations preserved in guidance
- [ ] **NO placeholder citations**
- [ ] **All new citations are peer-reviewed academic sources**
- [ ] **In-text citations use correct format**: `([Author Year](DOI_URL))`
- [ ] Content guidance aligns with 2026 MRD
- [ ] **MRD compliance checklist passed** for all recommendations
- [ ] No forbidden terms suggested
- [ ] Maintains SEO best practices guidance
- [ ] Tone guidance matches "The Inspiring Scientist" voice

## Example

```
/phase-1-analyze-seo-draft-external-mrd-compliant 025-probiotics-for-bad-breath "probiotics for bad breath"
```

or

```
/phase-1-analyze-seo-draft-external-mrd-compliant https://www.seed.com/cultured/signs-probiotics-are-working "signs probiotics are working"
```

## Output Format

The command provides:
1. Published article loaded (from folder or scraped fresh)
2. SciCare POV Brief status (found or not found)
3. Initial citation count (no target enforcement)
4. Competitive landscape summary
5. **Seed MRD Perspective Summary** documenting unique positions, conflicts, and topic appropriateness
6. Detailed comparative analysis through Seed's MRD-aligned scientific lens
7. **Dual Review Summary** showing recommendations validated against BOTH SEO safety AND MRD compliance checklists
8. Auto-proceeds with all recommendations (no interactive pause)
9. Formatted drafter instructions with:
   - Strategic analysis context at TOP
   - MRD-compliant reference files header
   - Clear implementation guidance for human drafter
   - MRD compliance notes per recommendation
10. Drafting Instructions file automatically saved
11. Google Doc automatically created with link reported to user

## Key Differences from v3

| Aspect | v3 (current) | MRD-compliant (this command) |
|--------|-------------|------------------------------|
| Primary authority | POV + Claims Library | Full MRD suite (POV + Claims Library + Product Positioning + Timeline of Benefits + Topline Messaging + Disclaimer Cheat Sheet + COPYStyleGuide) |
| SciCare POV Brief | Not checked | Checked first — governs when found |
| Old SciCare POV | Not used | Optional fallback for topics outside MRD scope |
| Topic Appropriateness Gate | Not applied | Applied — determines if/how DS-01 appears |
| DS-01 strain names | Not restricted | Formulation-level language only |
| Implied superiority check | Not checked | Checked — "bone broth test" applied |
| Implied synergy check | Not checked | Checked |
| Research/product separation | Not enforced | Enforced — different paragraphs |
| Disclaimer symbols | Not required | Required per Disclaimer Cheat Sheet |
| Citation Misattribution Guard | Not applied | Applied — Claims Library studies only for DS-01 |
| Hedging rules | Not specified | "Can support" / "may" for non-DS-01 claims |
| Vocabulary restrictions | Basic (no-no words) | Extended ("reshape", "colonize", "die-off", "boost", "supplement") |
| Messaging pillar mapping | Not done | Maps to Consumer Journey stages |
| Per-claim presentation | Not enforced | Each claim gets own citation + disclaimer |
| Input options | URL/path only | URL/path OR existing folder with -currently-published.md |
| Drafter reference header | Points to old SciCare POV files | Points to 2026 MRD files with DS-01 rules |
| MRD compliance checklist | Not included | 13-point checklist applied to every recommendation |

## Notes

- **Phase 1 Specific**: Designed for revisions to existing published Seed articles
- Uses Firecrawl skill for fresh scraping OR reads from existing folder
- Always uses exact keyword provided by user
- Sequential folder numbering for new scrapes
- **Preserves all existing citations** — no removal even if count >15
- **Bolding system** clearly marks new vs. existing content in guidance
- **MANDATORY MRD consultation** (Step 2.5)
- **MANDATORY dual safety evaluation** — SEO + MRD compliance (Step 3)
- **SciCare POV Brief check** — when available, governs topic-specific perspective
- **Old SciCare POV as fallback** — selectively loaded for topics outside MRD scope
- **Topic Appropriateness Gate** — prevents DS-01 from appearing in unsupported contexts
- **Objectivity & Implied Claims Guard** — prevents implied superiority, synergy, or misattribution
- Auto-proceeds with all recommendations
- Creates Google Doc using google-docs skill
- Maintains Seed's "The Inspiring Scientist" voice
