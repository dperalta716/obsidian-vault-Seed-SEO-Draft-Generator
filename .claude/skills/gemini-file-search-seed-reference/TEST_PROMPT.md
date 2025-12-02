# Test Prompt for Gemini File Search Skill

**Purpose**: Test the gemini-file-search-seed-reference skill with multiple queries

**Copy everything below the line into a new conversation**

---

I need you to test the Gemini File Search skill for Seed reference materials. The skill and File Search store were just created and need validation.

## Background

- **Skill Location**: `.claude/skills/gemini-file-search-seed-reference/`
- **Store ID**: `fileSearchStores/seed-reference-materials-pr-jma5jhay17is` (in `dev/active/reference-store-setup/REFERENCE_STORE_ID`)
- **API Key**: `~/.claude/skills/gemini-api-key`
- **Store Contents**: 62 Seed Reference files (Claims, Messaging, Compliance, Style)

## What to Test

Please run the following queries using the query script at `.claude/skills/gemini-file-search-seed-reference/scripts/query-store.sh`

### Test 1: Basic Query (No Filter)
Test broad semantic search without metadata filter.

**Query**: "What does Seed say about gut-brain axis?"

**Expected**: Should return relevant passages from multiple files, showing source attribution

**Command**:
```bash
cd .claude/skills/gemini-file-search-seed-reference
./scripts/query-store.sh "What does Seed say about gut-brain axis?"
```

### Test 2: Ingredient Claims with Product Filter
Test finding specific ingredient claims for a product.

**Query**: "What are approved health claims about biotin for hair and nails?"

**Filter**: `product=DM-02 AND file_type=Ingredient-Claims`

**Expected**: Should return biotin claims specifically from DM-02 product

**Command**:
```bash
./scripts/query-store.sh "What are approved health claims about biotin for hair and nails?" "product=DM-02 AND file_type=Ingredient-Claims"
```

### Test 3: Compliance Rules
Test finding compliance restrictions.

**Query**: "What words and phrases should we avoid in Seed content?"

**Filter**: `category=Compliance`

**Expected**: Should return content from NO-NO-WORDS.md and compliance rules

**Command**:
```bash
./scripts/query-store.sh "What words and phrases should we avoid in Seed content?" "category=Compliance"
```

### Test 4: Product Positioning
Test finding product messaging and positioning.

**Query**: "What is Seed's unique positioning for PM-02 sleep product?"

**Filter**: `product=PM-02 AND category=NPD-Messaging`

**Expected**: Should return PM-02 messaging document content

**Command**:
```bash
./scripts/query-store.sh "What is Seed's unique positioning for PM-02 sleep product?" "product=PM-02 AND category=NPD-Messaging"
```

### Test 5: Cross-Product Comparison
Test finding an ingredient across multiple products.

**Query**: "What are the benefits of PQQ?"

**Filter**: `file_type=Ingredient-Claims`

**Expected**: Should return PQQ claims from AM-02, DM-02, and PM-02

**Command**:
```bash
./scripts/query-store.sh "What are the benefits of PQQ?" "file_type=Ingredient-Claims"
```

### Test 6: Tone and Style Guidance
Test finding writing guidelines.

**Query**: "How should Seed content be written? What's the brand voice?"

**Filter**: `category=Style`

**Expected**: Should return tone guide content

**Command**:
```bash
./scripts/query-store.sh "How should Seed content be written? What's the brand voice?" "category=Style"
```

### Test 7: Specific Ingredient in Specific Product
Test narrow filtering for precise results.

**Query**: "Tell me about melatonin dosing"

**Filter**: `product=PM-02 AND file_type=Ingredient-Claims`

**Expected**: Should return PM-02 melatonin claims specifically

**Command**:
```bash
./scripts/query-store.sh "Tell me about melatonin dosing" "product=PM-02 AND file_type=Ingredient-Claims"
```

### Test 8: General Claims
Test finding product-level general claims.

**Query**: "What are the general health claims for AM-02?"

**Filter**: `product=AM-02 AND file_type=General-Claims`

**Expected**: Should return AM-02 general claims document

**Command**:
```bash
./scripts/query-store.sh "What are the general health claims for AM-02?" "product=AM-02 AND file_type=General-Claims"
```

## What to Report

For each test, please document:

1. **Did the query execute successfully?** (Yes/No/Error)
2. **HTTP Status Code**: What status did the API return?
3. **Number of passages returned**: How many relevant excerpts?
4. **Source files**: Which files were cited in grounding support?
5. **Relevance**: Were the results relevant to the query?
6. **Any errors or issues**: What went wrong (if anything)?

## Known Issues to Watch For

1. **API Endpoint**: The script uses `:query` endpoint which may not be correct
   - If you get 404/400 errors, the endpoint might need adjustment
   - Check Gemini File Search API docs for correct endpoint

2. **Request Format**: Request body format might differ from actual API
   - If you get validation errors, the JSON structure may need changes

3. **Metadata Filter Syntax**: The AND syntax might not match API expectations
   - If filters don't work, syntax may need adjustment

4. **Store ID Location**: Script checks two locations for store ID
   - Should work, but verify it finds the ID correctly

## Success Criteria

**Minimum for success**:
- [ ] At least 5/8 queries execute without errors
- [ ] Returned passages are relevant to queries
- [ ] Source attribution shows correct files
- [ ] Metadata filtering works (results match filter criteria)

**Ideal success**:
- [ ] All 8 queries execute successfully
- [ ] All results are highly relevant
- [ ] Metadata filters work perfectly
- [ ] Performance is good (1-3 seconds per query)

## After Testing

Please provide a summary including:

1. **Overall Status**: Working / Needs Fixes / Completely Broken
2. **Success Rate**: X/8 queries successful
3. **Issues Found**: List any errors or problems
4. **Recommendations**: What needs to be fixed or improved?

## Additional Context

If you encounter errors, you can also:

1. **Check store health**:
```bash
cd dev/active/reference-store-setup
STORE_NAME=$(cat REFERENCE_STORE_ID)
API_KEY=$(cat ~/.claude/skills/gemini-api-key)
curl -s "https://generativelanguage.googleapis.com/v1beta/${STORE_NAME}?key=${API_KEY}" | jq
```

2. **Read detailed documentation**:
   - `.claude/skills/gemini-file-search-seed-reference/SKILL.md`
   - `.claude/skills/gemini-file-search-seed-reference/references/store-reference.md`
   - `dev/active/reference-store-setup/STORE_SUMMARY.md`

3. **Check API key**:
```bash
cat ~/.claude/skills/gemini-api-key
```

Thank you for testing\!
