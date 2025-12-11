**Version:** 2.1
**Last Updated:** 2025-12-11

**Changes from V2.0:** Added Competitor Product Discovery section - Gemini now identifies and locates official product pages based on keyword parsing.
**Changes from V1:** Added Citation Protocol section to separate scientific sources from competitor sources; clarified source hierarchy; added inline citation requirements.

**BEGIN SUPPLEMENTAL INSTRUCTIONS - SEED VS. COMPETITOR MULTIVITAMIN COMPARISONS (V2.1)**

**Purpose:** These supplemental instructions are for generating three-way comparison articles comparing Seed's DM-02™ Daily Multivitamin against two competitor multivitamin products.

**Keyword:** metagenics vs pure encapsulations multivitamin vs Seed DM-02

---

## **⚠️ IMPORTANT: No Stage 1 Analysis for This Workflow**

**This workflow does NOT use a `stage1_analysis-[KEYWORD].md` document.**

Unlike standard keyword articles, comparison articles gather competitor information directly from official product pages that YOU identify and locate.

**This workflow requires:**
1. The **keyword** provided by the user
2. **YOU identify the correct competitor products and find their official product pages** (see Product Discovery section below)
3. Direct consultation of Seed's internal DM-02 reference documents for **scientific claims**

---

## **🔍 COMPETITOR PRODUCT DISCOVERY (STEP 0)**

Before writing the article, you must identify and locate the correct competitor products based on the keyword.

### **Parse the Keyword**

Extract the competitor brand names from the keyword. Examples:
- "life extension vs pure encapsulations multivitamin vs Seed DM-02" → Life Extension, Pure Encapsulations
- "ritual vs thorne multivitamin vs Seed DM-02" → Ritual, Thorne
- "centrum vs one a day multivitamin vs Seed DM-02" → Centrum, One A Day

### **Identify the Correct Product**

For each competitor brand, determine which specific multivitamin product to compare:

**If the keyword includes a specific product name:**
- Use that exact product (e.g., "Life Extension Two-Per-Day" → use Two-Per-Day)

**If the keyword only mentions the brand name:**
- Search for "[Brand Name] most popular multivitamin" or "[Brand Name] flagship multivitamin"
- Identify their PRIMARY/FLAGSHIP multivitamin product in the general adult category
- Common flagship products by brand:
  - **Life Extension** → Two-Per-Day Multivitamin
  - **Pure Encapsulations** → O.N.E. Multivitamin
  - **Thorne** → Basic Nutrients 2/Day
  - **Ritual** → Essential for Women/Men
  - **Garden of Life** → Vitamin Code
  - **Metagenics** → PhytoMulti
  - **Centrum** → Centrum Adults or Centrum Silver
  - **One A Day** → One A Day Complete

### **Locate the Official Product Page**

For each competitor product:
1. **Search for the official manufacturer product page** (not Amazon, Vitacost, iHerb, etc.)
2. **The URL should be on the brand's own domain** (e.g., lifeextension.com, pureencapsulations.com, thorne.com)
3. **Record the URL** for use in the article and citations

**Example Discovery Process:**
```
Keyword: "metagenics vs pure encapsulations multivitamin vs Seed DM-02"

Competitor A: Metagenics
→ Flagship multivitamin: PhytoMulti
→ Official URL: https://www.metagenics.com/phytomulti

Competitor B: Pure Encapsulations
→ Flagship multivitamin: O.N.E. Multivitamin
→ Official URL: https://www.pureencapsulationspro.com/o-n-e-multivitamin.html
```

### **Document Your Findings**

Before proceeding to write, confirm:
- **Competitor A:** [Brand] - [Product Name] - [Official URL]
- **Competitor B:** [Brand] - [Product Name] - [Official URL]

---

## **🔬 CITATION PROTOCOL FOR COMPARISONS (CRITICAL)**

This section explicitly separates WHERE to get different types of information:

### **For Seed/Scientific Claims → Use Internal Claims Documents**

You MUST cite peer-reviewed academic papers found in the internal `DM-02-[Ingredient]-Claims.md` files. Examples:
- **PQQ claims** → Cite Chowanadisai et al. from PQQ claims file
- **CoQ10 claims** → Cite Barcelos et al. from CoQ10 claims file
- **Gut-microbiome claims** → Cite Magnúsdóttir et al. from General Claims file
- **B-vitamin synthesis** → Cite studies from DM-02-General-Claims.md

**DO NOT cite the Seed website (seed.com) for scientific claims.**

### **For Competitor Product Specs → Use ONLY Official Manufacturer Pages**

- Use ONLY the official manufacturer product page URLs provided by the user
- **DO NOT use third-party retailers** (Amazon, Vitacost, iHerb, eBay, etc.) as sources
- Extract factual product details: ingredients, forms, pricing, serving size, claims

### **Final Citation List Structure**

The Citations section should contain a MIX of:
1. **Academic papers** (with DOI links) used to support Seed's scientific claims
2. **Official competitor URLs** (2 total) used for product specifications

**Target: 5-8 total citations** (3-6 academic + 2 competitor URLs)

### **Inline Citation Format**

For scientific claims, use the standard format: `([Author Year](DOI_URL))`

Example: "Research shows PQQ can stimulate mitochondrial biogenesis ([Chowanadisai 2010](https://doi.org/10.1074/jbc.M109.030130))."

---

## **Article Structure & Content Focus**

### **1. Primary Goal**
Provide a comprehensive, evidence-based, and Seed-aligned comparison between Seed's DM-02™ Daily Multivitamin and two specified competitor multivitamin products.

### **2. DM-02™ Naming Convention**
- **First Mention (Introduction & H2 Title):** "Seed's DM-02™ Daily Multivitamin"
- **In "Key Differences at a Glance" Table:** "Seed's DM-02™ Daily Multivitamin"
- **Subsequent Mentions:** "Seed's DM-02™" or "DM-02™"

### **3. Mandatory Article Structure**

You MUST use the following H2/H3 structure:

```
Title (SEO-optimized for "[Competitor A] vs [Competitor B] vs Seed's DM-02™ Daily Multivitamin")

### Overview (3-5 bullet points summarizing core differences across all three products)

Introduction (Engaging, acknowledging that choosing a multivitamin can feel overwhelming, setting up the comparison)

## What Makes a Multivitamin Actually Work?
Brief explanation of what separates effective multivitamins from ineffective ones (bioavailability, form quality, dosing precision, delivery)

## A Closer Look: Seed's DM-02™ Daily Multivitamin
### The 2-in-1 Difference: Nutrients for You and Your Microbiome
### Key DM-02™ Benefits: What the Science Shows
### Bioavailable Forms: Nutrients Your Body Can Actually Use
### The Cellular Energy Complex: CoQ10, PQQ, and Spermidine
### The Delivery System: ViaCap® Technology
### Microbiome Support: The Gut-Nutrition Connection

## A Closer Look: [Competitor A Name]
### Formulation Overview
### Key Ingredients and Forms
### Benefit Claims
### Delivery Format
### Considerations

## A Closer Look: [Competitor B Name]
### Formulation Overview
### Key Ingredients and Forms
### Benefit Claims
### Delivery Format
### Considerations

## Key Differences at a Glance (MUST be formatted as a table)

## What Does This Mean For You? Choosing the Right Multivitamin

## The Key Insight (Paragraph summary, Seed-branded closer)

## Frequently Asked Questions (3-4 questions comparing key aspects across all three products)

## Citations (Mixed: Academic papers + Official competitor URLs)
```

### **4. Key Differences Table Requirements**

The comparison table MUST include the following rows at minimum:

| Feature | Seed's DM-02™ | [Competitor A] | [Competitor B] |
|---------|---------------|----------------|----------------|
| Product Category | Multivitamin with Microbiome Support | [Their category] | [Their category] |
| Nutrient Strategy | 100% DV (Precision Dosing) | [High potency/Balanced/etc.] | [Their approach] |
| Bioavailable Forms | Yes (methylated Bs, chelated minerals, D3) | [Yes/No/Partial] | [Yes/No/Partial] |
| Microbiome Support | Yes (ViaCap® delivery to colon) | [Yes/No] | [Yes/No] |
| Cellular Energy Compounds | CoQ10, PQQ, Spermidine | [If any] | [If any] |
| Delivery Technology | ViaCap® (capsule-in-capsule) | [Standard capsule/tablet/etc.] | [Format] |
| Daily Dosage | 1 Capsule | [Number] | [Number] |
| **Price (per 30-day supply)** | $39.99 | [Price] | [Price] |

---

## **Competitor Information Gathering & Usage**

### **Step A: Internal Perspective First (FOR SCIENTIFIC CLAIMS)**

Before external searches, thoroughly review these files to find **academic citations**:
- `DM-02 Product Messaging Reference Documents.md` - positioning and approved claims
- `DM-02-Key-Benefits-Claims.md` - substantiated benefit claims WITH academic sources
- `DM-02-General-Claims.md` - gut-nutrition claims WITH academic sources
- `DM-02 Gut-Nutrition Education.md` - microbiome-nutrition science
- Individual ingredient claims files: `DM-02-PQQ-Claims.md`, `DM-02-CoQ10-Claims.md`, etc.

**Extract the DOI links from these files to cite in the article.**

### **Step B: Visit Competitor Official Product Websites (FOR PRODUCT SPECS ONLY)**

Using the URLs you identified in **Step 0 (Competitor Product Discovery)**, visit each official product page and gather ONLY factual product details:
- Exact vitamins and minerals included (and their forms if listed)
- Number of nutrients and % daily values
- Capsules/tablets per serving
- Delivery format (capsule, tablet, gummy)
- Benefit claims made by the competitor (in their words)
- **Current price for a 30-day supply**
- Allergen and quality testing information

**DO NOT use competitor websites as sources for scientific claims.**

### **Step C: Synthesize with Seed's Authoritative Voice**

- Use factual details from competitor websites to populate the descriptive sections and comparison table
- Support Seed's scientific claims with academic citations from internal claims documents
- **Rewrite competitor information in Seed's own words** - do not quote or say "according to [competitor's] website"
- **CRITICAL: Do NOT adopt competitor marketing claims as scientific fact**

---

## **DM-02™ Information Sources**

Refer extensively to:
- `DM-02 Product Messaging Reference Documents.md` (positioning, price: $39.99/30-day supply)
- `DM-02-Key-Benefits-Claims.md` (substantiated health claims + academic sources)
- `DM-02-General-Claims.md` (gut-nutrition science claims + academic sources)
- `DM-02 Gut-Nutrition Education.md` (microbiome-nutrition connection)
- Individual ingredient claims files in `/Reference/Claims/DM-02/` (for specific DOIs)

---

## **Seed's Key Differentiators to Emphasize**

When comparing DM-02™ to competitors, highlight these unique aspects:

### **Microbiome Support**
- DM-02™ is designed to support both the body AND the microbiome
- The gut-nutrition connection is bidirectional: nutrients shape the microbiome, and the microbiome shapes nutrient availability
- Inner capsule delivers B vitamins and prebiotics (Japanese wasabi) to support gut bacteria
- **Cite:** Magnúsdóttir et al. on B-vitamin biosynthesis by gut microbes

### **Bioavailable Forms**
- Methylfolate (not folic acid)
- Methylcobalamin and adenosylcobalamin (B12)
- Pyridoxal-5'-phosphate (B6)
- Cholecalciferol/D3 (not D2)
- Chelated minerals (e.g., manganese bisglycinate)

### **Cellular Energy Complex (Unique to DM-02™)**
- CoQ10 (declines with age, supports mitochondrial function) - **Cite:** Barcelos et al.
- PQQ (supports mitochondrial biogenesis) - **Cite:** Chowanadisai et al.
- Spermidine (cellular renewal compound)
- Vitamin K2 MK-7 (longer-lasting, microbially-produced form)

### **ViaCap® Technology**
- Capsule-in-capsule delivery
- Outer capsule: releases vitamins/minerals in upper GI tract
- Inner capsule: delivers nutrients to the microbiome (~3 hours post-consumption)

### **Precision Dosing**
- 100% DV of 20 vitamins and minerals
- No mega-doses or micro-doses
- Designed to complement a healthy diet, not replace it

---

## **Competitor Analysis Framework**

When analyzing competitors, evaluate and note:

### **Formulation Quality**
- Are vitamins in bioavailable/active forms or synthetic/inactive forms?
- Are minerals chelated or in oxide/carbonate forms (poorly absorbed)?
- Do they include meaningful amounts or "fairy dust" doses?

### **Completeness**
- How many vitamins and minerals are included?
- Are there notable gaps (e.g., no vitamin K, no trace minerals)?
- Do they include any specialty compounds (CoQ10, etc.)?

### **Delivery & Convenience**
- How many pills/capsules per day?
- Is it a tablet (harder to absorb), capsule, gummy (often contains sugar/fillers)?
- Any special delivery technology?

### **Microbiome Consideration**
- Does the product address gut health at all?
- Any prebiotics or gut-supporting ingredients?

---

## **Tone of Comparison**

- Maintain Seed's friendly, educational, and empathetic tone
- Frame comparison from Seed's scientific perspective
- It is appropriate to subtly highlight DM-02™'s advantages based on objective differences
- **Do NOT directly disparage competitors** - focus on objective differences
- Acknowledge that different products may suit different needs

---

## **Copy Compliance Reminders**

### ✅ DO:
- Use "DM-02™ is *formulated to*" when making claims
- All claims are ingredient-level claims
- Use the ™ symbol when using the product name
- State that vitamins and minerals are in "bioavailable forms"

### ❌ DO NOT:
- State vitamins are in their "*most* bioavailable" forms
- State or imply DM-02™ addresses any chronic condition
- State DM-02™ *delivers* ingredients directly to the colon (it is *engineered* to do so)
- Use verbs like *improve, boost, strengthen* - use *support, contribute to, promote*

---

## **Product Link Format**

All mentions of Seed products MUST include trademark symbols and be hyperlinked:
- `[DM-02™ Daily Multivitamin](https://seed.com/daily-multivitamin)`
- `[DS-01® Daily Synbiotic](https://seed.com/daily-synbiotic)` (if mentioned for context)

---

## **General Adherence**

- Word count: 1500-1800 words
- **Target 5-8 total citations** (academic papers + 2 competitor URLs)
- Ensure 7th-8th grade reading level (Flesch-Kincaid)
- Maximum 25 words average sentence length
- 2-3 sentences per paragraph maximum
- Inline citations use `([Author Year](DOI_URL))` format

---

## **Example Citation List Format**

```markdown
## Citations

1. Barcelos, I. P., & Haas, R. H. (2019). CoQ10 and Aging. *Biology*, 8(2), 28. https://doi.org/10.3390/biology8020028
2. Chowanadisai, W., et al. (2010). Pyrroloquinoline quinone stimulates mitochondrial biogenesis. *Journal of Biological Chemistry*, 285(1), 142–152. https://doi.org/10.1074/jbc.M109.030130
3. Magnúsdóttir, S., et al. (2015). Systematic genome assessment of B-vitamin biosynthesis suggests co-operation among gut microbes. *Frontiers in Genetics*, 6, 148. https://doi.org/10.3389/fgene.2015.00148
4. Life Extension. (n.d.). Two-Per-Day Multivitamin. https://www.lifeextension.com/vitamins-supplements/item02315/two-per-day-tablets
5. Pure Encapsulations. (n.d.). O.N.E. Multivitamin. https://www.pureencapsulationspro.com/o-n-e-multivitamin.html
```

**END SUPPLEMENTAL INSTRUCTIONS (V2)**
