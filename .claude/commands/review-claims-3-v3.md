# review-claims-3-v3

Enhanced claims verification with **PubMed-first** approach for fetching abstracts and verifying claims against source content.

## Usage

- `/review-claims-3-v3` - Reviews claims in the most recent draft in /Generated-Drafts/ or /Phase 1 Draft Revsions/
- `/review-claims-3-v3 filename.md` - Reviews claims in a specific file
- `/review-claims-3-v3 melatonin` - Reviews claims in draft containing keyword in filename

## What This Command Does

1. Extracts ALL sentences containing citations
2. Fetches source content (abstracts) using **triple-fallback**: PubMed → WebFetch → Firecrawl
3. Compares each claim against its cited source
4. Categorizes as Supported, Partially Supported, or Unsupported
5. Recommends specific fixes while preserving Seed's tone
6. Allows selective application of changes

## Key Enhancement in v3: PubMed-First Abstract Retrieval

**Triple-Fallback Hierarchy:**

| Priority | Method | Best For | Returns |
|----------|--------|----------|---------|
| 1st | **PubMed API** | Biomedical literature | Structured abstract + metadata |
| 2nd | **WebFetch** | Non-PubMed sources | Parsed HTML content |
| 3rd | **Firecrawl** | Blocked/JS-heavy sites | Scraped markdown |

**Why PubMed First:**
- Returns full abstract as structured text
- No HTML parsing needed
- Includes exact title for verification
- Covers ~70% of health/nutrition citations
- Faster than web scraping

## Implementation

### Step 1: File Identification

- If no argument: Find most recent versioned file
- If filename: Use that specific file
- If keyword: Find keyword folder, use latest version

### Step 2: Claim Extraction

Parse article to identify:
- All inline citations: `([Author Year](URL))`
- The complete sentence containing each citation (this is the "claim")
- Line number for reference

Store as:
```json
{
  "line": 45,
  "claim": "Studies show ashwagandha can reduce cortisol levels by up to 30%",
  "author": "Chandrasekhar",
  "year": "2012",
  "url": "https://doi.org/10.4103/0253-7176.106022"
}
```

### Step 3: Fetch Source Content with Triple-Fallback

For EACH claim, fetch the cited source:

#### 3a. Extract DOI and Try PubMed First

If URL contains DOI pattern:

```bash
# First, verify DOI and get PMID
/Users/david/Documents/Obsidian Vaults/claude-code-demo/Seed-SEO-Draft-Generator-v4/.claude/skills/pubmed-research/scripts/pubmed-verify-doi.sh "[DOI]"
```

If verified, fetch full abstract:
```bash
# Get abstract using PMID from verification
/Users/david/Documents/Obsidian Vaults/claude-code-demo/Seed-SEO-Draft-Generator-v4/.claude/skills/pubmed-research/scripts/pubmed-fetch.sh "[PMID]"
```

**PubMed fetch returns:**
```json
{
  "pmid": "23439798",
  "title": "A Prospective, Randomized Double-Blind...",
  "abstract": "BACKGROUND: Ashwagandha (Withania somnifera) is...",
  "authors": ["Chandrasekhar K", "Kapoor J", "Anishetty S"],
  "pub_year": "2012"
}
```

#### 3b. WebFetch Fallback

If PubMed returns "not indexed" or for non-DOI URLs:

```
WebFetch the URL with prompt:
"Extract and return:
1. ABSTRACT: [full abstract text]
2. KEY FINDINGS: [main results if accessible]
3. CONCLUSION: [conclusion if accessible]

If only abstract is available, note: 'FULL TEXT NOT ACCESSIBLE'"
```

#### 3c. Firecrawl Fallback

If WebFetch fails:

```bash
./.claude/skills/firecrawl-scraper/scripts/firecrawl-scrape.sh "[URL]" "markdown" "true" "2000"
```

Extract abstract/content from scraped markdown.

#### 3d. Track Fetch Method

Log which method succeeded for each source:
- 🧬 PubMed API
- 🌐 WebFetch
- 🔥 Firecrawl
- 🔒 Inaccessible (all methods failed)

### Step 4: Verify Claims Against Source Content

For each claim, compare against fetched abstract:

#### Support Levels

| Level | Criteria | Action |
|-------|----------|--------|
| ✅ **SUPPORTED** | Source directly states or data supports claim | No change |
| ⚠️ **PARTIALLY SUPPORTED** | General support but with caveats | Usually keep as-is |
| ❌ **UNSUPPORTED** | Source doesn't mention or contradicts | Needs fix |
| 🔒 **INACCESSIBLE** | Couldn't retrieve source | Manual review |

#### Verification Examples

**Claim:** "Studies show ashwagandha reduces cortisol by 30%"

**Abstract says:** "...resulted in a 27.9% reduction in serum cortisol levels (P<0.05)..."

**Verdict:** ✅ SUPPORTED (27.9% ≈ "up to 30%" is acceptable rounding)

---

**Claim:** "Probiotics eliminate IBS symptoms"

**Abstract says:** "...showed modest improvement in IBS symptom severity..."

**Verdict:** ❌ UNSUPPORTED ("eliminate" vs "modest improvement")

### Step 5: Decision Logic for Issues

#### PARTIALLY SUPPORTED (⚠️)
- **Default:** Keep as-is (partial support is acceptable)
- **Exception:** Specific quantitative claims may need minor adjustment

#### UNSUPPORTED (❌)
Determine appropriate action:

| Situation | Action | Example |
|-----------|--------|---------|
| Quantitative error | **MODIFY** | "30%" → "28%" |
| Overstated benefit | **MODIFY** | "eliminates" → "may reduce" |
| Wrong source | **REPLACE** | Find correct study |
| Non-essential claim | **REMOVE** | Delete sentence |

### Step 6: Maintain Seed's Tone in All Modifications

**CRITICAL:** All modifications must preserve Seed's voice:

#### Reading Level (7th-8th grade)
- Max 25 words per sentence
- 2-3 sentences per paragraph
- One concept per sentence

#### Tone ("Knowledgeable Friend")
- Use "you/your" direct address
- Include contractions
- Warm, approachable language

#### Scientific Language
- Plain language FIRST, then technical term
- ❌ "affects ATP synthesis"
- ✅ "affects how your cells make energy"

#### Modification Examples

**POOR:** "The study demonstrated a 23% reduction in cortisol levels."

**GOOD:** "Studies show that ashwagandha can reduce morning cortisol levels by 23%."

**BETTER:** "Studies show ashwagandha can lower your morning cortisol—that stress hormone that makes you feel wired—by about 23%."

### Step 7: Search for Replacement Sources

When a claim needs a new source:

#### 7a. Search PubMed First

```bash
./pubmed-search.sh "[claim topic] clinical study" 10 relevance
```

Review results for studies that support the claim.

#### 7b. Fetch and Verify Candidate

```bash
./pubmed-fetch.sh "[PMID]"
```

Check if abstract actually supports the claim.

#### 7c. WebSearch Fallback

If not in PubMed:
```
WebSearch for: [claim topic] clinical study research DOI
```

### Step 8: Generate Interactive Report

```
🔍 Claims Verification Report: [filename]
📅 Generated: [date]

📊 Claims Analyzed: X total
✅ Supported: Y (Z%)
⚠️ Partially Supported: W (kept as-is)
❌ Unsupported: N (action needed)
🔒 Inaccessible: M (manual review)

## Fetch Method Statistics:
🧬 PubMed API: A sources (structured abstract)
🌐 WebFetch: B sources
🔥 Firecrawl: C sources
🔒 Failed all methods: D sources

══════════════════════════════════════════
## Recommended Changes:

1. Line [X]: "[Full claim sentence]"
   Citation: ([Author Year](URL))
   📥 Source retrieved via: PubMed API

   🔬 Abstract says: "[Relevant excerpt from abstract]"
   ❌ Issue: Claim overstates findings

   → MODIFY: "[Suggested new claim text]"
   ✅ Reading Level: Maintains accessibility
   ✅ Tone: Preserves conversational voice

2. Line [Y]: "[Full claim sentence]"
   Citation: ([Author Year](URL))
   📥 Source retrieved via: WebFetch

   🔬 Source says: "[What source says]"
   ❌ Issue: Source doesn't support this claim

   → REPLACE with new source:
   New Citation: ([NewAuthor Year](NewURL))
   📥 Found via: PubMed search
   🔬 Verified via: PubMed API
   New Claim: "[Adjusted claim if needed]"

3. Line [Z]: "[Full claim sentence]"
   Citation: ([Author Year](URL))
   📥 Retrieval: All methods failed

   → MANUAL REVIEW NEEDED
   Reason: Source inaccessible to automated tools

══════════════════════════════════════════
## Partially Supported Claims (keeping as-is):

• Line [A]: "[Claim]" - Minor difference acceptable
  📥 Via: PubMed API
• Line [B]: "[Claim]" - General support sufficient
  📥 Via: Firecrawl

══════════════════════════════════════════
## Inaccessible Sources (manual review):

• Line [X]: ([Author Year](URL))
  All methods blocked - check manually

══════════════════════════════════════════
🔧 Apply Changes?

Options:
• 'all' - Apply all recommended changes
• '1,3' - Apply specific changes by number
• 'none' - Keep original unchanged
• 'report' - Save report without changes
```

### Step 9: Apply Selected Changes

Based on user input:

1. **Create versioned copy** (never modify original)
2. **Apply changes:**
   - MODIFY: Replace claim text, keep citation
   - REPLACE: Update claim + citation + Citations section
   - REMOVE: Delete sentence, ensure paragraph flow
3. **Maintain tone** throughout all modifications
4. **Update Citations section** (add new, remove unused)

### Step 10: Final Summary

```
✅ Changes Applied Successfully!

📝 Modified: X claims
🔄 Replaced: Y sources
❌ Removed: Z claims

## Fetch Method Summary:
🧬 PubMed: A sources
🌐 WebFetch: B sources
🔥 Firecrawl: C sources
🔒 Manual needed: D sources

💾 Original: [filename]
📄 Verified: v[X]-claims-verified.md
```

## PubMed Skill Reference

Scripts location:
```
.claude/skills/pubmed-research/scripts/
├── pubmed-verify-doi.sh   # Verify DOI exists, get PMID
├── pubmed-fetch.sh        # Get full abstract + metadata
└── pubmed-search.sh       # Find replacement sources
```

**Workflow for each citation:**
```bash
# 1. Verify DOI and get PMID
./pubmed-verify-doi.sh "10.4103/0253-7176.106022"

# 2. If verified, fetch full abstract
./pubmed-fetch.sh "23439798"

# 3. If need replacement, search
./pubmed-search.sh "ashwagandha cortisol clinical trial" 5
```

## Acceptable vs Unacceptable Variations

### Acceptable (Still Supported)
- Rounding: "27.9%" → "nearly 30%" ✅
- Simplified language: "statistically significant (p<0.05)" → "significantly" ✅
- Combined findings from multiple citations ✅

### Unacceptable (Needs Fix)
- Wrong numbers: "15%" → "50%" ❌
- Overstated certainty: "may" → "will" ❌
- Missing limitations: mice study → implies humans ❌
- Wrong outcomes: study measured X, claim says Y ❌

## Edge Cases

| Case | Handling |
|------|----------|
| Paywall - abstract only | Verify against abstract, note limitation |
| PubMed not indexed | Fall back to WebFetch |
| Multiple citations for one claim | Any one source supporting = supported |
| Claims doc approved language | Auto-supported (from Seed's Claims files) |
| Animal studies | Flag if claim implies human results |

## File Saving

- Original: NEVER modified
- Output: `v[X]-claims-verified.md`
- Report option: `claims-report.md` (no changes)

## Version History

- **v1**: WebFetch only
- **v2**: WebFetch → Firecrawl fallback
- **v3**: PubMed API → WebFetch → Firecrawl
  - Direct abstract retrieval (no parsing)
  - Structured metadata for accurate matching
  - Faster verification for biomedical sources
  - Better replacement source discovery via PubMed search
