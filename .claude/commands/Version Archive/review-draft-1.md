# review-draft

Review generated SEO articles against all Seed requirements and offer to fix issues.

## Usage

- `/review-draft` - Reviews the most recent draft in /Generated-Drafts/
- `/review-draft filename.md` - Reviews a specific file
- `/review-draft melatonin` - Reviews draft containing keyword in filename

## What This Command Does

This command performs a comprehensive quality review of your generated draft, checking ~50 different requirements across 6 categories. It then offers to fix any issues found, either all at once or by category.

## Implementation

When this command runs:

1. **First, identify which file to review:**
   - If no argument provided: Find the most recent v1-*.md file across all subdirectories in `/Generated-Drafts/`
   - If argument looks like a filename: Use that specific file (search in subdirectories)
   - If argument is a keyword: Find the keyword folder in `/Generated-Drafts/[keyword]/` and use the latest version

2. **Load the draft and all reference documents:**
   - The draft to review
   - `/Reference/Compliance/NO-NO-WORDS.md`
   - `/Reference/Compliance/What-We-Are-Not-Allowed-To-Say.md`
   - `/Reference/Style/Seed-Tone-of-Voice-and-Structure.md`
   - `/Reference/Style/8-Sample-Reference-Blog-Articles.md`

3. **Run comprehensive checks across 6 categories:**

### 📊 Citations & Evidence Checks
- Count total citations (must be exactly 12-15, no more, no less)
- Verify each citation format: `([Author Year](DOI_URL))` with NO comma between Author and Year
- Check that all citations have DOI links (must start with http or https)
- Calculate citation density (should be ~1 per 75-100 words for key claims, not for every statement)
- Verify citations are only for: specific studies, quantitative data, mechanisms, health claims, Seed positioning

### 🏷️ Product References Checks
- All NPD product mentions include ® symbol
- Correct format: `[PM-02® Sleep + Restore](https://seed.com/sleep-restore)`, `[AM-02® Energy + Focus](https://seed.com/energy-focus)`, `[DM-02® Daily Multivitamin](https://seed.com/daily-multivitamin)`
- Verify focus is on ingredient story, not product pitch (should explain WHY ingredients work, not just promote products)

### ⚖️ Compliance Checks
- Scan entire text against NO-NO-WORDS list (case-insensitive)
- Check for "supplement" used specifically with probiotics (this is forbidden)
- Flag medical claims: treat, cure, diagnose, prevent, boost, heal, fix
- Check for unapproved health claims not in claims documents
- Verify no absolute statements ("always", "never", "guaranteed" in medical context)

### 📝 Structure & Length Checks
- Total word count ≥1300 words
- Has `### Overview` section with 3-5 bullet points
- Has `## The Key Insight` section (paragraph form summary)
- Has `## Frequently Asked Questions` section with 3-4 questions
- Contains quote attributed to "Dirk Gevers, Ph.D."
- Has `## Citations` section at the end
- Has section for internal link suggestions (5-15 links)
- Proper H2/H3 hierarchy throughout

### 💬 Tone & Voice Checks (Most Comprehensive)

**Writing Style:**
- Consistent use of "you/your" throughout (not "one" or "people")
- Contractions used naturally (it's, you're, don't, won't, that's, etc.)
- Paragraphs are short (2-4 sentences max, not walls of text)
- Sentence length varies for good rhythm
- Active voice predominant (not "it was discovered that...")

**Conversational Elements:**
- Contains rhetorical questions to engage reader
- Includes relatable scenarios or examples
- Has "we've all been there" or shared experience moments
- Uses gentle self-deprecation where appropriate
- Transitions feel conversational, not academic

**Scientific Explanation:**
- Plain language explanation comes BEFORE technical terms
- Complex concepts have analogies or metaphors
- Contains "Think of it like..." or similar constructions
- Scientific jargon is immediately explained in simple terms
- Science is connected to reader's daily experience

**Empathy Markers:**
- Acknowledges potential concerns ("This might sound alarming, but...")
- Addresses potentially embarrassing topics sensitively
- Maintains no-judgment tone for sensitive health issues
- Validates reader's experience before offering new perspective
- Shows understanding of reader's potential skepticism

**Personality & Warmth:**
- Contains light, appropriate humor (not forced or cringey)
- Includes friendly asides or parenthetical comments
- Shows enthusiasm without excessive superlatives
- Maintains knowledgeable friend tone, not lecturer
- Avoids being preachy or condescending

**Seed-Specific Voice:**
- Uses curious/questioning approach ("What if we told you...")
- Takes gentle contrarian perspective vs standard advice
- Remains science-forward but completely accessible
- Weaves in microbiome connections naturally
- Emphasizes precision and bioidentical approaches

### 🔍 SEO Elements Checks
- Primary keyword is present and used naturally throughout
- Has exactly 3 SEO title options (each 50-60 characters)
- URL slug ends with "-guide"
- Meta description exists and is ≤160 characters
- Article description exists and is ≤300 characters
- Primary keyword appears in first 100 words
- Headers include keyword variations naturally

4. **Generate a friendly, clear report:**

Present findings in this format:
```
🔍 Draft Review: [filename]
📅 Generated: [date from file]
📝 Word Count: [X words]

✅ Passed: X/50 checks
⚠️ Issues Found: Y

[Group issues by category, only showing categories with issues]

## 💬 Tone & Voice (X issues)
❌ Line 45: Technical term "endogenous melatonin production" needs a simpler intro first
   Suggestion: "Your body's own melatonin factory (what scientists call endogenous melatonin production)"

❌ Line 78: Paragraph too long (6 sentences). Break it up for easier reading.

❌ Line 112: Missing contractions make it sound stiff
   Current: "It is important to understand that it does not work immediately"
   Better: "It's important to understand that it doesn't work immediately"

[Continue for all categories with issues...]

---
🔧 Would you like me to fix these issues?

Options:
• Type 'all' to fix everything
• Type category names to fix specific areas (e.g., 'tone compliance')
• Type 'none' to skip fixes
• Type 'save' to save this report without fixes
```

5. **Apply fixes based on user response:**

For each category approved:

**Tone fixes:**
- Add contractions throughout
- Break up long paragraphs
- Add plain language intros before technical terms
- Rewrite overly academic sentences conversationally
- Add rhetorical questions where needed
- Insert relatable examples
- Add "Think of it like..." explanations

**Compliance fixes:**
- Replace NO-NO words with approved alternatives
- Remove "supplement" when used with probiotics
- Soften medical claims to approved language
- Remove absolute statements

**Citation fixes:**
- If too few: Flag that manual addition needed
- Fix formatting issues (add missing parentheses, remove commas)
- If too many: Identify and remove citations on basic concepts

**Product reference fixes:**
- Add missing ® symbols
- Fix product name formatting
- Adjust product-focused sections to ingredient-focused

**Structure fixes:**
- Add missing sections with placeholder content
- Fix heading hierarchy
- Add bullet points to Overview if needed

**SEO fixes:**
- Adjust title length if needed
- Add "-guide" to slug if missing
- Trim meta description to 160 chars
- Add keyword to first paragraph if missing

6. **Save the reviewed version:**
- Determine the next version number (if reviewing v1, save as v2)
- Save as `v2-reviewed.md` in the same keyword subfolder
- Show summary of changes made
- Preserve original file

## Important Notes

- This command searches within keyword subfolders in `/Generated-Drafts/`
- Always preserves the original file
- Creates versioned file (v2-reviewed.md) with fixes in the same subfolder
- Automatically detects current version number and increments it
- Some issues (like missing citations) may need manual intervention
- Tone fixes attempt to maintain meaning while improving style
- All fixes follow Seed's brand guidelines