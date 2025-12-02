#!/bin/bash
# pubmed-search.sh - Search PubMed for articles matching a query
# Uses NCBI E-utilities (free, no API key required for moderate use)
#
# Usage: ./pubmed-search.sh "search query" [max_results] [sort]
#   search query: PubMed search terms (required)
#   max_results: Number of results to return (default: 10, max: 100)
#   sort: Sort order - "relevance" or "date" (default: relevance)
#
# Example: ./pubmed-search.sh "probiotics weight loss" 5 relevance
#
# Returns: JSON with PMIDs and article summaries

QUERY="$1"
MAX_RESULTS="${2:-10}"
SORT="${3:-relevance}"

if [ -z "$QUERY" ]; then
    echo "Error: Search query required"
    echo "Usage: ./pubmed-search.sh \"search query\" [max_results] [sort]"
    exit 1
fi

# Cap max results at 100
if [ "$MAX_RESULTS" -gt 100 ]; then
    MAX_RESULTS=100
fi

# URL encode the query
ENCODED_QUERY=$(python3 -c "import urllib.parse; print(urllib.parse.quote('''$QUERY'''))")

# Set sort parameter
if [ "$SORT" = "date" ]; then
    SORT_PARAM="pub+date"
else
    SORT_PARAM="relevance"
fi

# Step 1: Search for PMIDs using ESearch
SEARCH_URL="https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term=${ENCODED_QUERY}&retmax=${MAX_RESULTS}&sort=${SORT_PARAM}&retmode=json&tool=claude-code-skill&email=api@claude.ai"

SEARCH_RESULT=$(curl -s "$SEARCH_URL")

# Extract PMIDs from search result
PMIDS=$(echo "$SEARCH_RESULT" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    ids = data.get('esearchresult', {}).get('idlist', [])
    print(','.join(ids))
except:
    print('')
")

if [ -z "$PMIDS" ]; then
    echo '{"error": "No results found", "query": "'"$QUERY"'", "results": []}'
    exit 0
fi

# Step 2: Fetch article summaries using ESummary
SUMMARY_URL="https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?db=pubmed&id=${PMIDS}&retmode=json&tool=claude-code-skill&email=api@claude.ai"

SUMMARY_RESULT=$(curl -s "$SUMMARY_URL")

# Parse and format the results
echo "$SUMMARY_RESULT" | python3 -c "
import sys, json

try:
    data = json.load(sys.stdin)
    results = data.get('result', {})
    uids = results.get('uids', [])

    articles = []
    for uid in uids:
        article = results.get(uid, {})
        if isinstance(article, dict):
            # Extract authors
            authors = article.get('authors', [])
            author_names = [a.get('name', '') for a in authors[:3]]
            first_author = authors[0].get('name', '').split()[0] if authors else 'Unknown'

            # Extract DOI from articleids
            doi = ''
            for aid in article.get('articleids', []):
                if aid.get('idtype') == 'doi':
                    doi = aid.get('value', '')
                    break

            articles.append({
                'pmid': uid,
                'title': article.get('title', ''),
                'authors': ', '.join(author_names) + (' et al.' if len(authors) > 3 else ''),
                'first_author': first_author,
                'journal': article.get('source', ''),
                'pub_date': article.get('pubdate', ''),
                'doi': doi,
                'doi_url': f'https://doi.org/{doi}' if doi else '',
                'pubmed_url': f'https://pubmed.ncbi.nlm.nih.gov/{uid}/'
            })

    output = {
        'query': '''$QUERY''',
        'count': len(articles),
        'results': articles
    }
    print(json.dumps(output, indent=2))
except Exception as e:
    print(json.dumps({'error': str(e), 'query': '''$QUERY''', 'results': []}))
"
