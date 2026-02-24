---
name: 'Raw Artifact Processor'
description: 'Instructions for processing raw context artifacts into structured insights'
applyTo: 'raw-artifacts/**'
---

# Raw Artifact Processor Instructions

You are processing raw context documents to extract structured insights.

## STEP 1: Automatic File Conversion

Before reading any files, check if conversion is needed and run the converter:

### Check for unsupported files
Look for these file types in `raw-artifacts/`:
- `.pdf` - PDF documents
- `.docx` - Word documents
- `.pptx` - PowerPoint
- `.eml` / `.msg` - Email files
- Images (`.png`, `.jpg`, `.jpeg`)

### Run the converter
If unsupported files exist, execute the conversion script:

```bash
# Option 1: Shell script (requires pandoc)
cd /path/to/project
bash scripts/convert.sh

# Option 2: Python script
cd /path/to/project
python3 scripts/convert_artifacts.py --input raw-artifacts --output raw-artifacts/converted
```

After running, Copilot should read from `raw-artifacts/converted/` instead of `raw-artifacts/`.

### Manual conversion fallback
If conversion scripts fail or aren't available:
1. For PDFs: Use online tools or copy text manually
2. For images: Create `.md` file with image reference (see template below)
3. For emails: Use `TEMPLATE-email-thread.md`

## STEP 2: Read Converted Files

After conversion, read ALL files from `raw-artifacts/` (or `raw-artifacts/converted/`):

Required files to read:
- business-background.md
- stakeholder-notes.md
- current-state-process.md
- constraints.md

Optional files:
- jira-export.csv
- meeting notes
- email threads
- converted PDFs/DOCXs

## STEP 3: Extract Business Context

From business-background.md extract:
- Business drivers (why is this happening?)
- Business goals (what success looks like)
- Key metrics (how success is measured)
- Strategic alignment (how it fits org strategy)

## STEP 4: Extract Stakeholders

From stakeholder-notes.md extract:
- Stakeholder register with roles
- Key concerns and interests
- Influence/interest matrix

## STEP 5: Extract Current State

From current-state-process.md extract:
- Existing process flow
- Pain points
- Systems involved
- Integration points

## STEP 6: Extract Constraints

From constraints.md extract:
- Budget limitations
- Timeline constraints
- Technical constraints
- Resource constraints
- Regulatory requirements

## STEP 7: Synthesize Gaps

Identify gaps between current state and desired future state:
- Capability gaps
- Process gaps
- Technology gaps
- Data gaps

## Output Files

Generate these files in `extracted-insights/01-discovery/`:

1. **problem-statement.md**
   - Problem summary (2-3 sentences)
   - Root causes identified
   - Impact if not addressed
   - Opportunity if addressed

2. **functional-requirements.md**
   - Structured requirements with IDs (FR-001, FR-002, etc.)
   - Each requirement: ID, Title, Description, Priority, Source
   - Group by capability area

3. **non-functional-requirements.md**
   - Quality attributes: Performance, Security, Scalability, Availability
   - Each NFR: ID, Category, Requirement, Acceptance Criteria
   - GIS-specific NFRs if applicable

4. **capability-map.md**
   - Current capabilities
   - Future capabilities needed
   - Gap analysis table
   - Priority capabilities

5. **stakeholder-matrix.md**
   - RACI matrix: Stakeholder vs. Deliverable
   - Communication plan

## Risk Identification

Include a **Risk Summary** section in problem-statement.md:
- Risk ID, Description, Impact, Likelihood, Mitigation

## GIS Considerations

If GIS context is present:
- Note spatial data requirements
- Identify geodatabase/map service dependencies
- Flag any coordinate system requirements

## Questions to Ask

If critical information is missing, list questions BEFORE generating:
1.
2.
3.

## Validation

Before outputting, verify:
- [ ] Conversion script run (or manual conversion noted)
- [ ] All source files read
- [ ] Business drivers identified
- [ ] At least 5 functional requirements captured
- [ ] NFRs identified
- [ ] Constraints documented
- [ ] Risks identified
- [ ] Gaps analyzed
