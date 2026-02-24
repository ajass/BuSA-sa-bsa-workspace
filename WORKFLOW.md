# Workflow Guide

Step-by-step guide for using this Solution Architecture + BSA orchestration layer.

## Overview

This workspace uses a **pipeline approach**: drop raw context → invoke Copilot → review structured outputs → iterate.

```
raw-artifacts/ → 01-discovery/ → 02-architecture/ → 03-environments/ → 04-testing/ → 05-compliance/
```

---

## Phase 0: Setup

### Step 1: Create Project Folder
Copy the workspace structure to your project location.

### Step 2: Install Prerequisites
```bash
# macOS
brew install pandoc

# Windows (using Chocolatey)
choco install pandoc

# Windows (manual): https://pandoc.org/installing.html
```

### Step 3: Drop Raw Context
Place context documents in `raw-artifacts/`:

| File | Purpose | Required |
|------|---------|----------|
| business-background.md | Business drivers, goals, metrics | Yes |
| stakeholder-notes.md | Stakeholder register, concerns | Yes |
| jira-export.csv | Existing requirements from Jira | Optional |
| current-state-process.md | Current process flows | Yes |
| constraints.md | Budget, timeline, technical limits | Yes |
| *.pdf, *.docx, *.pptx, *.xlsx | Other documents | Auto-converted |

**Supported file types** - just drop them in, they'll be auto-converted:
- PDF documents
- Word documents (.docx)
- PowerPoint presentations (.pptx)
- Excel spreadsheets (.xlsx)
- Images (screenshots, diagrams)
- Markdown, CSV, JSON

**Tip**: Use the template files in `raw-artifacts/` as guides.

### Step 4: Run Conversion
```bash
bash scripts/convert.sh
```

This converts all files to Markdown in `raw-artifacts/converted/`.

### Step 5: Verify Context
Ensure you have:
- Clear business problem statement
- Identified stakeholders
- Known constraints
- Current state understanding

---

## Phase 1: Discovery

### Goal
Transform raw context into structured requirements and capability analysis.

### Command
In Copilot Chat, type:
```
/process-discovery
```

### What Happens
Copilot runs `scripts/convert.sh` first (if not already run), then reads converted files from `raw-artifacts/converted/` and generates:

| Output File | Contents |
|-------------|----------|
| problem-statement.md | Synthesized problem, root causes, impact |
| functional-requirements.md | FR-XXX requirements with traceability |
| non-functional-requirements.md | NFRs (performance, security, GIS) |
| capability-map.md | Current vs. future capabilities |
| stakeholder-matrix.md | RACI matrix |

### Your Action
1. Review generated files
2. Validate requirements are accurate
3. Add missing items
4. If changes needed: `/refine-discovery`

### GIS Check
- Are spatial data requirements captured?
- Are GIS-specific NFRs included?

---

## Phase 2: Architecture

### Goal
Generate solution architecture from validated requirements.

### Prerequisites
- Discovery phase complete
- Requirements signed off by stakeholders

### Command
```
/process-architecture
```

### What Happens
Copilot reads discovery outputs and generates:

| Output File | Contents |
|-------------|----------|
| solution-overview.md | Executive summary, key decisions |
| c4-context.puml | System context diagram (Mermaid) |
| c4-container.puml | Application containers diagram |
| c4-component.puml | Component details |
| integration-options.md | Integration patterns evaluated |
| data-ownership.md | Data domains |
| architecture-decisions.md | ADRs |

### Diagram Rules
- Every element tagged with requirement ID: `{REQ-001}`
- Legend included
- Boundaries clearly marked

### Your Action
1. Review C4 diagrams
2. Validate traceability
3. Check integration approach
4. If changes needed: `/refine-architecture`

### GIS Check
- Are spatial data flows shown?
- Are geodatabase connections included?
- Are map services represented?

---

## Phase 3: Environments

### Goal
Analyze DEV/TEST/PROD impacts and create deployment strategy.

### Prerequisites
- Architecture approved

### Command
```
/process-environments
```

### What Happens
Copilot reads architecture outputs and generates:

| Output File | Contents |
|-------------|----------|
| dev-test-prod-impact.md | Component-by-environment matrix |
| release-strategy.md | Deployment approach, sequence |
| rollback-plan.md | Rollback procedures |
| infrastructure-requirements.md | Resource specs |

### Your Action
1. Review environment impacts
2. Validate release sequence
3. Ensure rollback plans exist

---

## Phase 4: Testing

### Goal
Generate test strategies with full requirements traceability.

### Prerequisites
- Architecture complete
- Integration points known

### Command
```
/process-testing
```

### What Happens
Copilot reads architecture and requirements, generates:

| Output File | Contents |
|-------------|----------|
| sit1-test-plan.md | Integration tests |
| sit2-test-plan.md | System tests |
| uat-test-plan.md | UAT scenarios |
| traceability-matrix.md | **CRITICAL**: RTM |
| regression-scope.md | Regression test scope |
| test-data-requirements.md | Test data needs |

### Traceability Matrix
This is critical. Every requirement must have:
- At least one test case
- Traceable test type (SIT1, SIT2, UAT)

| Requirement | Test Case | Type |
|-------------|-----------|------|
| FR-001 | TC-001, TC-002 | SIT1, UAT |

### Your Action
1. Review traceability matrix
2. Flag orphan requirements (no test)
3. Validate test coverage

---

## Phase 5: Compliance

### Goal
Generate risk register and compliance artifacts.

### Prerequisites
- Any prior phase (can run in parallel)

### Command
```
/process-compliance
```

### What Happens
Copilot reads all prior outputs and generates:

| Output File | Contents |
|-------------|----------|
| security-assessment.md | Security controls |
| data-governance.md | Data ownership, classification |
| accessibility-compliance.md | WCAG/508 compliance |
| risk-register.md | **CRITICAL**: Full risk register |
| compliance-checklist.md | Sign-off checklist |

### Your Action
1. Review risk register
2. Validate security controls
3. Complete sign-off checklist

---

## Iteration Commands

### Refine Discovery
```
/refine-discovery
```
Re-runs discovery phase with changes you've made.

### Refine Architecture
```
/refine-architecture
```
Re-runs architecture phase with updates.

### Full Pipeline
```
/full-extract
```
Runs entire pipeline end-to-end (requires all phases complete).

---

## Best Practices

### 1. Don't Skip Phases
Each phase builds on the previous. Skipping creates gaps.

### 2. Review Before Proceeding
Validate outputs before moving to next phase.

### 3. Maintain Traceability
If you manually edit outputs, maintain the ID system.

### 4. Document Decisions
Use architecture-decisions.md (ADRs) for key choices.

### 5. Flag Missing Info
If Copilot flags missing information, provide it before proceeding.

---

## GIS-Specific Tips

### Spatial Data Requirements
- Document all spatial data sources
- Note coordinate systems in use
- Identify spatial accuracy requirements

### Map Services
- Specify map service publishing approach
- Note caching requirements
- Identify performance targets for map rendering

### Integration
- Document geodatabase connection patterns
- Note real-time vs. batch spatial data flows

---

## Troubleshooting

### Copilot Not Loading Instructions
- Check: `Cmd/Ctrl+,` → Search "Copilot" → Enable "Instruction files"
- Verify: `.github/copilot-instructions.md` exists in workspace root

### Missing Outputs
- Verify source files exist in correct folders
- Check Copilot has read access to files

### Traceability Gaps
- Run `/refine-` commands to regenerate with fixes

---

## Quick Reference

| Goal | Command |
|------|---------|
| Start discovery | `/process-discovery` |
| Start architecture | `/process-architecture` |
| Start environments | `/process-environments` |
| Start testing | `/process-testing` |
| Start compliance | `/process-compliance` |
| Refine discovery | `/refine-discovery` |
| Refine architecture | `/refine-architecture` |
| Full pipeline | `/full-extract` |
