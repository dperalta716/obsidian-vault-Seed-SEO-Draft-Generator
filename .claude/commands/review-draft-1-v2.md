# review-draft-1-v2

Review generated SEO articles against Seed's scientific perspective (Claims docs, NPD Messaging, SciComms) FIRST, then quality/compliance checks.

## Usage

- `/review-draft-1-v2` - Reviews the most recent draft in /Generated-Drafts/
- `/review-draft-1-v2 filename.md` - Reviews a specific file
- `/review-draft-1-v2 keyword` - Reviews draft containing keyword in filename

## What This Command Does

This command performs a **two-tier comprehensive review**:

1. **PRIMARY (40% weight):** Grades article against **Seed's scientific perspective** - Claims documents, NPD Messaging, and relevant SciComms content
2. **SECONDARY (60% weight):** Quality and compliance checks (citations, tone, structure, SEO)

The key innovation: **Smart relevance detection** - only checks for SciComms content that's actually relevant to the article's topic, avoiding unnecessary bloat.

## Implementation

When this command runs:

### STEP 1: File Identification

Identify which file to review (same logic as review-draft-1):
- If no argument: Find most recent v1-*.md file in `/Generated-Drafts/` subdirectories
- If argument looks like filename: Use that specific file
- If argument is keyword: Find keyword folder and use latest version

### STEP 2: Product Auto-Detection

**Scan the article to determine which product it covers:**

1. **Look for explicit product mentions:**
   - DS-01® or "Daily Synbiotic" → DS-01
   - PM-02® or "Sleep + Restore" → PM-02
   - DM-02® or "Daily Multivitamin" → DM-02
   - AM-02® or "Energy + Focus" → AM-02

2. **Check for product-specific ingredients/topics:**
   - Probiotics, microbiome, gut health, strains, synbiotic → DS-01
   - Melatonin → PM-02
   - Multivitamin, comprehensive vitamins/minerals → DM-02
   - Energy, mitochondrial function, nootropics → AM-02

3. **Analyze keyword patterns:**
   - "probiotic", "gut health", "microbiome", "bloating", "digestion", "IBS" → DS-01
   - "sleep", "circadian", "melatonin" → PM-02
   - "multivitamin", "nutrient gaps", "daily vitamin" → DM-02
   - "energy", "focus", "cognitive", "mitochondria" → AM-02

4. **If multiple products detected:** Choose primary focus based on keyword and main content
5. **If unclear:** Default to checking all three NPD products and note this in output

**Load appropriate reference files based on detected product:**

**For DS-01:**
- `Phase 1 Reference Files/Ds-01 Science Reference File.md`
- `Phase 1 Reference Files/SEO Article Sprint - SciCare POV - DS-01 - General.md`
- `Phase 1 Reference Files/Ds-01 PDP.md`
- `Phase 1 Draft Revsions/Phase 1 Reference Files/seed strains.md`

**For NPD products (PM-02/DM-02/AM-02):**
- `/Reference/Claims/[PRODUCT]/[PRODUCT]-General-Claims.md`
- `/Reference/Claims/[PRODUCT]/[PRODUCT]-*-Claims.md` (all ingredient-specific files)
- `/Reference/NPD-Messaging/[PRODUCT] Product Messaging Reference Documents.md`
- `/Reference/SciComms Education Files/[PRODUCT] SciComms [Topic] Education.md`

Also load universal files:
- `/Reference/Compliance/NO-NO-WORDS.md` (or `Phase 1 Reference Files/What we are and are not allowed to say when writing for Seed.md` for DS-01)
- `/Reference/Compliance/What-We-Are-Not-Allowed-To-Say.md`
- `/Reference/Style/Seed-Tone-of-Voice-and-Structure.md` (or `Phase 1 Reference Files/Seed Tone of Voice and Structure.md` for DS-01)
- `/Reference/Style/8-Sample-Reference-Blog-Articles.md` (or `Phase 1 Reference Files/8 Sample Reference Blog Articles.md` for DS-01)

### STEP 3: Relevance Analysis (KEY INNOVATION)

**Before grading, analyze which SciComms content is actually relevant to THIS article:**

1. **Read the article's:**
   - Primary keyword
   - H2/H3 structure
   - Main topics covered
   - Specific ingredients discussed

2. **Identify relevant SciComms sections:**
   - Read through the SciComms Education file for detected product
   - Determine which talking points, narratives, and claims apply to THIS specific article
   - Flag sections that are relevant vs. those that would be bloat

3. **Create a relevance map:**
   ```
   Relevant SciComms Sections:
   - "Why Should you Take a Multivitamin with Microbiome Support" → Highly relevant
   - "The Gut-Nutrition Connection" → Relevant
   - "Nutrient Deficiencies And Inadequacies" → Highly relevant
   - Deep CoQ10 mechanism details → Not relevant for overview article
   ```

**Relevance Criteria:**
- **Highly relevant:** Core to answering the article's primary keyword
- **Relevant:** Provides supporting context or Seed's unique angle
- **Not relevant:** Too detailed, off-topic, or would bloat the article

**IMPORTANT:** Only check for "Highly relevant" and "Relevant" content in subsequent grading. Do NOT flag missing content that's "Not relevant."

### STEP 4: PRIMARY Grading (Most Important - 40% Weight)

Run 15 checks across 3 categories, using product-specific criteria:

## 📋 SEED SCIENTIFIC PERSPECTIVE CHECKS

### A. Claims Document Usage (5 checks - universal)

**Check 1: Uses General Claims file as PRIMARY authority**
- ✅ Pass: Article cites studies directly from [PRODUCT]-General-Claims.md as primary sources
- ❌ Fail: Article uses competitive analysis sources or new research as primary, ignoring Claims docs
- **How to check:** Count citations from General Claims vs. other sources. Claims docs should be >50% of total.
- **Priority:** CRITICAL - This is the most important check

**Check 2: Cites specific studies from Claims docs with proper DOI links**
- ✅ Pass: Uses exact DOI links from Claims documents
- ❌ Fail: Missing Claims doc sources or using different studies
- **How to check:** Cross-reference article citations with Claims document DOI links
- **Priority:** CRITICAL

**Check 3: Approved health claims align with Claims doc language**
- ✅ Pass: Health claims match wording in Claims docs (e.g., "supports immune function" not "boosts immunity")
- ❌ Fail: Uses language not approved in Claims docs
- **How to check:** Compare health claim statements with Claims doc "Claim" sections
- **Priority:** HIGH (compliance issue)

**Check 4: Dose information matches Claims doc substantiation**
- ✅ Pass: When mentioning doses, matches what's in Claims docs
- ❌ Fail: Mentions doses not supported by Claims docs
- **How to check:** Look for any dose mentions and verify against Claims docs
- **Priority:** MEDIUM

**Check 5: Claims properly attributed to ingredients (not product itself)**
- ✅ Pass: Says "DM-02 is formulated with ingredients that support..." or "[ingredient] in DM-02 supports..."
- ❌ Fail: Says "DM-02 supports..." without ingredient attribution
- **How to check:** Scan for product name mentions and verify they use proper attribution format
- **Priority:** HIGH (compliance issue)

### B. Product Messaging Alignment (5 checks - PRODUCT-SPECIFIC)

**For DS-01 Articles:**

**Check 6: Emphasizes strain specificity ("not all probiotics are equal")**
- ✅ Pass: Explains that probiotic benefits are strain-specific, not generic to all probiotics
- ❌ Fail: Treats all probiotics as interchangeable or doesn't emphasize strain-level evidence
- **Why it matters:** This is DS-01's core scientific differentiator
- **Priority:** CRITICAL for DS-01

**Check 7: Discusses gut-[topic] axis connection relevant to the article**
- ✅ Pass: Connects gut health to the article's primary topic (gut-brain, gut-skin, gut-immune, etc.)
- ❌ Fail: Discusses topic in isolation without connecting to gut/microbiome
- **Priority:** CRITICAL for DS-01

**Check 8: Addresses ViaCap® delivery technology and survivability**
- ✅ Pass: Mentions ViaCap® capsule-in-capsule and why delivery matters
- ❌ Fail: Doesn't mention delivery technology or survivability challenge
- **Priority:** HIGH

**Check 9: References clinical trial evidence (Harvard/Health Canada studies)**
- ✅ Pass: Mentions DS-01's clinical trials and specific outcomes
- ❌ Fail: Only uses strain-level studies without finished-product clinical validation
- **Priority:** HIGH

**Check 10: Positions probiotics as complementary to lifestyle (not a magic pill)**
- ✅ Pass: Frames DS-01 alongside diet, exercise, sleep as part of holistic approach
- ❌ Fail: Positions DS-01 as standalone solution or replacement for healthy lifestyle
- **Priority:** MEDIUM

**For DM-02 Articles:**

**Check 6: Addresses soil depletion / modern nutrient gaps narrative**
- ✅ Pass: Discusses how modern agriculture has depleted soil nutrients, even healthy foods lack micronutrients
- ❌ Fail: Doesn't mention soil depletion as foundational reason for supplementation
- **Why it matters:** This is DM-02's core positioning - "you need a multivitamin because food isn't enough anymore"
- **Priority:** CRITICAL for DM-02

**Check 7: Emphasizes bidirectional microbiome-nutrition relationship**
- ✅ Pass: Explains how nutrients shape microbiome AND microbiome produces/affects nutrients (two-way street)
- ❌ Fail: Only discusses one direction or doesn't cover microbiome-nutrition connection
- **Priority:** CRITICAL for DM-02

**Check 8: Discusses ViaCap® precision delivery system**
- ✅ Pass: Explains capsule-in-capsule technology and targeted delivery to microbiome
- ❌ Fail: Doesn't mention ViaCap® or precision delivery
- **Priority:** HIGH

**Check 9: Highlights bioavailability (methylfolate vs folic acid examples)**
- ✅ Pass: Discusses bioavailable forms with specific examples (methylfolate, chelated minerals)
- ❌ Fail: Doesn't emphasize form mattering or lacks specific examples
- **Priority:** HIGH

**Check 10: Critiques mass-market multivitamins (mega-doses, poor forms)**
- ✅ Pass: Positions against standard multivitamin problems (mega-doses, synthetic forms, no microbiome consideration)
- ❌ Fail: Doesn't critique existing products or explain what's wrong with standard approach
- **Priority:** HIGH

**For PM-02 Articles:**

**Check 6: Emphasizes bioidentical/precision melatonin dosing (0.5mg vs 5-10mg)**
- ✅ Pass: Explains Seed's 0.5mg bioidentical approach and contrasts with standard 5-10mg
- ❌ Fail: Doesn't emphasize precision dosing or critique high-dose melatonin
- **Priority:** CRITICAL for PM-02

**Check 7: Explains sleep-gut-brain axis connection**
- ✅ Pass: Discusses how gut, brain, and sleep are interconnected through microbiome
- ❌ Fail: Treats sleep as isolated issue without gut connection
- **Priority:** CRITICAL for PM-02

**Check 8: Discusses dual-phase release mechanism**
- ✅ Pass: Explains how PM-02 releases in two phases to support sleep architecture
- ❌ Fail: Doesn't mention dual-phase or time-release approach
- **Priority:** HIGH

**Check 9: Critiques high-dose melatonin standard practice**
- ✅ Pass: Explains problems with 5-10mg doses (desensitization, overloading system)
- ❌ Fail: Doesn't position against standard high-dose approach
- **Priority:** HIGH

**Check 10: "Not overloading the system" philosophy**
- ✅ Pass: Emphasizes calibrating circadian rhythm vs. pharmacological knockout
- ❌ Fail: Doesn't explain Seed's gentler approach
- **Priority:** MEDIUM

**For AM-02 Articles:**

**Check 6: Emphasizes sustained energy without crash/stimulants**
- ✅ Pass: Positions energy as cellular/mitochondrial, not stimulant-based
- ❌ Fail: Doesn't differentiate from caffeine/stimulant approach
- **Priority:** CRITICAL for AM-02

**Check 7: Explains gut-mitochondria axis connection**
- ✅ Pass: Discusses how gut health affects mitochondrial function and energy
- ❌ Fail: Treats energy as isolated from microbiome
- **Priority:** CRITICAL for AM-02

**Check 8: Focuses on cellular energy optimization (not caffeine)**
- ✅ Pass: Discusses CoQ10, PQQ, and cellular energy production mechanisms
- ❌ Fail: Doesn't emphasize cellular/mitochondrial approach
- **Priority:** HIGH

**Check 9: Highlights nootropic cognitive benefits**
- ✅ Pass: Discusses cognitive function, focus, mental clarity benefits
- ❌ Fail: Only focuses on physical energy without cognitive aspect
- **Priority:** HIGH

**Check 10: Critiques traditional stimulant-based energy products**
- ✅ Pass: Positions against caffeine/stimulant products and their downsides
- ❌ Fail: Doesn't critique standard energy supplement approach
- **Priority:** MEDIUM

### C. SciComms Education Integration (5 checks - smart/relevant only)

**Check 11: Incorporates relevant talking points from SciComms file**
- ✅ Pass: Uses talking points identified as "Highly relevant" or "Relevant" in Step 3
- ❌ Fail: Missing talking points that are relevant to this article's topic
- **How to check:** Compare article content with relevant sections from Step 3 analysis
- **Do NOT flag:** Missing content marked "Not relevant" in Step 3
- **Priority:** HIGH

**Check 12: Uses product-specific narratives where applicable**
- ✅ Pass: Incorporates "Expanded Content Guide" narratives that apply to article topic
- ❌ Fail: Missing applicable narratives from SciComms file
- **Priority:** MEDIUM

**Check 13: Cites additional sources from SciComms docs if relevant**
- ✅ Pass: Uses pre-vetted sources from SciComms file when relevant
- ❌ Fail: Could cite SciComms sources but doesn't
- **Priority:** NICE TO HAVE (don't fail article for this)

**Check 14: Reflects Seed's educational angle on the specific topic**
- ✅ Pass: Matches the educational tone and approach in SciComms files
- ❌ Fail: Takes different angle than Seed's approved education materials
- **Priority:** MEDIUM

**Check 15: Dirk Gevers quote aligns with Seed's unique perspective**
- ✅ Pass: Quote reinforces a key Seed differentiator (microbiome focus, precision approach, etc.)
- ❌ Fail: Quote is generic or doesn't emphasize Seed's unique angle
- **Priority:** MEDIUM

### PRIMARY Grading Scale

**Count checks passed (out of 15):**
- **13-15 passed: Grade A** (Excellent Seed alignment)
- **10-12 passed: Grade B** (Good, minor gaps)
- **7-9 passed: Grade C** (Needs significant work)
- **4-6 passed: Grade D** (Major misalignment)
- **0-3 passed: Grade F** (Complete rewrite needed)

### STEP 5: SECONDARY Quality Checks (60% Weight)

Run all checks from existing review-draft-1 command:

**📊 Citations & Evidence (10 checks)**
- Citation count (must be 12-15)
- Format verification: `([Author Year](DOI_URL))` with NO comma
- DOI links present (http/https)
- Citation density (~1 per 75-100 words for key claims)
- Citations only for: specific studies, quantitative data, mechanisms, health claims
- **NEW:** Check that Claims docs are prioritized over competitive sources

**🏷️ Product References (5 checks)**
- ® symbol present on all NPD product mentions
- Correct format and URLs
- Focus on ingredient story (not product pitch)
- Proper product attribution for claims

**⚖️ Compliance (10 checks)**
- NO-NO-WORDS scan
- No "supplement" with probiotics
- No forbidden medical claims (treat, cure, diagnose, prevent, boost, heal, fix)
- No unapproved health claims
- No absolute statements in medical context

**📝 Structure & Length (8 checks)**
- Word count ≥1300
- Has ### Overview section (3-5 bullets)
- Has ## The Key Insight section
- Has ## Frequently Asked Questions (3-4 questions)
- Contains Dirk Gevers, Ph.D. quote
- Has ## Citations section
- Has internal link suggestions (5-15)
- Proper H2/H3 hierarchy

**💬 Tone & Voice (20 checks)**
- Writing style (you/your, contractions, short paragraphs, varied sentences, active voice)
- Conversational elements (rhetorical questions, relatable scenarios, shared experiences)
- Scientific explanation (plain language first, analogies, "Think of it like...")
- Empathy markers (acknowledges concerns, sensitive to embarrassment, no judgment)
- Personality (light humor, friendly asides, enthusiasm, knowledgeable friend tone)
- Seed-specific voice (curious approach, gentle contrarian, science-forward but accessible)

**🔍 SEO Elements (7 checks)**
- Primary keyword present and natural
- 3 SEO title options (50-60 chars each)
- URL slug ends with "-guide"
- Meta description ≤160 chars
- Article description ≤300 chars
- Keyword in first 100 words
- Headers include keyword variations

### STEP 6: Generate Integrated Report

Present findings in this format:

```
🔍 Draft Review v2: [filename]
📅 Generated: [date from file]
📝 Word Count: [X words]
🎯 Product Detected: [DM-02/PM-02/AM-02]
🔍 Relevant SciComms Sections Identified: [list sections marked relevant in Step 3]

═══════════════════════════════════════════════════
PRIMARY: SEED SCIENTIFIC PERSPECTIVE - GRADE: [A/B/C/D/F] (X/15 checks passed)
═══════════════════════════════════════════════════

📋 A. Claims Document Usage (X/5 checks passed)

[For each failed check, provide:]
❌ [Check name] - Priority: [CRITICAL/HIGH/MEDIUM]
   Issue: [Specific problem found]
   Found: [What the article currently does]
   Missing: [What should be present]
   Fix: [Specific recommendation with line numbers if applicable]

[For passed checks:]
✅ [Check name]
   [Brief note on what was done well]

📋 B. NPD Messaging Alignment - [PRODUCT] (X/5 checks passed)

[Same format as above, using product-specific checks]

📋 C. SciComms Education Integration (X/5 checks passed)

Note: Only checking for content identified as "Relevant" in Step 3
Skipping: [list any "Not relevant" sections]

[Same format as above]

═══════════════════════════════════════════════════
SECONDARY: QUALITY & COMPLIANCE CHECKS
═══════════════════════════════════════════════════

[Show results from all 6 secondary categories]

📊 Citations & Evidence (X/10 checks passed)
[List issues and recommendations]

💬 Tone & Voice (X/20 checks passed)
[List issues and recommendations]

⚖️ Compliance (X/10 checks passed)
[List issues and recommendations]

📝 Structure & Length (X/8 checks passed)
[List issues and recommendations]

🏷️ Product References (X/5 checks passed)
[List issues and recommendations]

🔍 SEO Elements (X/7 checks passed)
[List issues and recommendations]

═══════════════════════════════════════════════════
SUMMARY & RECOMMENDATIONS
═══════════════════════════════════════════════════

Overall Assessment: [Text description based on PRIMARY grade]
- Grade A: "Excellent Seed Alignment - Minor polish needed"
- Grade B: "Good Foundation - Some key elements missing"
- Grade C: "Needs Significant Rework - Missing core Seed perspective"
- Grade D: "Major Misalignment - Substantial rewrite required"
- Grade F: "Complete Rewrite Needed - Does not reflect Seed's positioning"

CRITICAL ISSUES (Must Fix):
[List all Priority: CRITICAL items]

IMPORTANT ISSUES (Should Fix):
[List all Priority: HIGH items]

MINOR ISSUES (Nice to Fix):
[List all Priority: MEDIUM and lower items]

---
🔧 Would you like me to fix these issues?

Options:
• 'all' - Fix everything
• 'critical' - Fix only critical priority issues
• 'seed' - Fix all Seed perspective issues (sections A, B, C)
• 'secondary' - Fix only quality/compliance issues
• 'claims' - Fix only Claims document usage issues
• 'messaging' - Fix only NPD messaging issues
• 'scicomms' - Fix only SciComms integration issues
• [any category name] - Fix specific category (e.g., 'tone', 'compliance', 'citations')
• Multiple categories: 'seed compliance tone' - Fix multiple areas
• 'none' - Skip fixes and end review
• 'save' - Save this report as markdown file without applying fixes
```

### STEP 7: Apply Fixes Based on User Response

Parse user's response and apply appropriate fixes:

**For 'seed' or Seed perspective category fixes (A, B, C):**

1. **Claims Document Integration:**
   - Identify which Claims doc studies should be cited
   - Replace or add citations with proper format: `([Author Year](DOI_URL))`
   - Ensure Claims docs are primary authority (>50% of citations)
   - Add missing health claims with proper attribution language

2. **NPD Messaging Alignment:**
   - **For DM-02:** Add soil depletion section, enhance microbiome-nutrition bidirectional discussion, add ViaCap® section, strengthen bioavailability examples, add critique of mega-dose multivitamins
   - **For PM-02:** Add precision dosing explanation, enhance sleep-gut-brain axis, add dual-phase release section, add high-dose melatonin critique, emphasize "not overloading" philosophy
   - **For AM-02:** Emphasize sustained vs. stimulant energy, enhance gut-mitochondria axis, strengthen cellular energy focus, add nootropic benefits, add stimulant product critique

3. **SciComms Integration:**
   - Add relevant talking points from SciComms file (only those marked relevant)
   - Incorporate applicable narratives from "Expanded Content Guide"
   - Add citations from SciComms docs where appropriate
   - Adjust Dirk Gevers quote if needed to better align with Seed's perspective

**For secondary category fixes:**

Apply fixes as defined in existing review-draft-1 command:
- **Tone fixes:** Add contractions, break up paragraphs, add plain language intros, add analogies
- **Compliance fixes:** Replace NO-NO words, soften medical claims, fix attribution
- **Citation fixes:** Fix formatting, add/remove as needed
- **Product reference fixes:** Add ® symbols, fix links, adjust focus to ingredients
- **Structure fixes:** Add missing sections with appropriate content
- **SEO fixes:** Adjust titles/descriptions, add keyword where missing

### STEP 8: Save Reviewed Version

1. **Determine next version number:**
   - If reviewing v1-[name].md → save as v2-reviewed.md
   - If reviewing v2-[name].md → save as v3-reviewed.md
   - etc.

2. **Save in same keyword subfolder as original**

3. **Show summary:**
   ```
   ✅ Review complete! Saved as: v2-reviewed.md

   Changes applied:
   - [Category 1]: X fixes
   - [Category 2]: Y fixes

   Major improvements:
   - Added soil depletion narrative
   - Integrated 7 Claims document citations
   - Enhanced bioavailability section with methylfolate example
   - Added ViaCap® technology explanation
   ```

4. **Preserve original file (never overwrite)**

## Important Notes

- **Product detection is automatic** but may need manual override in ambiguous cases
- **Relevance analysis is key** - prevents forcing irrelevant SciComms content
- **PRIMARY checks are most important** - these catch fundamental misalignment with Seed's perspective
- **Grading is hierarchical** - PRIMARY grade (A-F) is the headline, secondary is supporting detail
- **Smart about relevance** - only flags missing content that's actually relevant to the article's topic
- **Preserves original files always**
- **Version numbering is automatic**
- **Some issues may need manual intervention** (like writing new sections)
- **All fixes maintain article's core structure** while improving alignment with Seed's perspective

## Key Differences from review-draft-1

| Aspect | review-draft-1 | review-draft-1-v2 |
|--------|----------------|-------------------|
| **Priority** | All checks equal weight | Seed perspective first (40% weight) |
| **Claims Review** | Not included | Comprehensive Claims doc checking |
| **Messaging Check** | Not included | Product-specific NPD Messaging review |
| **SciComms** | Not included | Smart relevance-based SciComms review |
| **Product Detection** | Manual/implicit | Automatic with smart detection |
| **Grading** | Pass/fail by category | Letter grade for PRIMARY alignment |
| **Report Structure** | Single-tier flat list | Two-tier: PRIMARY then SECONDARY |
| **Relevance** | N/A | Analyzes what's relevant vs. bloat |

## Completion Output Format

When the command completes successfully and saves a new version, ALWAYS end with this exact format:

```
✅ Review complete!

Saved as: [FILENAME]
Location: [FULL_FOLDER_PATH]

Changes applied:
- [Summary of changes]

═══════════════════════════════════════════════════
📝 NEXT STEP (copy and paste this command):
═══════════════════════════════════════════════════

/review-sources-2-v3 [FULL_PATH_TO_FILE_JUST_CREATED]
```

**CRITICAL:** The file path in the NEXT STEP must be the ACTUAL file that was just saved. Use the exact path including the version number that was created (e.g., `v3-reviewed.md`).
