---
name: pubmed-research
description: Search and verify biomedical literature via PubMed/NCBI E-utilities API. Use when verifying DOI citations, searching for academic sources on health/medical topics, fetching article abstracts, or finding replacement citations. Covers 36M+ biomedical articles. Ideal for SEO content citation verification, source discovery, and claims substantiation workflows.
---

# PubMed Research Skill

Access PubMed's 36M+ biomedical citations via NCBI E-utilities API. Free, no API key required.

## Scripts

All scripts are in `scripts/` directory. Execute with full path:
```bash
/Users/david/Documents/Obsidian Vaults/claude-code-demo/Seed-SEO-Draft-Generator-v4/.claude/skills/pubmed-research/scripts/[script-name].sh
```

### pubmed-search.sh

Search PubMed for articles matching a query.

```bash
./scripts/pubmed-search.sh "search query" [max_results] [sort]
```

- `max_results`: 1-100 (default: 10)
- `sort`: "relevance" or "date" (default: relevance)

**Returns**: JSON with PMIDs, titles, authors, DOIs, publication dates.

**Example**:
```bash
./scripts/pubmed-search.sh "probiotics gut microbiome meta-analysis" 5 relevance
```

### pubmed-fetch.sh

Fetch detailed article info including abstract by PMID.

```bash
./scripts/pubmed-fetch.sh <pmid>
```

**Accepts**: Single PMID or comma-separated list.

**Returns**: JSON with title, abstract, authors, journal, DOI, PMC ID, URLs.

**Example**:
```bash
./scripts/pubmed-fetch.sh 31412048
./scripts/pubmed-fetch.sh "31412048,30054559,29858877"
```

### pubmed-verify-doi.sh

Verify a DOI exists and retrieve its PubMed metadata.

```bash
./scripts/pubmed-verify-doi.sh <doi>
```

**Accepts**: DOI with or without `https://doi.org/` prefix.

**Returns**: JSON with verification status, article metadata, and formatted citation.

**Status values**:
- `VERIFIED`: DOI found in PubMed with full metadata
- `DOI exists but not indexed in PubMed`: DOI resolves but not in PubMed
- `DOI NOT FOUND`: Invalid DOI

**Example**:
```bash
./scripts/pubmed-verify-doi.sh "10.3390/nu11092048"
./scripts/pubmed-verify-doi.sh "https://doi.org/10.1038/nrgastro.2014.66"
```

## Common Workflows

### Citation Verification

Verify a citation from a draft article:
```bash
# Check if DOI is valid and get correct metadata
./scripts/pubmed-verify-doi.sh "10.3390/nu11092048"

# Response includes:
# - verified: true/false
# - title: Actual article title (compare with claimed title)
# - first_author: For citation format
# - pub_year: For citation format
# - citation_format: "(Author Year)" ready to use
# - citation_with_link: Full markdown link format
```

### Finding Replacement Sources

When a citation is wrong, find alternatives:
```bash
# Search for articles on the same topic
./scripts/pubmed-search.sh "probiotics IBS systematic review" 10 relevance

# Get full details including abstract for a promising result
./scripts/pubmed-fetch.sh 31412048
```

### Claims Verification

Verify a claim against source abstract:
```bash
# Get the abstract to check if it supports the claim
./scripts/pubmed-fetch.sh 31412048

# Abstract returned in response - compare claim text against it
```

## Search Tips

### Effective PubMed Queries

- Use quotes for exact phrases: `"irritable bowel syndrome"`
- Combine with AND: `probiotics AND "weight loss"`
- Filter by type: `"meta-analysis"[pt]` or `"review"[pt]`
- Author search: `Smith J[au]`
- Date range: `2020:2024[dp]`

### Example Searches

```bash
# Find meta-analyses on probiotics and IBS
./scripts/pubmed-search.sh "probiotics IBS meta-analysis" 10 date

# Find recent reviews on gut-brain axis
./scripts/pubmed-search.sh "gut brain axis review 2023" 10 relevance

# Search by author
./scripts/pubmed-search.sh "Gevers D[au] microbiome" 5
```

## Output Fields

### Search Results
- `pmid`: PubMed ID
- `title`: Article title
- `authors`: Author list (first 3 + "et al.")
- `first_author`: Last name only (for citations)
- `journal`: Journal name
- `pub_date`: Publication date
- `doi`: DOI identifier
- `doi_url`: Full DOI URL
- `pubmed_url`: PubMed page URL

### Fetch Results (adds)
- `abstract`: Full abstract text
- `pub_year`: Publication year
- `pmc`: PubMed Central ID (if available)
- `pmc_url`: PMC full-text URL (if available)
- `citation_short`: Formatted "(Author Year)"

### Verify Results (adds)
- `verified`: true/false
- `status`: Verification status message
- `citation_format`: "(Author Year)"
- `citation_with_link`: Full markdown citation

## Rate Limits

NCBI allows 3 requests/second without API key. Scripts include tool/email parameters as required by NCBI guidelines. For batch processing, add 0.5s delays between calls.

## Integration Notes

This skill replaces WebFetch/Firecrawl for DOI verification when the source is biomedical literature. Benefits:
- Structured JSON response (no HTML parsing)
- Consistent metadata format
- Direct abstract access
- Verification status built-in
- ~70% of SEO health content citations are PubMed-indexed
