# review-draft-seed-perspective-ds01

Review generated SEO articles against **Seed's scientific perspective for DS-01** (DS-01 Science Reference, SciCare POV, DS-01 PDP, Seed Strains). Run this FIRST before quality checks.

## Usage

- `/review-draft-seed-perspective-ds01` - Reviews the most recent draft in /Generated-Drafts/
- `/review-draft-seed-perspective-ds01 filename.md` - Reviews a specific file
- `/review-draft-seed-perspective-ds01 keyword` - Reviews draft containing keyword in filename

## What This Command Does

This command grades DS-01 articles against **Seed's scientific perspective** across 3 categories:
1. **Claims Document Usage** (5 checks) - Uses DS-01 Science Reference File as primary authority
2. **SciCare POV Alignment** (5 checks) - Reflects DS-01-specific positioning from SciCare POV
3. **DS-01 Differentiator Integration** (5 checks) - Incorporates Seed's unique DS-01 angles

**Total: 15 checks → Letter Grade (A-F)**

## When to Use This

**Run FIRST to verify Seed perspective**, then run `/review-draft-1-v2` for quality/compliance checks.

```
Workflow:
1. /review-draft-seed-perspective-ds01 → Grade Seed alignment (A-F)
2. If Grade A-B → /review-draft-1-v2 for quality polish
3. If Grade C-F → Fix Seed issues first, then quality check
```

## What This Command Does NOT Check

- Citation formatting
- Tone of voice
- Compliance with NO-NO words
- Article structure
- SEO elements

(Use `/review-draft-1-v2` for these checks)

## Implementation

### STEP 1: File Identification

Identify which file to review:
- If no argument: Find most recent v1-*.md file in `/Generated-Drafts/` subdirectories
- If argument looks like filename: Use that specific file
- If argument is keyword: Find keyword folder and use latest version

### STEP 2: Confirm DS-01 Product & Load Reference Files

**This command is specifically for DS-01 articles.** Verify the article is DS-01 content by scanning for:
- DS-01® or "Daily Synbiotic" mentions
- Probiotic/microbiome/gut health focus
- Strain references (Bifidobacterium, Lactobacillus, etc.)

**If the article appears to be NPD content (PM-02/DM-02/AM-02), warn the user** and suggest using `/review-draft-seed-perspective` instead.

**Load DS-01 reference files:**

**Tier 1 - Evidence Authority:**
- `Phase 1 Reference Files/Ds-01 Science Reference File.md` (full file)
- `Phase 1 Reference Files/Ds-01 PDP.md` (full file)

**Tier 1 - SciCare POV (SELECTIVE LOADING - DO NOT load the full 52K-word file):**
- `Phase 1 Reference Files/SciCare-POV-Section-Index.md` ← **Read this FIRST**
- Then load ONLY the 2-4 sections relevant to the article's keyword (see Section Index for line ranges)
- Use the Read tool with `offset` and `limit` parameters to load specific sections from:
  `Phase 1 Reference Files/SEO Article Sprint - SciCare POV - DS-01 - General.md`
- Example: For a "probiotics for bloating" article, load sections 3 (offset:68, limit:172), 8 (offset:584, limit:80), and 20 (offset:937, limit:28)

**Supporting Documents:**
- `Phase 1 Draft Revsions/Phase 1 Reference Files/seed strains.md`
- `Phase 1 Reference Files/What we are and are not allowed to say when writing for Seed.md`
- `Phase 1 Reference Files/Seed Tone of Voice and Structure.md`
- `Phase 1 Reference Files/8 Sample Reference Blog Articles.md`
- `Reference/Compliance/NO-NO-WORDS.md`

### STEP 3: Relevance Analysis via Section Index (KEY INNOVATION)

**Instead of loading the full 52K-word SciCare POV, selectively load only relevant sections:**

1. **Read the article's:**
   - Primary keyword
   - H2/H3 structure
   - Main topics covered
   - Specific health areas discussed (digestive, skin, cardiovascular, immune, etc.)

2. **Consult the Section Index:**
   - Read `Phase 1 Reference Files/SciCare-POV-Section-Index.md`
   - Match the article's keyword against the "Keywords" column and "Common Article-to-Section Mappings" table
   - Identify 2-4 sections to load (typically 1-2 highly relevant + 1-2 supporting)

3. **Load selected sections:**
   - Use the Read tool with `offset` and `limit` from the Section Index
   - Source file: `Phase 1 Reference Files/SEO Article Sprint - SciCare POV - DS-01 - General.md`
   - Example for "probiotics for bloating":
     ```
     Section 3 (benefits/regularity): offset=68, limit=172
     Section 8 (side effects/gas): offset=584, limit=80
     Section 20 (IBS): offset=937, limit=28
     ```

4. **Create a relevance map:**
   ```
   Loaded SciCare POV Sections:
   - Section 3: "Should I take probiotics / regularity" → Highly relevant
   - Section 8: "Do probiotics make you poop / gas" → Highly relevant
   - Section 20: "IBS" → Relevant (supporting context)

   Skipped (not loaded):
   - Section 22: Skin → Not relevant for digestive article
   - Section 25: Gut-brain axis → Not relevant
   ```

**Relevance Criteria:**
- **Highly relevant:** Core to answering the article's primary keyword
- **Relevant:** Provides supporting context or Seed's unique angle
- **Not relevant:** Too detailed, off-topic, or would bloat the article

**IMPORTANT:** Only check for content from sections you loaded. Do NOT flag missing content from sections that aren't relevant to the article's topic.

### STEP 4: Grade Against 15 Seed Perspective Checks

## 📋 SEED SCIENTIFIC PERSPECTIVE CHECKS (DS-01)

### A. Claims Document Usage (5 checks - DS-01 Science Reference)

**Check 1: Uses DS-01 Science Reference File as PRIMARY authority**
- ✅ Pass: Article cites studies directly from `Ds-01 Science Reference File.md` as primary sources (>50% of citations)
- ❌ Fail: Article uses competitive analysis sources or new research as primary, ignoring DS-01 Science Ref
- **Priority:** CRITICAL

**Check 2: Cites specific studies from DS-01 Science Ref with proper DOI links**
- ✅ Pass: Uses exact DOI links from DS-01 Science Reference
- ❌ Fail: Missing DS-01 Science Ref sources or using different studies for the same claims
- **Priority:** CRITICAL

**Check 3: Health claims are substantively supported by DS-01 reference docs**
- ✅ Pass: Claims are supported by DS-01 Science Ref or SciCare POV, even if phrased casually/conversationally
- ✅ Pass: "helps keep your gut lining strong" when reference says "supports gut barrier integrity" (same substance, casual tone preserved)
- ❌ Fail: Makes claims NOT found in reference docs (e.g., "cures IBS", "treats depression", "boosts immunity")
- **How to check:** Verify the MEANING/SUBSTANCE of the claim is in reference docs, NOT exact wording match
- **Why:** Preserves article's casual, friendly tone while ensuring compliance
- **Priority:** HIGH

**Check 4: Strain-specific claims use correct strain names**
- ✅ Pass: Uses PREFERRED strain names from `seed strains.md` reference
- ❌ Fail: Uses outdated or incorrect strain nomenclature
- **Priority:** MEDIUM

**Check 5: Claims properly attributed to strains/ingredients (not product itself)**
- ✅ Pass: Says "strains in DS-01® have been studied to support..." or "research on [specific strain] shows..."
- ❌ Fail: Says "DS-01® treats..." or "DS-01® cures..." without strain/ingredient attribution
- **Priority:** HIGH (compliance issue)

### B. SciCare POV Alignment (5 checks - DS-01 SPECIFIC)

**Check 6: Emphasizes strain specificity ("not all probiotics are equal")**
- ✅ Pass: Explains that probiotic benefits are strain-specific, not generic to all probiotics
- ❌ Fail: Treats all probiotics as interchangeable or doesn't emphasize strain-level evidence
- **Why it matters:** This is DS-01's core scientific differentiator - benefits are clinically assessed at the strain level
- **Priority:** CRITICAL for DS-01

**Check 7: Discusses gut-[topic] axis connection relevant to the article**
- ✅ Pass: Connects gut health to the article's primary topic (gut-brain axis, gut-skin axis, gut-immune axis, etc.)
- ❌ Fail: Discusses the topic in isolation without connecting to gut/microbiome
- **Priority:** CRITICAL for DS-01

**Check 8: Addresses ViaCap® delivery technology and survivability**
- ✅ Pass: Mentions ViaCap® capsule-in-capsule technology and why delivery matters (most probiotics don't survive digestion)
- ❌ Fail: Doesn't mention delivery technology or survivability challenge
- **Priority:** HIGH

**Check 9: References clinical trial evidence (Harvard/Health Canada studies)**
- ✅ Pass: Mentions DS-01's clinical trials (double-blind, randomized, placebo-controlled) and specific outcomes
- ❌ Fail: Only uses strain-level studies without mentioning finished-product clinical validation
- **Priority:** HIGH

**Check 10: Positions probiotics as complementary to lifestyle (not a magic pill)**
- ✅ Pass: Frames DS-01 alongside diet, exercise, sleep as part of holistic health approach
- ❌ Fail: Positions DS-01 as standalone solution or replacement for healthy lifestyle
- **Priority:** MEDIUM

### C. DS-01 Differentiator Integration (5 checks - smart/relevant only)

**Check 11: Incorporates relevant SciCare POV talking points**
- ✅ Pass: Uses talking points identified as "Highly relevant" or "Relevant" in Step 3
- ❌ Fail: Missing talking points that are relevant to this article's topic
- **Do NOT flag:** Missing content marked "Not relevant" in Step 3
- **Priority:** HIGH

**Check 12: Uses DS-01 benefit-specific narratives where applicable**
- ✅ Pass: Incorporates the correct benefit narrative (digestive, dermatological, cardiovascular, immune, micronutrient) for the article's topic
- ❌ Fail: Missing applicable benefit narratives from SciCare POV or DS-01 Science Ref
- **Priority:** MEDIUM

**Check 13: Cites DS-01's clinical trial data where relevant**
- ✅ Pass: Uses clinical trial outcomes (e.g., "400% growth of beneficial bacteria", "improved abdominal discomfort", serum serotonin increase) when relevant to article
- ❌ Fail: Could cite clinical trial data but doesn't
- **Priority:** NICE TO HAVE (don't fail article for this)

**Check 14: Reflects Seed's educational angle on the specific topic**
- ✅ Pass: Matches the SciCare POV educational tone and approach (informed but accessible, acknowledges limitations of research)
- ❌ Fail: Takes different angle than Seed's approved education materials
- **Priority:** MEDIUM

**Check 15: Dirk Gevers quote aligns with Seed's unique DS-01 perspective**
- ✅ Pass: Quote reinforces a key DS-01 differentiator (strain specificity, precision delivery, microbiome science, clinical validation)
- ❌ Fail: Quote is generic wellness advice or doesn't emphasize Seed's unique angle
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
🔍 Seed Perspective Review (DS-01): [filename]
📝 Word Count: [X words]
🎯 Product: DS-01® Daily Synbiotic
🔍 Relevant SciCare POV Sections: [list sections marked relevant in Step 3]

═══════════════════════════════════════════════════
SEED SCIENTIFIC PERSPECTIVE (DS-01) - GRADE: [A/B/C/D/F]
Checks Passed: X/15
═══════════════════════════════════════════════════

📋 A. Claims Document Usage - DS-01 Science Ref (X/5 checks passed)

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
❌ Uses DS-01 Science Ref as PRIMARY authority - Priority: CRITICAL
   Issue: Only 2 of 14 citations come from DS-01 Science Reference File
   Found: Majority of citations from competitive analysis sources
   Missing: Clinical trial data (Napier et al.), strain-specific studies (BB536, LP01, BR03)
   Fix: Replace competitive sources with DS-01 Science Ref studies for digestive claims

✅ Health claims substantively supported by reference docs
   Note: Article says "helps keep things moving" which aligns with "supports bowel movement regularity"
         Casual tone preserved ✓ Substance matches ✓

📋 B. SciCare POV Alignment - DS-01 (X/5 checks passed)

❌ Emphasizes strain specificity - Priority: CRITICAL
   Issue: Article discusses "probiotics" generically without strain-level evidence
   Seed says: "Benefits are clinically assessed and demonstrated at the strain level"
   Fix: Add specific strain references when discussing benefits (e.g., "strains like B. longum BB536")

✅ Discusses gut-[topic] axis connection
   Strong: Good explanation of gut-brain axis with microbiome connection

[Continue for all checks...]

📋 C. DS-01 Differentiator Integration (X/5 checks passed)

Note: Only checking content identified as "Relevant" in Step 3
Skipping as not relevant: [list any "Not relevant" sections]

Relevant sections for this article:
- "DS Benefits - Digestive" ✅ Incorporated
- "GALT / Gut Barrier Integrity / SCFAs" ✅ Incorporated
- "DS Benefits - Cardiovascular" ❌ Not relevant, correctly omitted

[Continue...]

═══════════════════════════════════════════════════
SUMMARY & RECOMMENDATIONS
═══════════════════════════════════════════════════

Overall Assessment: [Text description based on grade]
- Grade A: "Excellent Seed Alignment - Ready for quality review with /review-draft-1-v2"
- Grade B: "Good Foundation - Address minor gaps then run /review-draft-1-v2"
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
• 'scicare' - Fix only SciCare POV alignment issues
• 'differentiators' - Fix only DS-01 differentiator issues
• 'claims scicare' - Fix multiple categories
• 'none' - Skip fixes and end review
• 'save' - Save this report as markdown file without applying fixes

📝 NEXT STEP: After fixing Seed perspective issues and achieving Grade A or B,
            run /review-draft-1-v2 to check quality, tone, compliance, and SEO.
```

### STEP 6: Apply Fixes Based on User Response

Parse user's response and apply appropriate fixes:

**⚠️ CRITICAL: File Handling Protocol**

**BEFORE making ANY edits, you MUST:**
1. **First, create the new version file** (e.g., `v2-seed-perspective-reviewed.md`) by using the Write tool to copy the ENTIRE original content to the new file
2. **Make ALL edits to the new file ONLY** using the Edit tool on the new file path
3. **NEVER modify the original v1 file** - it must remain untouched

This ensures the original is always preserved and avoids needing to restore it later.

**For 'all' or 'critical' or specific categories:**

**Claims Document Integration (DS-01):**
- Identify which DS-01 Science Ref studies should be cited
- Replace or add citations with proper format: `([Author Year](DOI_URL))`
- Ensure DS-01 Science Ref is primary authority (>50% of citations)
- Add missing health claims with proper attribution language ("strains in DS-01® have been studied to...")
- Use correct PREFERRED strain names from seed strains reference
- **Preserve casual tone** when incorporating claims

**SciCare POV Alignment:**
- Add strain specificity emphasis where probiotics are discussed generically
- Enhance gut-[topic] axis connection relevant to the article
- Add ViaCap® delivery technology mention if missing
- Reference clinical trial evidence (Harvard/Health Canada) where appropriate
- Ensure probiotics positioned as complementary to lifestyle, not magic pill

**DS-01 Differentiator Integration:**
- Add relevant SciCare POV talking points (only those marked relevant in Step 3)
- Incorporate applicable DS-01 benefit narratives
- Add clinical trial data citations where appropriate
- Adjust Dirk Gevers quote if needed to better align with DS-01's unique perspective

### STEP 7: Save Reviewed Version

1. **Determine next version number:**
   - If reviewing v1-[name].md → save as v2-seed-perspective-reviewed.md
   - If reviewing v2-[name].md → save as v3-seed-perspective-reviewed.md
   - etc.

2. **Save in same keyword subfolder as original**

3. **Show summary with COPY-PASTE READY next command:**
   ```
   ✅ Seed Perspective Review (DS-01) complete!

   Grade: B (Good foundation - minor gaps addressed)

   Saved as: v2-seed-perspective-reviewed.md

   Changes applied:
   - Claims: Added 5 citations from DS-01 Science Reference File
   - SciCare: Added strain specificity emphasis and ViaCap® section
   - Differentiators: Incorporated clinical trial outcomes

   ═══════════════════════════════════════════════════
   📝 NEXT STEP (copy and paste this command):
   ═══════════════════════════════════════════════════

   /review-draft-1-v2 [FULL_PATH_TO_V2_FILE]

   Example:
   /review-draft-1-v2 Seed-SEO-Draft-Generator-v4/Generated-Drafts/066-probiotics-for-bloating/v2-seed-perspective-reviewed.md
   ```

   **IMPORTANT:** The next step command MUST include:
   - The correct review command (`/review-draft-1-v2`)
   - The FULL relative path from the vault root to the v2 file that was just created
   - This allows the user to simply copy and paste the command without searching for the file

4. **Original file is NEVER modified** (edits only made to new v2 file per STEP 6 protocol)

## Important Notes

- **This command is for DS-01 articles ONLY** - use `/review-draft-seed-perspective` for NPD (PM-02/DM-02/AM-02)
- **This command checks SEED PERSPECTIVE ONLY** - not quality, tone, or compliance
- **Run this FIRST** before `/review-draft-1-v2`
- **Check #3 preserves casual tone** - verifies substance of claims, not exact wording
- **Smart relevance detection** - only flags missing content that's relevant to the topic
- **Grading is strict** - Grade A/B means Seed perspective is solid, proceed to quality review
- **Grade C or lower** - fix Seed issues before bothering with quality checks
- **NEVER modify the original file** - always create v2 copy FIRST, then edit only the copy
- **Version numbering includes "seed-perspective-reviewed"** to distinguish from quality reviews
- **Completion output includes copy-paste ready next command** with full file path

## Workflow Integration

```
DS-01 Draft Generation → /review-draft-seed-perspective-ds01 → Grade A/B? → /review-draft-1-v2 → Done
                                                              ↓
                                                           Grade C-F? → Fix & Re-review
```

**Why This Workflow?**
- Catches fundamental Seed perspective issues first
- Avoids wasting time polishing tone/SEO if core perspective is wrong
- Keeps each command focused and non-bloated
- Two-step process ensures both Seed alignment AND quality

## Completion Output Format

When the command completes successfully and saves a new version, ALWAYS end with this exact format:

```
✅ Seed Perspective Review (DS-01) complete!

Grade: [GRADE] ([description])

Saved as: [FILENAME]
Location: [FULL_FOLDER_PATH]

Changes applied:
- [Summary of changes]

═══════════════════════════════════════════════════
📝 NEXT STEP (copy and paste this command):
═══════════════════════════════════════════════════

/review-draft-1-v2 [FULL_PATH_TO_FILE_JUST_CREATED]
```

**CRITICAL:** The file path in the NEXT STEP must be the ACTUAL file that was just saved. Use the exact path including the version number that was created (e.g., `v2-seed-perspective-reviewed.md`).
