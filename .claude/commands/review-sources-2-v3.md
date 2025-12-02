# review-sources-2-v3

Enhanced source verification with **PubMed-first** approach and triple-fallback for comprehensive coverage.

## Usage

- `/review-sources-2-v3` - Reviews sources in the most recent draft in /Generated-Drafts/ or /Phase 1 Draft Revsions/
- `/review-sources-2-v3 filename.md` - Reviews sources in a specific file
- `/review-sources-2-v3 melatonin` - Reviews sources in draft containing keyword in filename

## What This Command Does

1. Extracts ALL citations from your draft
2. Verifies each DOI using **triple-fallback**: PubMed API → WebFetch → Firecrawl
3. Detects non-existent DOIs and wrong-paper DOIs
4. Searches for and finds correct studies
5. Updates ALL instances throughout the article
6. Reports which method verified each citation

## Key Enhancement in v3: PubMed-First Verification

**Triple-Fallback Hierarchy:**

| Priority | Method | Best For | Speed |
|----------|--------|----------|-------|
| 1st | **PubMed API** | Biomedical literature (~70% of health citations) | Fastest |
| 2nd | **WebFetch** | Non-PubMed sources, other publishers | Fast |
| 3rd | **Firecrawl** | Sites blocking WebFetch, JS-heavy pages | Slower |

**Why PubMed First:**
- Structured JSON response (no HTML parsing needed)
- Returns exact metadata: title, authors, year, DOI
- Instant verification status
- Covers 36M+ biomedical articles
- Free, no rate limit issues

## Implementation

### Step 1: File Identification

Same as v2:
- If no argument: Find most recent versioned file in `/Generated-Drafts/` or `/Phase 1 Draft Revsions/`
- If filename argument: Use that specific file
- If keyword argument: Find keyword folder and use latest version

### Step 2: Extract All Citations

Parse the article to extract:
- All entries from "## Citations" section
- All inline citations in format `([Author Year](URL))`
- Extract: Author name, Year, Title, Current DOI/URL

### Step 3: Verify Each Citation with Triple-Fallback

For EACH citation, process sequentially:

#### 3a. Check if DOI-based citation

If URL contains `doi.org/` or matches DOI pattern (`10.xxxx/...`):

**Try PubMed API first:**
```bash
# Use the pubmed-research skill
/Users/david/Documents/Obsidian Vaults/claude-code-demo/Seed-SEO-Draft-Generator-v4/.claude/skills/pubmed-research/scripts/pubmed-verify-doi.sh "[DOI]"
```

**PubMed Response Handling:**

| Status | Meaning | Action |
|--------|---------|--------|
| `verified: true` | DOI found in PubMed | Compare title/author with citation |
| `DOI exists but not indexed in PubMed` | Valid DOI, not in PubMed | Fall back to WebFetch |
| `DOI NOT FOUND` | Invalid DOI | Mark as NON-EXISTENT, search for correct |

**If PubMed returns verified:**
```json
{
  "verified": true,
  "title": "Actual Article Title",
  "first_author": "Smith",
  "pub_year": "2023",
  "citation_format": "(Smith 2023)"
}
```
- Compare `title` with citation's claimed title
- Compare `first_author` with citation's author
- If match → VALID
- If mismatch → WRONG PAPER (DOI leads to different article)

#### 3b. WebFetch Fallback

If PubMed returns "not indexed" or for non-DOI URLs:

```
WebFetch the URL with prompt:
"Extract: TITLE: [exact title], FIRST_AUTHOR: [first author last name], YEAR: [publication year]
If page shows 'DOI NOT FOUND' or similar error, return: ERROR: DOI not found"
```

#### 3c. Firecrawl Fallback

If WebFetch fails (blocked, timeout, error):

```bash
# Use firecrawl-scraper skill
./.claude/skills/firecrawl-scraper/scripts/firecrawl-scrape.sh "[URL]" "markdown" "true" "2000"
```

Process scraped content to extract title/author/year.

#### 3d. Determine Citation Status

| Condition | Status | Action |
|-----------|--------|--------|
| Title AND author match | ✅ VALID | No change needed |
| DOI not found in any system | ❌ NON-EXISTENT | Search for correct DOI |
| DOI works but wrong paper | ❌ WRONG PAPER | Search for correct DOI |
| All methods fail | ⚠️ MANUAL REVIEW | Flag for human review |

### Step 4: Fix Invalid Citations

For each invalid citation:

#### 4a. Search PubMed First

```bash
# Search for the correct article by title/author
/Users/david/Documents/Obsidian Vaults/claude-code-demo/Seed-SEO-Draft-Generator-v4/.claude/skills/pubmed-research/scripts/pubmed-search.sh "[Title keywords] [Author]" 5 relevance
```

If found in PubMed:
- Get the correct DOI from results
- Verify with `pubmed-verify-doi.sh`
- Use the `citation_with_link` format from response

#### 4b. WebSearch Fallback

If not in PubMed:
```
WebSearch for: "[Full citation title]" [Author last name] [Year] DOI
```

Prioritize results from:
- doi.org
- pubmed.ncbi.nlm.nih.gov
- sciencedirect.com
- nature.com, springer.com, wiley.com
- academic.oup.com, journals.plos.org
- mdpi.com, frontiersin.org

#### 4c. Verify Replacement Source

Use triple-fallback to verify the new source before using it.

### Step 5: Update Article

1. **Create versioned copy** (never modify original):
   - If reviewing v2 → save as v3-sources-verified.md
   - Keep in same keyword subfolder

2. **Update Citations section:**
   - Replace incorrect DOI with verified DOI
   - Maintain APA format

3. **Update ALL inline references:**
   - Find every `([Author Year](old-url))`
   - Replace with `([Author Year](new-url))`
   - Count replacements per citation

### Step 6: Generate Report

```
🔍 Source Verification Complete: [filename]

📚 Reviewed X citations
✅ Valid: Y
❌ Fixed: Z
⚠️ Manual review: W

## Verification Methods Used:
🧬 PubMed API: A citations (verified via NCBI)
🌐 WebFetch: B citations
🔥 Firecrawl: C citations
❓ Unverifiable: D citations

## Changes Made:

1. [Author Year]
   ❌ Old: [old DOI] - Status: [NON-EXISTENT/WRONG PAPER]
   ✅ New: [new DOI]
   📥 Found via: [PubMed/WebSearch]
   🔬 Verified via: [PubMed/WebFetch/Firecrawl]
   → Updated X inline references

[Continue for all fixed citations...]

## Citations Requiring Manual Review:

- [Author Year]: [reason - e.g., "Not found in any database"]

💾 Original preserved: [original filename]
📝 Verified version: v[X]-sources-verified.md
```

## Matching Logic

### Title Matching
- Match part BEFORE any colon
- Case-insensitive
- Ignore trailing punctuation
- Allow minor word variations

### Author Matching
- Match last name only
- "Smith" = "Smith, J." = "Smith, John"
- Handle accent variations: "García" = "Garcia"

### Year Matching
- Exact match required
- Use publication year (not online-first year)

## Edge Cases

| Case | Handling |
|------|----------|
| DOI not in PubMed | Falls back to WebFetch → Firecrawl |
| Non-DOI URL (e.g., PMC link) | Extract PMID, verify via PubMed fetch |
| Retracted article | Flag with warning, don't auto-fix |
| Preprint → Published | Update to published version DOI |
| Multiple valid DOIs | Accept any correct one |
| Book chapters | May not be in PubMed, use WebFetch |

## PubMed Skill Reference

Scripts location:
```
.claude/skills/pubmed-research/scripts/
├── pubmed-verify-doi.sh   # Verify DOI, get metadata
├── pubmed-search.sh       # Search by keywords
└── pubmed-fetch.sh        # Get full article details
```

**Verify DOI:**
```bash
./pubmed-verify-doi.sh "10.1038/nrgastro.2014.66"
# Returns: verified status, title, authors, citation_format
```

**Search for articles:**
```bash
./pubmed-search.sh "probiotics IBS meta-analysis" 5 relevance
# Returns: list of matching articles with DOIs
```

**Get abstract (for deeper verification):**
```bash
./pubmed-fetch.sh "24912386"
# Returns: full metadata including abstract
```

## File Saving

- Original file: NEVER modified
- Output: `v[X]-sources-verified.md` in same folder
- Version auto-increments
- Atomic updates (all or nothing)

## Version History

- **v1**: WebFetch only
- **v2**: WebFetch → Firecrawl fallback
- **v3**: PubMed API → WebFetch → Firecrawl triple-fallback
  - 70%+ faster for biomedical citations
  - Structured verification (no HTML parsing)
  - Better accuracy with exact metadata matching
