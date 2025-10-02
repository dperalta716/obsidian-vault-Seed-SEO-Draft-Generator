# Seed SEO Draft Generator

A specialized Obsidian vault for generating SEO-optimized articles for Seed Health's NPD products using Claude Code.

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

### 3. Generate Articles
Simply type a keyword and Claude will automatically:
- Search competitor articles
- Analyze user intent
- Generate a complete 1300+ word article
- Include 12-15 academic citations
- Create SEO metadata
- Suggest internal links

**Example:**
```
You: melatonin for sleep
Claude: [Generates complete article automatically]
```

## 📁 Vault Structure

```
Seed-SEO-Draft-Generator/
├── .claude/output-styles/       # Custom output style (auto-loads)
├── Reference/                   # All source materials
│   ├── NPD-Messaging/          # Product messaging docs
│   ├── Claims/                 # Clinical evidence
│   ├── Compliance/             # Rules and forbidden terms
│   └── Style/                  # Tone guide and samples
├── Generated-Drafts/           # Your completed articles
├── Templates/                  # Article template
└── CLAUDE.md                   # Fallback instructions
```

## 🎯 How Output Styles Work

### What's Different?
- **Normal Claude Code**: Writes code, manages files, general assistant
- **With Output Style**: Becomes a specialized SEO content generator
- **Automatic Workflow**: No need to prompt for each step

### Where Output Styles Live
- **Project-specific**: `.claude/output-styles/` (this vault)
- **User-level**: `~/.config/claude/output-styles/` (all projects)

### Installing Globally (Optional)
To use this output style in ANY project:
```bash
./install-output-style.sh
```

## 📝 Key Features

### Automatic Workflow Execution
When you provide a keyword, Claude automatically:
1. Searches top-ranking articles
2. Identifies standard advice vs Seed's approach
3. Pulls evidence from claims documents
4. Creates detailed outline
5. Writes full article with proper tone
6. Generates all metadata

### Citation Requirements
- **12-15 academic sources** (enforced)
- Primary sources from claims docs (any age)
- Secondary sources <10 years old
- Proper DOI linking

### Seed's Unique Perspective
- Bioidentical dosing vs mega-doses
- Precision formulation philosophy
- Gut-brain axis integration
- Multi-system approach

## 🔧 Customization

### Adding Reference Documents
Place documents in appropriate folders:
- `/Reference/NPD-Messaging/` - Product positioning
- `/Reference/Claims/` - Clinical studies
- `/Reference/Compliance/` - Rules and guidelines
- `/Reference/Style/` - Writing samples

### Updating Instructions
Edit either:
- `.claude/output-styles/seo-content-generator.md` - For output style mode
- `CLAUDE.md` - For fallback mode

## ⚠️ Important Notes

### What This Vault Does
✅ Generates SEO articles from keywords
✅ Follows Seed's scientific perspective
✅ Maintains compliance with regulations
✅ Creates publication-ready content

### What This Vault Doesn't Do
❌ General coding tasks
❌ File management beyond saving articles
❌ Non-SEO content creation
❌ Tasks unrelated to article generation

## 🐛 Troubleshooting

### Output Style Not Working?
1. Check if file exists: `.claude/output-styles/seo-content-generator.md`
2. Try reloading: Close and reopen Claude Code
3. Manually select: Run `/output-style` command

### Articles Not Generating?
1. Ensure all reference documents are in place
2. Check CLAUDE.md is present as fallback
3. Verify keyword is clear and specific

### Wrong Citation Count?
The output style enforces 12-15 citations. If you get fewer:
1. Check claims documents are present
2. Ensure keyword maps to available evidence
3. Verify secondary source availability

## 📊 Quality Checklist

Before publishing, verify:
- [ ] Word count ≥1300
- [ ] Citations between 12-15
- [ ] All product mentions include ® and placeholder links
- [ ] FAQs based on People Also Ask
- [ ] Seed's unique angle vs standard advice
- [ ] Dr. Gevers quote included
- [ ] Conversational, empathetic tone
- [ ] No forbidden terms used

## 💡 Pro Tips

1. **Batch Processing**: Generate multiple articles in one session
2. **Keyword Variations**: Try different phrasings for comprehensive coverage
3. **Review Claims First**: Check `/Reference/Claims/` to see available evidence
4. **Update Regularly**: Keep reference documents current with latest research

## 📧 Support

For issues or improvements:
1. Check this README first
2. Review the output style file
3. Verify reference documents are complete
4. Contact: [Your contact info]

---

*Built for Seed Health NPD Content Generation*
*Version 1.0 - January 2025*