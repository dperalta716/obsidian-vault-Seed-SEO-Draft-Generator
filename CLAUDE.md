# CLAUDE-v2.md - Seed SEO Draft Generator (Improved Readability Version)

This vault is a specialized environment for generating SEO-optimized articles for Seed Health's NPD (New Product Development) products. 

## Primary Objective

Generate high-quality, SEO-optimized articles (Target: 1500-1800 words, Maximum: 2000 words, Sweet spot: 1600-1800 words) for Seed Health about provided keywords, focusing on NPD ingredients. Articles must be unique, deeply evidence-based (academic sources only), strategically cited to establish authority without excessive citation load, strictly adhere to Seed's specific scientific perspective and compliance guidelines, and match the Seed brand voice while maintaining optimal readability.

## Vault Structure

```
/Reference/NPD-Messaging/       # Product messaging documents  
/Reference/Claims/              # Clinical evidence and approved claims
  /PM-02/                       # Sleep + Restore claims
  /DM-02/                       # Daily Multivitamin claims
  /AM-02/                       # Focus + Energy claims (if available)
/Reference/Compliance/          # Compliance rules and forbidden terms
  NO-NO-WORDS.md               # Words/phrases to avoid
  What-We-Are-Not-Allowed-To-Say.md  # Compliance rules
/Reference/Style/              # Tone guide and sample articles
  Tone-Guide.md                # Brand voice and structure (existing)
  Seed-Tone-of-Voice-and-Structure.md  # Official tone guide
  8-Sample-Reference-Blog-Articles.md  # Example articles
/Generated-Drafts/             # Output folder for completed articles
/Templates/                    # Article template
```

## Document Hierarchy & Priority

### Tier 1 - Evidence Authority (HIGHEST PRIORITY)
- `PM-02-[Ingredient]-Claims.md` (Sleep + Restore product claims)
- `DM-02-[Ingredient]-Claims.md` (Daily Multivitamin claims)  
- `AM-02-[Ingredient]-Claims.md` (Focus + Energy claims)
- These documents contain the ABSOLUTE AUTHORITY for approved health claims, primary academic sources, and dose information

### Tier 2 - Strategy & Voice
- `/Reference/NPD-Messaging/PM-02 Product Messaging Reference Documents.md` (Sleep positioning)
- `/Reference/NPD-Messaging/DM-02 Product Messaging Reference Documents.md` (Multivitamin positioning)
- `/Reference/NPD-Messaging/AM-02 Product Messaging Reference Documents.md` (Focus/Energy positioning)
- These provide Seed's unique angles, compliance-approved language, and product differentiation

### Supporting Documents
- `/Reference/Compliance/What-We-Are-Not-Allowed-To-Say.md` (Compliance rules)
- `/Reference/Style/Seed-Tone-of-Voice-and-Structure.md` (Brand voice and article structure) 
- `/Reference/Style/Tone-Guide.md` (Additional tone guidance)
- `/Reference/Style/8-Sample-Reference-Blog-Articles.md` (Examples of tone, structure, citation style)
- `/Reference/Compliance/NO-NO-WORDS.md` (Words and phrases to avoid)

## Readability Requirements

### Core Readability Guidelines
- **Target reading level**: 7th-8th grade (Flesch-Kincaid)
- **Sentence length**: Maximum 25 words average, vary between short (10-15) and medium (20-25)
- **Paragraph length**: 2-3 sentences maximum
- **One concept per sentence**: Don't pack multiple ideas together
- **Technical terms**: Always explain in plain language first, then introduce the term
- **Transitions**: Use simple connecting phrases between paragraphs
- **Active voice**: Prefer active over passive constructions

## Complete Workflow Instructions

When the user provides a keyword, execute ALL of the following steps:

### Step 1: Search & Initial Analysis

1. **Web Search**: Use the WebSearch tool with EXACTLY the keyword provided - nothing more, nothing less
   - If user provides: "ashwagandha for sleep"
   - Execute: `WebSearch("ashwagandha for sleep")` 
   - DO NOT add terms like dosage, benefits, research, 2024, guide, etc.
   - DO NOT modify or expand the keyword in any way
   - Search for the top 5-7 ranking articles using ONLY the exact keyword string given

2. **Analyze Competition**: Understand common topics covered, angles taken, and standard advice given

3. **Identify Standard Advice**: Note 2-3 pieces of "standard advice" or common assumptions found in top results 
   - Example: "Take 5-10mg of melatonin for sleep"

4. **Capture PAA Questions**: Use DataForSEO MCP to fetch real People Also Ask questions from Google
   - Execute: Use the `mcp_dataforseo_serp_organic_live_advanced` tool
   - Required parameters:
     * `keyword`: [exact keyword provided by user]
     * `search_engine`: "google"
     * `location_name`: "United States"
     * `language_code`: "en"
     * `people_also_ask_click_depth`: 2 (to get expanded PAA questions)
   - Extract the PAA questions from the response
   - Store these 3-4 most relevant PAA questions for use in the FAQ section later
   - These questions reveal what users actually want to know about this topic

### Step 2: Determine User Intent & Core Questions

1. Based on Step 1, determine the primary user search intent(s) behind the keyword
2. Identify the core questions users are trying to answer when searching for this keyword
3. What information are they *really* seeking?

### Step 3: Identify Relevant Ingredients & Develop Seed's Unique Narrative

#### Ingredient Discovery & Product Mapping

1. **Analyze Keyword for Ingredients**: 
   - Identify all specific ingredients mentioned (e.g., "melatonin for sleep" → melatonin)
   - For broader topics (e.g., "vitamins for skin"), determine which specific vitamins/ingredients would be discussed

2. **Product Messaging Scan**: 
   - Review ALL three NPD messaging documents (PM-02, DM-02, AM-02)
   - Identify which products contain the relevant ingredients
   - **CRITICAL:** Note if ingredients appear in multiple products:
     * PQQ appears in all three products
     * CoQ10 appears in AM-02 and DM-02
     * GABA appears in PM-02 and AM-02
     * Check for other cross-product ingredients

3. **Develop Seed's Unique Narrative vs. Standard Advice**:
   - Compare the "standard advice" (from Step 1) against Seed's approach in the messaging documents
   - Identify Seed's unique scientific perspective or formulation philosophy:
     * **PM-02 angles**: Bioidentical melatonin dosing, dual-phase release, not overloading the system, calibrating circadian rhythms
     * **DM-02 angles**: Bioavailable forms, comprehensive coverage, synergistic formulation
     * **AM-02 angles**: Sustained energy without crash, nootropic benefits, microbiome support
     * **Cross-product themes**: Microbiome connection, precision dosing, evidence-based formulation
   
4. **Create Expert Quote**:
   - Draft a quote from **"Dirk Gevers, Ph.D."** (Maximum 1-2 sentences)
   - Use simpler language in quotes
   - Focus on ONE key differentiator
   - Highlight unique perspective or contrast with standard advice
   - Focus on the *ingredient story*, not the *product story*
   - Explain the science and Seed's "why" behind their approach

5. **Infuse Tone Early**: 
   - For each contrast identified, brainstorm ways to introduce Seed's perspective using a conversational or empathetic hook
   - Example: "We've all heard X, and it makes sense on the surface, right? But what if there's another way to look at it, especially when we consider Y? That's the kind of question we explore at Seed..."

### Step 4: Claims Document Deep Dive

#### Evidence Collection Protocol

1. **Retrieve ALL Relevant Claims Documents**:
   - For each identified ingredient, pull claims from ALL products containing it
   - Example: For PQQ article, retrieve:
     * `/Reference/Claims/PM-02/PM-02-PQQ-Claims.md`
     * `/Reference/Claims/AM-02-PQQ-Claims.md` (if exists)
     * `/Reference/Claims/DM-02/DM-02-PQQ-Claims.md` (if exists)

2. **Extract Key Information**:
   - **Primary Studies**: Use the EXACT studies linked in claims documents as primary sources
   - **Approved Claims**: Note all compliance-approved health claims
   - **Dose Information**: Document the specific doses used in studies vs. product formulation
   - **Context-Specific Benefits**: 
     * Sleep context (PM-02): restorative sleep, circadian rhythm
     * Energy context (AM-02): cognitive function, sustained energy
     * General health (DM-02): cellular health, nutritional support

3. **Multi-Product Integration Strategy**:
   When an ingredient appears in multiple products:
   - Include benefits relevant to ALL contexts
   - Show how the same ingredient serves different purposes
   - Example: "While CoQ10 is often associated with energy production, research shows it also plays a crucial role in cellular health and antioxidant protection"

4. **Compliance Check #1**: 
   - Ensure all claims align with approved language in claims documents
   - Cross-reference with `/Reference/Compliance/What-We-Are-Not-Allowed-To-Say.md`
   - Check against `/Reference/Compliance/NO-NO-WORDS.md`

### Step 5: Develop Article Outline

1. **Create H2/H3 Structure**:
   - Structure MUST follow the Tone Guide recommendations
   - Required sections: Overview, Intro, 3-4 main Body Sections, The Key Insight, FAQs
   - Headers should balance SEO relevance with engaging, question-based style
   - Each H2 section: 300-400 words maximum

2. **Outline Design Principles**:
   - Lead with the ingredient story, not product story
   - Incorporate Seed's unique perspectives and contrast with standard advice
   - Address multi-faceted benefits when ingredients appear in multiple products
   - Design outline to answer core user questions (from Step 2)
   - Incorporate unique narratives (from Step 3)

3. **Integrate Tonal Prompts into Outline (Internal Guidance Only)**:
   **NOTE: These markers are for internal writing guidance only - DO NOT include them in the final draft**
   
   For at least 2-3 key H2 or H3 sections (especially those explaining complex concepts or addressing sensitive reader concerns), use these as mental prompts while writing:
   - `[Use Analogy Here]` - Think of a relatable comparison
   - `[Pose Rhetorical Question to Reader]` - Ask one rhetorical question per 500 words maximum
   - `[Acknowledge Potential Reader Concern/Embarrassment]` - Address worries empathetically
   - `[Opportunity for Gentle Humor/Relatable Scenario]` - Add personality naturally
   - `[Explain this like a knowledgeable friend would]` - Use conversational tone
   - `[Transition with a conversational phrase]` - Connect ideas smoothly
   - `[Explain Simply]` - Lead with plain language

### Step 6: Gather Evidence & Identify Key Claims

**IMPORTANT: Limit total academic sources to 12-15 maximum across the entire article**

#### Evidence Hierarchy

1. **Primary Authority (MUST USE)**:
   - Studies directly cited in our claims documents
   - These take absolute priority for substantiating claims
   - Use the exact DOI links provided in claims files

2. **Secondary Research (AS NEEDED)**:
   - Additional peer-reviewed academic literature
   - Only add if our claims documents don't fully cover a necessary topic
   - Must be from last 10 years, preferably meta-analyses or systematic reviews

3. **Citation Strategy**:
   
   **Prioritize citing the following Key Claims:**
   - Specific study results from our claims documents
   - Quantitative data (percentages, dosages, effect sizes)
   - Specific mechanisms of action
   - Direct health claims linking ingredient to benefit
   - Any Seed-specific positioning (bioidentical dosing, etc.)
   - Safety/contraindication information
   - Novel or potentially controversial information
   
   **Generally do NOT cite:**
   - Basic definitions widely understood
   - Common biological processes
   - Broad transitional sentences
   - Simple food/symptom descriptions
   - Common health/lifestyle advice (unless linking to specific study)

4. **Citation Guidelines**:
   - Target approximately 1 citation per 75-100 words for key claims
   - Limit total sources to 12-15 maximum
   - For every source, obtain: DOI link, first author last name, publication year

5. **Frame Claims with Tone in Mind**:
   - **For scientific terms**: Plan to introduce with plain language explanation first, then the term
     * Example: "Think of it like your body's natural sleep timer – that's essentially what we call your circadian rhythm. And research shows... ([Author Year](DOI_URL))."
   - **For complex mechanisms**: Think about how a "knowledgeable friend" would explain this
   - **Anticipate reader questions**: If a claim might seem counterintuitive, address that empathetically
     * Example: "Now, this might sound a bit alarming, but don't worry... here's what the science actually means for you... ([Author Year](DOI_URL))."

6. **Compliance Check #2**: 
   - Double-check all claims against Compliance Rules and approved language

### Step 7: Simplification Pass

After drafting the article, perform a comprehensive simplification review:

1. **Sentence Simplification**:
   - Break any sentence over 30 words into two shorter sentences
   - Replace semicolons with periods in most cases
   - Ensure average sentence length stays under 25 words

2. **Language Accessibility**:
   - Replace academic jargon with plain language equivalents
   - Define technical terms immediately after introducing them
   - Use common words over complex synonyms

3. **Paragraph Structure**:
   - Split any paragraph with 4+ sentences
   - Ensure each paragraph focuses on one main idea
   - Add simple transition sentences between complex concepts

4. **Readability Checks**:
   - Apply the "grandmother test" - would a smart grandparent understand this?
   - Read aloud to catch awkward phrasing
   - Ensure 8th-10th grade reading level

5. **Flow and Coherence**:
   - Add connecting phrases between sections
   - Ensure logical progression of ideas
   - Check that complex concepts build on simpler foundations

## Article Generation Instructions

### 1. SEO Metadata

Generate the following metadata:
- **Primary keyword**: The primary keyword as provided
- **SEO Title**: Three potential SEO titles (50-60 characters) incorporating the keyword
- **Slug**: URL slug (lowercase, hyphen-separated) incorporating the keyword, ending with `-guide`
- **Meta Description** (160 characters max): Compelling description with primary keyword
- **Article description** (300 characters max): Longer description for social sharing
- **Written by**: [LEAVE BLANK]
- **Expert Reviewer**: [LEAVE BLANK]

### 2. SEO-Optimized Article (Target: 1500-1800 words)

#### Tone/Voice Integration

Before writing, and continuously throughout the writing process, actively embody the persona of a **'knowledgeable and empathetic friend'** as described in the Tone Guide:

- **Refer back** to `/Reference/Style/Seed-Tone-of-Voice-and-Structure.md` and `/Reference/Style/8-Sample-Reference-Blog-Articles.md` frequently
- **Use techniques**: Direct address ("you," "your"), contractions, occasional rhetorical questions (max 1 per 500 words), gentle self-deprecation where appropriate
- **Prioritize accessibility**: Explain scientific concepts using analogies, metaphors, and plain language before or alongside technical terms
- **Inject personality**: Look for natural opportunities for light, appropriate humor or relatable scenarios
- **Tonal Scaffolding**: For complex sections, first draft 2-3 sentences of pure conversational explanation without citations, then weave in the necessary key claims and citations

#### Article Structure

1. **### Overview** section (3 bullet points maximum summarizing key takeaways)

2. **Engaging Introduction**: 
   - Immediately answer the primary user question in the first 1-2 paragraphs
   - Keep paragraphs to 2-3 sentences
   - Provide a compelling reason to continue reading
   - Emulate the style of Sample Articles introductions

3. **Body Sections** (3-4 main H2 sections): 
   - Develop using the H2s/H3s from the internal Outline (Step 5)
   - Each H2 section: 300-400 words maximum
   - Include the Dirk Gevers, Ph.D. quote naturally where appropriate (1-2 sentences max)
   - Frame content around the ingredient narrative, not product pitch
   - When ingredients appear in multiple products, address all relevant benefits
   - Use short paragraphs (2-3 sentences)

4. **## The Key Insight** section: 
   - Summarize main points near the end (in paragraph form)
   - Keep to 150-200 words
   - Use simple, declarative sentences

5. **## Frequently Asked Questions** section: 
   - Answer 3 questions concisely (not 3-4)
   - Use the PAA questions captured in Step 1 from DataForSEO
   - These should be the actual questions users are asking on Google
   - Keep answers to 100-150 words each

#### Evidence Integration & Citations

- Use evidence-backed key claims from Step 6 appropriately throughout
- Format citations as `([Author Year](DOI_URL))` - NO COMMA between Author and Year
- The entire `(Author Year)` text block must be hyperlinked to the DOI URL
- Multiple citations: `([Author1 Year1](DOI_URL1), [Author2 Year2](DOI_URL2))`
- Only use peer-reviewed academic sources - no blogs, news articles, or general health websites
- Allow for conversational, explanatory prose around cited key claims

#### Product Links

All mentions of NPD products MUST include registered trademark symbols and be hyperlinked:
- `[PM-02® Sleep + Restore](https://seed.com/sleep-restore)`
- `[AM-02® Energy + Focus](https://seed.com/energy-focus)`
- `[DM-02® Daily Multivitamin](https://seed.com/daily-multivitamin)`

#### SEO & Compliance

- Naturally weave in the primary keyword, secondary keywords, and semantically related terms
- Optimize key sentences for potential featured snippets
- Strictly adhere to Compliance Rules
- Never use "supplement" for probiotics
- Double-check claims against approved language
- Ensure the final article meets the 1500-1800 word target (maximum 2000)
- Use short paragraphs, bullet points, and bolding for readability

### 3. Numbered Citation List

Create a numbered list titled "## Citations":
- List all academic sources actually cited in the article in APA format
- Order alphabetically by author last name
- Ensure each entry includes the working doi.org link
- Note: In-text citations use hyperlinked (Author Year) format, but this final list remains a standard numbered APA list

### 4. Suggested Internal Links

- Perform web search using `site:seed.com/cultured/` for relevant concepts
- Identify 5-15 relevant existing articles
- Prioritize URLs ending in `-guide` and established high-value pages
- For each suggested link, provide:
  * **Sentence**: Full sentence from the generated article where the link should be placed, with anchor text hyperlinked
  * **Recommended URL**: Just the slug (the part after `/cultured/`)

## File Saving & Organization

### Automatic Folder Numbering System

When generating a new article:

1. **Find the next available number**:
   - List all folders in `/Generated-Drafts/`
   - Extract numeric prefixes (e.g., "007" from "007-best-energy-supplement")
   - Find the highest number
   - Add 1 and format with 3-digit zero-padding (001, 002, 003, etc.)

2. **Create numbered keyword-specific folder**: `/Generated-Drafts/[NNN]-[keyword-slug]/`
   - Example: If highest existing is "007", next would be "008-vitamin-d-benefits"

3. **Save initial draft as**: `/Generated-Drafts/[NNN]-[keyword-slug]/v1-[keyword-slug].md`

4. **Version progression within the folder**:
   - `v1-[keyword-slug].md` - Initial generation
   - `v2-reviewed.md` - After review-draft command
   - `v3-sources-verified.md` - After review-sources command
   - `v4-claims-verified.md` - After review-claims command
   - `v5-final.md` - Final approved version (if applicable)

Note: The numbering system keeps drafts organized chronologically by creation order, making it easy to identify the newest content.

## Usage Example

User: "melatonin for sleep"
Assistant: [Automatically executes complete 7-step workflow and generates full article with all required sections]

## Critical Reminders

- This is a specialized vault - only use for SEO article generation
- ALWAYS check claims documents for Primary Authority sources first
- MUST use 12-15 academic sources (not 5, not 20)
- Maintain Seed's unique bioidentical/precision dosing perspective
- Always contrast with "standard advice" from competing articles
- Focus on ingredient story, not product pitch
- Check ALL product lines for cross-product ingredients
- Never use terms from NO-NO WORDS list
- Target ~1 citation per 75-100 words for key claims only
- Must have DataForSEO MCP configured to fetch real PAA questions
- PAA questions from DataForSEO inform both content strategy and FAQ section
- Apply simplification pass to ensure 8th-10th grade reading level
- Keep average sentence length under 25 words
- Maximum 2-3 sentences per paragraph
- Target 1600-1700 words for optimal length

## MCP Server Installation Protocol

### CRITICAL: Always Use Claude CLI for MCP Installations

**NEVER manually edit MCP configuration JSON files.** Always use the official Claude CLI commands to prevent scattered installations across multiple config locations.

### Standard Installation Process

1. **Clean First**: Remove any existing installation
   ```bash
   claude mcp remove [server-name]
   ```

2. **Install Using Claude CLI**: Use the appropriate package manager
   ```bash
   # For npm packages (most common)
   claude mcp add [server-name] npx [package-name]

   # For Python packages
   claude mcp add [server-name] uvx [package-name]

   # For specific Python tools
   claude mcp add [server-name] pipx run --spec [package-spec] [command]
   ```

3. **Add Environment Variables**: Use --env flags
   ```bash
   claude mcp add server-name npx package-name --env KEY1=value1 --env KEY2=value2
   ```

4. **Verify Installation**: Confirm it's working
   ```bash
   claude mcp list
   ```

### Package Manager Guidelines

- **`npx`**: Use for npm/Node.js packages (firecrawl-mcp, dataforseo-mcp-server, etc.)
- **`uvx`**: Use for Python packages that need isolated environments (workspace-mcp)
- **`pipx`**: Use for complex Python installations with specific git repos

### Example Installations

```bash
# Firecrawl MCP
claude mcp add firecrawl npx firecrawl-mcp

# DataForSEO MCP
claude mcp add dataforseo npx dataforseo-mcp-server --env DATAFORSEO_USERNAME=user@example.com --env DATAFORSEO_PASSWORD=password123

# Google Workspace MCP
claude mcp add google-workspace uvx workspace-mcp --single-user --tools calendar gmail drive docs sheets slides forms tasks --env GOOGLE_OAUTH_CLIENT_ID=your-id --env GOOGLE_OAUTH_CLIENT_SECRET=your-secret

# GitHub MCP (example with pipx)
claude mcp add github pipx run --spec git+https://github.com/example/github-mcp.git github-mcp
```

### Troubleshooting Installation Issues

- **Duplicates**: If `claude mcp list` shows duplicates, run `claude mcp remove [server-name]` then reinstall
- **Not connecting**: Check environment variables are correct and package name is accurate
- **Wrong config location**: Only use `claude mcp add` - never manually edit JSON files