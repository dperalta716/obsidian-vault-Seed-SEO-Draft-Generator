#!/bin/bash
# semantic-scholar-search.sh - Search for papers via Semantic Scholar API
# Returns citation counts, open-access status, and abstracts inline
# Better relevance ranking than PubMed for many queries
#
# Usage: ./semantic-scholar-search.sh "search query" [max_results] [year_range]
#   search query: Free-text search (required)
#   max_results: 1-100 (default: 10)
#   year_range: e.g., "2020-2024" (optional)
#
# Example: ./semantic-scholar-search.sh "probiotics gut microbiome meta-analysis" 10 "2020-2024"
# Example: ./semantic-scholar-search.sh "ashwagandha cortisol" 5
#
# Returns: JSON with matching papers including citation counts and abstracts

QUERY="$1"
MAX_RESULTS="${2:-10}"
YEAR_RANGE="$3"

if [ -z "$QUERY" ]; then
    echo "Error: Search query required"
    echo "Usage: ./semantic-scholar-search.sh \"search query\" [max_results] [year_range]"
    exit 1
fi

# URL encode the query
ENCODED_QUERY=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$QUERY'))")

# Build URL with fields
FIELDS="title,authors,year,externalIds,abstract,citationCount,influentialCitationCount,isOpenAccess,openAccessPdf,journal"
URL="https://api.semanticscholar.org/graph/v1/paper/search?query=${ENCODED_QUERY}&limit=${MAX_RESULTS}&fields=${FIELDS}"

# Add year range if provided
if [ -n "$YEAR_RANGE" ]; then
    URL="${URL}&year=${YEAR_RANGE}"
fi

# Query Semantic Scholar API
RESULT=$(curl -s -w "\n%{http_code}" "$URL")

HTTP_CODE=$(echo "$RESULT" | tail -1)
BODY=$(echo "$RESULT" | sed '$d')

if [ "$HTTP_CODE" != "200" ]; then
    echo '{
  "error": "API request failed",
  "http_code": '"$HTTP_CODE"',
  "query": "'"$QUERY"'"
}'
    exit 0
fi

# Parse response
echo "$BODY" | python3 -c "
import sys, json

try:
    data = json.load(sys.stdin)
    total = data.get('total', 0)
    papers = data.get('data', [])

    results = []
    for p in papers:
        # Extract authors
        authors_raw = p.get('authors', [])
        author_names = [a.get('name', '') for a in authors_raw[:3]]
        if len(authors_raw) > 3:
            author_names.append('et al.')
        authors_str = ', '.join(author_names)

        first_author = authors_raw[0].get('name', 'Unknown').split()[-1] if authors_raw else 'Unknown'

        # Extract external IDs
        ext_ids = p.get('externalIds', {}) or {}
        doi = ext_ids.get('DOI', '')
        pmid = ext_ids.get('PubMed', '')

        # Extract journal
        journal_info = p.get('journal', {}) or {}
        journal = journal_info.get('name', '')

        # Open access PDF
        oa_pdf_info = p.get('openAccessPdf', {}) or {}
        oa_pdf = oa_pdf_info.get('url', '')

        year = p.get('year', None)

        result = {
            'paper_id': p.get('paperId', ''),
            'title': p.get('title', ''),
            'authors': authors_str,
            'first_author': first_author,
            'year': year,
            'doi': doi,
            'doi_url': f'https://doi.org/{doi}' if doi else '',
            'pmid': pmid,
            'pubmed_url': f'https://pubmed.ncbi.nlm.nih.gov/{pmid}/' if pmid else '',
            'citation_count': p.get('citationCount', 0),
            'influential_citations': p.get('influentialCitationCount', 0),
            'is_open_access': p.get('isOpenAccess', False),
            'open_access_pdf': oa_pdf,
            'journal': journal,
            'abstract': p.get('abstract', '')
        }

        if first_author and year:
            result['citation_format'] = f'({first_author} {year})'
            if doi:
                result['citation_with_link'] = f'([{first_author} {year}](https://doi.org/{doi}))'

        results.append(result)

    output = {
        'query': '$QUERY',
        'count': len(results),
        'total': total,
        'results': results
    }

    print(json.dumps(output, indent=2))

except Exception as e:
    print(json.dumps({
        'error': str(e),
        'query': '$QUERY'
    }, indent=2))
"
