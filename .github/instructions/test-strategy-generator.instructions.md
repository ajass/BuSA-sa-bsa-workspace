---
name: 'Test Strategy Generator'
description: 'Instructions for generating test strategies with full requirements traceability'
applyTo: 'extracted-insights/04-testing/**'
---

# Test Strategy Generator Instructions

You are generating test strategies with complete requirements traceability.

## Prerequisites

ENSURE Phase 2 (Architecture) is complete:
- [ ] Components defined
- [ ] Interfaces documented
- [ ] Integration points known

## Input

Read:
- extracted-insights/02-architecture/ (all files)
- extracted-insights/01-discovery/ (all files)
- extracted-insights/03-environments/ (for environment context)

## Testing Phases

### SIT-1: Integration Testing
- Test component-to-component integration
- Test data flows between containers
- Test integration points with external systems

### SIT-2: System Testing
- End-to-end business scenarios
- Full system workflow testing
- Non-functional requirement validation

### UAT: User Acceptance Testing
- Business process validation
- User scenario testing
- Sign-off criteria

## Test Case Structure

```
## TC-XXX: [Test Case Name]

**Type:** [Positive | Negative | Boundary]

**Requirement Traceability:**
- Primary Requirement: FR-XXX
- Supporting Requirements: FR-XXX, NFR-XXX

**Preconditions:**
1.
2.

**Test Steps:**
1.
2.
3.

**Expected Result:**
-

**Pass Criteria:**
-

**Test Data Required:**
-
```

## Outputs

### 1. sit1-test-plan.md

Generate integration test cases:
- Component integration tests
- API integration tests
- Data flow tests
- GIS service integration (if applicable)

### 2. sit2-test-plan.md

Generate system test cases:
- End-to-end workflows
- NFR validation tests
- Performance tests
- Security tests
- GIS-specific tests (spatial queries, map rendering)

### 3. uat-test-plan.md

Generate UAT test cases:
- Business scenario tests
- User acceptance criteria
- User training validation

### 4. traceability-matrix.md

**CRITICAL OUTPUT** - Requirements Traceability Matrix:

| Req ID | Requirement | Test Case ID | Test Type | Status |
|--------|-------------|--------------|-----------|--------|
| FR-001 | User login | TC-001, TC-002 | SIT1, UAT | Ready |
| NFR-001 | Response <2s | TC-010 | SIT2 | Ready |

### 5. regression-scope.md

- Components affected by change
- Recommended regression tests
- Excluded areas (with justification)

### 6. test-data-requirements.md

| Test Case | Data Needed | Source | Setup Steps |
|-----------|-------------|--------|-------------|
| TC-001 | User accounts | HR system | Sync script |
| TC-010 | Large dataset | Generate | Script |

## Traceability Enforcement Rules

1. **EVERY functional requirement MUST have at least one test case**
2. **EVERY NFR MUST have validation test**
3. **Orphan requirements (no test) must be flagged**
4. **Test cases without requirement link must be flagged**

## GIS-Specific Testing

If GIS in scope:
- Spatial query validation
- Map service performance
- Coordinate transformation accuracy
- Geodatabase integrity
- Spatial data quality checks

## Risk Assessment

Include in each test plan:
- Testing risks (data, environment, timing)
- Mitigation strategies

## Questions

Before finalizing:
1. What test data is available?
2. Are there test accounts?
3. What are the success criteria for UAT?

## Validation Checklist

- [ ] All FRs have test cases
- [ ] All NFRs validated
- [ ] Traceability matrix complete
- [ ] GIS tests included (if applicable)
- [ ] Test data requirements documented
- [ ] Risks identified
