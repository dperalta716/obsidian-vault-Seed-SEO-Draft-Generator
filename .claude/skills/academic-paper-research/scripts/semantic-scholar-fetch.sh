#!/bin/bash
# semantic-scholar-fetch.sh - Fetch detailed paper info via Semantic Scholar
# Auto-detects identifier type (DOI, PMID, arXiv, S2 paper ID)
# Returns full abstract, TLDR summary, and citation graph metadata
#
# Usage: ./semantic-scholar-fetch.sh <identifier> [id_type]
#   identifier: DOI, PMID, arXiv ID, or Semantic Scholar paper ID (required)
#   id_type: "doi", "pmid", "arxiv", "s2" (optional, auto-detected)
#
# Example: ./semantic-scholar-fetch.sh "10.3390/nu11092048"
# Example: ./semantic-scholar-fetch.sh "31412048" "pmid"
# Example: ./semantic-scholar-fetch.sh "2103.15348" "arxiv"
#
# Returns: JSON with full metadata including abstract and TLDR

IDENTIFIER="$1"
ID_TYPE="$2"

if [ -z "$IDENTIFIER" ]; then
    echo "Error: Identifier required"
    echo "Usage: ./semantic-scholar-fetch.sh <identifier> [id_type]"
    exit 1
fi

# Clean DOI prefix if present
CLEAN_ID=$(echo "$IDENTIFIER" | sed 's|https://doi.org/||' | sed 's|http://doi.org/||' | sed 's|doi.org/||')

# Auto-detect identifier type if not provided
if [ -z "$ID_TYPE" ]; then
    ID_TYPE=$(python3 -c "
import re
id_val = '$CLEAN_ID'
if '/' in id_val and re.match(r'10\.\d{4,}/', id_val):
    print('doi')
elif id_val.isdigit():
    print('pmid')
elif re.match(r'\d{4}\.\d{4,5}', id_val):
    print('arxiv')
else:
    print('s2')
")
fi

# Build the API identifier prefix
case "$ID_TYPE" in
    doi)
        API_ID="DOI:$CLEAN_ID"
        ;;
    pmid)
        API_ID="PMID:$CLEAN_ID"
        ;;
    arxiv)
        API_ID="ArXiv:$CLEAN_ID"
        ;;
    s2)
        API_ID="$CLEAN_ID"
        ;;
    *)
        API_ID="$CLEAN_ID"
        ;;
esac

# URL encode the identifier (preserve : and / which S2 expects in prefixed IDs)
ENCODED_ID=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$API_ID', safe=':/'))")

# Request fields
FIELDS="title,authors,year,abstract,externalIds,citationCount,influentialCitationCount,isOpenAccess,openAccessPdf,journal,publicationTypes,tldr,referenceCount,citationCount"

# Query Semantic Scholar API
RESULT=$(curl -s -w "\n%{http_code}" \
    "https://api.semanticscholar.org/graph/v1/paper/${ENCODED_ID}?fields=${FIELDS}")

HTTP_CODE=$(echo "$RESULT" | tail -1)
BODY=$(echo "$RESULT" | sed '$d')

if [ "$HTTP_CODE" != "200" ]; then
    echo '{
  "found": false,
  "identifier": "'"$CLEAN_ID"'",
  "id_type": "'"$ID_TYPE"'",
  "error": "Paper not found in Semantic Scholar",
  "http_code": '"$HTTP_CODE"'
}'
    exit 0
fi

# Parse response
echo "$BODY" | python3 -c "
import sys, json

try:
    p = json.load(sys.stdin)

    # Extract authors
    authors_raw = p.get('authors', [])
    author_names = [a.get('name', '') for a in authors_raw[:5]]
    if len(authors_raw) > 5:
        author_names.append('et al.')

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

    # TLDR
    tldr_info = p.get('tldr', {}) or {}
    tldr = tldr_info.get('text', '')

    year = p.get('year', None)

    result = {
        'found': True,
        'paper_id': p.get('paperId', ''),
        'title': p.get('title', ''),
        'abstract': p.get('abstract', ''),
        'tldr': tldr,
        'authors': author_names,
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
        'publication_types': p.get('publicationTypes', []),
        'references_count': p.get('referenceCount', 0)
    }

    if first_author and year:
        result['citation_short'] = f'({first_author} {year})'
        if doi:
            result['citation_with_link'] = f'([{first_author} {year}](https://doi.org/{doi}))'

    print(json.dumps(result, indent=2))

except Exception as e:
    print(json.dumps({
        'found': False,
        'identifier': '$CLEAN_ID',
        'error': str(e)
    }, indent=2))
"
