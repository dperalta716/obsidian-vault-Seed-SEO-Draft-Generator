# Quick Reference - Seed Reference Materials Access

**Last Updated**: 2025-11-18

---

## Two Ways to Access Seed Reference Materials

### 1. Direct File Access (Traditional)

**When to Use**:
- ✅ Know exact file needed
- ✅ Need 1-3 specific files
- ✅ Need FULL file content
- ✅ Need deterministic results

**How**:
```markdown
Read /path/to/Reference/Claims/DM-02/DM-02-Biotin-Claims.md
```

**Cost**: Tokens for files read

---

### 2. File Search (Semantic Search)

**When to Use**:
- ✅ Uncertain which files contain info
- ✅ Info spans multiple files
- ✅ Semantic search needed
- ✅ Token efficiency critical
- ✅ Draft review/validation
- ✅ Cross-product research

**How**:
```bash
# Use the skill
Load gemini-file-search-seed-reference skill

# Or use query script directly
cd .claude/skills/gemini-file-search-seed-reference
./scripts/query-store.sh "Your query" "optional metadata filter"
```

**Cost**: ~$0.01-0.02 per query

---

## File Search Store Info

**Store ID**: `fileSearchStores/seed-reference-materials-pr-jma5jhay17is`
**Location**: `dev/active/reference-store-setup/REFERENCE_STORE_ID`
**Contents**: 62 files (685 KB)
**Status**: ✅ Production Ready

**Health Check**:
```bash
cd dev/active/reference-store-setup
STORE_NAME=$(cat REFERENCE_STORE_ID)
API_KEY=$(cat ~/.claude/skills/gemini-api-key)
curl -s "https://generativelanguage.googleapis.com/v1beta/${STORE_NAME}?key=${API_KEY}" | jq
```

---

## Common File Search Queries

**Find ingredient claims**:
```bash
./scripts/query-store.sh "What are approved claims about biotin?" "product=DM-02 AND file_type=Ingredient-Claims"
```

**Check compliance**:
```bash
./scripts/query-store.sh "What words should we avoid?" "category=Compliance"
```

**Product positioning**:
```bash
./scripts/query-store.sh "What is Seed's unique angle on PM-02?" "product=PM-02 AND category=NPD-Messaging"
```

**Cross-product comparison**:
```bash
./scripts/query-store.sh "Compare PQQ benefits" "file_type=Ingredient-Claims"
```

**Tone guidance**:
```bash
./scripts/query-store.sh "How should Seed content be written?" "category=Style"
```

---

## Metadata Filters

**By Category**:
- `category=Claims`
- `category=NPD-Messaging`
- `category=Compliance`
- `category=SciComms`
- `category=Style`

**By Product**:
- `product=AM-02`
- `product=DM-02`
- `product=PM-02`
- `product=Cross-Product`
- `product=N/A`

**By File Type**:
- `file_type=Ingredient-Claims`
- `file_type=General-Claims`
- `file_type=Messaging`
- `file_type=Compliance`
- `file_type=Tone-Guide`

**Combine with AND**:
```
product=DM-02 AND file_type=Ingredient-Claims
category=Claims AND product=PM-02
```

---

## Documentation Locations

### Reference Store Setup
- **Start Here**: `dev/active/reference-store-setup/README.md`
- **Store Details**: `dev/active/reference-store-setup/STORE_SUMMARY.md`
- **Scripts**: `dev/active/reference-store-setup/scripts/`

### File Search Skill
- **Skill Docs**: `.claude/skills/gemini-file-search-seed-reference/SKILL.md`
- **Query Script**: `.claude/skills/gemini-file-search-seed-reference/scripts/query-store.sh`
- **Detailed Reference**: `.claude/skills/gemini-file-search-seed-reference/references/store-reference.md`

### Session Notes
- **Session Summary**: `SESSION_SUMMARY_2025-11-18.md`
- **This File**: `QUICK_REFERENCE.md`

---

## Hybrid Approach Best Practices

**For SEO Draft Generation** (current workflow):
- Continue using direct file access (Steps 3-4 identify specific files)
- File Search not needed for this workflow

**For Draft Review/Validation** (future):
- Use File Search to check claims
- Use File Search to verify compliance
- Use File Search to validate positioning

**For Research** (when uncertain):
- Start with File Search to discover relevant files
- Then read specific files directly for full content

**For Cross-Product Work**:
- Use File Search to find all mentions
- Compare excerpts across products efficiently

---

**Created**: 2025-11-18
**Status**: Both systems production-ready ✅
