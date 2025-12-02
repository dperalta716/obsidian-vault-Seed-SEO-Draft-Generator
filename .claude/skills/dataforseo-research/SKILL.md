---
name: dataforseo-research
description: This skill should be used when conducting keyword research, SERP analysis, competitive research, or content gap analysis for SEO. Use this skill when analyzing search intent, identifying ranking opportunities, building content briefs, or validating keyword clustering strategies.
---

# DataForSEO Research

## Overview

This skill provides token-efficient access to Google SERP data via DataForSEO API for SEO keyword research and competitive analysis. The skill uses a filtered approach that reduces token consumption by 60-80% while preserving essential SERP insights.

## Quick Start

Run the DataForSEO script from the vault root:

```bash
cd /Users/david/Documents/Obsidian\ Vaults/claude-code-demo
./dataforseo-filtered.sh "keyword" "language_code" "location"
```

**Example:**
```bash
./dataforseo-filtered.sh "best probiotics for gut health" "en" "United States"
```

**What you get:**
- Top 10 organic results with title, URL, domain, description
- People Also Ask questions
- Related searches
- Featured snippets (if present)
- Forums/discussions, top stories, AI overviews (when relevant)

## Core SEO Research Tasks

### 1. Keyword Research & Intent Analysis

**When to use:** Discovering keywords and understanding what users want when they search.

**Process:**
1. Start with a seed keyword
2. Analyze organic results for content patterns
3. Extract PAA questions to understand user intent
4. Review related searches for topic expansion

**Example request:** "Research the keyword 'ultra processed foods' to understand search intent"

**Command:**
```bash
./dataforseo-filtered.sh "ultra processed foods" "en" "United States"
```

**What to analyze:**
- **Organic results:** What type of content ranks? (listicles, guides, scientific)
- **Featured snippet:** What answer format works? (definition, list, table)
- **People Also Ask:** What questions do users have?
- **Related searches:** What related topics matter?
- **Forums present:** Are users seeking personal advice/experiences?

### 2. Keyword Clustering

**When to use:** Determining if multiple keywords should target one page or separate pages.

**Process:**
1. Run SERP analysis for each keyword in the potential cluster
2. Compare the top 10 organic results across keywords
3. Calculate overlap: 7+ same URLs = same cluster (one page), <3 URLs = different clusters (separate pages)

**Example request:** "Should 'best probiotics' and 'top probiotic supplements' be the same page?"

**Commands:**
```bash
./dataforseo-filtered.sh "best probiotics" "en" "United States"
./dataforseo-filtered.sh "top probiotic supplements" "en" "United States"
```

**Decision criteria:**
- **High overlap (7+ URLs):** Target with single content piece
- **Medium overlap (4-6 URLs):** Consider separate pages with internal linking
- **Low overlap (<3 URLs):** Definitely separate pages, different intent

### 3. Content Brief Creation

**When to use:** Building comprehensive content briefs based on ranking content.

**Process:**
1. Get SERP data for target keyword
2. Analyze top 3 competitors' title/description patterns
3. Extract PAA questions for H2/H3 section ideas
4. Note SERP features to target (snippets, forums, etc.)
5. Compile into structured brief

**Example request:** "Create a content brief for 'signs probiotics are working'"

**Command:**
```bash
./dataforseo-filtered.sh "signs probiotics are working" "en" "United States"
```

**Brief components from SERP:**
- **Title pattern:** Extract from top 3 organic results
- **Content angle:** Infer from description patterns
- **Sections:** Use PAA questions as H2/H3 ideas
- **Format targets:** List format if featured snippet shows list
- **Topical coverage:** Map related searches to content sections

### 4. Competitor Analysis

**When to use:** Understanding who ranks and why for target keywords.

**Process:**
1. Run SERP for target keyword
2. Identify domains in top 10
3. Analyze their title/description strategies
4. Check if they own featured snippets or appear in discussions
5. Note competitive advantages

**Example request:** "Who are the main competitors for 'meal delivery services'?"

**Command:**
```bash
./dataforseo-filtered.sh "meal delivery services" "en" "United States"
```

**Competitor insights:**
- **Domain authority:** Which established sites rank?
- **Content strategies:** Listicle vs comparison vs review?
- **SERP feature ownership:** Who has the snippet/discussions?
- **Title patterns:** What terminology do they use?

### 5. Regional SEO Research

**When to use:** Researching local or region-specific search behavior.

**Process:**
1. Run same keyword with different location parameters
2. Compare SERP differences across regions
3. Identify location-specific content needs

**Example request:** "Compare 'meal delivery' SERPs in California vs Texas"

**Commands:**
```bash
./dataforseo-filtered.sh "meal delivery" "en" "California,United States"
./dataforseo-filtered.sh "meal delivery" "en" "Texas,United States"
```

**Regional insights:**
- Different local players ranking?
- Different PAA questions by region?
- Different SERP features present?
- Location-specific content opportunities?

## Parameter Reference

### Language Codes
Common two-letter ISO codes:
- `en` - English
- `es` - Spanish
- `fr` - French
- `de` - German

### Location Formats
**National:** `"United States"`
**State/Region:** `"California,United States"`
**City:** `"San Francisco,California,United States"`

**When to use each:**
- National: General keyword research
- Regional: State-specific businesses
- City: Local SEO research

## Integration with Vault Workflows

### Saving Research
Save outputs for later analysis:
```bash
./dataforseo-filtered.sh "keyword" "en" "United States" > "research/keyword-$(date +%Y-%m-%d).txt"
```

### Workflow with Slash Commands
- `/seo-keyword-serp-align` - Keyword clustering analysis
- `/seo-keyword-serp-align-cluster` - Clustering + cannibalization
- Custom content brief commands

## Technical Details

**Script location:** `/Users/david/Documents/Obsidian Vaults/claude-code-demo/dataforseo-filtered.sh`

**API endpoint:** DataForSEO SERP API (`.ai` endpoint for token optimization)

**Results depth:** Top 10 organic results

**SERP types returned:** organic, people_also_ask, related_searches, featured_snippet, top_stories, ai_overview, discussions_and_forums

**SERP types filtered out:** 39+ types including products, images, videos, knowledge graphs, carousels (reduces tokens by 60-80%)

## Common Patterns & Best Practices

### Analyze PAA for Content Structure
People Also Ask questions reveal:
- User knowledge level (beginner vs advanced)
- Common concerns and objections
- Natural section hierarchy for content

### Target SERP Features Strategically
- **Featured snippet present:** Format content to compete (lists, tables, concise answers in first 100 words)
- **Forums appearing:** Add FAQ or community-focused sections
- **News present:** Topic may be trending, consider newsjacking angle
- **No special features:** Focus on comprehensive, authoritative content

### Save Research for Comparison
Track SERP changes over time:
```bash
# Save with timestamp
./dataforseo-filtered.sh "keyword" "en" "United States" > "research/keyword-$(date +%Y-%m-%d).txt"
```

Monitor for:
- SERP volatility (ranking changes)
- Competitor movement
- New SERP features
- Emerging topics in PAA

### Batch Research for Efficiency
When researching multiple related keywords, run them sequentially and compare outputs to identify clustering opportunities or content gaps.
