# Seed SEO Draft Generator v4

A specialized Obsidian vault for generating and reviewing SEO-optimized articles for Seed Health's NPD products (PM-02, DM-02, AM-02) using Claude Code.

## 🚀 Quick Start

### 1. Setup as Obsidian Vault
1. Move this folder to your preferred Obsidian vaults location
2. Open Obsidian and select "Open folder as vault"
3. Navigate to this folder and open it

### 2. Activate in Claude Code
1. Open the vault in Claude Code
2. Run the command: `/output-style`
3. Select "seo-content-generator" from the list
4. Claude is now transformed into an SEO specialist!

### 3. Generate & Review Articles

**Generate:**
```
You: should i take a multivitamin
Claude: [Generates complete 1500-1800 word article automatically]
```

**Review (NEW Two-Step Process):**
```
Step 1: /review-draft-seed-perspective    ← Check Seed alignment (Grade A-F)
Step 2: /review-draft-1                   ← Polish quality/compliance
```

## 📁 Vault Structure

```
Seed-SEO-Draft-Generator-v4/
├── .claude/
│   ├── output-styles/              # SEO content generator mode
│   └── commands/
│       ├── review-draft-seed-perspective.md  ← NEW: Seed alignment checker
│       └── review-draft-1.md                  ← Quality/compliance checker
├── Reference/
│   ├── NPD-Messaging/              # Product positioning docs
│   ├── Claims/                     # Clinical evidence (PRIMARY authority)
│   │   ├── DM-02/
│   │   ├── PM-02/
│   │   └── AM-02/
│   ├── SciComms Education Files/   # Educational talking points
│   ├── Compliance/                 # Rules and forbidden terms
│   └── Style/                      # Tone guide and samples
├── Generated-Drafts/               # Your completed articles
│   └── [###]-[keyword]/            # Auto-numbered folders
│       ├── v1-[keyword].md         # Initial draft
│       ├── v2-seed-perspective-reviewed.md   # After Seed review
│       └── v3-reviewed.md          # Final version
└── README.md                       # This file
```

---

## 🔄 The New Review Workflow (v4)

### The Problem We Identified

Initial drafts (especially from Gemini) weren't adhering to Seed's unique positioning:
- ❌ Using competitive sources instead of our Claims documents
- ❌ Missing Seed's core narratives (soil depletion, precision dosing, etc.)
- ❌ Generic industry perspective instead of Seed's differentiated angle
- ❌ Not incorporating relevant SciComms educational content

**Example Issue:**
Article about "should i take a multivitamin" would say *"multivitamins probably don't work"* instead of Seed's position: *"you DO need one because of soil depletion, BUT most are formulated wrong."*

### The Solution: Two-Command Workflow

We've separated **Seed perspective checks** from **quality/compliance checks** to keep each focused.

```
Draft Generated
    ↓
/review-draft-seed-perspective  ← Grade A-F for Seed alignment (15 checks)
    ↓
Grade A-B? → /review-draft-1    ← Polish quality/compliance (60 checks)
Grade C-F? → Fix Seed issues first, then re-review
    ↓
Final Draft Ready
```

---

## 📋 Command 1: `/review-draft-seed-perspective`

**Purpose:** Grade article against Seed's scientific perspective FIRST

**Auto-detects product** (PM-02, DM-02, or AM-02) and applies appropriate checks.

### What It Checks (15 Total)

#### A. Claims Document Usage (5 checks)
✅ Uses our Claims docs as PRIMARY authority (>50% of citations)
✅ Cites specific studies from Claims documents with DOI links
✅ Health claims substantively supported *(preserves casual tone!)*
✅ Dose information matches Claims substantiation
✅ Proper ingredient attribution ("DM-02 is formulated with...")

#### B. NPD Messaging Alignment (5 checks - product-specific)

**For DM-02 articles:**
- Soil depletion / nutrient gaps narrative
- Bidirectional microbiome-nutrition relationship
- ViaCap® precision delivery
- Bioavailability emphasis (methylfolate vs folic acid)
- Critique of mass-market multivitamins

**For PM-02 articles:**
- Precision melatonin dosing (0.5mg vs 5-10mg)
- Sleep-gut-brain axis
- Dual-phase release mechanism
- Critique of high-dose melatonin
- "Not overloading the system" philosophy

**For AM-02 articles:**
- Sustained energy without stimulants
- Gut-mitochondria axis
- Cellular energy optimization
- Nootropic cognitive benefits
- Critique of stimulant-based products

#### C. SciComms Education Integration (5 checks)
✅ Incorporates relevant talking points *(smart: no forced bloat)*
✅ Uses product-specific narratives where applicable
✅ Cites additional sources from SciComms if relevant
✅ Reflects Seed's educational angle
✅ Dirk Gevers quote aligns with Seed's unique perspective

### Grading Scale
- **A (13-15 passed):** Excellent - ready for quality review
- **B (10-12 passed):** Good - address minor gaps then proceed
- **C (7-9 passed):** Needs significant work on Seed perspective
- **D (4-6 passed):** Major misalignment - substantial rewrite needed
- **F (0-3 passed):** Complete rewrite required

### Usage
```bash
/review-draft-seed-perspective                    # Reviews most recent draft
/review-draft-seed-perspective filename.md        # Reviews specific file
/review-draft-seed-perspective keyword            # Reviews by keyword
```

### Key Innovation: Tone-Aware Compliance

**Check #3 verifies claim SUBSTANCE while preserving casual voice:**

❌ **OLD approach:** Required exact Claims doc wording
✅ **NEW approach:** Allows casual phrasing if substance matches

**Example:**
- Article: "helps your body unwind and prepare for restorative rest" ✨
- Claims doc: "helps to improve sleep onset when used over time" 📋
- **Result:** ✅ PASS - Same substance, casual tone preserved!

Only fails if making claims NOT in our Claims docs (like "cures insomnia").

---

## 🎯 Command 2: `/review-draft-1`

**Purpose:** Check quality, tone, compliance, SEO (run AFTER Seed perspective is good)

### What It Checks (~60 Total)

📊 **Citations & Evidence** (10 checks)
- Format verification: `([Author Year](DOI_URL))`
- Citation count: 12-15
- Proper DOI links
- Appropriate citation density

💬 **Tone & Voice** (20 checks)
- Conversational, empathetic style
- Short paragraphs (2-3 sentences)
- Plain language before technical terms
- Analogies and relatable examples

⚖️ **Compliance** (10 checks)
- NO-NO words scan
- No forbidden medical claims
- Approved health claim language
- No absolute statements

📝 **Structure & Length** (8 checks)
- Word count ≥1300
- Required sections present
- Proper H2/H3 hierarchy
- Dr. Gevers quote included

🏷️ **Product References** (5 checks)
- ® symbols on all NPD products
- Proper product links
- Ingredient focus (not product pitch)

🔍 **SEO Elements** (7 checks)
- Keyword usage and density
- Meta descriptions ≤160 chars
- URL slug ends with "-guide"
- 3 SEO title options

### Usage
```bash
/review-draft-1 v2-seed-perspective-reviewed.md   # After Seed fixes applied
```

---

## 💡 Complete Workflow Example

### Step 1: Generate Draft
```
You: should i take a multivitamin

Claude generates complete article:
→ Saved as: /Generated-Drafts/039-should-i-take-a-multivitamin/v1-should-i-take-a-multivitamin.md
```

### Step 2: Review Seed Perspective
```bash
/review-draft-seed-perspective should-i-take-a-multivitamin

Output:
🎯 Product Detected: DM-02
📋 Grade: C (8/15 checks passed)

CRITICAL ISSUES:
❌ Missing soil depletion narrative (Priority: CRITICAL)
❌ Zero citations from DM-02-General-Claims.md (Priority: CRITICAL)
❌ ViaCap® technology not mentioned (Priority: HIGH)

Would you like me to fix these issues?
Options: all | critical | claims | messaging | scicomms
```

### Step 3: Apply Seed Fixes
```bash
You: critical

✅ Seed Perspective Review complete!
Saved as: v2-seed-perspective-reviewed.md
Grade improved to: B (11/15 checks passed)

Changes applied:
- Added soil depletion narrative with nutrient deficiency statistics
- Integrated 7 citations from DM-02-General-Claims.md
- Added ViaCap® technology explanation

📝 NEXT STEP: Run /review-draft-1 to check quality/compliance
```

### Step 4: Quality Review
```bash
/review-draft-1 v2-seed-perspective-reviewed.md

Output:
✅ Passed: 54/60 checks
⚠️ Issues Found: 6

Issues:
- Tone: 2 paragraphs too long (lines 89, 134)
- SEO: Meta description 3 chars over limit
- Citations: 1 format issue (missing DOI)

Would you like me to fix these issues?
Options: all | tone | seo | citations
```

### Step 5: Final Polish
```bash
You: all

✅ Review complete!
Saved as: v3-reviewed.md

Changes applied:
- Tone: Broke up 2 long paragraphs
- SEO: Trimmed meta description to 157 chars
- Citations: Fixed DOI link formatting

Ready for publication!
```

---

## 🔑 Key Features

### Smart Relevance Detection

The command analyzes which SciComms content is **actually relevant** to each article.

**Example for "should i take a multivitamin":**
- ✅ Relevant: Nutrient gaps, bidirectional microbiome, bioavailability
- ❌ Not relevant: Deep spermidine mechanisms, specific CoQ10 dosing

**Result:** Only flags missing content that genuinely improves the article - no forced bloat.

### Automatic Product Detection

Scans for:
- Product mentions (PM-02®, DM-02®, AM-02®)
- Product-specific ingredients (melatonin → PM-02, multivitamin → DM-02)
- Keyword patterns ("sleep" → PM-02, "energy" → AM-02)

### Priority-Based Recommendations

Issues are tagged:
- **CRITICAL** - Must fix before proceeding
- **HIGH** - Should fix for proper Seed alignment
- **MEDIUM** - Nice to have improvements

---

## 📚 Reference Files Priority

### Tier 1: Evidence Authority (HIGHEST)
**Claims Documents** - Absolute authority for approved health claims and studies
- `/Reference/Claims/DM-02/DM-02-General-Claims.md`
- `/Reference/Claims/PM-02/PM-02-General-Claims.md`
- `/Reference/Claims/AM-02/AM-02-General-Claims.md`
- Ingredient-specific claims files

### Tier 2: Strategy & Voice
**NPD Messaging** - Seed's unique angles and differentiation
- `/Reference/NPD-Messaging/DM-02 Product Messaging Reference Documents.md`
- `/Reference/NPD-Messaging/PM-02 Product Messaging Reference Documents.md`
- `/Reference/NPD-Messaging/AM-02 Product Messaging Reference Documents.md`

**SciComms Education** - Educational talking points and narratives
- `/Reference/SciComms Education Files/DM-02 Gut-Nutrition Education.md`
- `/Reference/SciComms Education Files/PM-02 SciComms Gut-Sleep Education.md`
- `/Reference/SciComms Education Files/AM-02 SciComms Gut-Energy Education.md`

### Supporting Documents
- `/Reference/Compliance/What-We-Are-Not-Allowed-To-Say.md`
- `/Reference/Compliance/NO-NO-WORDS.md`
- `/Reference/Style/Seed-Tone-of-Voice-and-Structure.md`
- `/Reference/Style/8-Sample-Reference-Blog-Articles.md`

---

## ⚠️ Common Issues & Solutions

### Issue: Grade C or Lower on Seed Perspective

**Problem:** Article doesn't reflect Seed's unique positioning

**Solutions:**
1. Check which product is detected - ensure it matches article topic
2. Review CRITICAL issues first (usually Claims docs and core narrative)
3. Fix messaging issues before proceeding to quality review
4. Re-run `/review-draft-seed-perspective` after fixes

### Issue: Missing Claims Document Citations

**Problem:** Article uses competitive sources instead of our approved studies

**Solution:**
1. Go to `/Reference/Claims/[PRODUCT]/[PRODUCT]-General-Claims.md`
2. Find relevant claims with DOI links
3. Replace competitive citations with Claims doc studies
4. Ensure >50% of citations are from Claims docs

### Issue: Generic Positioning (Not Seed-Specific)

**Problem:** Article sounds like any other blog, not Seed

**DM-02 fixes:**
- Add soil depletion narrative
- Emphasize bidirectional microbiome relationship
- Critique mega-dose multivitamins
- Add ViaCap® technology

**PM-02 fixes:**
- Add precision dosing (0.5mg vs 5-10mg) contrast
- Explain sleep-gut-brain axis
- Critique high-dose melatonin approach

**AM-02 fixes:**
- Position against stimulant-based energy
- Emphasize cellular/mitochondrial approach
- Explain gut-mitochondria axis

---

## 📊 Quality Checklist

### Before Running Reviews
- [ ] Draft is complete with all sections
- [ ] Keyword is clear and matches folder name
- [ ] Product context is evident in article

### After Seed Perspective Review (Grade A or B)
- [ ] Claims docs used as primary sources
- [ ] Product-specific positioning present
- [ ] Relevant SciComms content incorporated
- [ ] Dr. Gevers quote aligns with Seed's angle

### After Quality Review (All Checks Pass)
- [ ] Word count ≥1300 (ideally 1600-1800)
- [ ] Citations between 12-15
- [ ] All ® symbols present on products
- [ ] Conversational, empathetic tone
- [ ] No NO-NO words
- [ ] Meta descriptions within limits

---

## 💡 Pro Tips

### For Generating Better Initial Drafts
1. **Be specific with keywords** - "should i take a multivitamin" not just "multivitamin"
2. **Point to Claims docs** - Mention using our approved sources in prompt
3. **Specify product** - Indicate if it's DM-02, PM-02, or AM-02 focused

### For Faster Reviews
1. **Always start with Seed perspective** - Don't waste time on tone if perspective is wrong
2. **Fix critical issues first** - Address CRITICAL priorities before HIGH or MEDIUM
3. **Run both commands sequentially** - Seed perspective → Quality review
4. **Batch similar fixes** - Fix all "claims" issues at once, then "messaging", etc.

### For Better Compliance
1. **Check Claims docs first** - Know what claims are approved before writing
2. **Use substance over exact wording** - Preserve casual tone while maintaining claim accuracy
3. **Always attribute to ingredients** - "DM-02 is formulated with..." not "DM-02 supports..."

---

## 🐛 Troubleshooting

### Seed Perspective Command Not Finding Product

**Symptoms:** Command says "Unable to detect product"

**Solutions:**
1. Add explicit product mention (PM-02®, DM-02®, AM-02®)
2. Include product-specific ingredients in article
3. Manually specify in review: `/review-draft-seed-perspective [file] DM-02`

### Claims Not Being Recognized

**Symptoms:** Command flags approved claims as missing

**Solutions:**
1. Verify Claims doc file exists in correct location
2. Check claim wording is SUBSTANTIVELY similar (not exact match required)
3. Ensure claim is in the General Claims file (not just ingredient-specific)

### Too Many "Not Relevant" Flags

**Symptoms:** Command says SciComms content isn't relevant when it should be

**This is good!** The command is preventing bloat. Only add if:
- Content directly answers the primary keyword
- It's a key Seed differentiator for this topic
- Reader would expect this information

---

## 🔧 Customization

### Adding New Reference Documents
1. Place in appropriate folder (`/Reference/Claims/`, `/NPD-Messaging/`, etc.)
2. Use consistent naming: `[PRODUCT]-[Topic]-Claims.md`
3. Review commands will auto-detect new files

### Updating Product Positioning
1. Edit: `/Reference/NPD-Messaging/[PRODUCT] Product Messaging Reference Documents.md`
2. Add new positioning elements
3. Update review command checks if needed

### Adding New Products (Beyond PM/DM/AM-02)
1. Create Claims folder: `/Reference/Claims/[NEW-PRODUCT]/`
2. Add General Claims file
3. Update product detection logic in review command

---

## 📧 Support & Questions

**For workflow issues:**
1. Check this README first
2. Review command documentation in `.claude/commands/`
3. Verify all reference files are present

**For content questions:**
1. Consult Claims documents for approved claims
2. Check NPD Messaging for product positioning
3. Review SciComms files for educational angles

---

## 📈 Version History

- **v4 (Current - Jan 2025):** Two-command workflow with Seed perspective checks
  - Added `/review-draft-seed-perspective` command
  - Separated Seed alignment from quality checks
  - Implemented smart relevance detection
  - Fixed tone-awareness in compliance checks

- **v3:** Single-command approach (deprecated - too bloated)
- **v2:** Initial Gemini integration
- **v1:** Manual drafting process

---

**Built for Seed Health NPD Content Generation**
*Ensuring every article reflects Seed's unique scientific perspective*
