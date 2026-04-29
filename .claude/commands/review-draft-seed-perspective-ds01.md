# review-draft-seed-perspective-ds01

Review generated SEO articles against **Seed's scientific perspective for DS-01** using the 2026 Messaging Reference Documents (POV, Claims Library, Product Positioning, Timeline of Benefits). Run this FIRST before quality checks.

## Usage

- `/review-draft-seed-perspective-ds01` - Reviews the most recent draft in /Generated-Drafts/
- `/review-draft-seed-perspective-ds01 filename.md` - Reviews a specific file
- `/review-draft-seed-perspective-ds01 keyword` - Reviews draft containing keyword in filename

## What This Command Does

This command grades DS-01 articles against **Seed's scientific perspective** across 3 categories:
1. **Claims Library Compliance** (5 checks) - Uses Claims Library as primary authority for product claims
2. **POV & Messaging Alignment** (5 checks) - Reflects DS-01 positioning from 2026 POV and Product Positioning docs
3. **DS-01 Differentiator Integration** (5 checks) - Incorporates Seed's unique DS-01 angles from Timeline of Benefits and messaging pillars

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

**If the article appears to be NPD content (PM-02/DM-02/AM-02), warn the user** and suggest using `/review-draft-seed-perspective` instead.

**Load DS-01 reference files:**

**Tier 1 - Science & Claims Authority:**
- `Reference/2026-03 DS-01 Updated Messaging Reference Files/POV_ 27APR2026.md`
- `Reference/2026-03 DS-01 Updated Messaging Reference Files/New MRD/DS-01® Messaging + Positioning Reference Document • Claims Library.md`

**Tier 2 - Messaging Strategy:**
- `Reference/2026-03 DS-01 Updated Messaging Reference Files/New MRD/DS-01® Messaging + Positioning Reference Document • Product Positioning.md`
- `Reference/2026-03 DS-01 Updated Messaging Reference Files/New MRD/DS-01® Messaging + Positioning Reference Document • Timeline of Benefits + Mechanisms.md`
- `Reference/2026-03 DS-01 Updated Messaging Reference Files/New MRD/DS-01® Messaging + Positioning Reference Document • Product Topline messaging.md`

**Tier 3 - Compliance:**
- `Reference/2026-03 DS-01 Updated Messaging Reference Files/New MRD/DS-01® Messaging + Positioning Reference Document - disclaimer cheat sheet.md`
- `Reference/Compliance/NO-NO-WORDS.md`
- `Phase 1 Reference Files/What we are and are not allowed to say when writing for Seed.md`

### STEP 3: Identify Article Topics for Relevance Assessment

1. **Read the article's:**
   - Primary keyword
   - H2/H3 structure
   - Main topics covered
   - Specific health areas discussed (digestive, skin, immune, etc.)

2. **Map to messaging pillars:**
   - Is this a bloating/gas/regularity article? → Conversion messaging (Liberate Your Gut)
   - Is this a survivability/formulation article? → Consideration messaging (Engineered to Survive)
   - Is this a general probiotic/trust article? → Awareness messaging (Proven Probiotic Standard)
   - Is this about long-term/systemic benefits? → Retention messaging (Unlock the Potential)

3. **Map to Timeline of Benefits phases:**
   - Which phases (Restore/Rebalance/Optimize) are relevant to the article's topic?

### STEP 4: Grade Against 15 Seed Perspective Checks

## SEED SCIENTIFIC PERSPECTIVE CHECKS (DS-01)

### A. Claims Library Compliance (5 checks)

**Check 1: DS-01 product claims use EXACT language from Claims Library**
- ✅ Pass: All product-specific claims match approved language from Claims Library (casual paraphrasing of general science is fine, but product claims must be exact)
- ❌ Fail: Product claims use unapproved language or make claims not in the Claims Library
- **Priority:** CRITICAL

**Check 2: Required disclaimers present for all claims**
- ✅ Pass: All claims include the correct disclaimer symbols (°, **, ††, †, etc.) per the Disclaimer Cheatsheet
- ❌ Fail: Missing mandatory disclaimers on product claims
- **Priority:** CRITICAL

**Check 3: Health claims are substantively supported by reference docs**
- ✅ Pass: Claims are supported by POV document or Claims Library, even if phrased casually/conversationally
- ✅ Pass: "helps keep your gut lining strong" when reference says "supports gut barrier integrity" (same substance, casual tone preserved)
- ❌ Fail: Makes claims NOT found in reference docs (e.g., "cures IBS", "treats depression", "boosts immunity")
- **How to check:** Verify the MEANING/SUBSTANCE of the claim is in reference docs, NOT exact wording match
- **Priority:** HIGH

**Check 4: No individual strain names called out**
- ✅ Pass: Uses formulation-level language ("24-strain probiotic + prebiotic", "clinically validated formulation")
- ✅ Pass: Uses Lactobacillus/Bifidobacterium genera when discussing mechanisms broadly
- ❌ Fail: Names individual strains (e.g., "B. longum BB536", "L. rhamnosus GG")
- **Priority:** HIGH

**Check 5: Claims properly attributed (ingredients/formulation, not product making medical claims)**
- ✅ Pass: Says "clinically shown to reduce bloating" (approved Claims Library language) or "formulated with strains that support regularity"
- ❌ Fail: Says "DS-01® treats..." or "DS-01® cures..."
- **Priority:** HIGH (compliance issue)

### B. POV & Messaging Alignment (5 checks)

**Check 6: Reflects key POV positions (transient nature, mechanisms, fermented foods distinction)**
- ✅ Pass: Where relevant to the article's topic, reflects the POV document's positions on probiotic science
- ❌ Fail: Contradicts POV positions (e.g., claims probiotics colonize the gut, conflates fermented foods with probiotics)
- **Priority:** CRITICAL

**Check 7: Discusses gut-[topic] axis connection relevant to the article**
- ✅ Pass: Connects gut health to the article's primary topic (gut-brain axis, gut-skin axis, gut-immune axis, etc.)
- ❌ Fail: Discusses the topic in isolation without connecting to gut/microbiome
- **Priority:** HIGH

**Check 8: Addresses ViaCap® delivery technology and survivability**
- ✅ Pass: Mentions ViaCap® capsule-in-capsule technology and why delivery matters (most probiotics don't survive digestion)
- ❌ Fail: Doesn't mention delivery technology or survivability challenge
- **Priority:** HIGH

**Check 9: References clinical trial evidence (Allegretti et al. 2026, n=350)**
- ✅ Pass: Mentions DS-01's clinical trial (randomized, placebo-controlled, n=350) and specific outcomes
- ❌ Fail: Only uses general research without mentioning DS-01's clinical validation
- **Priority:** HIGH

**Check 10: Positions probiotics as complementary to lifestyle (not a magic pill)**
- ✅ Pass: Frames DS-01 alongside diet, exercise, sleep as part of holistic health approach
- ❌ Fail: Positions DS-01 as standalone solution or replacement for healthy lifestyle
- **Priority:** MEDIUM

### C. DS-01 Differentiator Integration (5 checks)

**Check 11: Incorporates relevant messaging pillar talking points**
- ✅ Pass: Uses talking points from the appropriate messaging pillar(s) identified in Step 3
- ❌ Fail: Missing key messaging pillar content relevant to the article's topic
- **Do NOT flag:** Missing content from messaging pillars not relevant to this article
- **Priority:** HIGH

**Check 12: Uses Timeline of Benefits phasing where applicable**
- ✅ Pass: When discussing "what to expect" or timeline-related content, uses the Restore/Rebalance/Optimize framework with appropriate proof points
- ❌ Fail: Could benefit from timeline phasing but doesn't include it
- **Priority:** MEDIUM

**Check 13: Cites DS-01's clinical trial data where relevant**
- ✅ Pass: Uses clinical trial outcomes (e.g., "72% reported rarely feeling bloated", "nearly 80% reported hardly any constipation-related discomfort") when relevant
- ❌ Fail: Could cite clinical trial data but doesn't
- **Priority:** NICE TO HAVE (don't fail article for this)

**Check 14: Reflects Seed's educational angle on the specific topic**
- ✅ Pass: Follows the POV document's guidance on disease discussion (separate general research from product context, avoid implied claims)
- ❌ Fail: Makes implied claims about DS-01 for specific conditions
- **Priority:** MEDIUM

**Check 15: Dirk Gevers quote aligns with Seed's unique DS-01 perspective**
- ✅ Pass: Quote reinforces a key DS-01 differentiator (clinical validation, precision delivery, microbiome science)
- ❌ Fail: Quote is generic wellness advice or focuses on individual strains
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
Seed Perspective Review (DS-01): [filename]
Word Count: [X words]
Product: DS-01® Daily Synbiotic
Relevant Messaging Pillars: [list from Step 3]
Relevant Timeline Phases: [list from Step 3]

═══════════════════════════════════════════════════
SEED SCIENTIFIC PERSPECTIVE (DS-01) - GRADE: [A/B/C/D/F]
Checks Passed: X/15
═══════════════════════════════════════════════════

A. Claims Library Compliance (X/5 checks passed)

[For each failed check, provide:]
❌ [Check name] - Priority: [CRITICAL/HIGH/MEDIUM]
   Issue: [Specific problem found]
   Found: [What the article currently does]
   Missing: [What should be present]
   Fix: [Specific recommendation with line numbers if applicable]

[For passed checks:]
✅ [Check name]
   [Brief note on what was done well]

B. POV & Messaging Alignment (X/5 checks passed)
[Continue for all checks...]

C. DS-01 Differentiator Integration (X/5 checks passed)
[Continue for all checks...]

═══════════════════════════════════════════════════
SUMMARY & RECOMMENDATIONS
═══════════════════════════════════════════════════

CRITICAL ISSUES (Must Fix):
[List all Priority: CRITICAL items]

IMPORTANT ISSUES (Should Fix):
[List all Priority: HIGH items]

MINOR ISSUES (Nice to Fix):
[List all Priority: MEDIUM items]

---
Would you like me to fix these issues?

Options:
• 'all' - Fix everything
• 'critical' - Fix only critical priority issues
• 'claims' - Fix only Claims Library compliance issues
• 'messaging' - Fix only POV & messaging alignment issues
• 'differentiators' - Fix only DS-01 differentiator issues
• 'none' - Skip fixes and end review
• 'save' - Save this report as markdown file without applying fixes

NEXT STEP: After fixing Seed perspective issues and achieving Grade A or B,
            run /review-draft-1-v2 to check quality, tone, compliance, and SEO.
```

### STEP 6: Apply Fixes Based on User Response

Parse user's response and apply appropriate fixes:

**CRITICAL: File Handling Protocol**

**BEFORE making ANY edits, you MUST:**
1. **First, create the new version file** (e.g., `v2-seed-perspective-reviewed.md`) by using the Write tool to copy the ENTIRE original content to the new file
2. **Make ALL edits to the new file ONLY** using the Edit tool on the new file path
3. **NEVER modify the original v1 file** - it must remain untouched

**For 'all' or 'critical' or specific categories:**

**Claims Library Compliance:**
- Ensure all DS-01 product claims use exact Claims Library language
- Add missing disclaimers per Disclaimer Cheatsheet
- Remove any individual strain name references — use formulation-level language
- Ensure claims are attributed to ingredients/formulation, not product making medical claims

**POV & Messaging Alignment:**
- Add POV-aligned science positions where missing
- Enhance gut-[topic] axis connection relevant to the article
- Add ViaCap® delivery technology mention if missing
- Reference Allegretti et al. 2026 clinical trial where appropriate
- Ensure probiotics positioned as complementary to lifestyle

**DS-01 Differentiator Integration:**
- Add relevant messaging pillar talking points
- Incorporate Timeline of Benefits phasing where applicable
- Add clinical trial data citations where appropriate
- Adjust Dirk Gevers quote if needed to avoid strain-level focus

### STEP 7: Save Reviewed Version

1. **Determine next version number:**
   - If reviewing v1-[name].md → save as v2-seed-perspective-reviewed.md
   - If reviewing v2-[name].md → save as v3-seed-perspective-reviewed.md

2. **Save in same keyword subfolder as original**

3. **Show summary with COPY-PASTE READY next command:**
   ```
   ✅ Seed Perspective Review (DS-01) complete!

   Grade: [GRADE] ([description])

   Saved as: [FILENAME]
   Location: [FULL_FOLDER_PATH]

   Changes applied:
   - [Summary of changes]

   ═══════════════════════════════════════════════════
   NEXT STEP (copy and paste this command):
   ═══════════════════════════════════════════════════

   /review-draft-1-v2 [FULL_PATH_TO_FILE_JUST_CREATED]
   ```

4. **Original file is NEVER modified**

## Important Notes

- **This command is for DS-01 articles ONLY** - use `/review-draft-seed-perspective` for NPD (PM-02/DM-02/AM-02)
- **This command checks SEED PERSPECTIVE ONLY** - not quality, tone, or compliance
- **Run this FIRST** before `/review-draft-1-v2`
- **Check #3 preserves casual tone** - verifies substance of claims, not exact wording
- **Smart relevance detection** - only flags missing content that's relevant to the topic
- **No individual strain names** - all references should be formulation-level
- **NEVER modify the original file** - always create v2 copy FIRST, then edit only the copy

## Workflow Integration

```
DS-01 Draft Generation → /review-draft-seed-perspective-ds01 → Grade A/B? → /review-draft-1-v2 → Done
                                                              ↓
                                                           Grade C-F? → Fix & Re-review
```
