# review-claims-3-v2

Enhanced version of claims verification with intelligent fallback for source fetching - first tries native WebFetch, then falls back to Fire Crawl MCP if needed.

## Usage

- `/review-claims-3-v2` - Reviews claims in the most recent draft in /Generated-Drafts/
- `/review-claims-3-v2 filename.md` - Reviews claims in a specific file
- `/review-claims-3-v2 melatonin` - Reviews claims in draft containing keyword in filename

## What This Command Does

This enhanced v2 version automatically:
1. Extracts ALL sentences containing citations from your draft
2. Fetches and analyzes each cited source using dual-method approach (WebFetch → Fire Crawl fallback)
3. Categorizes claims as Supported, Partially Supported, or Unsupported
4. Recommends specific actions for problematic claims (modify, replace, or remove)
5. Allows you to selectively apply fixes while preserving the original
6. Reports which fetch method successfully retrieved each source

## Key Enhancement in v2

**Intelligent Source Fetching with Fallback:**
- **Primary Method**: Uses native WebFetch tool (faster, more efficient)
- **Automatic Fallback**: If WebFetch fails (blocked, error, timeout), automatically tries Fire Crawl MCP scrape tool
- **Comprehensive Coverage**: Ensures more sources can be successfully analyzed
- **Transparent Tracking**: Reports which method successfully retrieved each paper

## Implementation

When this command runs:

### 1. File Selection
- If no argument provided: Find the most recent versioned file across all subdirectories in `/Generated-Drafts/`
- If argument looks like a filename: Use that specific file (search in subdirectories)
- If argument is a keyword: Find the keyword folder in `/Generated-Drafts/[keyword]/` and use the latest version

### 2. Claim Extraction

Parse the entire article to identify and extract:
- All inline citations in format `([Author Year](URL))`
- The complete sentence containing each citation (this is the "claim")
- Line number for each claim
- Store as: `{line: X, claim: "sentence text", author: "Name", year: "YYYY", url: "doi.org/..."}`

Important: A claim is the ENTIRE sentence that ends with a citation, not just the part immediately before it.

### 3. Enhanced Verification Process with Dual-Method Fetching

For EACH claim found, systematically:

a. **Fetch the source material with intelligent fallback:**

   **Primary Attempt (WebFetch):**
   ```
   WebFetch the URL with prompt:
   "Extract and return:
   1. ABSTRACT: [full abstract text]
   2. KEY FINDINGS: [main results if accessible]
   3. CONCLUSION: [conclusion if accessible]

   If only abstract is available, note: 'FULL TEXT NOT ACCESSIBLE'"
   ```

   **If WebFetch fails (automatic fallback to Fire Crawl):**
   ```
   Use mcp_firecrawl_scrape with same URL
   Process the scraped content to extract:
   - Abstract, key findings, and conclusions
   - Note in tracking: "Retrieved via Fire Crawl fallback"
   ```

   **Failure Tracking:**
   - If WebFetch returns error/timeout → Try Fire Crawl
   - If Fire Crawl also fails → Mark as "Source inaccessible - manual review needed"
   - Log which method succeeded for final report

b. **Assess support level (from either fetch method):**
   ```
   Compare the claim against source content:

   SUPPORTED (✅):
   - Source directly states the claim
   - Source data reasonably supports the claim
   - Minor differences in wording/rounding are acceptable

   PARTIALLY SUPPORTED (⚠️):
   - Source generally supports but with caveats
   - Claim slightly overstates findings
   - Missing important context/limitations

   UNSUPPORTED (❌):
   - Source doesn't mention this finding
   - Source contradicts the claim
   - Claim misrepresents the research

   INACCESSIBLE (🔒):
   - Neither fetch method could retrieve source
   - Flag for manual review
   ```

c. **Check against claims documents (if applicable):**
   - If reviewing an NPD ingredient article
   - Cross-reference with `/Reference/Claims/[Product]/` documents
   - Flag if claim conflicts with approved language

### 3.5 Tone and Style Requirements for ALL Modifications

When modifying any claim, preserve Seed's distinctive voice and accessibility:

#### Reading Level (7th-8th grade)
- Maximum 25 words per sentence average
- 2-3 sentences per paragraph maximum
- One concept per sentence
- Active voice preferred

#### Tone Preservation ("Knowledgeable and Empathetic Friend")
- Use direct address ("you," "your")
- Include contractions for conversational feel
- Maintain warm, approachable tone even when correcting technical claims
- Add gentle transitions like "Don't worry though" when addressing concerns
- Avoid being preachy or alarmist

#### Scientific Language Handling
- ALWAYS lead with plain language explanation first
- Then introduce technical term if needed
- Use analogies and metaphors when possible
- Examples:
  * ❌ "affects ATP synthesis"
  * ✅ "affects how your cells make energy"
  * ❌ "modulates the HPA axis"
  * ✅ "helps regulate your body's stress response system"
  * ❌ "reduces serum cortisol levels"
  * ✅ "lowers cortisol, your body's main stress hormone"

#### Example Modifications:
POOR: "The study demonstrated a 23% reduction in cortisol levels."
GOOD: "Studies show that ashwagandha can reduce morning cortisol levels by 23%."
BETTER: "Studies show ashwagandha can lower your morning cortisol—that stress hormone that makes you feel wired—by about 23%."

### 4. Decision Logic for Issues

For each problematic claim, determine the appropriate action:

#### PARTIALLY SUPPORTED Claims (⚠️)
- **Default**: Keep as-is (partial support is generally acceptable)
- **Exception**: If it's a specific quantitative claim, suggest minor modification

#### UNSUPPORTED Claims (❌)
Analyze context to recommend:

a. **MODIFY** - When claim is close but needs adjustment:
   - Quantitative errors: "30%" → "27.9%"
   - Overstated benefits: "eliminates" → "may reduce"
   - Missing nuance: "improves sleep" → "improves sleep quality in adults"
   - Ensure modified claim maintains conversational tone
   - Check reading level (7th-8th grade target)
   - Verify plain language comes before technical terms
   - Maintain "you/your" direct address where appropriate

b. **REPLACE** - When claim is essential but wrong source:
   - Search for alternative source supporting the claim
   - Use WebSearch: "[claim topic] clinical study research"
   - Verify new source actually supports the claim (using dual-method fetching)
   - First try WebFetch, fallback to Fire Crawl if needed

c. **REMOVE** - When claim is unsupported AND non-essential:
   - Claim isn't critical to main argument
   - No valid source can be found
   - Removing doesn't break article flow

### 5. Generate Interactive Report with Fetch Method Tracking

Present findings in this format:

```
🔍 Claims Verification Report: [filename]
📅 Generated: [date]

📊 Claims Analyzed: [X] total
✅ Supported: [Y] ([%])
⚠️ Partially Supported: [Z] ([%]) - keeping as-is
❌ Unsupported: [N] ([%]) - action needed
🔒 Inaccessible: [M] ([%]) - manual review needed

## Fetch Method Statistics:
🚀 WebFetch successful: [A] sources
🔥 Fire Crawl fallback: [B] sources
🔒 Both methods failed: [C] sources

==================================================
## Recommended Changes:

1. Line [X]: "[Full claim sentence]"
   Citation: ([Author Year](URL))
   📥 Retrieved via: WebFetch

   🔬 Source Says: "[What the source actually says]"
   ❌ Issue: [Specific problem]

   → MODIFY: "[Suggested new claim text]"
   Reading Level: ✅ Maintains accessibility
   Tone Check: ✅ Preserves conversational voice
   Reason: Makes claim accurate while preserving message and voice

2. Line [Y]: "[Full claim sentence]"
   Citation: ([Author Year](URL))
   📥 Retrieved via: Fire Crawl (WebFetch failed - site blocked)

   🔬 Source Says: "[What source says or doesn't say]"
   ❌ Issue: Source doesn't support this claim

   → REPLACE with new source:
   New Citation: ([NewAuthor Year](NewURL))
   📥 New source verified via: WebFetch
   New Claim: "[Adjusted claim if needed]"
   Reason: Found better source that supports this point

3. Line [Z]: "[Full claim sentence]"
   Citation: ([Author Year](URL))
   📥 Retrieval failed: Both methods blocked

   🔒 Unable to verify - manual review recommended

   → MANUAL REVIEW NEEDED
   Reason: Source inaccessible to automated tools

[Continue for all unsupported/inaccessible claims...]

==================================================
## Summary of Partially Supported Claims (keeping as-is):

• Line [A]: "[Claim]" - Close enough, minor difference acceptable
  📥 Retrieved via: WebFetch
• Line [B]: "[Claim]" - General support sufficient for context
  📥 Retrieved via: Fire Crawl
[List all partial claims being kept with fetch method...]

==================================================
## Sources Requiring Manual Review:

These sources could not be accessed by either fetch method:
• Line [X]: ([Author Year](URL)) - Both methods blocked
• Line [Y]: ([Author Year](URL)) - Paywall/authentication required
[List all inaccessible sources...]

==================================================
🔧 Ready to Apply Changes?

Options:
• 'all' - Apply all recommended changes
• '1,3' - Apply specific changes by number
• 'none' - Keep original file unchanged
• 'report' - Save this report without changes

Enter your choice:
```

### 6. Apply Selected Changes

Based on user input:

a. **Create a working copy:**
   - Determine the next version number (if reviewing v3, save as v4)
   - Copy original to `v4-claims-verified.md` in the same keyword subfolder
   - All edits happen on the COPY only

b. **For each approved change:**

   **MODIFY actions:**
   - Use Edit tool to replace claim sentence
   - Keep citation unchanged
   - Ensure paragraph flow remains smooth
   - Verify all modifications maintain Seed's voice and tone
   - Check reading level remains at 7th-8th grade
   - Ensure conversational elements are preserved
   - Confirm plain language precedes technical terms

   **REPLACE actions:**
   - Update claim text if needed
   - Replace old citation with new one (verify new source with dual-method approach)
   - Update both inline and Citations section
   - Add new source to numbered citations list

   **REMOVE actions:**
   - Delete the entire sentence
   - Check if paragraph still flows
   - If paragraph becomes too short, merge with adjacent

c. **Update Citations section:**
   - Add any new sources in alphabetical order
   - Remove citations that are no longer referenced
   - Maintain APA format

d. **Final summary:**
   ```
   ✅ Changes Applied Successfully!

   📝 Modified: X claims
   🔄 Replaced: Y sources
   ❌ Removed: Z claims

   ## Fetch Method Summary:
   🚀 WebFetch: A sources
   🔥 Fire Crawl: B sources
   🔒 Manual review needed: C sources

   💾 Original preserved: [filename]
   📄 Verified version: v[X]-claims-verified.md in [keyword] folder
   ```

## Critical Verification Rules

### Acceptable Variations (Still Count as Supported)
- Rounding differences: Study says "27.9%", claim says "nearly 30%" ✅
- Simplified language: Study says "statistically significant reduction (p<0.05)", claim says "significantly reduced" ✅
- Combined findings: Multiple studies cited for one claim ✅
- Mechanism explanations: Well-established biological pathways ✅

### Unacceptable Variations (Need Fixing)
- Wrong numbers: Study says "15%", claim says "50%" ❌
- Overstated certainty: Study says "may", claim says "will" ❌
- Missing limitations: Study was in mice, claim implies humans ❌
- Wrong outcomes: Study measured X, claim says Y ❌
- Time frame errors: Study shows 8-week results, claim says 3 days ❌

### Style-Preserving Modifications

When modifying claims, maintain these Seed-specific elements:

#### Must Preserve:
- Conversational, empathetic friend tone
- Direct address using "you/your"
- Plain language explanations before technical terms
- Short sentences (under 25 words average)
- Gentle transitions and acknowledgments
- Positive framing when possible

#### Examples of Proper Modifications:
- Technical fix WITH tone preservation:
  * Original: "Magnesium affects ATP synthesis for energy"
  * ❌ Wrong: "Magnesium is involved in adenosine triphosphate production"
  * ✅ Right: "Your cells need magnesium to make energy"

- Quantitative fix WITH accessibility:
  * Original: "Reduces anxiety by 59%"
  * ❌ Wrong: "Demonstrates a statistically significant anxiety reduction"
  * ✅ Right: "Can help reduce anxiety in meaningful ways"

- Adding nuance WITH warmth:
  * Original: "Eliminates sleep problems"
  * ❌ Wrong: "May potentially ameliorate sleep disturbances"
  * ✅ Right: "May help improve your sleep quality"

## Handling Special Cases with Dual-Method Approach

### Paywalled Articles
- First attempt with WebFetch
- If paywall detected, try Fire Crawl (may have different access)
- If only abstract is accessible via either method, verify against abstract only
- Note in report: "Verification based on abstract only"
- Be more conservative - if abstract doesn't clearly support, mark as unsupported

### Sites That Block WebFetch
- Common with certain publishers (Elsevier, Springer, etc.)
- Fire Crawl often succeeds where WebFetch is blocked
- Log which method worked for transparency

### Multiple Citations for One Claim
- Check ALL cited sources (using dual-method for each)
- Claim is supported if ANY source supports it
- Note which specific source provides support and fetch method used

### Claims from Product Documentation
- Cross-reference with `/Reference/Claims/` documents
- If claim matches approved language exactly, mark as supported
- Flag any deviations from approved claims

### Review Articles & Meta-Analyses
- These often summarize multiple studies
- Verify claim matches the review's conclusions
- Don't need to check every underlying study

### Quantitative Claims
- Exact match not always required
- "Approximately", "nearly", "about" are acceptable for small variations
- Specific numbers should be within 5% of source

## Edge Cases Handled

- **No DOI/broken links**: Try to find study via title search, use dual-method for verification
- **Retracted papers**: Flag immediately, must replace source
- **Preprints**: Note if not peer-reviewed, suggest finding published version
- **Secondary sources**: If claim cites a review citing another study, verify against review
- **Old studies**: Flag if >10 years old and newer research contradicts
- **Animal studies**: Ensure claim doesn't imply human results
- **In vitro studies**: Ensure claim doesn't overstate real-world application
- **Bot detection**: If WebFetch triggers bot detection, Fire Crawl usually bypasses
- **Rate limiting**: Fire Crawl provides backup when sites rate-limit WebFetch

## File Management

- **Original file**: Never modified, always preserved
- **Output file**: `v[X]-claims-verified.md` with all approved changes in same keyword subfolder
- **Report option**: Can save report as `claims-report.md` in the keyword folder without changes
- Automatically increments version number
- All files remain in keyword subfolders within `/Generated-Drafts/`

## Important Notes

- **v2 Enhancement**: Dual-method fetching ensures higher success rate for source verification
- Process claims in order (1, 2, 3...) for systematic review
- Partial support is usually acceptable - we're not being overly strict
- When searching for replacement sources, prioritize peer-reviewed studies
- Always maintain the article's narrative flow when removing claims
- Some claims about basic biology/nutrition may not need citations
- Focus on claims about specific benefits, mechanisms, and research findings
- If a claim is from Seed's approved claims documents, it's automatically supported
- Modified claims must sound like they belong in the original article
- Preserve the "knowledgeable friend" voice throughout all changes
- When in doubt, choose warmth and accessibility over technical precision
- Remember: We're writing for stressed, tired readers who need clear, friendly guidance
- Fire Crawl fallback may add slight processing time but ensures better coverage

## Version History

- **v1**: Original implementation with WebFetch only
- **v2**: Enhanced with intelligent Fire Crawl MCP fallback for improved reliability and coverage