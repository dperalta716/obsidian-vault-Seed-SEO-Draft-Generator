---
name: gemini-file-search-seed-reference
description: This skill should be used when semantic search across Seed's Reference materials is needed, particularly when files to consult are unclear, information spans multiple files, or token efficiency is critical. Use for draft review, compliance checking, cross-product research, or finding claims/messaging without knowing specific filenames. Provides query patterns, metadata filtering, and guidance on when to use File Search vs. direct file access.
---

# Gemini File Search - Seed Reference Materials

## Overview

Access Seed's Reference materials (62 files: Claims, NPD Messaging, Compliance, SciComms, Style guides) via semantic search using Google's Gemini File Search API. This provides 60-80% token reduction compared to loading all files directly, while enabling intelligent search by meaning rather than filename.

**Store ID**: `fileSearchStores/seed-reference-materials-pr-jma5jhay17is`
**Contents**: 685 KB across 49 Claims files, 3 Messaging docs, 3 SciComms files, 2 Compliance files, 5 Style guides

## When to Use This Skill

### Use File Search When:

✅ **Uncertain which files contain needed information**
  - Example: "What does Seed say about gut-brain axis?" (might be in multiple files)

✅ **Information spans multiple files**
  - Example: "Compare PQQ benefits across AM-02, DM-02, and PM-02"

✅ **Semantic search needed** (search by meaning, not filename)
  - Example: "What compliance rules apply to energy claims?" (don't need to know exact file)

✅ **Approaching context limits** (token efficiency matters)
  - File Search uses 60-80% fewer tokens than loading all files

✅ **Draft review or validation**
  - Check claims against approved language
  - Verify compliance with NO-NO words
  - Validate product positioning accuracy

✅ **Cross-product research**
  - Comparing ingredients across products
  - Finding all mentions of a topic

### Use Direct File Access Instead When:

❌ You know exactly which file you need (e.g., "Read DM-02-Biotin-Claims.md")
❌ You need only 1-3 specific files (low token cost)
❌ You need FULL file content, not excerpts
❌ You need deterministic results every time
❌ You're doing initial research to understand file structure

## Core Capabilities

### 1. Semantic Query with Metadata Filtering

Query the File Search store using natural language with optional metadata filters to narrow results.

**Query Script**: `scripts/query-store.sh`

**Basic Usage**:
```bash
./scripts/query-store.sh "Your natural language query here"
```

**With Metadata Filter**:
```bash
./scripts/query-store.sh "Your query" "product=DM-02 AND file_type=Ingredient-Claims"
```

**Metadata Fields Available**:
- `category`: Claims, NPD-Messaging, SciComms, Compliance, Style
- `product`: AM-02, DM-02, PM-02, Cross-Product, N/A
- `file_type`: Ingredient-Claims, General-Claims, Formula, Messaging, Education, Compliance, Tone-Guide, Sample-Articles, Other
- `relative_path`: Full path from Reference/ directory

### 2. Common Query Patterns

#### Pattern 1: Ingredient-Specific Claims
**Use Case**: Find approved health claims for a specific ingredient

**Example**:
```bash
./scripts/query-store.sh "What are approved claims about biotin for hair and nails?" "product=DM-02 AND file_type=Ingredient-Claims"
```

**Filter**: `file_type=Ingredient-Claims` (optionally add product filter)

#### Pattern 2: Product Positioning
**Use Case**: Understand Seed's unique angle for a product

**Example**:
```bash
./scripts/query-store.sh "What is Seed's unique positioning for PM-02 sleep product?" "product=PM-02 AND category=NPD-Messaging"
```

**Filter**: `category=NPD-Messaging` + specific product

#### Pattern 3: Compliance Checking
**Use Case**: Find words to avoid or compliance rules

**Example**:
```bash
./scripts/query-store.sh "What words should we avoid in Seed content?" "category=Compliance"
```

**Filter**: `category=Compliance`

#### Pattern 4: Cross-Product Comparisons
**Use Case**: Compare an ingredient across multiple products

**Example**:
```bash
# Query each product separately
./scripts/query-store.sh "PQQ benefits" "product=AM-02 AND file_type=Ingredient-Claims"
./scripts/query-store.sh "PQQ benefits" "product=DM-02 AND file_type=Ingredient-Claims"
./scripts/query-store.sh "PQQ benefits" "product=PM-02 AND file_type=Ingredient-Claims"
```

**Filter**: `file_type=Ingredient-Claims` (no product filter for broad search)

#### Pattern 5: Tone and Style Guidance
**Use Case**: Understand how to write Seed content

**Example**:
```bash
./scripts/query-store.sh "How should Seed content be written? What's the brand voice?" "category=Style"
```

**Filter**: `category=Style` or `file_type=Tone-Guide`

#### Pattern 6: Broad Topic Search
**Use Case**: Find all relevant information on a topic

**Example**:
```bash
./scripts/query-store.sh "What does Seed say about mitochondrial health?"
```

**Filter**: None (semantic search across all files)

### 3. Metadata Filter Syntax

**Single Condition**:
```
product=DM-02
```

**Multiple Conditions (AND)**:
```
product=DM-02 AND file_type=Ingredient-Claims
category=Claims AND product=PM-02
```

**Common Filters**:
```
# All DM-02 materials
product=DM-02

# All claims files (any product)
category=Claims

# Compliance rules only
category=Compliance

# PM-02 messaging
product=PM-02 AND category=NPD-Messaging

# Ingredient claims for AM-02
product=AM-02 AND file_type=Ingredient-Claims
```

### 4. Interpreting Results

Query results include:
1. **Synthesized Answer**: Natural language summary generated by Gemini
2. **Sources Used**: List of source files consulted
3. **✨ Detailed Source Excerpts**: Full markdown chunks with study links, claims, doses, and citations

**Script Output** (formatted):
```
=== Query Results ===

=== Answer ===
[Gemini's synthesized natural language answer to your query]

=== Sources Used ===
Used 3 source chunk(s)

• DM-02-Biotin-Claims.md
• DM-02-Zinc-Claims.md
• PM-02-General-Claims.md

=== Detailed Source Excerpts (with Study Links & Citations) ===

=== Source Chunk 1 ===
Source File: DM-02-Biotin-Claims.md

## Study 4: EFSA Health Claims
**Link**: https://ec.europa.eu/food/food-feed-portal/screen/health-claims/eu-register

### Claims
✅ Contributes to the maintenance of normal hair
✅ Contributes to the maintenance of normal skin and mucous membranes

### Study Dose
N/A

### Dose Matched
Yes

### Support for Claim
High

### Notes/Caveats
None specified

────────────────────────────────────────────────────────────────

[Additional source chunks follow...]
```

**What You Get for Article Writing**:
- ✅ **Study names** ("Study 4: EFSA Health Claims")
- ✅ **Direct study links** (ready for citations)
- ✅ **Specific approved claims** (compliance-ready language)
- ✅ **Study doses** (for dose-matching validation)
- ✅ **Support levels** (High/Medium/Low)
- ✅ **Important caveats** (compliance warnings, study limitations)
- ✅ **Product information** (dose, % DV)

**Using for Citations**:
```markdown
# In-line citation
Biotin contributes to the maintenance of normal hair ([EFSA Health Claims](https://ec.europa.eu/food/food-feed-portal/screen/health-claims/eu-register)).

# Reference list
1. European Food Safety Authority. (n.d.). EU Register of Health Claims.
   Retrieved from https://ec.europa.eu/food/food-feed-portal/screen/health-claims/eu-register
```

## Detailed Reference

For comprehensive information including:
- Complete file inventory (all 62 files)
- Detailed metadata structure
- All query pattern examples
- Cost and performance metrics
- Troubleshooting guide
- When to use File Search vs. direct access

**See**: `references/store-reference.md`

Load this reference file when deeper understanding is needed or when crafting complex queries with metadata filters.

## Quick Reference

**Store Location**: `/dev/active/reference-store-setup/REFERENCE_STORE_ID`
**API Key**: `~/.claude/skills/gemini-api-key`
**Full Docs**: `/dev/active/reference-store-setup/STORE_SUMMARY.md`

**Query Cost**: ~$0.01-0.02 per query
**Token Savings**: 60-80% vs. loading all files
**Query Speed**: 1-3 seconds

## Tips for Effective Queries

1. **Be specific**: "What are approved claims about biotin for hair?" vs. "Tell me about biotin"

2. **Use metadata filters**: Narrow down to relevant files for better, focused results

3. **Multiple queries for comparisons**: Query each product separately for cross-product research

4. **Natural language**: Ask questions naturally - semantic search understands meaning

5. **Iterate**: If first query doesn't return what you need, refine with more specific language or different filters

6. **Check sources**: Always review the source files in grounding metadata to verify context

## Resources

### scripts/
- `query-store.sh` - Query the File Search store with natural language and metadata filters

### references/
- `store-reference.md` - Comprehensive documentation including all query patterns, metadata field values, file inventory, and troubleshooting guidance
