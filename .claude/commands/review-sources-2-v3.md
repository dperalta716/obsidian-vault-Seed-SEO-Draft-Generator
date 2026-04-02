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

## Key Enhancement in v3.1: 6-Layer Verification Pipeline

**Full Fallback Hierarchy:**

| Priority | Method | Best For | Speed |
|----------|--------|----------|-------|
| 1st | **PubMed API** | Biomedical literature (~70% of health citations) | Fastest |
| 2nd | **CrossRef API** | ALL disciplines — catches "DOI exists but not in PubMed" | Fast |
| 3rd | **Semantic Scholar** | Metadata + abstracts + citation counts | Fast |
| 4th | **WebFetch** | Non-DOI sources, other publishers | Medium |
| 5th | **Firecrawl** | Sites blocking WebFetch, JS-heavy pages | Slower |
| 6th | **Sci-Hub** | Last resort for paywalled content | Variable |

**Why This Order:**
- PubMed: Structured JSON, exact metadata, 36M+ biomedical articles
- CrossRef: Covers ALL registered DOIs regardless of discipline, returns citation counts
- Semantic Scholar: Returns abstracts + TLDR inline, citation-graph awareness
- WebFetch/Firecrawl: Handles non-DOI URLs and publisher pages
- Sci-Hub: Last resort when all legal methods fail

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

#### 3a-ii. CrossRef Fallback

If PubMed returns "DOI exists but not indexed in PubMed":

```bash
# Verify DOI via CrossRef (covers ALL disciplines)
/Users/david/Documents/Obsidian Vaults/claude-code-demo/Seed-SEO-Draft-Generator-v4/.claude/skills/academic-paper-research/scripts/crossref-verify-doi.sh "[DOI]"
```

CrossRef returns full metadata (title, authors, year, journal, citation count) for any registered DOI regardless of discipline. Handle the same way as PubMed verified response.

#### 3a-iii. Semantic Scholar Fallback

If CrossRef also fails or returns incomplete metadata:

```bash
# Fetch paper details via Semantic Scholar
/Users/david/Documents/Obsidian Vaults/claude-code-demo/Seed-SEO-Draft-Generator-v4/.claude/skills/academic-paper-research/scripts/semantic-scholar-fetch.sh "[DOI]"
```

Returns title, authors, year, abstract, TLDR, and citation count. The TLDR field provides a quick one-sentence summary useful for relevance checks.

#### 3b. WebFetch Fallback

If PubMed, CrossRef, and Semantic Scholar all fail, or for non-DOI URLs:

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

#### 3d. Sci-Hub Last Resort

If WebFetch and Firecrawl both fail:

```bash
# Last resort — try Sci-Hub for the paper
/Users/david/Documents/Obsidian Vaults/claude-code-demo/Seed-SEO-Draft-Generator-v4/.claude/skills/academic-paper-research/scripts/scihub-fetch.sh "[DOI]"
```

If found, note the PDF URL in the report. If the page contains extractable metadata, use it for verification. Otherwise, provide the PDF URL for manual review.

#### 3e. Determine Citation Status

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

#### 4a-ii. Semantic Scholar Search

If not found in PubMed, or for non-biomedical topics:

```bash
# Search Semantic Scholar (returns citation counts for authority ranking)
/Users/david/Documents/Obsidian Vaults/claude-code-demo/Seed-SEO-Draft-Generator-v4/.claude/skills/academic-paper-research/scripts/semantic-scholar-search.sh "[Title keywords] [Author]" 10
```

Prefer results with higher `citation_count` for more authoritative sources. Verify the candidate with `crossref-verify-doi.sh` or `pubmed-verify-doi.sh`.

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
📚 CrossRef API: B citations (all disciplines)
🔬 Semantic Scholar: C citations (with citation counts)
🌐 WebFetch: D citations
🔥 Firecrawl: E citations
🏴‍☠️ Sci-Hub: F citations (last resort)
❓ Unverifiable: G citations

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

## Skill References

### PubMed Research (biomedical)
```
.claude/skills/pubmed-research/scripts/
├── pubmed-verify-doi.sh   # Verify DOI, get metadata
├── pubmed-search.sh       # Search by keywords
└── pubmed-fetch.sh        # Get full article details
```

### Academic Paper Research (all disciplines)
```
.claude/skills/academic-paper-research/scripts/
├── config.sh                  # Shared config (email for APIs)
├── crossref-verify-doi.sh     # Verify DOI via CrossRef (all disciplines)
├── semantic-scholar-search.sh # Search with citation-graph awareness
├── semantic-scholar-fetch.sh  # Fetch abstract + metadata by DOI/PMID
├── unpaywall-find-pdf.sh      # Find legal open-access PDFs
└── scihub-fetch.sh            # Last-resort paper retrieval
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
- **v3.1**: 6-layer verification pipeline
  - Added CrossRef (catches all non-PubMed DOIs)
  - Added Semantic Scholar (citation counts + abstracts)
  - Added Sci-Hub as last resort before MANUAL REVIEW
  - Added Semantic Scholar search for finding replacement sources
  - Dramatically reduces MANUAL REVIEW cases

## Completion Output Format

When the command completes successfully and saves a new version, ALWAYS end with this exact format:

```
✅ Source Verification Complete!

Saved as: [FILENAME]
Location: [FULL_FOLDER_PATH]

Summary:
- Verified: X citations
- Fixed: Y citations
- Manual review: Z citations

═══════════════════════════════════════════════════
📝 NEXT STEP (copy and paste this command):
═══════════════════════════════════════════════════

/review-claims-3-v3 [FULL_PATH_TO_FILE_JUST_CREATED]
```

**CRITICAL:** The file path in the NEXT STEP must be the ACTUAL file that was just saved. Use the exact path including the version number that was created (e.g., `v4-sources-verified.md`).
