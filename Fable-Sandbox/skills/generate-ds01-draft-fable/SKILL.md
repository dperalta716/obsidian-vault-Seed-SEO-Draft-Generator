---
name: Generate DS-01 Draft
description: End-to-end SEO article generation for Seed Health DS-01 content. Runs competitor analysis, then generates a compliance-checked, voice-calibrated draft with academic citations.
argument-hint: keyword (e.g., "probiotics for bloating")
user-invocable: true
---

> **FABLE SANDBOX COPY** — calibration version. May be freely modified during calibration. The original in `.claude/` is read-only. All generated files go to `Fable-Sandbox/Generated-Drafts/`. Never run any `upload-to-gdocs*` command — the pipeline ends at v5.

# Generate DS-01 Draft

Generate a complete SEO-optimized article draft for Seed Health's DS-01 Daily Synbiotic content. This skill runs the full pipeline: competitor analysis first, then article generation using the analysis as input.

## Usage

```
/generate-ds01-draft probiotics for bloating
```

The keyword argument is required. The skill handles everything else automatically.

---

## PHASE 0: SciCare POV Brief Lookup

Before starting competitor analysis, check if SciCare has provided a topic-specific POV brief for this keyword.

### Step 0.1: Search for POV Brief

Search `Reference/SciCare POV briefs/` (including all subfolders) for a markdown file whose name matches or closely matches the keyword.

```bash
find "Reference/SciCare POV briefs" -name "*.md" -type f 2>/dev/null
```

**Matching logic:**
- Exact match: keyword is "gut health detox" → look for `gut health detox.md`
- Fuzzy match: if no exact match, check if any filename contains the keyword or vice versa
- If multiple matches, prefer the most specific one

### Step 0.2: Load POV Brief (if found)

**If a matching POV brief is found:**
1. Read the file in full
2. Extract:
   - **SciCare's POV/Key Takeaway** — the scientific perspective on this topic. This becomes the article's narrative backbone.
   - **Suggested References** — pre-vetted academic sources with DOIs/URLs. These become the PRIMARY citation pool for the topic (replacing the usual "go find academic sources" step).
   - **Any specific cautions or nuances** — things SciCare flagged as important.
3. Log: `Found SciCare POV brief: [filename] — this will govern the article's angle and primary evidence base`

**How the POV brief changes the workflow:**
- **Phase 1 (competitor analysis) still happens** — we still need the competitive baseline to rank. But the article's ANGLE comes from the POV brief, not from mimicking competitors.
- **Phase 2 (draft generation):** The POV brief's key takeaway becomes the article's throughline. Its suggested references become Tier 0 in the evidence hierarchy (used before even Claims Library sources for topic-specific claims). Every section is filtered through the SciCare lens.
- **Evidence hierarchy with POV brief:**
  - Tier 0 (USE FIRST for topic claims): Suggested references from POV brief
  - Tier 1 (USE for DS-01 claims): Claims Library citations
  - Tier 2 (USE NEXT): Citations from the POV document and Timeline of Benefits
  - Tier 3 (SUPPLEMENT): Pre-vetted academic sources from stage1_analysis

**If no matching POV brief is found:**
- Log: `No SciCare POV brief found for this keyword — proceeding with standard workflow`
- Continue to Phase 1 as normal (no changes to the rest of the workflow)

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

### Step 1.1b: Create Output Folder

Create the output folder before spawning sub-agents so they can save scraped content:

```bash
HIGHEST=$(ls -1 Fable-Sandbox/Generated-Drafts 2>/dev/null | grep -E '^[0-9]{3}-' | sed 's/-.*//' | sort -n | tail -1)
NEXT=$(printf "%03d" $((10#${HIGHEST:-0} + 1)))
SLUG=$(echo "$ARGUMENTS" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
mkdir -p "Fable-Sandbox/Generated-Drafts/${NEXT}-${SLUG}/competitors"
```

Store the folder path `Fable-Sandbox/Generated-Drafts/${NEXT}-${SLUG}` for use in subsequent steps.

### Step 1.2: Scrape & Analyze Top 5 Articles

Spawn 5 parallel sub-agents. Pass each sub-agent the output folder path from Step 1.1b. Each sub-agent:

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

3. Saves the full scraped content to the competitors subfolder:
   - File path: `[folder_path]/competitors/[title-slug].md` (title slug: lowercase, hyphens, max 60 chars)
   - File format:
     ```markdown
     # [Article Title]

     - **Source**: [Domain name]
     - **Author**: [Author name if available, otherwise "Not specified"]
     - **URL**: [Original URL]
     - **Scraped**: [YYYY-MM-DD]

     ---

     [Full scraped article content in markdown]
     ```

### Step 1.3: Consolidate Findings

After all 5 sub-agents complete, synthesize:

1. **Primary User Search Intent** and core questions
2. **Competitive Baseline Requirements**: Topics in 3+ articles = must-cover
3. **Citation & Evidence Landscape**: Academic sources table with DOIs
4. **Intelligent PAA Selection**: Choose 4 best of 8 questions with rationales
5. **Gaps & Opportunities**: Where Seed can differentiate

### Step 1.4: Create Analysis Document

Use the folder created in Step 1.1b (already exists with competitors/ subfolder populated).

Save to: `Fable-Sandbox/Generated-Drafts/[NNN]-[slug]/stage1_analysis-[slug].md`

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

**A2. Topic Appropriateness Gate (per POV "Navigating Probiotic and Disease Discussions"):**

Before proceeding, assess whether the keyword's context permits DS-01 mentions:
- If the topic involves alcohol recovery, disease treatment, medication interaction, or other conditions NOT covered by the Claims Library → do NOT position DS-01 as relevant to that specific context. You may discuss probiotics broadly using general research, but clearly separate general research from product context (per POV guidance). The default for disease/disruptor topics is to OMIT DS-01 from that context entirely.
- If the topic involves a food, supplement, or ingredient → DS-01 can be mentioned, but only with objective differentiation framing (see DS-01 Section Construction below). Never imply DS-01 is superior to or synergistic with the topic ingredient.
- If uncertain whether the MRD supports DS-01 claims in this context → err on the side of omission. The default is NOT to include DS-01.

**B. Identify Seed's Unique Angles:**
- Find 2-3 pieces of "standard advice" from competitive baseline
- Cross-reference against the POV document and Claims Library
- Where conflicts or nuances exist, draft a Dirk Gevers, Ph.D. quote (1-3 sentences)
- Frame Seed's view as their specific approach, not the only correct view
- Use the Consumer Journey messaging pillars from Product Positioning to align angles with the appropriate stage
- When the article topic involves consuming live microorganisms (fermented foods, kombucha, yogurt, etc.), the "Engineered to Survive" pillar is almost always relevant — flag it as a candidate angle. The natural reader question is: "Do the microbes in [topic food] even survive digestion?" DS-01's answer (ViaCap®, SHIME-tested) is a direct differentiator.
- **CRITICAL — No Implied Superiority (per POV and Chelsea Jackle compliance review, May 2026):**
  - When comparing the topic ingredient to probiotics, discuss probiotics as a CATEGORY first — do not introduce DS-01 in the same breath as the comparison. DS-01 can appear later in the article in its own clearly separated context.
  - Never frame the comparison as "what the topic ingredient can't do but DS-01 can." Instead frame as "these work through different mechanisms." Model on the bone broth article: explains why bone broth and probiotics are different without implying superiority, and pulls claims directly from the MRD.
  - Per the POV: "it's important to clearly separate general research from product context." General probiotic science goes in one paragraph; DS-01 product claims go in a SEPARATE paragraph.

**C. Build Evidence Strategy:**
- Tier 1 (USE FIRST): Claims and citations from the Claims Library (Allegretti et al. 2026 n=350 is the landmark study — citation ¹ is always reserved for this trial)
- Tier 2 (USE NEXT): Citations from the POV document and Timeline of Benefits
- Tier 3 (SUPPLEMENT): Pre-vetted academic sources from stage1_analysis Section 3
- Target ~1 citation per 75-100 words. Max 12-15 total sources.
- Cite: study results, quantitative data, mechanisms, health claims, safety info
- Do NOT cite: basic definitions, common biological processes, transitions, general advice
- ONLY peer-reviewed academic sources with working doi.org links
- All DS-01 product claims MUST use EXACT language from Claims Library
- All claims MUST include required disclaimers per the Disclaimer Cheatsheet

**Source Fitness Gate (Tier 3 competitor-scraped sources only — Tier 0/1 are pre-vetted, skip them):**

Tier 0 (SciCare brief) and Tier 1 (Claims Library) sources are pre-vetted — do NOT apply this gate to them. Before citing any Tier 3 source from stage1_analysis, confirm all four:
1. **Population match** — for a general/healthy-audience topic, prefer human studies in healthy adults. Use clinical-patient, pediatric, or animal/in-vitro studies ONLY to fill a gap where healthy-adult evidence is missing — never as the lead source for a general claim. (The article topic's intended reader defines "healthy adult" unless the keyword is explicitly clinical or pediatric.)
2. **Scope match** — the source's actual subject (strain, compound, condition, scope) must directly match the specific claim. Never cite a study on one compound/strain for a claim about a different one, even within the same family. When two sources both fit, prefer the more scope-specific one.
3. **Recency** — prefer 2019+. Keep an older source only when it is the seminal/only study for that point; note why in one internal line.
4. **Reputability** — peer-reviewed journals only. No blogs, brand/company pages, news, or social media. Sole exception: NIH/CDC/FDA. Drop any Tier 3 "secondary" URL the Phase 1 scrape flagged.

**Guided Discovery (find best-fit sources, don't just borrow competitors'):**

For any topic-level claim (NON-DS-01) that has no Tier 0 or Tier 1 source and would otherwise rely on a competitor-borrowed Tier 3 citation, run a guided literature search to find a better-fit source before inheriting the competitor's:

```bash
.claude/skills/pubmed-research/scripts/pubmed-search.sh "[claim topic] healthy adults" 5 relevance
```

- Apply the Source Fitness Gate (above) to the results and select the best-fit study.
- If PubMed returns nothing suitable, fall back to the competitor-borrowed source — but flag it for the source-review step.
- Bound the cost: run discovery only for topic claims lacking Tier 0/1 coverage, max one search per claim.
- Do NOT run discovery for DS-01 product claims — those are Claims-Library-locked.

**Evidence-base transparency (MANDATORY auto-caveat):**

After assembling the final pool, check the composition of the *topic* (non-DS-01) evidence. If the majority is animal or in-vitro, the draft MUST be written with a plain-language caveat already in the relevant body section noting that human research is still limited. Vary the wording each time — never reuse a stock sentence. This is written into the prose at generation time, not left for the reviewer.

**CRITICAL — Citation Misattribution Guard:**
- Studies from the Claims Library (Allegretti 2026, Del Piano 2010, Iemoli 2012, Chakkalakal 2022, Strozzi 2008, Xiao 2006) are DS-01 ingredient or product evidence ONLY
- NEVER use these citations to support claims about the article's topic food/drink/ingredient
- If discussing immune function, gut barrier, or regularity in the context of the topic (not DS-01), use independent academic literature from the stage1_analysis citation pool
- Only cite Claims Library studies in sentences that explicitly reference DS-01 or its formulation

**CRITICAL — Implied Claims Guard (per POV "Disease Discussions" + Chelsea Jackle compliance review, May 2026):**
- The POV warns: "readers may infer that a probiotic product is intended to treat or support a condition simply because it is discussed in proximity to that condition." Prevent this by maintaining clear separation between general research and DS-01 product claims.
- When citing a study about probiotics + another substance (e.g., a study on berberine + probiotics), NEVER follow it immediately with a DS-01 mention — this creates the implication that DS-01 was the probiotic studied or that DS-01 works synergistically with that substance.
- If a general probiotics study is relevant to the article, present it in a paragraph about probiotics broadly. Introduce DS-01 in a SEPARATE paragraph with its own approved Claims Library language.
- Never suggest DS-01 use is helpful in conjunction with other supplements — this is not a claim in the MRD and could be read as medical advice. If the article naturally discusses supplement combinations, include: "As with any supplement routine, it's always a good idea to check in with your healthcare provider."
- Never imply that DS-01 was "designed with [topic ingredient] synergy in mind" or that DS-01 "amplifies" the effects of the topic ingredient — these are not MRD-supported claims.

**DS-01 Positioning Requirements (from MRD Product Positioning):**
- When introducing the Allegretti trial, always include: "the largest clinical trial for a probiotic on bloating + gas in healthy adults°µ" — this is a key awareness-stage differentiator
- When explaining WHY DS-01 works differently from the topic food/ingredient, reference at least ONE of these root-cause mechanisms:
  - "Transforms the gut microbiome°" / "Targets root causes of digestive distress°"
  - "Increases beneficial bacteria [in the gut microbiome]°"
  - "Supports gut barrier integrity°" / "Strengthens the gut barrier by 22%†°"
- When the article's argument naturally raises the question "do ingested bacteria survive digestion?" — address it using the "Engineered to Survive" pillar: ViaCap® delivers probiotics through digestion to the colon*° (especially relevant for articles comparing food-based microbes to DS-01)

**D. Develop Outline:**
- Overview, Introduction, 3-5 H2 body sections, The Key Insight, FAQs
- Must address competitive baseline requirements
- Layer Seed's unique angles on top of baseline
- **Give each distinct mechanism or distinction its own dedicated H2/H3 header — do not bury a discrete idea as a paragraph inside an unrelated section.** The North Star articles segment finely: if the topic involves short-chain fatty acid production, a "why fermented foods aren't the same as probiotics" distinction, a survivability/digestion question, or a diversity-vs-volume point, each earns its own conversational-but-keyword header rather than being folded into a neighboring block. Finely-segmented drafts need less editorial restructuring. Headers follow the voice rules above (ask the reader's literal question, or `Vivid Concept: plain-language payoff`).
- Use the Timeline of Benefits phasing (Restore/Rebalance/Optimize) when discussing what to expect from DS-01

### Step 2.2: Write the Article

#### Voice & Tone Target

You are a **knowledgeable friend who also happens to be an inspiring scientist**. The personality framework comes from the 2026 Tone of Voice guide ("The Inspiring Scientist"), but the practical execution is grounded in the conversational, empathetic style that has been working well in published Seed articles.

**The Persona: "The Inspiring Scientist"**

Think of the guest at a dinner party who makes the table feel more alive. They don't lecture or overwhelm — they turn a casual health question into a moment of revelation. Warm, not whimsical. Grounded, not mystical. A trusted expert explaining something vital in a very human way.

The voice balances three pillars (dial up or down based on the topic):

- **Grounding** — Clear, concise, human. Cut through complexity. Resist exaggeration and superlatives. Write like a brilliant mentor: clear, direct, empowering.
- **Illuminating** — Translate information into understanding. Use analogy and progressive disclosure so comprehension feels natural. Lead with meaning, not mechanisms.
- **Intriguing** — Spark curiosity. Lead with the angle no one expects. Say the thing others won't, confidently.

#### Practical Execution: How to Sound Like This

**Conversational & Approachable:**
- Write as a knowledgeable friend speaking directly to the reader
- Use "you" and "your" in nearly every paragraph — more than "we"
- Always use contractions (don't, you're, it's, won't, isn't)
- Use parenthetical asides: "(even if that sounds counterintuitive)", "(yes, really)", "(which, fair enough)"
- Casual transitions: "Here's the thing...", "Let's be real...", "But here's where it gets interesting..."
- Include occasional rhetorical questions to create dialogue (max 1 per 500 words)
- Balance scientific accuracy with accessibility
- Use gentle self-deprecation where appropriate to make complex topics approachable

**Empathetic & Reassuring:**
- Acknowledge reader concerns and potential embarrassment about health topics
- Normalize common experiences ("We've all been there")
- Use a supportive, non-judgmental tone when discussing sensitive topics (gas, poop, bloating)
- Provide balanced information without causing unnecessary worry
- Create a sense of shared experience through relatable scenarios

*Example: "If you've been quietly Googling 'do probiotics make you poop' (don't worry, your secret's safe here), you're in good company."*

**Strategic Use of Humor (a firm requirement, not a "where natural" option):**
- The North Star articles carry a conversational device — a parenthetical aside, a rhetorical question, a light beat, or a "here's the thing" turn — roughly **every other paragraph**. A draft with none of these reads flat and is the failure mode editors most often have to repair. Aim for that density (without crowding: cap rhetorical questions at ~1 per 400-500 words).
- **On any embarrassing or anxiety-laden dimension** (gas, bloating, diarrhea, constipation, body odor, etc.), use the published pattern: **one validation sentence first** ("you're not alone," "this is completely normal," "you're not doing anything wrong") **then deflate the tension with one light, self-aware beat.**
- Humor often involves self-awareness (bodily functions) or relatable everyday scenarios; keep it supportive of the educational mission — never at the reader's expense.
- **Metaphor before the technical term, every time.** The North Star voice introduces every complex mechanism with a concrete everyday image *before* naming the science (gut-as-garden, antibiotics-as-bulldozers, strain mismatch as "a hammer when you need a screwdriver," a generic species label as "a menu that just says 'beer'"). Reach for a fresh, topic-appropriate metaphor at each mechanism — this is the comprehension engine *and* the warmth engine at once.

*Examples: "Who knew your microbiome had such refined taste?" / "If you've been quietly Googling this (don't worry, your secret's safe here), you're in good company."*

**Scientific Communication:**
- Introduce scientific terms with plain language explanations first, then the term
- Use analogies and metaphors to explain complex biological concepts — choose ones that clarify rather than confuse
- Balance authoritative knowledge with humility about scientific limitations
- Note when research is still evolving or inconclusive ("research suggests" rather than absolute statements)
- Transition smoothly between casual asides and substantive information

*Example: "Think of probiotics as helpful allies rather than miracle workers — they shouldn't replace any part of your standard prenatal care."*

**Hedging and Claim Precision (per POV hedging templates + Chelsea Jackle compliance review, May 2026):**
- Use "can support" rather than "supports" when discussing benefits of ingredients outside of Seed's approved claims (e.g., "L-glutamine can support the gut barrier" not "L-glutamine supports the gut barrier")
- Use "may," "research suggests," and "evidence indicates" for non-DS-01 ingredients' benefits
- Only use definitive language ("is clinically shown to") for DS-01 claims that appear verbatim in the Claims Library
- Do NOT use "reshape" when describing microbiome effects — this word is not in the Claims Library. Approved alternatives from the MRD: "transforms the gut°," "increases beneficial bacteria°," "improves the gut microbiome°"
- When referencing the Timeline of Benefits phases (Restore/Rebalance/Optimize), present each phase's benefits separately with their individual citations and disclaimers — never lump multiple benefit categories into a single sentence

#### Writing Mechanics

**Sentence-level:**
- Vary sentence length deliberately — short punchy sentences for emphasis, medium for explanation
- Average sentence length under 25 words (mix 10-15 and 20-25 word sentences)
- Include occasional sentence fragments for conversational feel
- Active voice 90% of the time

**Paragraph-level:**
- Maximum 2-3 sentences per paragraph, no exceptions
- One concept per sentence
- Start paragraphs with a clear topic sentence
- Use transition phrases between paragraphs and sections

**Section-level:**
- Each H2 section: 300-500 words max
- **Introduction structure (this order matters):**
  1. Open with 1-2 sentences of relatable hook — a scenario the reader identifies with, an observation about common experience, or a curiosity-sparking statement. Examples: "You've probably seen kimchi on every 'best foods for gut health' list out there." / "If you've ever wondered whether your coffee habit is secretly helping (or hurting) your gut, you're not alone."
  2. Then deliver the direct short answer to the keyword question: "The short answer? Yes..." / "Here's what the research says..."
  3. Then expand with nuance — what's more complex, what most articles miss, and why it's worth reading on.
- Body sections address baseline topics with Seed's unique angle layered on
- **The Key Insight closer (REQUIRED pattern — do not ship a flat summary):** This section is the emotional close and the single most-rewritten element when editors fix a draft. Build it in this order so the editor has nothing to add:
  1. Re-answer the keyword question plainly in one or two short sentences.
  2. Reframe the topic as a long-term *practice*, not a hack or a fix.
  3. **Land an extended ecosystem metaphor** that fits the topic — gut-as-garden you tend daily, a well-zoned city/neighborhood, an orchestra, seeding/planting, "the first chapter, not the whole book." Carry the metaphor across two or three sentences; don't just name it.
  4. **Close on a warm "cultivation" grounding line** — a culture/seed/garden wordplay that lands the brand's "seeded in science" sensibility (e.g., the published closers use beats like *"Good health isn't hacked—it's cultured"* and *"The strongest gut ecosystems aren't built on a single food or a single strain—they're cultivated through variety, consistency, and a little scientific precision."*). Write a fresh line each time; never copy these verbatim, and never use emoji (the editor adds those).

#### Style Rules (COPYStyleGuide)

- Use "microbiome" for the entire ecology, "microbiota" for specific microbes
- Oxford commas always
- Em dashes without spaces on either side — use them instead of semicolons
- No exclamation points unless they serve a precise purpose
- Bacteria genus/species italicized; strain designation not italicized
- DS-01® uses ® symbol; use correct trademark (™ or ®) per product
- Use "capsule-in-capsule delivery system" not "cap-in-cap" when referencing ViaCap®

#### What NOT to do

- No emoji
- No internal links to other seed.com articles (added after the fact)
- No bold callout boxes (Pro Tip, TL;DR, etc.)
- No words/phrases from the NO-NO WORDS list
- Never call probiotics "supplements"
- No product spec dumps (don't list "24 strains at 53.6 billion AFU" in one sentence)
- No academic or clinical tone — you're a knowledgeable friend, not a professor
- Do NOT call out individual strain names — refer to formulation-level attributes ("24-strain probiotic + prebiotic", "clinically validated formulation") not individual strains
- Do NOT use genus/species names of individual strains in the draft text (Lactobacillus/Bifidobacterium genera are acceptable when discussing mechanisms broadly, per the Timeline of Benefits)
- No slang, overly chatty phrasing, or diluting precision for trendiness
- No bragging, self-importance, or superiority through puffery ("best," "only," "unparalleled")

#### DS-01 Mentions

- 1-3 natural mentions, all hyperlinked to https://seed.com/daily-synbiotic
- Format: [DS-01® Daily Synbiotic](https://seed.com/daily-synbiotic)
- Keep mentions casual and brief — don't dump product specs
- Position as complementary to food-based approaches, never a replacement
- **Never imply DS-01 is superior** to the topic ingredient — use "different mechanism" framing, not "addresses what X can't"
- **Never imply DS-01 works synergistically** with the topic ingredient unless a specific study of that exact combination appears in the Claims Library
- **Discuss probiotics broadly first** when comparing to the topic ingredient; introduce DS-01 as one example of a clinically validated probiotic in a SEPARATE paragraph
- **Preserve "formulated to" qualifiers** exactly as they appear in the Claims Library — if the MRD says "formulated to target root causes," do not drop "formulated to" (dropping it turns a design intent into a therapeutic claim)
- **Never suggest combining DS-01 with other supplements** without advising readers to consult their healthcare provider
- **If the article topic involves a disease, disruptor, or condition not in the Claims Library**, do NOT include DS-01 in that specific context (per Topic Appropriateness Gate above)
- Use ONLY approved claim language from the Claims Library when making product-specific claims
- Include ALL required disclaimers per the Disclaimer Cheatsheet:
  - ° (FDA disclaimer) — mandatory on ALL health benefit claims
  - µ (µas of February 2026) — mandatory whenever referencing the Allegretti clinical trial or "largest clinical trial" claim
  - †† (ingredient-level) — mandatory for strain-evidence claims (regularity in 2 weeks, immune support, micronutrient synthesis)
  - ** (subpopulation) — mandatory for 1-week bloating temporal claims ("for individuals with mild to moderately bothersome bloating")
  - † (preclinical) — mandatory for gut barrier %, butyrate %, or SHIME-derived data
  - * (SHIME) — mandatory when referencing "reaches the colon" or survivability through digestion
  - Δ (Lactobacillus genera) — mandatory for "17x beneficial bacteria" claim
- Key evidence asset: Allegretti et al. 2026 clinical trial (n=350, 6-week RCT) — always position as "the largest clinical trial for a probiotic on bloating + gas in healthy adults°µ"

#### DS-01 Section Construction

The DS-01 section should follow this logic:
1. **Objective differentiation**: Explain how the topic ingredient and probiotics work through different mechanisms — neither is superior, they address different aspects of health. Do NOT frame this as "what the topic ingredient can't do." Instead frame as "these are different tools that work in different ways."
2. **Separation of context**: Introduce DS-01 in its own paragraph, clearly separated from the general probiotics discussion. Do NOT position DS-01 as "naturally fitting" alongside the topic ingredient or as filling a gap. The reader should never infer that DS-01 was studied in relation to the topic ingredient.
3. **Evidence anchor**: Use approved Claims Library language with all required disclaimers. Only include claims RELEVANT to the article topic.
4. **Complementary positioning**: Frame as "a different approach to gut health" — never as filling a gap in what the topic ingredient does, and never as a synergistic companion to it.

**The "bone broth test"** (named after the one article Chelsea Jackle approved in her May 2026 compliance review): Before finalizing the DS-01 section, ask: "Does this read like the bone broth article — objective, different mechanisms, MRD-sourced claims, no implied superiority? Or does it read like the colostrum article — implied superiority, gap-filling, sales pitch?" If the latter, rewrite.

**Topic-relevant claim selection** — choose ONLY claims relevant to the article:
- If the topic is about regularity/digestion → use bloating + gas + regularity claims
- If the topic is about immune function → use immune health claims (†† required)
- If the topic is about microbiome diversity → use "increases beneficial bacteria" claims
- If the topic is about fermented foods or live microbe consumption → include "Engineered to Survive" / ViaCap survivability angle
- Do NOT include claims unrelated to the article topic just to pack in more product info

**Per-claim presentation** — when referencing multiple benefit categories (e.g., immune function, skin appearance, micronutrient synthesis), present each one separately with its own citation and disclaimer. Never lump multiple benefit categories into a single sentence — each claim has distinct evidence and distinct disclaimer requirements per the Claims Library.

#### Dirk Gevers, Ph.D. Quote

- 1-2 quotes total, each 1-3 sentences
- **Attribution MUST carry the full credential + title on first use** — `**Dirk Gevers, Ph.D., Chief Scientific Officer at Seed Health**` — e.g. "explains **Dirk Gevers, Ph.D., Chief Scientific Officer at Seed Health**" or "According to **Dirk Gevers, Ph.D., Chief Scientific Officer at Seed Health**, …". The bare "says Dirk Gevers, Ph.D." (no title) is the single most common E-E-A-T miss — a named expert without their title is a weaker trust signal. A second quote later in the piece may use the short form ("adds Gevers").
- Must reinforce a genuine Seed differentiator (clinical validation, precision approach, microbiome science)
- Not generic wellness advice
- Do NOT focus quotes on individual strains
- **NEVER name DS-01 or any product directly in the quote text** — quotes should support the scientific argument being made, not serve as product endorsements. The reader should understand the principle; the surrounding article text handles the product connection.
- Good: "A truly comprehensive approach involves introducing clinically studied strains that support specific digestive functions—something dietary sources alone don't provide."
- Bad: "A clinically validated formulation like DS-01® adds precision on top of that foundation."

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
[2-3 paragraphs, 150-200 words. REQUIRED closer pattern: plain re-answer → reframe as a long-term practice → extended ecosystem metaphor carried across 2-3 sentences → warm "cultivation" grounding line (culture/seed/garden wordplay, no emoji). See Step 2.2 Section-level for the full pattern.]

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
- [ ] µ disclaimer present wherever Allegretti 2026 trial is referenced or "largest clinical trial" claim appears
- [ ] † disclaimer present for any percentage-based claims (22% gut barrier, 17x bacteria, 47% butyrate)
- [ ] * disclaimer present if "reaches the colon" or ViaCap survivability is mentioned
- [ ] Δ disclaimer present if "17x beneficial bacteria" claim is used
- [ ] ** disclaimer present if 1-week bloating temporal claim is used
- [ ] †† disclaimer present for all strain-level evidence claims (regularity in 2 weeks, immune support, micronutrient synthesis)
- [ ] "Largest clinical trial for a probiotic on bloating + gas in healthy adults°µ" language used when introducing the Allegretti trial
- [ ] NO Claims Library citations (Allegretti, Del Piano, Iemoli, Chakkalakal, Strozzi, Xiao) used to support claims about the article topic — only for DS-01
- [ ] At least one root-cause mechanism mentioned (transforms gut, gut barrier, beneficial bacteria increase)
- [ ] Dirk Gevers quotes do NOT name any product directly
- [ ] **Dirk Gevers quote attribution carries full credential + title on first use** ("Dirk Gevers, Ph.D., Chief Scientific Officer at Seed Health") — not the bare "says Dirk Gevers, Ph.D."
- [ ] **The Key Insight closer carries an extended ecosystem metaphor (2-3 sentences) + a warm cultivation/"seeded in science" grounding line** — not a flat strategy summary
- [ ] **Conversational density check**: a conversational device (aside, rhetorical Q, "here's the thing" turn, light beat) roughly every other paragraph; on embarrassing dimensions, a validation sentence precedes any humor; each mechanism introduced with a metaphor before the technical term
- [ ] **Segmentation check**: each distinct mechanism/distinction has its own H2/H3 header, not buried inside an unrelated section
- [ ] DS-01 pitch is relevant to the article topic (not generic product dump)
- [ ] Strain-level temporal claims (e.g., "regularity in 2 weeks") include ingredient callout per Copy Compliance Guidance
- [ ] **No implied superiority** — DS-01 is never framed as "better than" or "addresses what [topic ingredient] can't" (use "different mechanism" framing)
- [ ] **No implied synergy** — DS-01 is not positioned as synergistic with the topic ingredient unless that specific combination is in the Claims Library
- [ ] **General probiotics discussed separately from DS-01** product claims (per POV: "clearly separate general research from product context")
- [ ] **"Formulated to" qualifiers preserved** exactly from Claims Library language — never dropped
- [ ] **"Can support" / "may"** used for non-DS-01 ingredient claims; **"reshape" not used** anywhere (not in Claims Library vocabulary)
- [ ] **Each benefit claim presented separately** with its own citation and disclaimer — no lumped multi-benefit sentences
- [ ] **Topic appropriateness verified** — DS-01 not placed in disease/disruptor/medication contexts outside Claims Library scope
- [ ] **Doctor consultation advised** if article discusses supplement combinations
- [ ] **"Bone broth test" passed** — DS-01 section reads as objective differentiation, not implied superiority or sales pitch
- [ ] **SciCare POV brief alignment (if one was loaded in Phase 0):**
  - [ ] Article's core narrative aligns with SciCare's stated POV/Key Takeaway
  - [ ] Suggested references from the POV brief were incorporated into the citation pool
  - [ ] No section contradicts SciCare's position or makes claims the POV brief warns against

### Step 2.5: Save Draft

Save to: `Fable-Sandbox/Generated-Drafts/[NNN]-[slug]/v1-[slug]-claude-draft.md`

(Same folder created in Phase 1.)

Add YAML frontmatter:
```yaml
---
date: [TODAY]
keyword: "[keyword]"
version: v1
status: draft
tags: [seed, seo-draft, ds-01]
---
```

---

## Completion Output

After saving both files, confirm:

```
Phase 1 complete: stage1_analysis-[slug].md
Phase 2 complete: v1-[slug]-claude-draft.md

Folder: Fable-Sandbox/Generated-Drafts/[NNN]-[slug]/
Word count: ~[N] words
Citations: [N] academic sources
DS-01 mentions: [N]
Compliance: Checked (Claims Library language verified, disclaimers present)

Ready for review with /review-draft-seed-perspective or /review-draft-1-v2-fable
```
