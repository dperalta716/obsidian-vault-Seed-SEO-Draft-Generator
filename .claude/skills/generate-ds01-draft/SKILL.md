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
- **The POV brief governs ANGLE and primary evidence — NOT scope.** ← critical. The brief sets the article's stance and citation pool. It does NOT decide which topics appear. Topic scope is set by the Phase 1 Coverage Inventory. A competitor item missing from the brief (e.g. ginger tea, ACV) is NOT a signal to skip it — it still appears per its Disposition, covered with an honest "limited evidence / here's the contradiction" frame grounded in the POV. Never let the brief's topic list silently cap the article's coverage. (This silent capping is the #1 cause of our drafts coming out thinner than competitors.)
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
HIGHEST=$(ls -1 Generated-Drafts 2>/dev/null | grep -E '^[0-9]{3}-' | sed 's/-.*//' | sort -n | tail -1)
NEXT=$(printf "%03d" $((10#${HIGHEST:-0} + 1)))
SLUG=$(echo "$ARGUMENTS" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
mkdir -p "Generated-Drafts/${NEXT}-${SLUG}/competitors"
```

Store the folder path `Generated-Drafts/${NEXT}-${SLUG}` for use in subsequent steps.

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

2. **Article Type Classification** — classify the keyword as exactly one of:
   - **Enumerated listicle** ("gut health drinks", "best X for gut health", "foods that…", "herbs for…") → the article must ENUMERATE items; each item gets its own H3.
   - **Single-subject explainer** ("kefir for gut health", "is X good for gut health", "X for gut health") → the article explains ONE subject; each distinct benefit/effect/mechanism gets its own H3.
   - **Comparison** ("X vs Y") → each option gets its own H3, plus a head-to-head section.

   This type drives the required structure in Phase 2 (one H3 per item vs. one H3 per benefit). State it explicitly in the analysis doc.

3. **Coverage Inventory** (REPLACES the old "topics in 3+ articles = must-cover" filter — that threshold silently dropped the long tail, e.g. ginger tea, ACV, and every drink only one competitor named, which is exactly how our drafts ended up thinner than competitors). Build ONE exhaustive table of EVERY distinct item/subtopic ANY competitor covers — do not pre-filter:

   | Item / Subtopic | # competitors | Deepest competitor + depth | In POV brief? | Disposition |
   |---|---|---|---|---|
   | Kefir | 5/5 | Wildwonder (own H3, ~150w) | Y | Full section |
   | Kombucha | 5/5 | GoodRx (own H2, ~130w) | Y | Full section |
   | Ginger tea | 2/5 | GoodRx (own H2, ~120w) | N | Include + honest caveat |
   | Apple cider vinegar | 2/5 | GoodRx (own H2, ~150w) | N | Include + honest caveat |
   | Rejuvelac / kvass / jun tea | 1/5 each | Wildwonder (~60w) | N | Fringe → catch-all line |

   **Disposition rules (decide every row — nothing is left implicit):**
   - **In the POV brief** → `Full section`, written through the SciCare POV angle.
   - **Not in brief, covered by ≥2 competitors** → `Include + honest caveat`. MANDATORY. Cover it, then ground it in our POV: "you'll see X recommended on nearly every list — here's what the evidence actually shows / what contradicts it." Never silently drop a ≥2-competitor item just because the brief omitted it.
   - **Not in brief, covered by only 1 competitor (fringe)** → `Fringe → catch-all line`. Fold into a single brief sentence (e.g., "Other drinks you'll spot — kvass, rejuvelac, jun tea — are fermented but barely studied").
   - **Depth bar:** record the deepest competitor's treatment per item (own heading? word count? sub-points?) so Phase 2 knows what "matching coverage" means and doesn't stay at overview altitude.

4. **Citation & Evidence Landscape**: Academic sources table with DOIs
5. **Intelligent PAA Selection**: Choose 4 best of 8 questions with rationales
6. **Gaps & Opportunities**: Where Seed can differentiate

### Step 1.4: Create Analysis Document

Use the folder created in Step 1.1b (already exists with competitors/ subfolder populated).

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
## 2. Article Type & Coverage Inventory   (article type + the exhaustive item table with dispositions)
## 3. Citation & Evidence Landscape
## 4. People Also Ask Questions
## 5. Article-by-Article Analysis
## 6. Synthesis for Drafting
```

**§6 Synthesis MUST include a coverage-driven outline — not a compressed one.**
The outline must contain a slot for EVERY Coverage Inventory item (full sections, caveat-mentions, and the fringe catch-all line), mapped to its H2 group and H3. Do NOT collapse multiple distinct items into a single vague H2 (e.g. lumping green tea + ginger tea + ACV + prebiotic drinks into one "teas and other drinks" section) — that compression is what drops competitor coverage. If the article type is a listicle, the outline lists one H3 per item up front.

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
- Section 2: Article type + the FULL Coverage Inventory — every item, its disposition (Full / Caveat-mention / Catch-all), and its depth bar. This is the binding scope of the article.
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

**D. Develop Outline (coverage-driven + article-type-aware):**

- **Coverage is mandatory, not "addressed."** Build a Coverage Checklist from the stage1 Coverage Inventory: list EVERY item and its planned disposition (Full section / Caveat-mention / Catch-all line). Every item must have a home in the outline. You will reconcile against this checklist after writing (Step 2.4) — nothing may be silently dropped. ("Address the baseline" was the old wording and it kept letting items fall out.)
- **Out-of-brief items still appear** (per Phase 0: POV brief = angle, not scope). Items covered by ≥2 competitors but absent from the POV brief are MANDATORY — include them with an honest caveat / contradiction call-out grounded in our POV ("you'll see X on every list; here's what the evidence actually shows"). Single-competitor fringe items collapse into one catch-all sentence.
- **Structure by article type** (from stage1 §2):
  - **Enumerated listicle** → group items into H2s by a meaningful axis (usually evidence tier: "The Fermented Drinks With the Most Evidence" → "Where the Evidence Gets Thinner"), and give EACH item its own H3. One drink = one H3.
  - **Single-subject explainer** → one H2 per theme, and one H3 per DISTINCT benefit/effect/mechanism. (E.g. "What Kefir Does to Your Gut Microbiome" splits into H3s: increases *Bifidobacterium*, crowds out pathogens, supports the gut barrier — not one dense block.)
  - **Comparison** → one H3 per option + a head-to-head H2.
- **H2/H3 count is NOT capped.** The old "3–5 H2 body sections" rule caused compression — ignore it. Use as many H2s and H3s as the Coverage Inventory requires. Coverage parity with the deepest competitor beats a tidy section count.
- Layer Seed's unique angles on top of FULL coverage — angle never replaces breadth.
- Use the Timeline of Benefits phasing (Restore/Rebalance/Optimize) when discussing what to expect from DS-01.

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
- **H3-per-topic rule (the single most important structural rule).** Any H2 that runs over ~200 words OR covers 2+ distinct items/benefits MUST be broken into H3 subsections — one H3 per item (listicle) or per benefit/effect (single-subject). No exceptions. A section that is one cohesive idea under ~200 words needs no H3.
- **Each H3 heading is a searchable, one-line summary of its paragraph.** A reader should know what's in the paragraph from the heading alone. Good: "Kefir Increases Beneficial Bifidobacterium." Bad (vague, no search value): "A Two-Way Street," "When the Balance Tips."
- **Scan test:** read all H2s + H3s in sequence — do they read like a table of contents a reader could navigate from headings alone? If any heading is ambiguous without the body, revise it.
- **Heading SEO:** primary keyword verbatim in at least one H2 AND at least one H3 (FAQ questions count); work secondary search terms into remaining headings; keep headings ~5–10 words; no decorative colon-subtitles with no search value.
- Each H2's intro (text between the H2 and its first H3) stays short — 1–2 sentences leading into the H3s beneath it.
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

#### 2. The Article (length flexes to coverage — typically 1800-2400 words)

Length follows coverage, not the other way around. The article MUST cover every Coverage Inventory item (full sections + caveat-mentions + the catch-all line), so word count flexes UPWARD toward the deepest competitor when coverage demands it — never drop an item to hit a cap. Don't pad either: caveat-mentions can be 2–3 sentences, the catch-all is one sentence.

```
# [H1 -- same as metadata H1]

### Overview
[3-5 bullet points summarizing key takeaways]

[Engaging Introduction -- immediately answer primary user question]

## [Body H2 Sections -- grouped by evidence tier (listicle) or theme (single-subject). ONE H3 per item or per benefit. H2/H3 count UNCAPPED — driven by the Coverage Inventory, not a fixed number.]

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

**Coverage & Structure (NEW — reconcile this FIRST; it's what prevents under-covering competitors):**
- [ ] Coverage Checklist reconciled: EVERY stage1 Coverage Inventory item appears in the draft (full section, caveat-mention, or catch-all line) — none silently dropped
- [ ] Every out-of-brief item covered by ≥2 competitors is present, with an honest "limited evidence / here's the contradiction" frame grounded in our POV
- [ ] Article type matches stage1 §2 and the structure follows it (one H3 per item for listicles; one H3 per benefit for single-subject)
- [ ] H3-per-topic rule applied: no H2 over ~200 words or covering 2+ items/benefits is left without H3 subdivisions
- [ ] H2s + H3s read as a scannable table of contents; each H3 summarizes its paragraph
- [ ] Primary keyword appears verbatim in ≥1 H2 AND ≥1 H3

**Compliance:**
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
- [ ] Word count appropriate to coverage (≈1800-2400; may exceed to match the deepest competitor — never drop items to hit a cap)
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

Save to: `Generated-Drafts/[NNN]-[slug]/v1-[slug]-claude-draft.md`

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

Folder: Generated-Drafts/[NNN]-[slug]/
Word count: ~[N] words
Citations: [N] academic sources
DS-01 mentions: [N]
Compliance: Checked (Claims Library language verified, disclaimers present)

Ready for review with /review-draft-seed-perspective or /review-draft-1-v2
```
