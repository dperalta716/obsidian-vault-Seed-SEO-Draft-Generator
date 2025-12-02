#!/bin/bash
# pubmed-verify-doi.sh - Verify a DOI exists and get its PubMed metadata
# Useful for citation verification workflows
#
# Usage: ./pubmed-verify-doi.sh <doi>
#   doi: DOI to verify (required) - with or without https://doi.org/ prefix
#
# Example: ./pubmed-verify-doi.sh "10.3390/nu11092048"
# Example: ./pubmed-verify-doi.sh "https://doi.org/10.3390/nu11092048"
#
# Returns: JSON with verification status and article metadata if found

DOI="$1"

if [ -z "$DOI" ]; then
    echo "Error: DOI required"
    echo "Usage: ./pubmed-verify-doi.sh <doi>"
    exit 1
fi

# Clean up DOI - remove https://doi.org/ prefix if present
CLEAN_DOI=$(echo "$DOI" | sed 's|https://doi.org/||' | sed 's|http://doi.org/||' | sed 's|doi.org/||')

# URL encode the DOI for search (including the [doi] tag)
SEARCH_TERM="${CLEAN_DOI}[doi]"
ENCODED_TERM=$(python3 -c "import urllib.parse; print(urllib.parse.quote('''$SEARCH_TERM'''))")

# Search PubMed for this DOI
SEARCH_URL="https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term=${ENCODED_TERM}&retmode=json&tool=claude-code-skill&email=api@claude.ai"

SEARCH_RESULT=$(curl -s "$SEARCH_URL")

# Extract PMID
PMID=$(echo "$SEARCH_RESULT" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    ids = data.get('esearchresult', {}).get('idlist', [])
    print(ids[0] if ids else '')
except:
    print('')
")

if [ -z "$PMID" ]; then
    # DOI not found in PubMed - check if DOI exists at all via doi.org API
    # Use doi.org's content negotiation to check if DOI is registered
    DOI_CHECK=$(curl -s -H "Accept: application/json" "https://doi.org/api/handles/$CLEAN_DOI" 2>/dev/null)
    DOI_EXISTS=$(echo "$DOI_CHECK" | python3 -c "import sys,json; d=json.load(sys.stdin); print('yes' if d.get('responseCode')==1 else 'no')" 2>/dev/null || echo "no")

    if [ "$DOI_EXISTS" = "yes" ]; then
        echo '{
  "verified": false,
  "doi": "'"$CLEAN_DOI"'",
  "doi_url": "https://doi.org/'"$CLEAN_DOI"'",
  "status": "DOI exists but not indexed in PubMed",
  "note": "This DOI resolves but is not in the PubMed database. It may be from a non-biomedical journal or too recent.",
  "pmid": null
}'
    else
        echo '{
  "verified": false,
  "doi": "'"$CLEAN_DOI"'",
  "doi_url": "https://doi.org/'"$CLEAN_DOI"'",
  "status": "DOI NOT FOUND",
  "note": "This DOI does not exist in the DOI system. The citation may have an incorrect DOI.",
  "pmid": null
}'
    fi
    exit 0
fi

# DOI found - fetch full article details
FETCH_URL="https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=${PMID}&rettype=abstract&retmode=xml&tool=claude-code-skill&email=api@claude.ai"

FETCH_RESULT=$(curl -s "$FETCH_URL")

# Parse and return verification result with article details
echo "$FETCH_RESULT" | python3 -c "
import sys
import xml.etree.ElementTree as ET
import json

def extract_text(element, default=''):
    if element is not None:
        return ''.join(element.itertext()).strip()
    return default

try:
    xml_content = sys.stdin.read()
    root = ET.fromstring(xml_content)

    article = root.find('.//PubmedArticle')
    if article is None:
        print(json.dumps({'verified': False, 'error': 'Could not parse article data'}))
        sys.exit(0)

    result = {
        'verified': True,
        'doi': '''$CLEAN_DOI''',
        'doi_url': 'https://doi.org/$CLEAN_DOI',
        'status': 'VERIFIED',
        'pmid': '''$PMID''',
        'pubmed_url': 'https://pubmed.ncbi.nlm.nih.gov/$PMID/'
    }

    # Get article metadata
    medline = article.find('.//MedlineCitation')
    art = medline.find('.//Article') if medline is not None else None

    if art is not None:
        # Title
        title = art.find('.//ArticleTitle')
        result['title'] = extract_text(title)

        # Authors
        authors = []
        author_list = art.find('.//AuthorList')
        if author_list is not None:
            for author in author_list.findall('.//Author'):
                lastname = extract_text(author.find('LastName'))
                initials = extract_text(author.find('Initials'))
                if lastname:
                    authors.append(f'{lastname} {initials}'.strip())

        result['authors'] = authors
        result['first_author'] = authors[0].split()[0] if authors else 'Unknown'

        # Journal and year
        journal = art.find('.//Journal')
        if journal is not None:
            result['journal'] = extract_text(journal.find('.//Title'))
            pub_date = journal.find('.//PubDate')
            if pub_date is not None:
                result['pub_year'] = extract_text(pub_date.find('Year'))

        # Citation format for verification
        if result.get('pub_year') and result.get('first_author'):
            result['citation_format'] = f\"({result['first_author']} {result['pub_year']})\"
            result['citation_with_link'] = f\"([{result['first_author']} {result['pub_year']}](https://doi.org/$CLEAN_DOI))\"

    print(json.dumps(result, indent=2))

except Exception as e:
    print(json.dumps({'verified': False, 'error': str(e), 'doi': '''$CLEAN_DOI'''}))
"
