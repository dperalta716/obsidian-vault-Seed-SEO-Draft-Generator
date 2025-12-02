#!/bin/bash
# pubmed-fetch.sh - Fetch detailed article info including abstract by PMID
# Uses NCBI E-utilities EFetch endpoint
#
# Usage: ./pubmed-fetch.sh <pmid> [format]
#   pmid: PubMed ID (required) - can be single ID or comma-separated list
#   format: Output format - "json" or "xml" (default: json)
#
# Example: ./pubmed-fetch.sh 12345678
# Example: ./pubmed-fetch.sh "12345678,23456789,34567890"
#
# Returns: JSON with full article details including abstract

PMID="$1"
FORMAT="${2:-json}"

if [ -z "$PMID" ]; then
    echo "Error: PMID required"
    echo "Usage: ./pubmed-fetch.sh <pmid> [format]"
    exit 1
fi

# Fetch article details using EFetch (returns XML, we'll parse to JSON)
FETCH_URL="https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=${PMID}&rettype=abstract&retmode=xml&tool=claude-code-skill&email=api@claude.ai"

FETCH_RESULT=$(curl -s "$FETCH_URL")

# Parse XML and convert to JSON
echo "$FETCH_RESULT" | python3 -c "
import sys
import xml.etree.ElementTree as ET
import json
import re

def extract_text(element, default=''):
    if element is not None:
        return ''.join(element.itertext()).strip()
    return default

def parse_article(article):
    result = {}

    # Get PMID
    pmid = article.find('.//PMID')
    result['pmid'] = extract_text(pmid)

    # Get article metadata
    medline = article.find('.//MedlineCitation')
    if medline is None:
        return result

    art = medline.find('.//Article')
    if art is None:
        return result

    # Title
    title = art.find('.//ArticleTitle')
    result['title'] = extract_text(title)

    # Abstract
    abstract = art.find('.//Abstract')
    if abstract is not None:
        abstract_texts = []
        for text in abstract.findall('.//AbstractText'):
            label = text.get('Label', '')
            content = extract_text(text)
            if label:
                abstract_texts.append(f'{label}: {content}')
            else:
                abstract_texts.append(content)
        result['abstract'] = ' '.join(abstract_texts)
    else:
        result['abstract'] = ''

    # Authors
    authors = []
    author_list = art.find('.//AuthorList')
    if author_list is not None:
        for author in author_list.findall('.//Author'):
            lastname = extract_text(author.find('LastName'))
            forename = extract_text(author.find('ForeName'))
            initials = extract_text(author.find('Initials'))
            if lastname:
                name = lastname
                if forename:
                    name = f'{lastname} {forename}'
                elif initials:
                    name = f'{lastname} {initials}'
                authors.append(name)
    result['authors'] = authors
    result['first_author'] = authors[0].split()[0] if authors else 'Unknown'

    # Journal
    journal = art.find('.//Journal')
    if journal is not None:
        result['journal'] = extract_text(journal.find('.//Title'))
        result['journal_abbrev'] = extract_text(journal.find('.//ISOAbbreviation'))

        # Publication date
        pub_date = journal.find('.//PubDate')
        if pub_date is not None:
            year = extract_text(pub_date.find('Year'))
            month = extract_text(pub_date.find('Month'))
            result['pub_year'] = year
            result['pub_date'] = f'{year} {month}'.strip()

    # DOI and other IDs
    result['doi'] = ''
    result['pmc'] = ''
    article_ids = article.find('.//PubmedData/ArticleIdList')
    if article_ids is not None:
        for aid in article_ids.findall('.//ArticleId'):
            id_type = aid.get('IdType', '')
            id_value = extract_text(aid)
            if id_type == 'doi':
                result['doi'] = id_value
            elif id_type == 'pmc':
                result['pmc'] = id_value

    # Build URLs
    result['pubmed_url'] = f\"https://pubmed.ncbi.nlm.nih.gov/{result['pmid']}/\"
    result['doi_url'] = f\"https://doi.org/{result['doi']}\" if result['doi'] else ''
    result['pmc_url'] = f\"https://pmc.ncbi.nlm.nih.gov/articles/{result['pmc']}/\" if result['pmc'] else ''

    # Citation format: (Author Year)
    if result.get('pub_year') and result.get('first_author'):
        result['citation_short'] = f\"({result['first_author']} {result['pub_year']})\"

    return result

try:
    xml_content = sys.stdin.read()
    root = ET.fromstring(xml_content)

    articles = []
    for article in root.findall('.//PubmedArticle'):
        parsed = parse_article(article)
        if parsed.get('pmid'):
            articles.append(parsed)

    if len(articles) == 1:
        print(json.dumps(articles[0], indent=2))
    else:
        print(json.dumps({'count': len(articles), 'articles': articles}, indent=2))

except Exception as e:
    print(json.dumps({'error': str(e)}))
"
