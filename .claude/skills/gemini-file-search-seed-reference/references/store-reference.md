# Seed Reference Materials File Search Store - Reference

**Store ID**: `fileSearchStores/seed-reference-materials-pr-jma5jhay17is`
**Contents**: 62 markdown files from Seed's Reference folder
**Size**: 685 KB
**Status**: Production Ready

---

## Store Contents

### By Category (62 files total)

| Category | Count | Description |
|----------|-------|-------------|
| **Claims** | 49 | Ingredient claims, general claims, formulations |
| **NPD-Messaging** | 3 | Product positioning documents |
| **SciComms** | 3 | Scientific communication materials |
| **Compliance** | 2 | NO-NO words and compliance rules |
| **Style** | 5 | Tone guides and sample articles |

### By Product

| Product | Count | Description |
|---------|-------|-------------|
| **AM-02** | 16 | Focus + Energy formulation |
| **DM-02** | 26 | Daily Multivitamin formulation |
| **PM-02** | 13 | Sleep + Restore formulation |
| **Cross-Product** | 1 | General cross-product claims |
| **N/A** | 6 | Compliance, Style guides |

### By File Type

| Type | Count | Examples |
|------|-------|----------|
| **Ingredient-Claims** | 41 | Biotin, PQQ, Melatonin claims |
| **General-Claims** | 3 | AM-02, DM-02, PM-02 general claims |
| **Formula** | 2 | PM-02 formulation docs |
| **Messaging** | 3 | Product positioning |
| **Education** | 2 | SciComms education |
| **Compliance** | 2 | NO-NO-WORDS, compliance rules |
| **Tone-Guide** | 4 | Writing tone and voice |
| **Sample-Articles** | 1 | Reference blog examples |
| **Other** | 4 | Miscellaneous |

---

## Metadata Structure

Every file has 4 metadata fields for filtering:

```json
{
  "category": "Claims|NPD-Messaging|SciComms|Compliance|Style",
  "product": "AM-02|DM-02|PM-02|Cross-Product|N/A",
  "file_type": "Ingredient-Claims|General-Claims|Formula|Messaging|Education|Compliance|Tone-Guide|Sample-Articles|Other",
  "relative_path": "path/from/Reference/directory.md"
}
```

### Metadata Field Values

**category**:
- `Claims` - Health claims and clinical evidence
- `NPD-Messaging` - Product positioning and messaging
- `SciComms` - Scientific communication materials
- `Compliance` - Compliance rules and restrictions
- `Style` - Tone guides and writing examples

**product**:
- `AM-02` - Focus + Energy product
- `DM-02` - Daily Multivitamin product
- `PM-02` - Sleep + Restore product
- `Cross-Product` - Applies to multiple products
- `N/A` - Not product-specific

**file_type**:
- `Ingredient-Claims` - Specific ingredient claims (e.g., Biotin, PQQ)
- `General-Claims` - Product-level general claims
- `Formula` - Formulation overviews
- `Messaging` - Product positioning documents
- `Education` - SciComms education materials
- `Compliance` - Compliance restrictions
- `Tone-Guide` - Writing tone and voice guidance
- `Sample-Articles` - Example blog articles
- `Other` - Miscellaneous

---

## Query Patterns

### Pattern 1: Ingredient-Specific Claims

**Goal**: Find approved claims for a specific ingredient

**Example Queries**:
- "What are approved health claims for biotin?"
- "Tell me about PQQ benefits in AM-02"
- "What does melatonin do for sleep quality?"

**Recommended Filter**: `file_type=Ingredient-Claims`

**With Product**: `product=DM-02 AND file_type=Ingredient-Claims`

### Pattern 2: Product Positioning

**Goal**: Understand Seed's unique angle for a product

**Example Queries**:
- "What is Seed's unique positioning for PM-02?"
- "How does Seed differentiate AM-02 from competitors?"
- "What's the messaging strategy for DM-02?"

**Recommended Filter**: `category=NPD-Messaging`

**Specific Product**: `product=PM-02 AND category=NPD-Messaging`

### Pattern 3: Compliance Checking

**Goal**: Find what words/phrases to avoid or compliance rules

**Example Queries**:
- "What words should we avoid in Seed content?"
- "What are the compliance rules for supplement claims?"
- "Can we say 'cure' or 'treat'?"

**Recommended Filter**: `category=Compliance`

### Pattern 4: Cross-Product Comparisons

**Goal**: Compare an ingredient across multiple products

**Example Queries**:
- "Compare PQQ benefits in AM-02 vs DM-02 vs PM-02"
- "How is GABA used differently in AM-02 vs PM-02?"
- "What products contain CoQ10 and why?"

**Recommended Filter**: `file_type=Ingredient-Claims` (no product filter)

### Pattern 5: Tone and Style Guidance

**Goal**: Understand how to write Seed content

**Example Queries**:
- "How should Seed content be written?"
- "What's the brand voice for Seed?"
- "Show me example Seed blog articles"

**Recommended Filter**: `category=Style`

**Specific Type**: `file_type=Tone-Guide` or `file_type=Sample-Articles`

### Pattern 6: Broad Topic Search

**Goal**: Find all relevant information on a topic

**Example Queries**:
- "What does Seed say about gut-brain axis?"
- "Tell me about mitochondrial health across products"
- "How does Seed talk about energy and fatigue?"

**Recommended Filter**: None (semantic search across all files)

---

## Metadata Filter Syntax

**Single Condition**:
```
product=DM-02
```

**AND Conditions**:
```
product=DM-02 AND file_type=Ingredient-Claims
```

**OR Conditions** (use multiple queries instead):
```
Query 1: product=AM-02
Query 2: product=DM-02
```

**Common Combinations**:
```
# Biotin claims for DM-02
product=DM-02 AND file_type=Ingredient-Claims

# PM-02 product messaging
product=PM-02 AND category=NPD-Messaging

# All claims files (any product)
category=Claims

# All AM-02 materials
product=AM-02

# Compliance rules only
category=Compliance
```

---

## Cost and Performance

**Query Cost**: ~$0.01-0.02 per query (minimal)
**Query Speed**: 1-3 seconds
**Token Savings**: 60-80% vs. loading all Reference files
**Storage**: FREE (685 KB well under 1 GB limit)

**Break-even Point**: After 4-5 queries, File Search is cheaper than loading all files directly

---

## File Locations

**Store ID**: Saved in `/dev/active/reference-store-setup/REFERENCE_STORE_ID`

**API Key**: `~/.claude/skills/gemini-api-key`

**Full Documentation**: `/dev/active/reference-store-setup/STORE_SUMMARY.md`

**Query Script**: `.claude/skills/gemini-file-search-seed-reference/scripts/query-store.sh`

---

## Example Metadata Filters by Use Case

### Draft Review Use Cases

**Validating biotin claims in a draft**:
```
Query: "What are approved claims about biotin for hair and nails?"
Filter: product=DM-02 AND file_type=Ingredient-Claims
```

**Checking compliance for energy claims**:
```
Query: "What compliance rules apply to energy and fatigue claims?"
Filter: category=Compliance
```

**Finding product positioning for PM-02**:
```
Query: "What is Seed's unique angle on sleep and melatonin?"
Filter: product=PM-02 AND category=NPD-Messaging
```

### Content Creation Use Cases

**Research for PQQ article across products**:
```
Query 1: "PQQ benefits in AM-02"
Filter: product=AM-02 AND file_type=Ingredient-Claims

Query 2: "PQQ benefits in DM-02"
Filter: product=DM-02 AND file_type=Ingredient-Claims

Query 3: "PQQ benefits in PM-02"
Filter: product=PM-02 AND file_type=Ingredient-Claims
```

**Understanding Seed's tone**:
```
Query: "Show me examples of Seed's writing style"
Filter: category=Style
```

**Finding cross-product general claims**:
```
Query: "What general health claims apply to all products?"
Filter: file_type=General-Claims OR product=Cross-Product
```

---

## When to Use File Search vs. Direct File Access

### Use File Search When:

✅ You're not sure which specific files contain the information
✅ Information might span multiple files
✅ You need semantic search (search by meaning, not filename)
✅ You're approaching context limits (token efficiency matters)
✅ Reviewing drafts for compliance or claims validation
✅ Researching across products (cross-product comparisons)

### Use Direct File Access When:

✅ You know exactly which file you need
✅ You need 1-3 specific files (low token cost)
✅ You need the FULL file content, not excerpts
✅ You need deterministic results every time
✅ You're doing initial research to understand file structure
✅ Working with a specific ingredient in a known product

---

## Tips for Effective Queries

1. **Be specific**: "What are approved claims about biotin for hair?" vs. "Tell me about biotin"

2. **Use metadata filters**: Narrow down to relevant files to get better results

3. **Multiple queries**: For cross-product research, query each product separately

4. **Natural language**: Ask questions naturally - the semantic search understands meaning

5. **Iterate**: If first query doesn't return what you need, refine with more specific language or different filters

6. **Check sources**: Always review the source files listed in grounding metadata

---

## Troubleshooting

**No results found**:
- Try broader query without metadata filter
- Check if metadata filter is too restrictive
- Try different query phrasing

**Wrong results**:
- Add metadata filter to narrow down
- Be more specific in query language
- Check if you're using correct product codes (AM-02, DM-02, PM-02)

**API errors**:
- Verify API key exists at `~/.claude/skills/gemini-api-key`
- Check store ID is correct
- Ensure internet connectivity

---

**Last Updated**: 2025-11-18
