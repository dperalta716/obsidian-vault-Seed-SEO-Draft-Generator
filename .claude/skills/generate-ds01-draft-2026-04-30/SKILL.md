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
/generate-ds01-draft-2026-04-30 probiotics for bloating
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
- When the article topic involves consuming live microorganisms (fermented foods, kombucha, yogurt, etc.), the "Engineered to Survive" pillar is almost always relevant — flag it as a candidate angle. The natural reader question is: "Do the microbes in [topic food] even survive digestion?" DS-01's answer (ViaCap®, SHIME-tested) is a direct differentiator.

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

**CRITICAL — Citation Misattribution Guard:**
- Studies from the Claims Library (Allegretti 2026, Del Piano 2010, Iemoli 2012, Chakkalakal 2022, Strozzi 2008, Xiao 2006) are DS-01 ingredient or product evidence ONLY
- NEVER use these citations to support claims about the article's topic food/drink/ingredient
- If discussing immune function, gut barrier, or regularity in the context of the topic (not DS-01), use independent academic literature from the stage1_analysis citation pool
- Only cite Claims Library studies in sentences that explicitly reference DS-01 or its formulation

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

**Strategic Use of Humor:**
- Incorporate occasional light humor, especially when discussing potentially embarrassing topics
- Humor often involves self-awareness (bodily functions) or relatable everyday scenarios
- Use witty section headings or playful asides where natural
- Keep humor appropriate and supportive of the educational mission — never at the reader's expense

*Example: "Who knew your microbiome had such refined taste?"*

**Scientific Communication:**
- Introduce scientific terms with plain language explanations first, then the term
- Use analogies and metaphors to explain complex biological concepts — choose ones that clarify rather than confuse
- Balance authoritative knowledge with humility about scientific limitations
- Note when research is still evolving or inconclusive ("research suggests" rather than absolute statements)
- Transition smoothly between casual asides and substantive information

*Example: "Think of probiotics as helpful allies rather than miracle workers — they shouldn't replace any part of your standard prenatal care."*

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
- The Key Insight closes with a warm, grounding line (not a strategy summary)

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

#### DS-01 Pitch Construction

The DS-01 section should follow this logic:
1. **Gap identification**: What the article topic (food/drink/ingredient) cannot do alone (e.g., introduce new strains, deliver at a validated dose, survive digestion)
2. **Mechanism bridge**: How DS-01 addresses that gap at the root-cause level (transforms the microbiome, supports gut barrier, delivers to the colon)
3. **Evidence anchor**: The landmark trial result using approved Claims Library language with all required disclaimers
4. **Positioning**: Frame as "precision on top of a good foundation" — never replacement

Choose only the claims and mechanisms RELEVANT to the article topic:
- If the topic is about regularity/digestion → use bloating + gas + regularity claims
- If the topic is about immune function → use immune health claims (††required)
- If the topic is about microbiome diversity → use "transforms the gut" + "increases beneficial bacteria" claims
- If the topic is about fermented foods or live microbe consumption → include "Engineered to Survive" / ViaCap survivability angle
- Do NOT include claims unrelated to the article topic just to pack in more product info

#### Dirk Gevers, Ph.D. Quote

- 1-2 quotes total, each 1-3 sentences
- Attribute as: says **Dirk Gevers, Ph.D.** or explains **Dirk Gevers, Ph.D.**
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
- [ ] DS-01 pitch is relevant to the article topic (not generic product dump)
- [ ] Strain-level temporal claims (e.g., "regularity in 2 weeks") include ingredient callout per Copy Compliance Guidance

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
