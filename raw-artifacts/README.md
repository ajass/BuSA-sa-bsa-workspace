# Raw Artifacts

This folder is for dropping context documents before processing.

## Supported File Types (Copilot can read directly)

| Extension | Type | Notes |
|-----------|------|-------|
| `.md` | Markdown | Best format |
| `.txt` | Plain text | |
| `.csv` | Spreadsheet | For Jira exports, data |
| `.json` | Data | API responses, configs |
| `.yml` / `.yaml` | Config | |

## Unsupported Types (Must Convert)

| Extension | Convert To | How |
|-----------|------------|-----|
| `.pdf` | `.md` | Copy text, describe diagrams |
| `.docx` | `.md` | Copy text |
| `.pptx` | `.md` + images | Copy to text, save slides as images |
| `.eml` | `.md` | Copy to email template |
| `.msg` | `.md` | Export to text, copy to email template |
| `.png` / `.jpg` | Image + `.md` | Save to `images/`, create .md with reference |

## Templates

Use these templates for unstructured content:
- `TEMPLATE-business-background.md`
- `TEMPLATE-stakeholder-notes.md`
- `TEMPLATE-current-state-process.md`
- `TEMPLATE-constraints.md`
- `TEMPLATE-meeting-notes.md`
- `TEMPLATE-email-thread.md`

## Workflow

1. Drop files here (convert unsupported types first)
2. Run `/process-discovery`
3. Review extracted insights

## Images Folder

Save diagrams/screenshots to `images/` subfolder, then reference in .md:
```markdown
![Process Flow](../raw-artifacts/images/diagram.png)
```
