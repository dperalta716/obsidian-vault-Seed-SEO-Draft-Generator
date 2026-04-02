---
name: academic-paper-research
description: Verify and discover academic papers across all disciplines via CrossRef, Semantic Scholar, Unpaywall, and Sci-Hub. Use when PubMed verification fails (non-biomedical sources), when searching for papers with citation-graph awareness, when finding legal open-access PDFs, or as a last-resort for full-text retrieval. Complements the pubmed-research skill as additional fallback layers in the review-sources and review-claims workflows.
---

# Academic Paper Research Skill

Verify and discover academic papers across all disciplines. Complements PubMed (biomedical-only) with broader coverage via CrossRef (all DOIs), Semantic Scholar (citation-graph + abstracts), Unpaywall (legal open-access PDFs), and Sci-Hub (last-resort full-text).

## Configuration

Scripts use a shared `config.sh` for the contact email (required by CrossRef and Unpaywall APIs). To configure:

```bash
# Option 1: Set environment variable (recommended for sharing)
export ACADEMIC_RESEARCH_EMAIL="your-email@example.com"

# Option 2: Auto-detects from git config (default fallback)
# No action needed — scripts read `git config user.email` automatically
```

The email is used for API identification only (not login/auth). CrossRef gives better rate limits to requests with a contact email, and Unpaywall requires one.

## Scripts

All scripts are in `scripts/` directory. Execute with full path:
```bash
/Users/david/Documents/Obsidian Vaults/claude-code-demo/Seed-SEO-Draft-Generator-v4/.claude/skills/academic-paper-research/scripts/[script-name].sh
```

### crossref-verify-doi.sh

Verify a DOI exists and retrieve metadata via CrossRef. Covers ALL academic disciplines (not just biomedical). This is the primary fallback when PubMed returns "DOI exists but not indexed."

```bash
./scripts/crossref-verify-doi.sh <doi>
```

- `doi` (required): DOI with or without `https://doi.org/` prefix

**Returns**: JSON with verification status, title, authors, year, journal, citation count, and formatted citation.

**Status values**:
- `VERIFIED`: DOI found in CrossRef with full metadata
- `DOI NOT FOUND`: DOI not registered in CrossRef

**Example**:
```bash
./scripts/crossref-verify-doi.sh "10.3390/nu11092048"
./scripts/crossref-verify-doi.sh "https://doi.org/10.1038/nrgastro.2014.66"
```

**Output fields**:
- `verified`: true/false
- `doi`, `doi_url`: DOI identifiers
- `status`: Verification status message
- `title`: Article title
- `authors`: Author list (first 3 + "et al.")
- `first_author`: Last name only (for citations)
- `journal`: Journal/container title
- `pub_year`: Publication year
- `type`: Publication type (journal-article, review, book-chapter, etc.)
- `citation_count`: Times cited (from CrossRef)
- `citation_format`: "(Author Year)" ready to use
- `citation_with_link`: Full markdown citation link

### semantic-scholar-search.sh

Search for papers with relevance ranking and citation-graph awareness. Returns citation counts, open-access status, and abstracts inline.

```bash
./scripts/semantic-scholar-search.sh "search query" [max_results] [year_range]
```

- `search query` (required): Free-text search query
- `max_results` (optional, default 10, max 100)
- `year_range` (optional): e.g., "2020-2024"

**Returns**: JSON array of matching papers with metadata.

**Example**:
```bash
./scripts/semantic-scholar-search.sh "probiotics gut microbiome meta-analysis" 10 "2020-2024"
./scripts/semantic-scholar-search.sh "ashwagandha cortisol clinical trial" 5
```

**Output fields per result**:
- `paper_id`: Semantic Scholar ID
- `title`: Article title
- `authors`: Author string (first 3 + "et al.")
- `first_author`: Last name only
- `year`: Publication year
- `doi`, `doi_url`: DOI identifiers (if available)
- `pmid`, `pubmed_url`: PubMed identifiers (if available)
- `citation_count`: Total citations
- `influential_citations`: Influential citation count
- `is_open_access`: Boolean
- `open_access_pdf`: Direct PDF URL (if available)
- `journal`: Journal name
- `abstract`: Full abstract text

### semantic-scholar-fetch.sh

Fetch detailed paper info by DOI, PMID, or Semantic Scholar ID. Returns full abstract, TLDR summary, and citation graph metadata.

```bash
./scripts/semantic-scholar-fetch.sh <identifier> [id_type]
```

- `identifier` (required): DOI, PMID, Semantic Scholar paper ID, or arXiv ID
- `id_type` (optional, auto-detected): "doi", "pmid", "s2", "arxiv"

**Auto-detection**: DOIs contain `/`, PMIDs are numeric, arXiv IDs match `\d{4}\.\d{4,5}`.

**Returns**: JSON with full metadata including abstract and TLDR.

**Example**:
```bash
./scripts/semantic-scholar-fetch.sh "10.3390/nu11092048"
./scripts/semantic-scholar-fetch.sh "31412048" "pmid"
./scripts/semantic-scholar-fetch.sh "2103.15348" "arxiv"
```

**Output fields**:
- `title`: Article title
- `abstract`: Full abstract text
- `tldr`: Machine-generated one-sentence summary (very useful for quick relevance check)
- `authors`: Full author list
- `first_author`: Last name only
- `year`: Publication year
- `doi`, `pmid`: Identifiers
- `citation_count`, `influential_citations`: Citation metrics
- `is_open_access`: Boolean
- `open_access_pdf`: Direct PDF URL (if available)
- `journal`: Journal name
- `publication_types`: e.g., ["JournalArticle", "Review"]
- `references_count`: Number of references
- `citation_short`: Formatted "(Author Year)"

### unpaywall-find-pdf.sh

Find legal open-access PDF URLs for a DOI. Indexes legal OA copies from publisher sites, institutional repositories, and preprint servers.

```bash
./scripts/unpaywall-find-pdf.sh <doi>
```

- `doi` (required): DOI with or without prefix

**Returns**: JSON with best open-access PDF URL and all available locations.

**Example**:
```bash
./scripts/unpaywall-find-pdf.sh "10.3390/nu11092048"
```

**Output fields**:
- `doi`: DOI queried
- `is_open_access`: Boolean
- `best_pdf_url`: Direct URL to best available PDF
- `best_landing_page`: Landing page URL
- `host_type`: "publisher", "repository", or "unknown"
- `license`: License type (e.g., "cc-by")
- `version`: "publishedVersion", "acceptedVersion", "submittedVersion"
- `title`, `journal`: Article metadata
- `all_locations`: Array of all available OA copies

### scihub-fetch.sh

Last-resort retrieval of paper PDF URL when all legal methods fail. Tries multiple Sci-Hub mirrors.

```bash
./scripts/scihub-fetch.sh <doi_or_url>
```

- `doi_or_url` (required): DOI, DOI URL, or direct paper URL

**Returns**: JSON with PDF URL if found.

**Example**:
```bash
./scripts/scihub-fetch.sh "10.1016/j.cell.2019.01.024"
```

**Output fields**:
- `doi`: DOI queried
- `found`: true/false
- `pdf_url`: Direct PDF URL
- `mirror_used`: Which Sci-Hub mirror responded
- `note`: Advisory about usage

**Legal note**: Sci-Hub operates in a legal gray area. Always try Unpaywall and other legal methods first. Use only for verification purposes when all legal methods have been exhausted.

## Common Workflows

### Enhanced DOI Verification (extends PubMed triple-fallback)

When PubMed returns "DOI exists but not indexed":
```bash
# PubMed said not indexed → try CrossRef
./scripts/crossref-verify-doi.sh "10.xxxx/..."

# CrossRef returns full metadata for any registered DOI
# If CrossRef also fails → try Semantic Scholar
./scripts/semantic-scholar-fetch.sh "10.xxxx/..."
```

### Paper Discovery with Citation Authority

Find the most authoritative papers on a topic:
```bash
# Search with citation counts
./scripts/semantic-scholar-search.sh "probiotics IBS meta-analysis" 20 "2020-2024"

# Sort results by citation_count to find most-cited
# Then fetch full details for top candidates
./scripts/semantic-scholar-fetch.sh "10.xxxx/..."
```

### Full-Text Access for Claims Verification

When an abstract is insufficient to verify a specific claim:
```bash
# Try legal open-access first
./scripts/unpaywall-find-pdf.sh "10.xxxx/..."

# If no legal PDF available → last resort
./scripts/scihub-fetch.sh "10.xxxx/..."
```

### Finding Replacement Sources

When a citation is invalid and you need a correct replacement:
```bash
# Search Semantic Scholar (has citation counts for authority)
./scripts/semantic-scholar-search.sh "[claim topic] clinical study" 10

# Verify the best candidate
./scripts/crossref-verify-doi.sh "[candidate DOI]"

# Get the abstract to confirm it supports the claim
./scripts/semantic-scholar-fetch.sh "[candidate DOI]"
```

## Integration with Existing Commands

### review-sources-2-v3 Pipeline

The verification hierarchy (6 layers):

| Priority | Script | Best For |
|----------|--------|----------|
| 1st | `pubmed-verify-doi.sh` | Biomedical literature (~70%) |
| 2nd | `crossref-verify-doi.sh` | All disciplines with DOI |
| 3rd | `semantic-scholar-fetch.sh` | Metadata + abstract when above lack it |
| 4th | WebFetch | Non-DOI URLs, publisher pages |
| 5th | Firecrawl | JS-heavy/blocking sites |
| 6th | `scihub-fetch.sh` | Last resort for paywalled content |

### review-claims-3-v3 Pipeline

For abstract retrieval:

| Priority | Script | Returns |
|----------|--------|---------|
| 1st | `pubmed-fetch.sh` | Structured abstract |
| 2nd | `semantic-scholar-fetch.sh` | Abstract + TLDR |
| 3rd | `unpaywall-find-pdf.sh` | Legal full-text PDF URL |
| 4th | WebFetch / Firecrawl | Parsed page content |
| 5th | `scihub-fetch.sh` | Full-text PDF URL |

## Rate Limits

| API | Limit | Notes |
|-----|-------|-------|
| CrossRef | ~50 req/sec (polite pool) | Email in User-Agent gets polite pool |
| Semantic Scholar | 100 req/5 min | Add 3s delay for batch processing |
| Unpaywall | 100K req/day | Email required in query param |
| Sci-Hub | No documented limits | Mirrors may be slow or unavailable |

For typical draft verification (12-15 citations), all APIs are well within limits.

## Notes

- CrossRef has abstracts for only ~15-20% of papers — use Semantic Scholar for abstract-based verification
- Semantic Scholar's TLDR field provides a machine-generated one-sentence summary — very efficient for quick relevance checks
- Unpaywall only works with DOIs — non-DOI sources must use other methods
- Sci-Hub mirrors change over time — update the mirror list in `scihub-fetch.sh` if all mirrors fail
