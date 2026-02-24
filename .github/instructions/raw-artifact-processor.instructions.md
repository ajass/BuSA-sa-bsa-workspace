---
name: 'Raw Artifact Processor'
description: 'Instructions for processing raw context artifacts into structured insights'
applyTo: 'raw-artifacts/**'
---

# Raw Artifact Processor Instructions

You are processing raw context documents to extract structured insights.

## Supported Input Formats

GitHub Copilot can read these file types directly:
- `.md` (Markdown)
- `.txt` (Plain text)
- `.csv` (Comma-separated)
- `.json` (JSON)
- `.yml` / `.yaml` (YAML)

**Copilot CANNOT read these directly** - must convert first:
- `.pdf` (Documents)
- `.docx` (Word)
- `.pptx` (PowerPoint)
- Images (`.png`, `.jpg`)

## Input Conversion Guide

For each unsupported file type, convert as follows:

### PDF Documents
1. Copy text content to new `.md` file
2. For diagrams/s swimlanes: Describe the flow in text OR save as image reference
3. Filename: `[original-name]-extracted.md`

### Emails
1. Create new `.md` file
2. Header: `From: | To: | Date: | Subject:`
3. Body: Copy email content
4. Filename: `email-YYYY-MM-DD-[subject].md`

### Meeting Transcripts
1. Save as `.md` file
2. Header: `Meeting: | Date: | Attendees:`
3. Structure: Use `##` for topics, `-` for discussion points
4. Filename: `meeting-YYYY-MM-DD-[topic].md`

### Images (Screenshots, Swimlanes)
1. Save image to `raw-artifacts/images/` subfolder
2. Create `.md` file with image reference:
```markdown
![Diagram description](../raw-artifacts/images/diagram-name.png)

## Description
[Describe what this diagram shows]
```
3. Copilot will describe the image when you reference it

## Processing Rules

### Step 1: Inventory First
1. List ALL files found in raw-artifacts/
2. Note file types
3. Identify unsupported types → note conversion needed

### Step 2: Check for Conversion Needed
For each unsupported file, add to conversion checklist:
- [ ] PDF: [filename] → [new-filename].md
- [ ] Email: [filename] → [new-filename].md

### Step 3: Read Converted Content
After conversion, read all markdown files.

### Step 4: Extract Insights
Follow standard extraction rules (see main instructions)

## Standardized Markdown Structure

### For Meeting Notes
```markdown
# Meeting: [Topic]

**Date:** YYYY-MM-DD
**Attendees:** [Names/Roles]

## Agenda
1. Topic 1
2. Topic 2

## Discussion

### Topic 1
- Point from [person]:
- Decision:

### Topic 2
- Point from [person]:
- Action Item: [Task] - [Owner]

## Decisions Made
| Decision | Owner | Status |
|----------|-------|--------|
|          |       |        |

## Action Items
| Item | Owner | Due Date |
|------|-------|----------|
|      |       |          |
```

### For Email Threads
```markdown
# Email: [Subject]

**From:** [sender]
**To:** [recipients]
**Date:** YYYY-MM-DD
**CC:** [cc]

---

## Original Message
[Content here]

---

## Reply/Thread Notes
[If relevant, notes about the thread]
```

## Output Files

After processing, generate standard outputs in `extracted-insights/01-discovery/`.

## Validation

Before outputting, verify:
- [ ] All supported files read
- [ ] Unsupported files noted with conversion needed
- [ ] Meeting notes standardized
- [ ] Email threads documented
- [ ] Image references created
