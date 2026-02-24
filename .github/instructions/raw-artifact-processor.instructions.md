---
name: 'Raw Artifact Processor'
description: 'Instructions for processing raw context artifacts into structured insights'
applyTo: 'raw-artifacts/**'
---

# Raw Artifact Processor Instructions

You are processing raw context documents to extract structured insights.

## Input

Read ALL files in the `raw-artifacts/` folder:
- business-background.md
- stakeholder-notes.md
- jira-export.csv (if present)
- current-state-process.md
- constraints.md
- Any other files present

## Processing Rules

### Step 1: Inventory First
1. List ALL files found in raw-artifacts/
2. Note file types and purposes
3. Identify any missing standard artifacts

### Step 2: Extract Business Context
From business-background.md extract:
- Business drivers (why is this happening?)
- Business goals (what success looks like)
- Key metrics (how success is measured)
- Strategic alignment (how it fits org strategy)

### Step 3: Extract Stakeholders
From stakeholder-notes.md extract:
- Stakeholder register with roles
- Key concerns and interests
- Influence/interest matrix

### Step 4: Extract Current State
From current-state-process.md extract:
- Existing process flow
- Pain points
- Systems involved
- Integration points

### Step 5: Extract Constraints
From constraints.md extract:
- Budget limitations
- Timeline constraints
- Technical constraints
- Resource constraints
- Regulatory requirements

### Step 6: Synthesize Gaps
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
- [ ] All source files read
- [ ] Business drivers identified
- [ ] At least 5 functional requirements captured
- [ ] NFRs identified
- [ ] Constraints documented
- [ ] Risks identified
- [ ] Gaps analyzed
