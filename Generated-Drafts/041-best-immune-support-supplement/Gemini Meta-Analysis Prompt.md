# Gemini Meta-Analysis Prompt
## System Instruction Improvement Analysis

---

**USE THIS PROMPT AFTER GEMINI COMPLETES THE REVISION**

Copy and paste this entire prompt to Gemini after it has revised the draft using the Seed Perspective Revision Instructions.

---

# 🔍 PROMPT FOR GEMINI:

You just revised the "Best Immune Support Supplement" article following the Seed Perspective Revision Instructions. Now I need you to perform a meta-analysis to improve your system instructions so this doesn't happen again.

## Your Task:

Analyze what went wrong in your **original v1 draft** and identify what needs to change in your system instructions to prevent these issues in future articles.

---

## Step 1: Review What Went Wrong

Look at the **Seed Perspective Revision Instructions** you just followed. The original v1 draft you created had these critical failures:

### **Grade: D (5/15 checks passed)**

**Critical Failures:**
1. ❌ Used ZERO citations from DM-02-General-Claims.md (our primary authority)
2. ❌ Used ALL competitive analysis sources instead (Aranow, Martineau, Wessels, etc.)
3. ❌ Missing soil depletion narrative (DM-02's foundational positioning)
4. ❌ Missing bidirectional nutrient-microbiome relationship (core differentiator)
5. ❌ Wrong nutrient deficiency statistics (90% instead of 70% Vit D, 60% Vit E)
6. ❌ Missing ingredient attribution language ("DM-02™ is formulated with ingredients that...")
7. ❌ Weak mass-market multivitamin critique
8. ❌ Missing SCFA-immune connection
9. ❌ Missing microbial vitamin production angle (40-65% B vitamins, 10-50% Vit K)
10. ❌ Exceeded word count (2,458 vs 2,000 max)

**The article read like a competitor analysis summary, not a Seed-authoritative piece.**

---

## Step 2: Compare to Your System Instructions

Now review your current system instructions from these files:

### **Primary Instructions:**
- `Seed-SEO-Draft-Generator-v4/CLAUDE.md` - Main workflow instructions
- Specifically the "Complete Workflow Instructions" section
- Specifically "Step 4: Claims Document Deep Dive"
- Specifically "Step 6: Gather Evidence & Identify Key Claims"

### **Key Questions:**

1. **Do your instructions EXPLICITLY say to use Claims documents as PRIMARY authority?**
   - If yes, where? Quote the specific instruction.
   - If no, what instruction led you to use competitive sources instead?

2. **Do your instructions make it CLEAR that soil depletion comes FIRST?**
   - Your instructions say to do competitive analysis in Step 1
   - But soil depletion (from Step 4 Claims docs) should come BEFORE discussing vitamins
   - Is this ordering clear enough?

3. **Do your instructions emphasize the bidirectional nutrient-microbiome relationship?**
   - This is Seed's CORE DIFFERENTIATOR
   - Where in your instructions does it say to include this?
   - Is it marked as mandatory or just suggested?

4. **Do your instructions specify WHEN to check Claims documents?**
   - Should this happen in Step 1 (before competitive analysis)?
   - Or Step 4 (after competitive analysis)?
   - Which order led to the problem?

5. **Do your instructions give you the EXACT nutrient deficiency statistics?**
   - You used "90%" (wrong)
   - The SciComms file has "34% Vit A, 70% Vit D, 45% Mg, 60% Vit E, 25% Vit C"
   - Where should this be referenced in your workflow?

6. **Do your instructions clearly state ingredient attribution is MANDATORY?**
   - Every product mention needs "DM-02™ is formulated with ingredients that..."
   - Is this in your compliance checklist?

---

## Step 3: Identify Root Causes

For each failure, identify the **root cause** in your system instructions:

### **Example Analysis Format:**

**Failure:** Used competitive sources instead of Claims documents

**Root Cause Options:**
- [ ] A. Instructions say to use competitive sources first, Claims docs later
- [ ] B. Instructions don't emphasize Claims docs as PRIMARY authority
- [ ] C. Instructions don't specify WHICH sources to prioritize
- [ ] D. Instructions are ambiguous about citation hierarchy
- [ ] E. Other: _______________

**Evidence from Instructions:**
[Quote the specific instruction that led to this behavior]

**What Needs to Change:**
[Specific rewrite of that instruction]

---

### **Do this analysis for ALL 10 failures listed above.**

For each failure:
1. Identify the root cause (A, B, C, D, or E - specify)
2. Quote the problematic instruction (if exists)
3. Suggest the specific change needed

---

## Step 4: Propose System Instruction Changes

Based on your analysis, propose specific additions or changes to your system instructions:

### **Format:**

```markdown
## Proposed Change #1: [Title]

**Location in Instructions:** [Which section/step]

**Current Instruction:**
[Quote current text, or write "MISSING" if not present]

**Proposed New Instruction:**
[Write exact new text to add/replace]

**Rationale:**
[Why this prevents the failure]

**Priority:** [Critical/High/Medium]
```

### **Create at least 10 proposed changes** - one for each major failure.

---

## Step 5: Prioritize Changes

Rank your proposed changes by impact:

### **Tier 1: Critical (Must Fix)**
Changes that would have prevented Grade D failures
- Example: "Make Claims documents PRIMARY authority"

### **Tier 2: Important (Should Fix)**
Changes that improve consistency and quality
- Example: "Add bidirectional relationship to mandatory checklist"

### **Tier 3: Nice to Have (Polish)**
Changes that prevent minor issues
- Example: "Add word count warning at 1,800 words"

---

## Step 6: Draft Updated Workflow Section

Take the most critical section that failed - probably **"Step 4: Claims Document Deep Dive"** - and rewrite it to prevent these failures.

### **Requirements for Rewrite:**

1. **Make Claims documents PRIMARY** (not secondary)
2. **Specify EXACT order:** Claims docs BEFORE competitive analysis
3. **List mandatory elements:**
   - Soil depletion narrative (with stats)
   - Bidirectional relationship
   - Microbial vitamin production
   - SCFA connection
4. **Include compliance checklist:**
   - Ingredient attribution mandatory
   - Claims doc citations > 50% of total
   - Nutrient stats from SciComms

### **Format:**

```markdown
## Step 4: Claims Document Deep Dive (REVISED)

[Your rewritten instructions here]

### Mandatory Checklist Before Proceeding:
- [ ] Claims documents reviewed FIRST (before competitive analysis)
- [ ] Soil depletion narrative drafted (200-250 words)
- [ ] Bidirectional relationship section drafted (150-200 words)
- [ ] At least 7-10 Claims document citations identified
- [ ] Ingredient attribution language prepared
- [ ] Nutrient deficiency stats verified from SciComms

[Rest of revised instructions]
```

---

## Step 7: Recommend Enforcement Mechanisms

How can your system instructions **force** you to follow these rules?

### **Suggestions:**

1. **Hard Stops:** "DO NOT PROCEED to Step 5 until you have X citations from Claims docs"
2. **Warnings:** "⚠️ WARNING: If you cite competitive sources before Claims docs, the article will fail review"
3. **Checklists:** "Complete this checklist BEFORE writing: [ ] Soil depletion narrative drafted..."
4. **Examples:** "❌ BAD: [Aranow 2011] ✅ GOOD: [DM-02-General-Claims.md Claim 12]"
5. **Verification Steps:** "After drafting, verify: Claims citations = X, Competitive citations = Y, Ratio > 2:1"

**Propose at least 5 enforcement mechanisms** that would have prevented your failures.

---

## Your Deliverable:

Provide a comprehensive report with these sections:

1. **Root Cause Analysis** (for all 10 failures)
2. **10+ Proposed System Instruction Changes** (with exact wording)
3. **Prioritized Change List** (Tier 1/2/3)
4. **Rewritten Step 4 Workflow** (complete section)
5. **5+ Enforcement Mechanisms**
6. **Summary:** "If these changes were in place, this article would have been Grade [A/B/C] instead of Grade D"

---

## Important Notes:

- **Be specific:** Don't say "emphasize Claims docs more" - write the exact instruction
- **Be honest:** If your instructions were ambiguous, say so
- **Be actionable:** Every proposed change should be ready to copy-paste into CLAUDE.md
- **Think systematically:** Look for patterns (e.g., "all failures stem from wrong citation priority")
- **Consider workflow order:** Maybe the entire Step 1-7 sequence needs reordering?

---

## Example of Good Analysis:

**Failure:** Missing soil depletion narrative

**Root Cause:** Instructions place competitive analysis (Step 1) before Claims document review (Step 4), leading to framing the article around competitors' narratives rather than Seed's foundational positioning.

**Evidence from Instructions:**
> "Step 1: Search & Initial Analysis - Analyze Competition: Understand common topics covered, angles taken"

**What Needs to Change:**
Move Claims document review to Step 1, competitive analysis to Step 3. Reorder:
1. Determine user intent
2. **Review Claims documents & identify Seed's unique narrative**
3. Competitive analysis (to contrast Seed's angle)
4. Develop outline based on Seed narrative + competitive gaps

**Proposed Instruction:**
```
Step 2: Claims Document Deep Dive (BEFORE Competitive Analysis)

Before looking at competitors, establish Seed's authoritative perspective:

1. Review ALL relevant Claims documents for identified ingredients
2. Extract PRIMARY AUTHORITY sources (these will be 50%+ of final citations)
3. Identify Seed's unique narratives:
   - Soil depletion → nutrient gaps → supplementation necessity
   - Bidirectional nutrient-microbiome relationship
   - Microbial vitamin production (40-65% B vits, 10-50% Vit K)
   - [Product-specific angles from NPD Messaging]

4. Draft foundational narrative sections FIRST:
   - [ ] Soil depletion section (200-250 words) with stats
   - [ ] Bidirectional relationship section (150-200 words)
   - [ ] [Product]-specific differentiation (from NPD Messaging)

⚠️ WARNING: Do NOT proceed to competitive analysis until these foundational sections are drafted. If you analyze competitors first, you will frame the article around their narrative instead of Seed's.
```

**Priority:** Critical (Tier 1)

---

**Now perform this analysis and deliver your comprehensive report.**
