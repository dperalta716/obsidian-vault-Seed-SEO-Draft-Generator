# Task: Seed Versus Article Competitive Gap Analysis

## Objective
Review existing Seed versus competitor articles, identify features competitors have that Seed doesn't address, and create addendums following Seed's tone and style guidelines.

---

## Reference Files Location
All reference files are in:
`/root/obsidian-vaults/claude-code-demo/Seed-SEO-Draft-Generator-v4/Phase 1 Reference Files/`

**Files to consult:**
- `Ds-01 PDP.md` — Product page details
- `Ds-01 Science Reference File.md` — Scientific claims and evidence
- `SEO Article Sprint - SciCare POV - DS-01 - General.md` — General positioning
- `Seed Tone of Voice and Structure.md` — **Follow this for all writing**
- `Drafting Prompt Instructions.md` — **Follow this for citation formatting (inline and end references)**
- `What we are and are not allowed to say when writing for Seed.md` — Compliance guardrails

---

## Step 1: Get the Google Doc Links
Access this spreadsheet: https://docs.google.com/spreadsheets/d/1VMNPMKCFG6an5UpteL5aUtm-VLgFgrSOFZDZE6h1ig8/edit?gid=440639538#gid=440639538

Go to the "Seed vs. Articles" tab. In rows 140-146, column O, extract all Google Doc links.

---

## Step 2: Read Each Draft
For each Google Doc link:
1. Open and read the full document (check for multiple tabs if present)
2. Identify all features, ingredients, or benefits mentioned about the competitor product
3. Note anything the competitor has that Seed DS-01 does NOT have or does NOT address (e.g., postbiotics, single capsule format, specific vitamins, prebiotics, iron, etc.)

---

## Step 3: Research Seed's Position
For each identified gap:
1. **First**, check the reference files listed above for Seed's official position or talking points
2. **If not found locally**, search seed.com for relevant information
3. Look for: Why Seed chose not to include that ingredient/feature, OR how Seed addresses it differently, OR scientific reasoning behind the formulation choice

---

## Step 4: Write Addendums
For each gap found, write a callout (2-4 sentences) that:
- Acknowledges the competitor has this feature
- Explains Seed's position (why they don't include it, or how they address it differently)
- Maintains a neutral, factual tone (no claims of superiority)
- **Follows the style in `Seed Tone of Voice and Structure.md`**
- **Formats any citations per `Drafting Prompt Instructions.md`** (inline and end references)

---

## Step 5: Output — Create Obsidian Notes

**Create this folder** (if it doesn't exist):
`/root/obsidian-vaults/claude-code-demo/Seed-SEO-Draft-Generator-v4/Phase 1 Draft Revisions/Seed vs. Revisions/`

**For each Google Doc, create one Obsidian note:**
- **Filename:** Same title as the Google Doc (e.g., `Seed DS-01 vs Ritual Synbiotic Guide.md`)
- **Contents:**

```markdown
# [Article Title]

**Google Doc:** [full Google Doc URL]

---

## Gaps Identified

1. **[Feature]** — Competitor has [X], Seed does not mention/address this

---

## Proposed Addendums

### 1. [Feature Name]

> [Callout text to add to the article, written in Seed's tone, with proper citations]

**Suggested placement:** [Where in the article this should go]

---

[Repeat for each gap]
```

---

## After Approval
Once I review and approve the addendums in the Obsidian notes, use the Google Docs skill to append the approved content to the end of each respective Google Doc.
