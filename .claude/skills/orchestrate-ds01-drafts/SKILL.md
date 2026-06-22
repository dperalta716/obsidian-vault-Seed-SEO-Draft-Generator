---
name: Orchestrate DS-01 Drafts End to End
description: >
  Batch orchestrator for DS-01 article production. Takes a combined SciCare POV briefs
  file (or a folder of pre-split briefs), splits into individual keywords, then runs
  /generate-ds01-draft on ALL keywords in parallel with pre-assigned folder numbers to
  prevent collisions. After user checkpoint, runs /full-draft-review-auto-ds01 on each
  draft in parallel. Use when processing a batch of SciCare briefs, when the user says
  "run the batch," "process these briefs," "generate all drafts," "orchestrate,"
  or references generating multiple DS-01 articles at once from a set of POV briefs.
argument-hint: path to combined briefs file or pre-split briefs folder
user-invocable: true
---

# Orchestrate DS-01 Drafts End to End

Batch-process SciCare POV briefs into fully reviewed, uploaded DS-01 articles. Handles splitting, parallel draft generation, checkpoint review, and parallel full-review — all with pre-assigned folder numbers to prevent the collision problem that happens when multiple agents auto-detect the next number simultaneously.

## Step 0: Apply Learnings

Read the `## Rules` section below and `learnings.md` in this skill's directory. Apply all rules during this execution. If any rules conflict with the current task, flag the conflict to the user.

## Step 1: Parse Input

Determine what the user provided in `$ARGUMENTS`:

**If it's a file path** (ends in `.md`):
- Verify the file exists
- This is a combined briefs file — proceed to Step 2

**If it's a directory path**:
- List all `.md` files in the directory
- These are pre-split briefs — skip to Step 4

**If no argument or unclear**:
- Ask the user: "Point me to the combined briefs file or the folder with pre-split briefs."

## Step 2: Extract Date & Create Folder

Parse a date from the input filename to create the date-stamped subfolder.

**Common filename patterns:**
- `SciCare POV Brief - 5_20_26.md` → `2026-05-20`
- `SciCare POV Brief - 05_20_2026.md` → `2026-05-20`
- `briefs-2026-05-20.md` → `2026-05-20`

**Parsing logic:**
- Look for digit groups separated by `_` or `-` in the filename
- For 2-digit years, prepend `20` (e.g., `26` → `2026`)
- If the first number is ≤ 12 and the second is ≤ 31, assume M/D/YY format
- If no date found in filename, check the first few lines of the file for a date
- Final fallback: use today's date

**Create the folder:**
```
Reference/SciCare POV briefs/[YYYY-MM-DD]/
```

If the folder already exists, warn the user and ask whether to overwrite or use the existing files.

## Step 3: Split Combined File into Individual Briefs

Read the combined file and split it into individual brief files.

**Splitting pattern:**
Each brief starts with a heading like `# **keyword**` followed by `**Target KW:** keyword`. Split on the `# **` pattern.

**For each brief section:**
1. Extract the keyword from the `**Target KW:** [keyword]` line
2. Save as `Reference/SciCare POV briefs/[YYYY-MM-DD]/[keyword].md`
3. Include everything from `**Target KW:**` through the end of that brief's suggested references

**Report to the user:**
```
Split into N briefs:
1. how to test gut health
2. best vegetables for gut health
3. best mushroom for gut health
4. is green tea good for gut health
5. are bananas good for gut health
6. best bread for gut health
```

## Step 4: Pre-Assign Folder Numbers

This step prevents the numbering collision that happens when parallel agents all read the same "highest number" at the same time.

1. Read the `Generated-Drafts/` directory listing
2. Extract all 3-digit numeric prefixes
3. Find the highest number
4. Assign the next N sequential numbers (one per brief)
5. Pre-create all N folders in `Generated-Drafts/`:

```bash
# Example: if highest is 094 and there are 6 briefs
# Include competitors/ subfolder — sub-agents save scraped competitor content here
mkdir -p "Generated-Drafts/095-how-to-test-gut-health/competitors"
mkdir -p "Generated-Drafts/096-best-vegetables-for-gut-health/competitors"
mkdir -p "Generated-Drafts/097-best-mushroom-for-gut-health/competitors"
mkdir -p "Generated-Drafts/098-is-green-tea-good-for-gut-health/competitors"
mkdir -p "Generated-Drafts/099-are-bananas-good-for-gut-health/competitors"
mkdir -p "Generated-Drafts/100-best-bread-for-gut-health/competitors"
```

**Display the assignment table:**
```
Folder Assignments:
095 → how to test gut health
096 → best vegetables for gut health
097 → best mushroom for gut health
098 → is green tea good for gut health
099 → are bananas good for gut health
100 → best bread for gut health
```

## Step 5: Spawn Draft Generation Subagents

Launch one Agent subagent per brief — **all in a single message** for true parallelism.

Each agent's prompt should include:

1. **The keyword** to generate the draft for
2. **The brief file path** so the agent reads it directly instead of searching:
   `Reference/SciCare POV briefs/[date]/[keyword].md`
3. **The pre-assigned folder** with explicit override instructions
4. **The skill to invoke**: `/generate-ds01-draft [keyword]`

**Template for each subagent prompt:**
```
Generate a DS-01 SEO article draft for the keyword "[keyword]".

Your SciCare POV brief is at: [brief file path]
Read it directly — do not search for it. This replaces the Phase 0 brief lookup.

Your output folder is: Generated-Drafts/[NNN]-[slug]/
This folder has been pre-created. Do NOT auto-detect the next folder number.
Use this folder exactly for all output files (stage1_analysis and v1 draft).

Invoke /generate-ds01-draft [keyword] and follow the full workflow.
Override the auto-numbering in Step 1.4 — use the pre-assigned folder above.
```

## Step 6: Monitor & Report

As each subagent completes, report to the user immediately:

- Success: `[keyword] — draft complete (Generated-Drafts/[NNN]-[slug]/)`
- Failure: `[keyword] — ERROR: [brief description of what went wrong]`

If an agent fails, let the others continue. Do not halt the entire batch.

Once ALL agents have completed (or failed), provide a summary:

```
Draft Generation Complete
=========================
[x] 095 - how to test gut health
[x] 096 - best vegetables for gut health
[x] 097 - best mushroom for gut health
[x] 098 - is green tea good for gut health
[ ] 099 - are bananas good for gut health (FAILED: DataForSEO timeout)
[x] 100 - best bread for gut health

5/6 successful. Say "continue" to run full review on all completed drafts.
```

## Step 7: Checkpoint

**STOP and WAIT** for the user to say "continue" (or equivalent).

Do not proceed automatically. The user needs time to review the drafts and may want to:
- Re-run a failed draft
- Review a specific draft before proceeding
- Adjust something before the review phase

If the user asks to retry a specific draft, spawn a single agent for that keyword using the same folder assignment.

## Step 8: Spawn Review Subagents

On "continue," launch one Agent subagent per completed draft — **all in a single message**.

Each agent's prompt should include:

1. **The path to the v1 draft file**
2. **The skill to invoke**: `/full-draft-review-auto-ds01 [path-to-v1-file]`

**Template for each subagent prompt:**
```
Run the full DS-01 draft review pipeline on this article:
[path to v1 draft file, e.g., Generated-Drafts/095-how-to-test-gut-health/v1-how-to-test-gut-health-claude-draft.md]

Invoke /full-draft-review-auto-ds01 with the file path above.
Run all 5 steps: Seed Perspective → Quality → Sources → Claims → Upload to Google Docs.
Report back with the completion summary and Google Docs link.
```

## Step 9: Monitor & Final Report

Same pattern as Step 6. Report each completion with the Google Docs link.

Final summary:
```
Full Review Complete
====================
[x] 095 - how to test gut health → [Google Docs link]
[x] 096 - best vegetables for gut health → [Google Docs link]
[x] 097 - best mushroom for gut health → [Google Docs link]
[x] 098 - is green tea good for gut health → [Google Docs link]
[x] 100 - best bread for gut health → [Google Docs link]

5 drafts generated, reviewed, and uploaded to Google Docs.
All entries added to Phase 3 Tracking spreadsheet.
```

## Step 10: Collect Feedback

After delivering the final report, ask:

"How did this batch go? Anything I should do differently next time?"

- If the user provides feedback: trigger the Self-Update process
- If the user says it's fine or moves on: no action needed

---

## Rules

*Updated when the user flags issues. Read before every run.*

<!-- Rules accumulate here as the skill is used. Keep each rule to 1-2 lines. -->

- Parallel upload agents race on the Phase 3 Tracking sheet — they independently find/append a row and can collide (seen: two agents wrote the same row, one overwrote the other, leaving a blank row). After the upload batch, ALWAYS read back the tracking rows for every keyword and confirm each has its own distinct doc link; patch any blank/duplicated row. Better: have the orchestrator (not the sub-agents) write all tracking rows sequentially after uploads, or pre-assign each keyword its row number.
- Recurring Google upload auth death (`invalid_grant`/`invalid_rapt`, ~weekly) is the OAuth consent screen being in "Testing" mode (7-day refresh-token expiry), NOT a script bug. Permanent fix: publish the consent screen to Production (Cloud Console → Google Auth Platform → Audience → Publish app). Re-auth via `~/.claude/skills/google-workspace-credentials/reauth.py <email>` and verify a Drive 200 before spawning upload agents.

---

## Self-Update

When the user provides feedback — wrong output, bad format, missing nuance, incorrect behavior — respond in this order:

1. **Fix the current output** based on the feedback
2. **Fix the source** — update this SKILL.md step or whatever caused the problem so it doesn't recur
3. **Add a Rule** to the `## Rules` section above if Claude might repeat the mistake in a future session (1-2 lines, specific and actionable)
4. **Log to `learnings.md`** only if the failure story adds context that the fix alone doesn't convey — the class of problem, the non-obvious root cause, or the reasoning behind the fix
