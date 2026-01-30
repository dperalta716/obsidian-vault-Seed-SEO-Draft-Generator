# review-sources-2-v2

Enhanced version of source verification with intelligent fallback for paper fetching - first tries native WebFetch, then falls back to Fire Crawl MCP if needed.

## Usage

- `/review-sources-2-v2` - Reviews sources in the most recent draft in /Generated-Drafts/
- `/review-sources-2-v2 filename.md` - Reviews sources in a specific file
- `/review-sources-2-v2 melatonin` - Reviews sources in draft containing keyword in filename

## What This Command Does

This enhanced v2 version automatically:
1. Extracts ALL citations from your draft (no matter how many)
2. Systematically checks each DOI link using dual-method approach (WebFetch → Fire Crawl fallback)
3. Detects both non-existent DOIs and wrong-paper DOIs
4. Searches for and finds the correct studies
5. Updates EVERY instance throughout the article (both Citations section and inline references)
6. Shows you exactly what was changed and which fetch method succeeded

## Key Enhancement in v2

**Intelligent Paper Fetching with Fallback:**
- **Primary Method**: Uses native WebFetch tool (faster, more efficient)
- **Automatic Fallback**: If WebFetch fails (blocked, error, timeout), automatically tries Fire Crawl MCP scrape tool
- **Transparent Logging**: Reports which method successfully retrieved each paper

## Implementation

When this command runs:

1. **First, identify which file to review:**
   - If no argument provided: Find the most recent versioned file across all subdirectories in `/Generated-Drafts/`
   - If argument looks like a filename: Use that specific file (search in subdirectories)
   - If argument is a keyword: Find the keyword folder in `/Generated-Drafts/[keyword]/` and use the latest version

2. **Count and extract all citations:**
   - Parse the "## Citations" section to count total citations
   - Process ALL citations found (could be 5, 10, 20, or any number)
   - Extract from each: Author name, Year, Title, Current DOI/URL
   - Also find all inline citations in the format `([Author Year](URL))`

3. **Systematically verify each citation IN ORDER with enhanced fetching:**

   Go through citations sequentially (1, 2, 3, etc.) - don't skip around:

   a. **First attempt with WebFetch (native tool):**
      ```
      WebFetch the DOI URL with prompt:
      "Check if this page shows 'DOI NOT FOUND' or 'This DOI cannot be found in the DOI System'.
      If yes, return: ERROR: DOI not found
      If no, extract: TITLE: [exact title], FIRST_AUTHOR: [first author last name]"
      ```

   b. **If WebFetch fails (error, blocked, timeout), automatically fallback to Fire Crawl MCP:**
      ```
      Use mcp_firecrawl_scrape with same URL
      Process the scraped content to:
      - Check for "DOI NOT FOUND" errors
      - Extract title and author information
      - Note in log: "Retrieved via Fire Crawl fallback"
      ```

   c. **Identify the type of error (from either method):**
      - If page shows "DOI NOT FOUND" → Mark as NON-EXISTENT
      - If DOI works but title/author don't match → Mark as WRONG PAPER
      - If both title AND author match → Mark as VALID
      - If neither method succeeds → Flag for manual review

   d. **Important matching rules:**
      - Check ONLY title and author (don't assume topic)
      - For title: Match the part before any colon
      - For author: Match last name (allow Smith vs Smith, J.)
      - Work for ANY topic (not just ashwagandha/sleep)

4. **Fix all incorrect citations:**

   For each invalid citation:

   a. **Search for the correct study:**
      ```
      WebSearch for: "[Full citation title]" [Author last name] [Year] DOI
      ```

   b. **Verify the correct study (using dual-method approach):**
      - First try WebFetch on promising results
      - If WebFetch fails, use Fire Crawl MCP scrape as fallback
      - Confirm exact title match (before colon)
      - Verify author and year match
      - Extract the correct DOI link

   c. **If no DOI found but correct study page found:**
      - Use the journal/publisher URL as fallback
      - Format: `([Author Year](https://journal-url.com/article))`

5. **Create the verified copy and update ALL instances:**

   a. **FIRST, create a copy to preserve the original:**
      - Determine the next version number (if reviewing v2, save as v3)
      - Copy the original file to `v3-sources-verified.md` in the same keyword subfolder
      - ALL edits will be made to this COPY, not the original

   b. **For EACH incorrect DOI that needs fixing (in the COPY):**
      - Update Citations section: Replace the old DOI with the new DOI in the numbered citation
      - Keep all other formatting identical

   c. **Search and replace ALL inline references (in the COPY):**
      - Search the ENTIRE article for `([Author Year](old-url))`
      - Replace EVERY instance with `([Author Year](new-url))`
      - Count how many replacements were made
      - Maintain exact formatting (no comma between Author Year)

6. **Generate detailed report with fetch method tracking:**

   ```
   🔍 Source Verification Complete: [filename]

   📚 Reviewed X citations (dynamically counted)
   ✅ Valid: Y
   ✗ Fixed: Z

   ## Fetch Methods Used:
   🚀 WebFetch successful: A papers
   🔥 Fire Crawl fallback: B papers
   ⚠️ Manual review needed: C papers

   ## Changes Made:

   1. [Author Year]
      ❌ Old: [old DOI] (DOI not found / wrong article)
      ✅ New: [new DOI]
      📥 Retrieved via: [WebFetch/Fire Crawl]
      → Updated X inline references and citation list

   [Continue for all fixed citations...]

   💾 Original file preserved
   📝 Updated file saved as: v[X]-sources-verified.md in [keyword] folder
   ```

## Enhanced Error Handling in v2

### Dual-Method Approach Benefits:
- **Resilience**: If one method fails, automatically tries another
- **Coverage**: Handles sites that block WebFetch but allow Fire Crawl
- **Speed**: Uses faster WebFetch first, only falls back when needed
- **Transparency**: Clear logging of which method worked for each paper

### Fallback Triggers:
WebFetch → Fire Crawl fallback occurs when:
- WebFetch returns connection error
- WebFetch times out (>30 seconds)
- WebFetch is blocked by site (403/429 errors)
- WebFetch returns empty or malformed response

## Critical Detection: DOI NOT FOUND Pages

When a DOI is completely incorrect, it leads to a specific error page that shows:
- Header: "DOI NOT FOUND"
- Message: "This DOI cannot be found in the DOI System"
- Note: The specific DOI number shown will be different for each broken link

This is DIFFERENT from a DOI that works but leads to the wrong paper. Both types must be fixed.

## Matching Logic Details

### Title Matching
- Extract title from citation and from fetched page
- If title contains colon, only match the part BEFORE the colon
- Ignore case differences
- Ignore minor punctuation differences at the end
- Works for ANY topic (not topic-specific)

### Author Matching
- Allow these variations:
  - "Smith" matches "Smith, J." or "Smith, John"
  - "García-López" matches "Garcia-Lopez" (accent variations)
  - First name initials vs full names
- Must match last name exactly (case-insensitive)

### Year Matching
- Must match exactly
- If page shows publication year and online year, use publication year

## Search Strategy for Broken Links

1. **Primary search**: `"[Full title in quotes]" [Author] [Year] DOI`
2. **If no results**: `[Title first 10 words] [Author] [Year]`
3. **Check these domains first** (most reliable):
   - doi.org
   - pubmed.ncbi.nlm.nih.gov
   - sciencedirect.com
   - nature.com
   - springer.com
   - wiley.com
   - academic.oup.com
   - journals.plos.org
   - mdpi.com
   - frontiersin.org
   - cureus.com

## Edge Cases Handled

- **Variable citation counts**: Works with any number of citations (5, 16, 30+)
- **DOI not found**: Specifically detects and handles non-existent DOIs
- **Wrong paper DOIs**: Detects when DOI works but leads to different paper
- **Retracted articles**: Flag but don't change (add warning to report)
- **Preprints**: If citation is to preprint but published version exists, update to published
- **No DOI exists**: Use direct journal URL as fallback
- **Multiple DOIs**: Some articles have multiple valid DOIs; any correct one is acceptable
- **Author name changes**: Match on last name if first/middle names have changed
- **Site blocking**: Automatically switches to Fire Crawl when sites block WebFetch

## File Saving

- **Original file is NEVER modified** - remains untouched
- Creates versioned copy: `v[X]-sources-verified.md` in same keyword subfolder
- Automatically increments version number
- All corrections are applied to the COPY only
- Updates happen atomically (all or nothing)

## Important Notes

- **v2 Enhancement**: Dual-method fetching ensures higher success rate
- Processes ALL citations systematically, regardless of count
- Goes through citations IN ORDER (1, 2, 3...) not randomly
- Works for ANY topic (not just specific ingredients)
- Replaces ALL instances of incorrect DOIs throughout the article
- Works on files in keyword subfolders within `/Generated-Drafts/`
- Requires internet connection to verify links
- Processing time depends on number of citations and fetch method used
- Fire Crawl fallback may add slight delay but ensures better coverage
- Always preserves the original file for safety

## Version History

- **v1**: Original implementation with WebFetch only
- **v2**: Enhanced with intelligent Fire Crawl MCP fallback for improved reliability