# Changelog

All notable changes to this Solution Architecture + BSA workspace should be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Automatic file conversion scripts (scripts/convert.sh)
- PPTX (PowerPoint) conversion support
- Excel (.xlsx) conversion support
- Image reference generation for diagrams/screenshots
- Virtual environment support for Python converter
- raw-artifacts/images/ folder for converted images
- Additional templates: meeting-notes, email-thread
- raw-artifacts/README.md with file type reference

### Changed
- Updated discovery phase workflow with automatic conversion
- Improved convert.sh with comprehensive error handling

### Removed

### Fixed

---

## [1.0.0] - YYYY-MM-DD

### Added
- Initial template release
- Phase 1: Discovery (requirements extraction)
- Phase 2: Architecture (C4 diagrams, ADRs)
- Phase 3: Environments (impact analysis, release strategy)
- Phase 4: Testing (SIT1, SIT2, UAT, RTM)
- Phase 5: Compliance (risk register, security)
- GIS-specific considerations
- Traceability enforcement rules
- Prompt commands (/process-discovery, /process-architecture, etc.)

### Changed

### Removed

### Fixed

---

## How to Use This Changelog

### Starting a New Project
1. Copy this workspace to your project folder
2. Update `[Unreleased]` to `[1.0.0]` with today's date
3. Start making project-specific customizations
4. Document changes under `[Unreleased]`

### Recording Changes
When you customize the template for a project, add entries under the appropriate section:

- **Added** - New files, templates, phases, or commands you created
- **Changed** - Modified existing templates, workflows, or instructions
- **Removed** - Deleted items you didn't need
- **Fixed** - Bug fixes or corrections to the template

### Example Entries

```markdown
## [Unreleased]

### Added
- Added `raw-artifacts/cloud-assessment.md` template for cloud migration projects

### Changed
- Updated functional-requirements.md to include additional GIS-specific fields
- Changed traceability ID format from FR-XXX to REQ-FR-XXX for clarity

### Removed
- Removed 05-compliance folder (not needed for internal projects)

### Fixed
- Fixed Mermaid syntax error in c4-container.puml
- Corrected missing requirement ID tags in architecture diagrams
```

### Version Numbering
- **1.0.0** - Initial project-specific release
- **1.1.0** - Added new functionality
- **1.1.1** - Bug fixes or minor corrections
- **2.0.0** - Breaking changes (new workflow, removed phases)

---

## Project Specifics

### Project Name: [Enter project name]
### Project Start Date: [Enter date]
### Base Template Version: [Enter version if known]

#### Customizations Made for This Project:

| Date | Change | Reason |
|------|--------|--------|
|      |        |        |
|      |        |        |
|      |        |        |

---

## Template Customization Log

Use this section to track quick notes during active customization:

```
[Date] - 
[Date] - 
[Date] - 
```

---

*This changelog is part of the Solution Architecture + BSA workspace template.*
*For the base template repository, visit: [URL if applicable]*
