---
name: 'Compliance Checklist'
description: 'Instructions for generating compliance and risk management artifacts'
applyTo: 'extracted-insights/05-compliance/**'
---

# Compliance Checklist Generator Instructions

You are generating compliance artifacts and risk management documentation.

## Prerequisites

Can be invoked at any phase, but ideally after architecture.

## Input

Read ALL prior phases:
- extracted-insights/01-discovery/
- extracted-insights/02-architecture/
- extracted-insights/03-environments/
- extracted-insights/04-testing/
- raw-artifacts/

## Risk Management Framework

### Risk Register Structure

```
## Risk ID: [RISK-XXX]

**Risk Title:**

**Category:** [Technical | Data | Resource | Schedule | Compliance | Operational]

**Description:**

**Impact:** [H | M | L]

**Likelihood:** [H | M | L]

**Risk Score:** [H | M | L] (Impact × Likelihood)

**Mitigation Strategy:**

**Owner:**

**Status:** [Open | Mitigated | Closed]
```

### Risk Categories

1. **Technical**: Technology failures, integration issues
2. **Data**: Data quality, migration, governance
3. **Resource**: Team availability, skills gaps
4. **Schedule**: Timeline pressures, dependencies
5. **Compliance**: Regulatory, security, accessibility
6. **Operational**: Support, training, adoption

## Outputs

### 1. security-assessment.md

| Control | Requirement | Implementation | Status |
|---------|-------------|----------------|--------|
| Authentication | NFR-003 | AD Integration | Implemented |
| Authorization | NFR-004 | Role-based | Planned |
| Data Encryption | NFR-005 | TLS 1.3 | Planned |

Include:
- Authentication approach
- Authorization model
- Data protection measures
- Security testing plan
- GIS-specific security (portal, services)

### 2. data-governance.md

- Data ownership
- Data classification
- Retention requirements
- Privacy considerations
- GIS data standards

### 3. accessibility-compliance.md

- WCAG 2.1 level requirements
- 508 compliance (if US government)
- GIS accessibility (map alternatives)

### 4. risk-register.md

**PRIORITY OUTPUT** - Comprehensive risk register:

| Risk ID | Risk | Category | Impact | Likelihood | Score | Mitigation | Owner |
|---------|------|----------|--------|------------|-------|------------|-------|
| RISK-001 | Data migration failure | Data | H | M | H | Rollback plan | DB Lead |

### 5. compliance-checklist.md

Sign-off checklist:

- [ ] Security review completed
- [ ] Data governance approved
- [ ] Accessibility requirements met
- [ ] Risk register reviewed
- [ ] Stakeholder sign-off obtained
- [ ] Architecture review passed

## GIS Compliance Considerations

If GIS in scope:
- Spatial data licensing
- Map service security
- Coordinate system compliance
- Data sharing agreements

## Questions

Before finalizing:
1. What security standards apply?
2. Are there data classification requirements?
3. What compliance frameworks (SOC2, ISO27001, etc.)?

## Validation Checklist

- [ ] All risk categories addressed
- [ ] Risk register complete
- [ ] Security controls documented
- [ ] Data governance defined
- [ ] Compliance checklist actionable
- [ ] GIS-specific compliance addressed
