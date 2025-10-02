# analyze-seo-draft

Performs competitive analysis of an SEO draft article against top-ranking competitors and generates revision instructions.

## Usage

```
/analyze-seo-draft <draft_file_path>
```

## Parameters

- `draft_file_path` (required): Path to the draft article markdown file to analyze

## Description

This command automates a comprehensive SEO competitive analysis workflow:

1. **Extracts the primary keyword** from your draft's SEO metadata
2. **Analyzes citation count** and identifies gaps (target: 12-15 academic citations)
3. **Searches and fetches** the top 3-4 competing articles for that keyword
4. **Performs in-depth analysis** comparing your draft to competitors
5. **Outputs a structured comparison** highlighting strengths, gaps, and recommendations
6. **Asks for your feedback** on which improvements to implement
7. **Generates detailed instructions** for the content drafter with citation requirements

## Workflow

### Step 1: Initial Draft Analysis
- Read the provided draft file
- Extract the primary keyword from SEO metadata
- Count existing citations (looking for DOI links and academic sources)
- Calculate citation gap: "Current draft has X citations. Need Y-Z more citations to reach target of 12-15."

### Step 2: Competitive Research
- Perform web search using the exact primary keyword (no modifications)
- Identify top 3-4 ranking articles from reputable sources
- Use WebFetch to analyze each competitor for:
  - Content structure and topics covered
  - Evidence approach (citations, studies mentioned)
  - Unique angles and positioning
  - Practical information (dosages, food sources, warnings)
  - Tone and target audience
  - Specific supplements or ingredients discussed

### Step 3: Comparative Analysis Output

Generate a structured report with these sections:

#### Where Your Draft Excels
- Scientific depth and novel approaches
- Evidence quality and citation strength
- Narrative coherence and storytelling
- Brand voice and accessibility
- Unique content elements not found in competitors

#### Where Competitors Have Advantages
- Popular topics or supplements you're missing
- Practical information (dosages, timing, food sources)
- Safety warnings and drug interactions
- Cost-benefit discussions
- User-friendly elements (lists, tables, FAQs)

#### Concrete Recommendations for Improvement
- Numbered list of 8-12 specific improvements
- Each with clear rationale and implementation notes
- Priority indicators (quick wins vs. major additions)
- Citation requirements for new content

### Step 4: Interactive Feedback
Present analysis and ask: **"What changes should we implement into this draft?"**

Wait for user to specify which recommendations to proceed with.

### Step 5: Generate Drafter Instructions

Based on selected improvements, create detailed implementation instructions including:

#### Citation Requirements Header
```
CRITICAL CITATION REQUIREMENT:
- Current draft has [X] citations
- Target: 12-15 total peer-reviewed academic citations
- Need to add [Y-Z] more citations for new content
- Format: ([Author Year](DOI_URL)) - NO comma between Author and Year
- Focus citations on: health claims, mechanisms, study results, dosages
```

#### For Each Improvement:
- **Clear placement instructions** (which section, before/after what content)
- **Specific content requirements** (what to write, how much detail)
- **Citation needs** (what claims must be cited)
- **Word count guidance** (to stay within 1500-1800 target, 2000 max)
- **Tone reminders** (maintain conversational, knowledgeable friend voice)

#### Final Checklist:
- [ ] All new health claims have citations
- [ ] Total citations between 12-15
- [ ] Word count under 2000
- [ ] Maintains unique angle while addressing gaps
- [ ] Safety/interaction information included where relevant
- [ ] Food sources mentioned for key nutrients
- [ ] Citations properly formatted with DOI links

## Example

```
/analyze-seo-draft /Generated-Drafts/014-heart-health-supplements/heart-health-supplements-v1.md
```

## Output Format

The command provides:
1. Initial citation count and gap analysis
2. Competitive landscape summary
3. Detailed comparative analysis
4. Interactive recommendation selection
5. Formatted drafter instructions ready for implementation

## Notes

- Always uses exact keyword from draft for search (no modifications)
- Prioritizes peer-reviewed academic sources for citations
- Maintains Seed's unique cellular/systemic health perspective
- Ensures compliance with brand voice and scientific standards
- Focuses on actionable, specific improvements
- Emphasizes evidence-based content additions