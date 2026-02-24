---
name: 'Requirements Generator'
description: 'Instructions for generating structured requirements from discovery phase'
applyTo: 'extracted-insights/01-discovery/**'
---

# Requirements Generator Instructions

You are generating structured, traceable requirements from the discovery phase outputs.

## Input

Read files in `extracted-insights/01-discovery/`:
- problem-statement.md
- functional-requirements.md
- non-functional-requirements.md
- capability-map.md
- stakeholder-matrix.md

Also reference raw-artifacts/ for full context.

## Requirements Elicitation Framework

### Functional Requirements

Generate requirements using this structure:

```
## FR-XXX: [Requirement Title]

**Description:** [What the system must do]

**Priority:** [Must Have | Should Have | Could Have | Won't Have]

**Source:** [Which stakeholder or driver this comes from]

**Acceptance Criteria:**
1. [Testable criterion]
2. [Testable criterion]

**Traceability:**
- Parent Driver: [DRV-XXX]
- Parent Capability: [CAP-XXX]
```

### Requirement ID Convention
- FR-XXX: Functional Requirements
- NFR-XXX: Non-Functional Requirements
- DRV-XXX: Business Drivers
- CAP-XXX: Capabilities
- STP-XXX: Stakeholders

### Non-Functional Requirements

Generate NFRs in these categories:
1. **Performance** - Response times, throughput, capacity
2. **Security** - Authentication, authorization, data protection
3. **Scalability** - Growth handling, concurrency
4. **Availability** - Uptime, recovery, redundancy
5. **Usability** - User experience, accessibility
6. **Interoperability** - Integration capabilities, standards
7. **Data** - Quality, retention, governance
8. **GIS-Specific** - Spatial accuracy, map performance, coordinate handling

### Requirement Quality Checklist

For each requirement verify:
- [ ] Atomic (not decomposable)
- [ ] Testable (can verify acceptance)
- [ ] Traceable (links to source)
- [ ] Prioritized (MoSCoW assigned)
- [ ] Unambiguous (single interpretation)

### Traceability Matrix

Generate a traceability table:

| Req ID | Requirement | Source Driver | Priority | Testable |
|--------|-------------|---------------|----------|----------|
| FR-001 | ... | DRV-001 | Must Have | Yes |
| NFR-001 | ... | DRV-002 | Must Have | Yes |

### Gap Analysis

From capability-map, generate gap analysis:
- Current state gaps
- Proposed capabilities to fill gaps
- Priority for each gap

## Risk Assessment

Include Risk Summary:
- Risk ID, Description, Impact (H/M/L), Likelihood (H/M/L), Mitigation

## Questions

If requirements are unclear, ask:
1. What does "success" look like for [requirement]?
2. Who is the decision maker for this requirement?
3. What happens if this requirement is not met?

## Output

Overwrite/update these files in `extracted-insights/01-discovery/`:
- functional-requirements.md (enhanced with full structure)
- non-functional-requirements.md (complete NFR set)
- capability-map.md (with gap priorities)
- Add: requirements-traceability.md
