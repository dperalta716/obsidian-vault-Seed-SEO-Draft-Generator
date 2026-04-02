#!/bin/bash
# crossref-verify-doi.sh - Verify a DOI exists and get metadata via CrossRef
# Covers ALL academic disciplines (not just biomedical like PubMed)
# Use as fallback when PubMed returns "DOI exists but not indexed"
#
# Usage: ./crossref-verify-doi.sh <doi>
#   doi: DOI to verify (required) - with or without https://doi.org/ prefix
#
# Example: ./crossref-verify-doi.sh "10.3390/nu11092048"
# Example: ./crossref-verify-doi.sh "https://doi.org/10.1038/nrgastro.2014.66"
#
# Returns: JSON with verification status and article metadata

DOI="$1"

if [ -z "$DOI" ]; then
    echo "Error: DOI required"
    echo "Usage: ./crossref-verify-doi.sh <doi>"
    exit 1
fi

# Load shared config (email for polite pool)
source "$(dirname "$0")/config.sh"

# Clean up DOI - remove prefix
CLEAN_DOI=$(echo "$DOI" | sed 's|https://doi.org/||' | sed 's|http://doi.org/||' | sed 's|doi.org/||')

# URL encode the DOI
ENCODED_DOI=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$CLEAN_DOI', safe=''))")

# Query CrossRef API with polite User-Agent (gets better rate limits)
RESULT=$(curl -s -w "\n%{http_code}" \
    -H "User-Agent: AcademicPaperResearch/1.0 (mailto:${CONTACT_EMAIL})" \
    "https://api.crossref.org/works/$ENCODED_DOI")

# Split response and status code
HTTP_CODE=$(echo "$RESULT" | tail -1)
BODY=$(echo "$RESULT" | sed '$d')

if [ "$HTTP_CODE" != "200" ]; then
    echo '{
  "verified": false,
  "doi": "'"$CLEAN_DOI"'",
  "doi_url": "https://doi.org/'"$CLEAN_DOI"'",
  "status": "DOI NOT FOUND",
  "note": "This DOI was not found in the CrossRef registry."
}'
    exit 0
fi

# Parse CrossRef JSON response
echo "$BODY" | python3 -c "
import sys, json

try:
    data = json.load(sys.stdin)
    msg = data.get('message', {})

    # Extract title
    titles = msg.get('title', [])
    title = titles[0] if titles else 'Unknown'

    # Extract authors
    authors_raw = msg.get('author', [])
    authors = []
    for a in authors_raw[:3]:
        family = a.get('family', '')
        given = a.get('given', '')
        if family:
            initials = ''.join([n[0] for n in given.split() if n]) if given else ''
            authors.append(f'{family} {initials}'.strip())
    if len(authors_raw) > 3:
        authors.append('et al.')

    first_author = authors_raw[0].get('family', 'Unknown') if authors_raw else 'Unknown'

    # Extract year
    date_parts = msg.get('published-print', msg.get('published-online', msg.get('created', {})))
    year_parts = date_parts.get('date-parts', [[None]])[0] if date_parts else [None]
    pub_year = str(year_parts[0]) if year_parts and year_parts[0] else 'Unknown'

    # Extract journal
    container = msg.get('container-title', [])
    journal = container[0] if container else msg.get('publisher', 'Unknown')

    # Extract type and citation count
    pub_type = msg.get('type', 'unknown')
    citation_count = msg.get('is-referenced-by-count', 0)

    # Extract abstract (CrossRef has it for ~15-20% of papers)
    abstract = msg.get('abstract', None)
    if abstract:
        # Clean HTML tags from abstract
        import re
        abstract = re.sub(r'<[^>]+>', '', abstract).strip()

    doi = '$CLEAN_DOI'

    result = {
        'verified': True,
        'doi': doi,
        'doi_url': f'https://doi.org/{doi}',
        'status': 'VERIFIED',
        'title': title,
        'authors': authors,
        'first_author': first_author,
        'journal': journal,
        'pub_year': pub_year,
        'type': pub_type,
        'citation_count': citation_count,
        'citation_format': f'({first_author} {pub_year})',
        'citation_with_link': f'([{first_author} {pub_year}](https://doi.org/{doi}))'
    }

    if abstract:
        result['abstract'] = abstract

    print(json.dumps(result, indent=2))

except Exception as e:
    print(json.dumps({
        'verified': False,
        'doi': '$CLEAN_DOI',
        'error': str(e),
        'status': 'PARSE ERROR'
    }, indent=2))
"
