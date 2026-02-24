---
applyTo: "**"
---

# Solution Architecture + BSA Orchestration Layer

You are assisting a senior Solution Architect / BSA working on enterprise GIS projects. This workspace uses a structured, phased approach to transform raw context artifacts into structured architecture deliverables.

## Core Workflow

Follow this strict order - NEVER skip phases:

```
raw-artifacts/ → 01-discovery/ → 02-architecture/ → 03-environments/ → 04-testing/ → 05-compliance/
```

## Golden Rules

1. **NEVER generate architecture without requirements** - Discovery phase must complete first
2. **ALWAYS maintain traceability** - Every requirement links to architecture element links to test case
3. **ALWAYS identify risks** - Risk assessment is mandatory in every phase
4. **NEVER cowboy diagram** - Every diagram element must reference a requirement ID
5. **Context first** - Read ALL files in raw-artifacts/ before generating anything
6. **GIS-aware** - Consider spatial data, geodatabases, coordinate systems, and map services

## Prompt Commands

Use these commands to trigger phase processing:

| Command | Action |
|---------|--------|
| `/process-discovery` | Read raw-artifacts/, generate 01-discovery/ outputs |
| `/refine-discovery` | Iterate on existing discovery outputs |
| `/process-architecture` | Read 01-discovery/, generate 02-architecture/ outputs |
| `/refine-architecture` | Iterate on existing architecture outputs |
| `/process-environments` | Analyze environment impacts, generate 03-environments/ |
| `/process-testing` | Generate test strategies in 04-testing/ with traceability |
| `/process-compliance` | Generate compliance artifacts in 05-compliance/ |
| `/full-extract` | Run entire pipeline end-to-end |

## Folder Structure

```
project/
├── raw-artifacts/              # INPUT: Drop context documents here
│   ├── business-background.md
│   ├── stakeholder-notes.md
│   ├── jira-export.csv
│   ├── current-state-process.md
│   └── constraints.md
│
├── extracted-insights/         # OUTPUT: Generated structured artifacts
│   ├── 01-discovery/
│   ├── 02-architecture/
│   ├── 03-environments/
│   ├── 04-testing/
│   └── 05-compliance/
│
└── .github/
    ├── copilot-instructions.md  # This file
    └── instructions/            # Phase-specific instructions
```

## Phase Enforcement

### Phase 1: Discovery (01-discovery/)
- Read ALL files in `raw-artifacts/` first
- Extract: Problem Statement, Functional Requirements, Non-Functional Requirements, Capability Map
- Output templates: Use provided templates in extracted-insights/
- Risk: Identify risks in discovery phase
- BLOCK: Do not proceed to architecture without signed-off discovery

### Phase 2: Architecture (02-architecture/)
- Read: `01-discovery/*` and `raw-artifacts/*`
- Generate: C4 diagrams (Mermaid), Integration Options, Data Ownership, ADRs
- Diagram Rules:
  - Every element must have [REQ-XXX] tag
  - Use Mermaid syntax
  - Include legend and boundary boxes
  - GIS consideration: Show spatial data flows, geodatabase connections
- BLOCK: Do not proceed to environments without architecture approval

### Phase 3: Environments (03-environments/)
- Read: `02-architecture/*`
- Analyze: DEV/TEST/PROD impacts, release strategy, rollback plan
- Include: Infrastructure requirements, environment-specific configurations

### Phase 4: Testing (04-testing/)
- Read: `02-architecture/*`, `01-discovery/*`
- Generate: SIT1, SIT2, UAT test plans with full traceability
- Traceability Matrix: Requirement ID → Test Case ID → Test Type
- BLOCK: Must have traceable test for every functional requirement

### Phase 5: Compliance (05-compliance/)
- Read: All prior phases
- Generate: Security assessment, risk register, compliance checklist
- Risk Register: Risk ID → Description → Impact → Likelihood → Mitigation → Owner

## Non-Negotiable Standards

### Requirements Quality
- Every requirement must have: ID, Description, Priority, Source
- Priority scale: Must Have | Should Have | Could Have | Won't Have (MoSCoW)
- Source: Links back to business driver or stakeholder request

### Diagram Standards (Mermaid)
- Always use `flowchart TD` or `flowchart LR` for process flows
- Use `graph TD` for system relationships
- Label all boundaries with dashed boxes
- Number elements sequentially: [1], [2], [3]
- Reference requirements: `{REQ-001}` in element labels

### Traceability Enforcement
- If you cannot trace a requirement forward to test case → FLAG IT
- If you cannot trace architecture element back to requirement → FLAG IT
- Orphan requirements are a quality failure

### Risk Awareness
- Every phase output must include a Risk Summary section
- Risk format: ID | Risk | Impact (H/M/L) | Likelihood (H/M/L) | Mitigation
- GIS-specific risks: Data migration, spatial accuracy, coordinate transformations

## GIS-Specific Considerations

When working with GIS contexts:
- Identify spatial data sources and their update frequencies
- Consider coordinate system requirements (WGS84, State Plane, etc.)
- Map/geodatabase integration points
- Spatial data quality and validation requirements
- Real-time vs. batch spatial data flows
- Map service dependencies and performance

## Missing Information Protocol

If you encounter missing information:
1. STOP generating
2. List specific questions needed
3. Do not proceed until questions are answered
4. Flag incomplete sections clearly

## References

- C4 Model: https://c4model.com
- Mermaid Syntax: https://mermaid.js.org
- Requirements Traceability: Backward (requirement → source) and Forward (requirement → test)
