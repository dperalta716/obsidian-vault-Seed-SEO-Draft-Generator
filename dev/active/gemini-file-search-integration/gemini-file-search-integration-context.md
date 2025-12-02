# Gemini File Search Integration - Context & Reference

**Last Updated**: 2025-11-18
**Status**: Phase 1 Complete, Phase 2-3 Pending

---

## Implementation Status

✅ **Phase 1 Complete** (reference-store-setup project):
- **Production Store Created**: `fileSearchStores/seed-reference-materials-pr-jma5jhay17is`
- **All 62 Files Uploaded**: 100% success rate, 0 failures
- **Scripts Operational**: create-store.sh, upload-file.sh, bulk-upload-reference.sh
- **Query Skill Available**: gemini-file-search-seed-reference
- **Documentation**: Complete in `dev/active/reference-store-setup/`
- **Completion Date**: 2025-11-18 (3.5 hours)

🔲 **Phase 2 Pending**: Integration with review command
- Build `/review-draft-seed-perspective-gemini-file-search` command
- Implement 15-check grading system using File Search
- Performance testing and validation

---

## Project Context

### Purpose
✅ **Infrastructure Complete**: Google File Search store with all Reference materials now operational.

**Remaining Work**: Integrate the existing File Search store into the `/review-draft-seed-perspective` command to enable intelligent, token-efficient draft reviews with 60-80% token reduction.

### Business Driver
Current approach costs ~$30/month for 100 reviews. File Search reduces this to ~$5/month while improving speed and relevance.

---

## Key Files & Locations

### Existing Files (Reference)

**Original Command**:
```
.claude/commands/review-draft-seed-perspective.md
```
- Current implementation that loads all 50+ reference files
- 15-check grading system
- Must maintain exact same grading logic

**Reference Materials** (To Be Indexed):
```
Reference/
├── Claims/
│   ├── AM-02/ (~15 files) - Focus + Energy product claims
│   ├── DM-02/ (~18 files) - Daily Multivitamin product claims
│   └── PM-02/ (~12 files) - Sleep + Restore product claims
├── NPD-Messaging/ (~3 files) - Product positioning and messaging
├── SciComms Education Files/ (~3 files) - Educational content
├── Compliance/ (~2 files) - NO-NO words and forbidden terms
└── Style/ (~5 files) - Tone guides and sample articles
```

### Files Created (Phase 1 - ✅ Complete)

**Reference Store Setup** (`dev/active/reference-store-setup/`):
```
dev/active/reference-store-setup/
├── scripts/
│   ├── create-store.sh              # ✅ Create File Search store
│   ├── upload-file.sh               # ✅ Upload single file
│   └── bulk-upload-reference.sh     # ✅ Bulk upload with metadata
├── REFERENCE_STORE_ID               # ✅ Production store ID
├── STORE_SUMMARY.md                 # ✅ Complete documentation
├── README.md                        # ✅ Project overview
├── HANDOFF_NOTES.md                 # ✅ Session notes
└── upload-log-20251118-014630.txt   # ✅ Upload log
```

**Gemini File Search Skill** (`.claude/skills/gemini-file-search-seed-reference/`):
```
.claude/skills/gemini-file-search-seed-reference/
├── SKILL.md                         # ✅ Skill documentation
├── scripts/
│   └── query-store.sh               # ✅ Query with natural language
├── references/
│   └── store-reference.md           # ✅ Comprehensive reference
└── SKILL_CREATION_NOTES.md          # ✅ Implementation notes
```

### Files To Be Created (Phase 2-3)

**New Command**:
```
.claude/commands/review-draft-seed-perspective-gemini-file-search.md
```

**API Key Storage** (✅ Created):
```
~/.claude/skills/gemini-api-key  # ✅ Contains paid tier API key
```

---

## Critical Technical Decisions

### Decision 1: Paid Tier API (✅ IMPLEMENTED)
**Choice**: Use paid tier Gemini API
**Rationale**: Protects Seed proprietary content from being used for training
**API Key**: `AIzaSyDSii2SLQEV4wxRxzfErwp4OSB1T4Y9PXo` (stored in ~/.claude/skills/gemini-api-key)
**Status**: ✅ Created and verified working
**Implications**:
- Data NOT used for model training ✅
- 30-day retention for abuse detection only
- Enterprise-grade privacy protections

### Decision 2: Resumable Upload Protocol (✅ IMPLEMENTED)
**Choice**: Use two-step resumable upload
**Rationale**: Official API documentation specifies this approach
**Status**: ✅ Implemented in upload-file.sh, tested with 62 files
**Implementation**:
1. Step 1: Initiate upload, get upload URL
2. Step 2: Upload file bytes with `--data-binary`
**Results**: 100% success rate across all uploads

### Decision 3: Metadata Structure (✅ IMPLEMENTED)
**Choice**: Store category, product, file_type, relative_path (4 fields per file)
**Rationale**: Enables filtering by product, category, and file type
**Status**: ✅ Applied to all 62 files, verified working
**Format**:
```json
[
  {"key": "category", "string_value": "Claims"},
  {"key": "product", "string_value": "DM-02"},
  {"key": "file_type", "string_value": "Ingredient-Claims"},
  {"key": "relative_path", "string_value": "Claims/DM-02/DM-02-General-Claims.md"}
]
```
**Validation**: Metadata filtering tested and working via query-store.sh

### Decision 4: Query Model (LOCKED IN)
**Choice**: Use `gemini-2.5-flash` for queries
**Rationale**: Fast, cost-effective, sufficient for retrieval
**Alternative**: `gemini-2.5-pro` if quality issues emerge

### Decision 5: Incremental Rollout (UPDATED)
**Original Choice**: Three-phase implementation
**Actual Implementation**:
- ✅ Phase 1 Complete: Production store with all 62 files (reference-store-setup)
- 🔲 Phase 2 Remaining: Partial command (Claims checks only)
- 🔲 Phase 3 Remaining: Full command (all 15 checks)
**Rationale**: Validate at each stage, reduce risk
**Status**: POC validation exceeded expectations, moved directly to production store

---

## Dependencies

### External Services

**Google Gemini API**:
- Endpoint: `https://generativelanguage.googleapis.com/v1beta/`
- Version: v1beta (subject to change)
- Models: gemini-2.5-flash, gemini-2.5-pro
- Authentication: API key via query parameter

**Required APIs**:
- File Search Stores API
- File Upload API
- Generative Language API

### System Requirements

**Tools**:
- bash 4.0+
- curl (for HTTP requests)
- jq (for JSON parsing)
- file command (for MIME type detection)

**Permissions**:
- Read access to `Reference/` directory
- Write access to `.claude/skills/`
- Write access to `~/.claude/skills/`

---

## Integration Points

### With Existing System

**Original Command**:
- Must remain functional (fallback)
- Grading logic must be identical
- All 15 checks must produce same results

**Reference Materials**:
- Read-only access
- No modifications to existing files
- Changes to references require re-indexing

**CLAUDE.md**:
- Add documentation for new skill
- Reference in workflows

### With Gemini API

**Authentication Flow**:
1. Read API key from `~/.claude/skills/gemini-api-key`
2. Export as `GEMINI_API_KEY` environment variable
3. Include in all API calls as `?key=${GEMINI_API_KEY}`

**Upload Flow**:
1. Initiate resumable upload
2. Receive upload URL
3. Upload file bytes
4. Receive operation response

**Query Flow**:
1. Build request with file_search tool
2. Include store name and optional metadata filter
3. Send to generateContent endpoint
4. Parse response with grounding metadata

---

## Data Model

### File Search Store

**Structure**:
```json
{
  "name": "fileSearchStores/abc123xyz",
  "displayName": "seed-reference-materials-production",
  "createTime": "2025-11-13T...",
  "updateTime": "2025-11-13T...",
  "activeDocumentsCount": 60,
  "pendingDocumentsCount": 0,
  "failedDocumentsCount": 0,
  "sizeBytes": 512000
}
```

**Indexed Documents**:
- Total: ~60 files
- Total size: ~500k tokens
- Retention: Indefinite (until manual deletion)

### Query Response

**Structure**:
```json
{
  "candidates": [{
    "content": {
      "parts": [{
        "text": "Retrieved content with claims, DOI links, etc."
      }]
    },
    "groundingMetadata": {
      "groundingChunks": [
        {
          "grounding": {
            "fileSearchStore": {
              "fileName": "DM-02-General-Claims.md",
              "chunkIndex": 0
            }
          }
        }
      ]
    }
  }]
}
```

**Extraction**:
- Content: `.candidates[0].content.parts[0].text`
- Sources: `.candidates[0].groundingMetadata.groundingChunks[]`

---

## Query Patterns

### Pattern 1: Claims Retrieval

**Purpose**: Get product-specific health claims
**Template**:
```
For an article about '${KEYWORD}' for ${PRODUCT}, retrieve:
1. General health claims from ${PRODUCT}-General-Claims.md
2. Ingredient-specific claims for: ${INGREDIENTS}
3. Include exact DOI links and study substantiation
4. Focus on claims relevant to: ${H2_HEADINGS}
5. Include dose information where applicable
```

**Metadata Filter**: `product=${PRODUCT} AND file_type=Claims`

### Pattern 2: NPD Messaging Retrieval

**Purpose**: Get positioning and differentiation messaging
**Template**:
```
For ${PRODUCT} article about '${KEYWORD}', retrieve:
1. Unique positioning and differentiators
2. Key narratives relevant to: ${MAIN_TOPICS}
3. Product-specific angles
4. Dirk Gevers quote suggestions
5. Critiques of mass-market alternatives
```

**Metadata Filter**: `file_type=NPD-Messaging AND product=${PRODUCT}`

### Pattern 3: SciComms Retrieval

**Purpose**: Get educational content and talking points
**Template**:
```
From SciComms education materials for ${PRODUCT}, retrieve:
- Keyword: ${KEYWORD}
- Topics covered: ${H2_HEADINGS}
- Only return sections relevant to THIS article
- Include talking points, narratives, pre-vetted sources
```

**Metadata Filter**: `file_type=SciComms AND product=${PRODUCT}`

---

## Testing Strategy

### Unit Testing

**Scripts to Test**:
- Each script individually
- Error handling
- Edge cases (missing files, bad store names)

**Test Fixtures**:
- Sample markdown files
- Mock API responses
- Test metadata structures

### Integration Testing

**End-to-End Flows**:
1. Create store → Upload → Query → Verify
2. Bulk index → Query multiple products → Verify
3. Command → Retrieve → Grade → Verify

**Success Criteria**:
- All scripts execute without errors
- Queries return expected content
- Grading matches original command

### Performance Testing

**Metrics to Measure**:
- Token usage per review
- Execution time per review
- Cost per review
- Retrieval relevance score

**Benchmarks**:
- Compare with original command
- Measure across different article types
- Track over multiple runs

---

## Troubleshooting Guide

### Common Issues

**Issue**: API key not found
**Solution**:
```bash
echo "API_KEY_HERE" > ~/.claude/skills/gemini-api-key
chmod 600 ~/.claude/skills/gemini-api-key
```

**Issue**: Upload fails with 404
**Solution**: Verify store name is correct format: `fileSearchStores/xxxxx`

**Issue**: Query returns empty results
**Solution**:
1. Check store has documents: `./get-store.sh STORE_NAME`
2. Verify metadata filter syntax
3. Try query without filter

**Issue**: Token usage not reduced
**Solution**:
1. Check query is retrieving from File Search, not loading files
2. Verify groundingMetadata present in response
3. Check for duplicate content retrieval

---

## Privacy & Compliance

### Data Protection

**What Gets Stored**:
- All content from Reference/ directory
- Vectorized embeddings of content
- Metadata (product, file_type, etc.)

**Where It's Stored**:
- Google Cloud infrastructure
- Exact location: Not publicly specified (likely US)
- Retention: Indefinite until manual deletion

**Who Can Access**:
- Only via your API key
- Google engineers for debugging (30-day retention)
- NOT used for model training (paid tier)

### Compliance Checklist

- [ ] Paid tier API confirmed
- [ ] Data processing terms reviewed
- [ ] Privacy policy accepted
- [ ] Store deletion process documented
- [ ] Re-indexing procedure defined

---

## Cost Tracking

### One-Time Costs

**Initial Indexing**:
- Volume: ~500k tokens
- Rate: $0.15 per 1M tokens
- Cost: ~$0.08

**Total Setup**: ~$0.08

### Ongoing Costs

**Per Review**:
- Query: FREE
- Context tokens: ~15k × $0.075/1M = $0.001125
- Total: ~$0.001 per review

**Monthly (100 reviews)**:
- Queries: FREE
- Context: 100 × $0.001 = $0.10
- Estimated total: ~$5/month (including buffer)

### Cost Comparison

| Metric | Original | File Search | Savings |
|--------|----------|-------------|---------|
| Per Review | $0.36 | $0.05 | 86% |
| Monthly (100) | $36 | $5 | $31 |
| Annual | $432 | $60 | $372 |

---

## Monitoring & Alerts

### Key Metrics to Track

**Usage**:
- Number of reviews per day/week/month
- Token usage per review
- API call count

**Performance**:
- Average execution time
- Query response time
- Retrieval relevance score

**Cost**:
- Daily API cost
- Monthly cumulative cost
- Cost per review trend

### Alert Thresholds

**Usage Alerts**:
- Daily reviews > 50 (investigate spike)
- Token usage > 25k per review (check for issues)

**Cost Alerts**:
- Daily cost > $2
- Monthly cost > $10
- Unexpected charges

**Quality Alerts**:
- Grading discrepancies vs original
- Missing content reports
- User feedback on relevance

---

## Rollback Plan

### Triggers for Rollback

**Immediate Rollback**:
- Critical grading errors (false negatives)
- Data privacy breach
- API service outage > 4 hours
- Cost exceeds 3x estimate

**Planned Rollback**:
- Consistent performance degradation
- Relevance score < 80%
- User dissatisfaction

### Rollback Procedure

1. **Switch to original command**:
   - Document rollback reason
   - Notify users
   - Use `/review-draft-seed-perspective` (original)

2. **Preserve File Search store**:
   - Don't delete store immediately
   - Keep for analysis and debugging

3. **Root cause analysis**:
   - Review logs and metrics
   - Identify failure mode
   - Document lessons learned

4. **Recovery plan**:
   - Fix identified issues
   - Re-test thoroughly
   - Gradual re-rollout

---

## Future Enhancements

### Potential Improvements

**Phase 4+**:
- Auto-detect reference material changes and re-index
- Query optimization based on usage patterns
- Multi-model support (switch to Pro for complex queries)
- Caching layer for frequently accessed content
- Batch processing for multiple reviews

**Advanced Features**:
- A/B testing framework for query prompts
- Relevance scoring and feedback loop
- Custom embeddings for domain-specific content
- Integration with other SEO commands

**Monitoring**:
- Grafana dashboard for metrics
- Automated cost reporting
- Performance trends analysis
- Query pattern analysis

---

## Resources

### Documentation

**Official**:
- Gemini API Docs: https://ai.google.dev/gemini-api/docs
- File Search Guide: https://ai.google.dev/gemini-api/docs/file-search
- API Reference: https://ai.google.dev/api/file-search/file-search-stores

**Internal**:
- Original command: `.claude/commands/review-draft-seed-perspective.md`
- Main CLAUDE.md: Project-level instructions
- Reference materials: `Reference/` directory

### Support

**Google**:
- AI Developer Forum
- Stack Overflow (tag: google-gemini)
- GitHub Issues (for SDK)

**Internal**:
- This context document
- Plan document
- Tasks checklist

---

## Production Store Information

### Actual Implementation Details (✅ Complete)

**Store ID**: `fileSearchStores/seed-reference-materials-pr-jma5jhay17is`
**Display Name**: Seed Reference Materials - Production v1
**Created**: 2025-11-18
**Status**: ✅ Production Ready

**Statistics**:
- Active Documents: 62/62
- Failed Documents: 0
- Total Size: 685 KB
- Upload Duration: 274 seconds (4 min 34 sec)
- Indexing Cost: ~$0.053

**Access Methods**:
1. Via skill: `gemini-file-search-seed-reference`
2. Direct query: `.claude/skills/gemini-file-search-seed-reference/scripts/query-store.sh`
3. Manual API calls: See `dev/active/reference-store-setup/STORE_SUMMARY.md`

**Related Documentation**:
- Store setup: `dev/active/reference-store-setup/`
- Query patterns: `.claude/skills/gemini-file-search-seed-reference/SKILL.md`
- API reference: `.claude/skills/gemini-file-search-seed-reference/references/store-reference.md`

**Maintenance**:
- Re-indexing when files change: See `dev/active/reference-store-setup/scripts/upload-file.sh`
- Quarterly health check: Next review 2026-02-18

---

## Glossary

**File Search Store**: Container for indexed documents with vector embeddings
**Grounding Metadata**: Citations showing which documents were used in response
**Resumable Upload**: Two-step upload process for large files
**Metadata Filter**: Query parameter to filter results by custom metadata
**RAG**: Retrieval Augmented Generation - using external documents to enhance LLM responses
**Vector Embedding**: Numerical representation of text for semantic search

---

**Last Review**: 2025-11-18
**Next Review**: After Phase 2-3 completion (command integration)
**Phase 1 Completion**: 2025-11-18 (reference-store-setup)
