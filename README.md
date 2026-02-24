# Solution Architecture + BSA Orchestration Layer

A context-driven workspace for Solution Architects and Business Systems Analysts working on enterprise GIS projects.

## Purpose

This workspace provides a structured, repeatable methodology for:
- Transforming raw business context into structured requirements
- Generating traceable architecture artifacts
- Analyzing environment impacts
- Creating test strategies with full requirements traceability
- Managing compliance and risk

## Quick Start

1. **Drop context** into `raw-artifacts/` folder
2. **Invoke Copilot** with prompt commands (see WORKFLOW.md)
3. **Review generated** outputs in `extracted-insights/`

## Folder Structure

```
project-name/
├── raw-artifacts/                    # INPUT: Drop context here
│   ├── business-background.md
│   ├── stakeholder-notes.md
│   ├── jira-export.csv
│   ├── current-state-process.md
│   └── constraints.md
│
├── extracted-insights/               # OUTPUT: Generated artifacts
│   ├── 01-discovery/                 # Requirements & capabilities
│   ├── 02-architecture/              # C4 diagrams & ADRs
│   ├── 03-environments/              # Impact & deployment
│   ├── 04-testing/                   # Test plans & traceability
│   └── 05-compliance/                # Risk & compliance
│
└── .github/
    ├── copilot-instructions.md       # Main orchestration
    └── instructions/                 # Phase-specific rules
```

## Key Features

### Structured Discovery
- Stakeholder mapping and RACI
- Functional and non-functional requirements
- Capability gap analysis
- MoSCoW prioritization

### Repeatable Artifacts
- C4 architecture diagrams (Mermaid)
- Requirements Traceability Matrix (RTM)
- Test plans (SIT1, SIT2, UAT)
- Risk Register
- Architecture Decision Records (ADRs)

### Traceability Enforcement
- Every requirement → architecture element → test case
- Orphan detection (unlinked items flagged)
- Full forward and backward traceability

### GIS-Aware
- Spatial data flow considerations
- Geodatabase and map service patterns
- Coordinate system awareness
- GIS-specific NFRs

## Requirements

- VS Code with GitHub Copilot extension
- GitHub Copilot subscription
- Copilot instructions enabled
- Pandoc (for file conversion)

## Automatic File Conversion

Drop any file type into `raw-artifacts/` - the conversion script automatically converts to Markdown:

| Input | Output |
|-------|--------|
| `.pdf` | Markdown |
| `.docx` | Markdown |
| `.pptx` | Markdown (with slide markers) |
| `.xlsx` | Markdown (tables) |
| `.md` | Copied |
| `.csv` | Copied |
| Images | Markdown reference + `images/` |

### Run Conversion

**macOS / Linux:**
```bash
bash scripts/convert.sh
```

**Windows:**
```cmd
scripts\convert.bat
```
OR
```powershell
powershell -ExecutionPolicy Bypass -File scripts\convert.ps1
```

## Setup

1. Clone/copy this workspace structure
2. Install pandoc:
   - **macOS:** `brew install pandoc`
   - **Windows:** `choco install pandoc` or download from [pandoc.org](https://pandoc.org/installing.html)
   - **Linux:** `sudo apt install pandoc` or `sudo yum install pandoc`
3. Open in VS Code
4. Ensure Copilot is enabled: `Cmd/Ctrl+Shift+P` → "Copilot: Enable"
5. Verify instructions loaded: Copilot chat shows "instructions loaded"

## Documentation

- [WORKFLOW.md](./WORKFLOW.md) - Step-by-step usage guide
- [.github/copilot-instructions.md](./.github/copilot-instructions.md) - Full instruction reference
- [Template files](./raw-artifacts/) - Context input templates

## Principles

1. **Context First** - Never generate without understanding the problem
2. **Requirements Before Solution** - Architecture follows requirements
3. **Trace Everything** - No orphan artifacts
4. **Risk Always** - Every phase includes risk assessment
5. **No Cowboy Diagramming** - Every element traces to source

## Support

This workspace follows TOGAF-inspired methodology adapted for GIS solution architecture.
