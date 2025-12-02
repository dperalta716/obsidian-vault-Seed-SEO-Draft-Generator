# Workflow: How to Use These Files with Gemini

## 📋 Three-Step Process

### **Step 1: Give Gemini the Revision Instructions**

**File to use:** `Seed Perspective Revision Instructions.md`

**What to say to Gemini:**
```
I need you to revise the article "Best immune support supplement - Gemini 3 v1.md"
following the attached revision instructions.

Please read through all the instructions first, then execute the revisions in the
order specified (Phase 1 → Phase 2 → Phase 3).

When you're done, output the complete revised article.
```

**Attach:** `Seed Perspective Revision Instructions.md`

---

### **Step 2: Let Gemini Revise**

Gemini will work through all 11 fixes:
- Replace competitive citations with Claims sources
- Add soil depletion section
- Add bidirectional relationship
- Fix statistics
- Add ingredient attribution
- Strengthen critiques
- Update bioavailability examples
- Add SCFA and microbial vitamin production
- Trim to word count

**Expected output:** Fully revised article (Grade A/B)

---

### **Step 3: Meta-Analysis (Learn from Mistakes)**

**File to use:** `Gemini Meta-Analysis Prompt.md`

**What to say to Gemini:**
```
Now that you've completed the revision, I need you to analyze what went wrong
in your original v1 draft and how to fix your system instructions.

Please follow the meta-analysis prompt attached.
```

**Attach:** `Gemini Meta-Analysis Prompt.md`

**Expected output:** Comprehensive analysis including:
- Root cause analysis for all 10 failures
- 10+ specific system instruction changes
- Rewritten workflow section (Step 4)
- 5+ enforcement mechanisms
- Priority ranking

---

## 📁 Files in This Folder

| **File** | **Purpose** | **When to Use** |
|----------|-------------|-----------------|
| `Best immune support supplement - Gemini 3 v1.md` | Original draft (Grade D) | Reference only |
| `Seed Perspective Revision Instructions.md` | Detailed fix instructions | Step 1: Give to Gemini |
| `Gemini Meta-Analysis Prompt.md` | System improvement prompt | Step 3: After revision |
| `WORKFLOW - How to Use These Files.md` | This guide | Your reference |

---

## ✅ Success Criteria

After Step 2 (Revision):
- [ ] Article uses 12-15 citations from Claims documents
- [ ] ZERO competitive citations (Aranow, Martineau, etc.)
- [ ] Soil depletion section present before vitamins discussion
- [ ] Bidirectional relationship explained
- [ ] Word count: 1,800-2,000 words
- [ ] All product mentions have ingredient attribution

After Step 3 (Meta-Analysis):
- [ ] Root causes identified for all major failures
- [ ] Specific CLAUDE.md instruction changes proposed
- [ ] Workflow reordering suggested (Claims BEFORE competitive analysis)
- [ ] Enforcement mechanisms suggested

---

## 🎯 Goal

Transform Gemini's system instructions so future articles:
1. Use Claims documents as PRIMARY authority (not competitive sources)
2. Lead with Seed's unique perspective (soil depletion, bidirectional relationship)
3. Include mandatory elements in every relevant article
4. Pass Seed Perspective Review with Grade A/B on first try

---

## 📝 Notes

- Keep all three files together for reference
- Gemini's meta-analysis output should be used to update the main CLAUDE.md
- This is a learning loop: Review → Revise → Analyze → Update Instructions → Prevent
