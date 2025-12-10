# Content Creation Workflow for Seed SEO Draft Generator v4

This document outlines the complete step-by-step process for creating new SEO content and revising existing published content for Seed Health.

---

## Overview

There are **two distinct workflows** depending on whether you're creating **new content** or **revising existing published content**:

| Workflow | Use Case | Starting Point |
|----------|----------|----------------|
| **Workflow A** | Creating new articles from scratch | Keyword |
| **Workflow B** | Revising existing published articles | Published URL |

---

## WORKFLOW A: Creating New Content

**Stage 1 → Gemini Draft → Reviews**

This is the primary workflow for generating new SEO articles from scratch.

### Step 1: Generate Competitive Analysis (Stage 1)

**Command:** `/pre-draft-competitor-analysis-v4 <keyword>`

**What it does:**
1. Fetches SERP data using DataForSEO shell script
2. Scrapes and analyzes top 5 ranking articles for the keyword
3. Extracts People Also Ask questions (8 total, selects best 4)
4. Identifies user search intent and competitive baseline topics
5. Builds a citation & evidence landscape table with DOIs
6. Creates a comprehensive analysis document

**Output:** `Generated-Drafts/[NNN]-[keyword-slug]/stage1_analysis-[keyword-slug].md`

**Example:**
```
/pre-draft-competitor-analysis-v4 best supplements for sleep
```

---

### Step 2: Draft with Gemini

After Stage 1 completes, take the analysis to **Google AI Studio (Gemini)** to generate the draft.

#### Setup in Google AI Studio:

1. **Open Google AI Studio** (aistudio.google.com)

2. **Load System Instructions:**
   - Copy the contents of `Gemini Drafting Instructions/2025-10-16-Gemini-System-Instructions.md`
   - Paste into the "System Instructions" field in AI Studio

3. **Upload Reference Documents** (these are specified in the system instructions):

   **Tier 1 - Evidence Authority (Highest Priority):**
   - Product-specific Claims files: `PM-02-[Ingredient]-Claims.md`, `DM-02-[Ingredient]-Claims.md`, `AM-02-[Ingredient]-Claims.md`
   - General Claims files: `PM-02-General-Claims.md`, `DM-02-General-Claims.md`, `AM-02-General-Claims.md`, `Cross-Product-General-Claims.md`

   **Tier 2 - Strategy & Voice:**
   - `PM-02 Product Messaging Reference Documents.md`
   - `DM-02 Product Messaging Reference Documents.md`
   - `AM-02 Product Messaging Reference Documents.md`

   **Supporting Documents:**
   - `What we are and are not allowed to say when writing for Seed.txt` (Compliance Rules)
   - `Seed Tone of Voice and Structure.txt` (Tone Guide)
   - `8 Sample Reference Blog Articles.txt` (Sample Articles)
   - `NO-NO WORDS.csv`

4. **Upload the Stage 1 Analysis:**
   - Upload `stage1_analysis-[keyword-slug].md` from Step 1

5. **Prompt Gemini:**
   ```
   Generate an article for the keyword: "[your keyword]"
   ```

#### What Gemini Does (per the System Instructions):

1. **Analyzes the Stage 1 document** - extracts user intent, competitive baseline, citation landscape, and PAA questions
2. **Identifies relevant Seed products** - maps ingredients to PM-02, DM-02, or AM-02
3. **Develops Seed's unique narrative** - layers Seed perspective on top of competitive baseline
4. **Deep dives into Claims documents** - uses Tier 1 sources as primary authority
5. **Builds citation strategy** - 12-16 academic sources using 3-tier hierarchy
6. **Creates the draft** - 1800-2200 words with proper formatting, tone, and citations
7. **Performs simplification pass** - ensures 7th-8th grade reading level

#### Save the Output:

Save Gemini's output as: `Generated-Drafts/[NNN]-[keyword-slug]/v1-[keyword-slug].md`

---

### Step 3: Review Seed Perspective (RUN FIRST!)

**Command:** `/review-draft-seed-perspective`

**What it does:**
- Grades the draft against 15 checks across 3 categories:
  - **A. Claims Document Usage** (5 checks) - Uses approved sources as primary authority
  - **B. NPD Messaging Alignment** (5 checks) - Product-specific positioning (soil depletion, precision dosing, etc.)
  - **C. SciComms Education Integration** (5 checks) - Educational content integration
- Assigns a letter grade (A-F)
- **Grade A-B:** Proceed to quality review
- **Grade C-F:** Fix Seed issues first, re-review

**Options after review:**
- `all` - Fix everything
- `critical` - Fix only critical priority issues
- `claims` - Fix only Claims document usage issues
- `messaging` - Fix only NPD messaging issues
- `scicomms` - Fix only SciComms integration issues

**Output:** `v2-seed-perspective-reviewed.md` (after fixes applied)

---

### Step 4: Quality/Compliance Review

**Command:** `/review-draft-1` or `/review-draft-1-v2`

**What it does:**
- Checks ~60 quality/compliance items:
  - **Citations & Evidence** (10 checks) - format, count 12-15, density
  - **Tone & Voice** (20 checks) - conversational, empathetic, "knowledgeable friend"
  - **Compliance** (10 checks) - NO-NO words, forbidden claims
  - **Structure & Length** (8 checks) - word count ≥1300, required sections
  - **Product References** (5 checks) - ® symbols, proper links
  - **SEO Elements** (7 checks) - keyword usage, meta descriptions

**Output:** `v3-reviewed.md` (after fixes applied)

---

### Step 5: Source Verification

**Command:** `/review-sources-2-v3`

**What it does:**
1. Extracts ALL citations from the draft
2. Verifies each DOI using **triple-fallback**: PubMed API → WebFetch → Firecrawl
3. Detects non-existent DOIs and wrong-paper DOIs
4. Finds correct replacement sources via PubMed search
5. Updates all instances throughout the article

**Output:** `v4-sources-verified.md`

---

### Step 6: Claims Verification

**Command:** `/review-claims-3-v3`

**What it does:**
1. Extracts all sentences containing citations
2. Fetches source abstracts using **triple-fallback**: PubMed → WebFetch → Firecrawl
3. Compares each claim against its cited source content
4. Categorizes: **Supported** / **Partially Supported** / **Unsupported**
5. Recommends specific fixes while preserving Seed's tone

**Output:** `v5-claims-verified.md`

---

### Workflow A Summary

```
/pre-draft-competitor-analysis-v4 <keyword>   → Stage 1 Analysis
     ↓
[Take to Google AI Studio with Gemini]        → v1 Draft (Gemini-generated)
     ↓
/review-draft-seed-perspective                 → v2 (Seed perspective fixed)
     ↓
/review-draft-1                                → v3 (Quality/compliance fixed)
     ↓
/review-sources-2-v3                           → v4 (Sources verified)
     ↓
/review-claims-3-v3                            → v5 (Claims verified) ✅ DONE
```

---

## WORKFLOW B: Revising Existing Published Content

**Phase 1 Revisions**

This workflow is for improving articles already published on seed.com.

### Single Command:

**Command:** `/phase-1-analyze-seo-draft-step-1-v3 <url_or_path> <primary_keyword>`

**What it does:**
1. Scrapes the published article from seed.com using Firecrawl
2. Creates organized folder in `Phase 1 Draft Revisions/`
3. Searches and fetches top 3-4 competing articles
4. **Consults Seed's SciCare POV** (mandatory) - unique scientific perspectives
5. Performs comparative analysis through Seed's lens
6. **Validates recommendations through SEO safety checklist** (mandatory)
7. Asks for your feedback on which improvements to implement
8. **Directly drafts the revised article** with bolded new content
9. Includes strategic analysis context at TOP of final document

**Output:** `Phase 1 Draft Revisions/[NNN]-[keyword]/v2-revised-[keyword].md`

**Example:**
```
/phase-1-analyze-seo-draft-step-1-v3 /cultured/probiotics-for-gut-health "probiotics for gut health"
```

### Follow-up Reviews:

After the revision is complete, run the same review commands:

```
/review-sources-2-v3    → Verify all citations
     ↓
/review-claims-3-v3     → Verify claims match sources ✅ DONE
```

---

## Quick Reference: Command Purposes

| Command | Purpose |
|---------|---------|
| `/pre-draft-competitor-analysis-v4` | Generate competitive analysis (Stage 1) |
| **Gemini (AI Studio)** | Generate draft from Stage 1 analysis |
| `/review-draft-seed-perspective` | Check Seed alignment (run FIRST after draft) |
| `/review-draft-1` | Quality, tone, compliance, SEO checks |
| `/review-sources-2-v3` | Verify all DOIs/citations are real |
| `/review-claims-3-v3` | Verify claims match cited sources |
| `/phase-1-analyze-seo-draft-step-1-v3` | Revise existing published articles |

---

## Gemini System Instructions Key Points

The Gemini drafting instructions (`Gemini Drafting Instructions/2025-10-16-Gemini-System-Instructions.md`) configure Gemini to:

- **Target word count:** 1800-2200 words (max 2500)
- **Citation count:** 12-16 academic sources
- **Use 3-tier evidence hierarchy:**
  1. **Tier 1:** Seed's Claims documents (absolute authority)
  2. **Tier 2:** Pre-vetted sources from Stage 1 analysis
  3. **Tier 3:** Additional PubMed research if gaps remain
- **Apply layering approach:** Competitive baseline first, then Seed's unique perspective on top
- **Include required elements:** Overview bullets, Dirk Gevers quote, The Key Insight section, FAQs from PAA questions
- **Maintain Seed tone:** "Knowledgeable and empathetic friend" voice
- **Perform simplification pass:** 7th-8th grade reading level, sentences under 25 words

---

## File Naming Conventions

### New Content (Workflow A):
```
Generated-Drafts/
└── [NNN]-[keyword-slug]/
    ├── stage1_analysis-[keyword-slug].md    ← Stage 1 output
    ├── v1-[keyword-slug].md                  ← Gemini draft
    ├── v2-seed-perspective-reviewed.md       ← After Seed review
    ├── v3-reviewed.md                        ← After quality review
    ├── v4-sources-verified.md                ← After source verification
    └── v5-claims-verified.md                 ← Final version
```

### Published Content Revisions (Workflow B):
```
Phase 1 Draft Revisions/
└── [NNN]-[keyword]/
    ├── [keyword]-currently-published.md      ← Scraped original
    ├── v2-revised-[keyword].md               ← After revision
    ├── v3-sources-verified.md                ← After source verification
    └── v4-claims-verified.md                 ← Final version
```

---

## Grading Scale (Seed Perspective Review)

| Grade | Checks Passed | Meaning | Action |
|-------|---------------|---------|--------|
| **A** | 13-15/15 | Excellent Seed alignment | Proceed to quality review |
| **B** | 10-12/15 | Good foundation | Address minor gaps, then proceed |
| **C** | 7-9/15 | Needs significant work | Fix Seed issues before quality review |
| **D** | 4-6/15 | Major misalignment | Substantial rewrite needed |
| **F** | 0-3/15 | Complete rewrite needed | Does not reflect Seed positioning |

---

## Tips for Best Results

1. **Always run Seed perspective review FIRST** - Don't waste time polishing tone/SEO if the core perspective is wrong

2. **Fix critical issues before high/medium** - Priority order matters

3. **Gemini drafts are a starting point** - The review commands catch what Gemini misses

4. **Claims docs are absolute authority** - When in doubt, defer to what's in the Claims files

5. **Preserve casual tone** - Reviews check substance of claims, not exact wording

6. **Version files, never overwrite** - Original files are always preserved

---

*Last Updated: December 2024*
