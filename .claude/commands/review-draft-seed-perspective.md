# review-draft-seed-perspective

Review generated SEO articles against **Seed's scientific perspective ONLY** (Claims docs, NPD Messaging, SciComms). Run this FIRST before quality checks.

## Usage

- `/review-draft-seed-perspective` - Reviews the most recent draft in /Generated-Drafts/
- `/review-draft-seed-perspective filename.md` - Reviews a specific file
- `/review-draft-seed-perspective keyword` - Reviews draft containing keyword in filename

## What This Command Does

This command grades articles against **Seed's scientific perspective** across 3 categories:
1. **Claims Document Usage** (5 checks) - Uses our pre-approved sources as primary authority
2. **NPD Messaging Alignment** (5 checks) - Reflects product-specific positioning
3. **SciComms Education Integration** (5 checks) - Incorporates relevant educational content

**Total: 15 checks → Letter Grade (A-F)**

## When to Use This

**Run FIRST to verify Seed perspective**, then run `/review-draft-1` for quality/compliance checks.

```
Workflow:
1. /review-draft-seed-perspective → Grade Seed alignment (A-F)
2. If Grade A-B → /review-draft-1 for quality polish
3. If Grade C-F → Fix Seed issues first, then quality check
```

## What This Command Does NOT Check

- Citation formatting
- Tone of voice
- Compliance with NO-NO words
- Article structure
- SEO elements

(Use `/review-draft-1` for these checks)

## Implementation

### STEP 1: File Identification

Identify which file to review:
- If no argument: Find most recent v1-*.md file in `/Generated-Drafts/` subdirectories
- If argument looks like filename: Use that specific file
- If argument is keyword: Find keyword folder and use latest version

### STEP 2: Product Auto-Detection

**Scan the article to determine which product it covers:**

1. **Look for explicit product mentions:**
   - PM-02® or "Sleep + Restore" → PM-02
   - DM-02® or "Daily Multivitamin" → DM-02
   - AM-02® or "Energy + Focus" → AM-02

2. **Check for product-specific ingredients:**
   - Melatonin → PM-02
   - Multivitamin, comprehensive vitamins/minerals → DM-02
   - Energy, mitochondrial function, nootropics → AM-02

3. **Analyze keyword patterns:**
   - "sleep", "circadian", "melatonin" → PM-02
   - "multivitamin", "nutrient gaps", "daily vitamin" → DM-02
   - "energy", "focus", "cognitive", "mitochondria" → AM-02

4. **If multiple products detected:** Choose primary focus based on keyword and main content
5. **If unclear:** Default to checking all three products and note this in output

**Load appropriate reference files based on detected product:**
- `/Reference/Claims/[PRODUCT]/[PRODUCT]-General-Claims.md`
- `/Reference/Claims/[PRODUCT]/[PRODUCT]-*-Claims.md` (all ingredient-specific files)
- `/Reference/NPD-Messaging/[PRODUCT] Product Messaging Reference Documents.md`
- `/Reference/SciComms Education Files/[PRODUCT] SciComms [Topic] Education.md`

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

### STEP 4: Grade Against 15 Seed Perspective Checks

## 📋 SEED SCIENTIFIC PERSPECTIVE CHECKS

### A. Claims Document Usage (5 checks - universal)

**Check 1: Uses General Claims file as PRIMARY authority**
- ✅ Pass: Article cites studies directly from [PRODUCT]-General-Claims.md as primary sources (>50% of citations)
- ❌ Fail: Article uses competitive analysis sources or new research as primary, ignoring Claims docs
- **Priority:** CRITICAL

**Check 2: Cites specific studies from Claims docs with proper DOI links**
- ✅ Pass: Uses exact DOI links from Claims documents
- ❌ Fail: Missing Claims doc sources or using different studies
- **Priority:** CRITICAL

**Check 3: Health claims are substantively supported by Claims docs**
- ✅ Pass: Claims are supported by Claims docs, even if phrased casually/conversationally
- ✅ Pass: "helps your body unwind" when Claims doc says "helps improve sleep onset" (same substance, casual tone preserved)
- ❌ Fail: Makes claims NOT found in Claims docs (e.g., "cures insomnia", "treats anxiety", "boosts immunity")
- **How to check:** Verify the MEANING/SUBSTANCE of the claim is in Claims docs, NOT exact wording match
- **Why:** Preserves article's casual, friendly tone while ensuring compliance
- **Priority:** HIGH

**Check 4: Dose information matches Claims doc substantiation**
- ✅ Pass: When mentioning doses, matches what's in Claims docs
- ❌ Fail: Mentions doses not supported by Claims docs
- **Priority:** MEDIUM

**Check 5: Claims properly attributed to ingredients (not product itself)**
- ✅ Pass: Says "DM-02 is formulated with ingredients that support..." or "[ingredient] in DM-02 supports..."
- ❌ Fail: Says "DM-02 supports..." without ingredient attribution
- **Priority:** HIGH

### B. NPD Messaging Alignment (5 checks - PRODUCT-SPECIFIC)

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

### Grading Scale

**Count checks passed (out of 15):**
- **13-15 passed: Grade A** (Excellent Seed alignment - ready for quality review)
- **10-12 passed: Grade B** (Good foundation - minor gaps to address)
- **7-9 passed: Grade C** (Needs significant work - missing core Seed perspective)
- **4-6 passed: Grade D** (Major misalignment - substantial rewrite required)
- **0-3 passed: Grade F** (Complete rewrite needed - does not reflect Seed's positioning)

### STEP 5: Generate Focused Report

```
🔍 Seed Perspective Review: [filename]
📝 Word Count: [X words]
🎯 Product Detected: [DM-02/PM-02/AM-02]
🔍 Relevant SciComms Sections: [list sections marked relevant in Step 3]

═══════════════════════════════════════════════════
SEED SCIENTIFIC PERSPECTIVE - GRADE: [A/B/C/D/F]
Checks Passed: X/15
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

Example output:
❌ Uses Claims docs as PRIMARY authority - Priority: CRITICAL
   Issue: Zero citations from DM-02-General-Claims.md
   Found: All citations from competitive analysis sources (Jia 2022, Gaziano 2012)
   Missing: Claims 1 (B vitamin synthesis), Claim 2 (Vitamin K), Claim 6 (Bioavailability), Claim 7 (Bidirectional)
   Fix: Replace [Jia 2022] with https://pmc.ncbi.nlm.nih.gov/articles/PMC4403557/ for B vitamin claim
         Add https://pmc.ncbi.nlm.nih.gov/articles/PMC7928036/ for vitamin K synthesis

✅ Health claims substantively supported by Claims docs
   Note: Article says "helps your body unwind" which aligns with Claims doc "helps improve sleep onset"
         Casual tone preserved ✓ Substance matches ✓

📋 B. NPD Messaging Alignment - [PRODUCT] (X/5 checks passed)

❌ Addresses soil depletion narrative - Priority: CRITICAL
   Issue: Not mentioned in article
   Seed says: "Modern soil depletion means even healthy foods lack nutrients"
   This is THE foundational reason for needing a multivitamin
   Fix: Add section on soil depletion before discussing evidence
        Use stats from SciComms: 34% Vit A deficient, 70% Vit D, 45% Mg

✅ Emphasizes bidirectional microbiome-nutrition relationship
   Strong: Good explanation of microbiome producing vitamins AND using nutrients

[Continue for all checks...]

📋 C. SciComms Education Integration (X/5 checks passed)

Note: Only checking content identified as "Relevant" in Step 3
Skipping as not relevant: [list any "Not relevant" sections]

Relevant sections for this article:
- "Why Should you Take a Multivitamin with Microbiome Support" ✅ Incorporated
- "The Gut-Nutrition Connection" ✅ Incorporated
- "Nutrient Deficiencies And Inadequacies" ❌ Missing

❌ Incorporates relevant talking points - Priority: HIGH
   Missing: Specific nutrient deficiency statistics (34% Vit A, 70% Vit D, 45% Mg)
   Found in SciComms: Bailey 2011 study with specific percentages
   Fix: Add concrete deficiency data to strengthen soil depletion argument

[Continue...]

═══════════════════════════════════════════════════
SUMMARY & RECOMMENDATIONS
═══════════════════════════════════════════════════

Overall Assessment: [Text description based on grade]
- Grade A: "Excellent Seed Alignment - Ready for quality review with /review-draft-1"
- Grade B: "Good Foundation - Address minor gaps then run /review-draft-1"
- Grade C: "Needs Significant Rework - Fix Seed perspective before quality review"
- Grade D: "Major Misalignment - Substantial rewrite required"
- Grade F: "Complete Rewrite Needed - Does not reflect Seed's positioning"

CRITICAL ISSUES (Must Fix):
[List all Priority: CRITICAL items]

IMPORTANT ISSUES (Should Fix):
[List all Priority: HIGH items]

MINOR ISSUES (Nice to Fix):
[List all Priority: MEDIUM items]

---
🔧 Would you like me to fix these issues?

Options:
• 'all' - Fix everything
• 'critical' - Fix only critical priority issues
• 'claims' - Fix only Claims document usage issues
• 'messaging' - Fix only NPD messaging issues
• 'scicomms' - Fix only SciComms integration issues
• 'claims messaging' - Fix multiple categories
• 'none' - Skip fixes and end review
• 'save' - Save this report as markdown file without applying fixes

📝 NEXT STEP: After fixing Seed perspective issues and achieving Grade A or B,
            run /review-draft-1 to check quality, tone, compliance, and SEO.
```

### STEP 6: Apply Fixes Based on User Response

Parse user's response and apply appropriate fixes:

**For 'all' or 'critical' or specific categories:**

**Claims Document Integration:**
- Identify which Claims doc studies should be cited
- Replace or add citations with proper format: `([Author Year](DOI_URL))`
- Ensure Claims docs are primary authority (>50% of citations)
- Add missing health claims with proper attribution language ("DM-02 is formulated with...")
- **Preserve casual tone** when incorporating claims

**NPD Messaging Alignment:**
- **For DM-02:** Add soil depletion section, enhance microbiome-nutrition bidirectional discussion, add ViaCap® section, strengthen bioavailability examples, add critique of mega-dose multivitamins
- **For PM-02:** Add precision dosing explanation, enhance sleep-gut-brain axis, add dual-phase release section, add high-dose melatonin critique, emphasize "not overloading" philosophy
- **For AM-02:** Emphasize sustained vs. stimulant energy, enhance gut-mitochondria axis, strengthen cellular energy focus, add nootropic benefits, add stimulant product critique

**SciComms Integration:**
- Add relevant talking points from SciComms file (only those marked relevant in Step 3)
- Incorporate applicable narratives from "Expanded Content Guide"
- Add citations from SciComms docs where appropriate
- Adjust Dirk Gevers quote if needed to better align with Seed's perspective

### STEP 7: Save Reviewed Version

1. **Determine next version number:**
   - If reviewing v1-[name].md → save as v2-seed-perspective-reviewed.md
   - If reviewing v2-[name].md → save as v3-seed-perspective-reviewed.md
   - etc.

2. **Save in same keyword subfolder as original**

3. **Show summary:**
   ```
   ✅ Seed Perspective Review complete!

   Grade: B (Good foundation - minor gaps addressed)

   Saved as: v2-seed-perspective-reviewed.md

   Changes applied:
   - Claims: Added 7 Citations from DM-02-General-Claims.md
   - Messaging: Added soil depletion narrative and ViaCap® section
   - SciComms: Incorporated relevant nutrient deficiency statistics

   📝 NEXT STEP: Run /review-draft-1 v2-seed-perspective-reviewed.md
                 to check quality, tone, compliance, and SEO.
   ```

4. **Preserve original file (never overwrite)**

## Important Notes

- **This command checks SEED PERSPECTIVE ONLY** - not quality, tone, or compliance
- **Run this FIRST** before `/review-draft-1`
- **Check #3 preserves casual tone** - verifies substance of claims, not exact wording
- **Smart relevance detection** - only flags missing content that's relevant to the topic
- **Product detection is automatic** but may need manual verification
- **Grading is strict** - Grade A/B means Seed perspective is solid, proceed to quality review
- **Grade C or lower** - fix Seed issues before bothering with quality checks
- **Preserves original files always**
- **Version numbering includes "seed-perspective-reviewed"** to distinguish from quality reviews

## Workflow Integration

```
Draft Generation → /review-draft-seed-perspective → Grade A/B? → /review-draft-1 → Done
                                                  ↓
                                               Grade C-F? → Fix & Re-review
```

**Why This Workflow?**
- Catches fundamental Seed perspective issues first
- Avoids wasting time polishing tone/SEO if core perspective is wrong
- Keeps each command focused and non-bloated
- Two-step process ensures both Seed alignment AND quality
