---
name: 'Environment Analyzer'
description: 'Instructions for analyzing environment impacts and generating deployment artifacts'
applyTo: 'extracted-insights/03-environments/**'
---

# Environment Analyzer Instructions

You are analyzing environment impacts and creating deployment-related artifacts.

## Prerequisites

ENSURE Phase 2 (Architecture) is complete:
- [ ] Solution architecture approved
- [ ] Components identified
- [ ] Integration patterns defined

## Input

Read:
- extracted-insights/02-architecture/ (all files)
- extracted-insights/01-discovery/constraints.md

## Environment Analysis Framework

### DEV Environment

| Aspect | Analysis |
|--------|----------|
| Purpose | Development and unit testing |
| Data | Synthetic/sample data |
| Config | Development settings |
| Access | All developers |
| Build | CI/CD pipeline |

### TEST Environment

| Aspect | Analysis |
|--------|----------|
| Purpose | SIT1, SIT2, UAT |
| Data | Sanitized production-like |
| Config | Test settings |
| Access | Testers, BA |
| Integration | Full integration |

### PROD Environment

| Aspect | Analysis |
|--------|----------|
| Purpose | Production workload |
| Data | Production data |
| Config | Production-hardened |
| Access | Limited |
| Integration | Live systems |

## Outputs

### 1. dev-test-prod-impact.md

Generate table:

| Component | DEV Impact | TEST Impact | PROD Impact | Migration Notes |
|-----------|-------------|-------------|-------------|-----------------|
| Database | New schema | Full data | Incremental | Backup required |
| API | Localhost | Test server | Production | Feature flags |
| GIS Services | Dev instance | Staging | Production | Map cache rebuild |

### 2. release-strategy.md

Include:
- Release approach: Big Bang | Phased | Canary
- Release sequence (order of deployments)
- Deployment windows
- Rollback triggers
- Approval gates

### 3. rollback-plan.md

For each component:
- Rollback trigger criteria
- Rollback procedure (step-by-step)
- Expected downtime
- Data recovery steps

### 4. infrastructure-requirements.md

| Resource | DEV | TEST | PROD |
|----------|-----|------|------|
| Compute | | | |
| Storage | | | |
| Network | | | |
| GIS | | | |

## GIS Environment Considerations

If GIS in scope:
- ArcGIS Enterprise tier requirements
- Server roles (Server, Portal, Data Store)
- Web Adaptor configuration
- Map service caching requirements
- GeoEvent Server (if real-time)

## Risk Assessment

Include in release-strategy.md:
- Environment-specific risks
- Data migration risks
- Rollback risks
- GIS-specific risks (service publishing, cache building)

## Questions

Before finalizing:
1. What is the change approval process?
2. What are the maintenance windows?
3. What is the backup/recovery SLA?
4. Are there GIS-specific environment constraints?

## Validation Checklist

- [ ] All components mapped to environments
- [ ] Release sequence defined
- [ ] Rollback procedures documented
- [ ] Infrastructure requirements specified
- [ ] GIS environment needs addressed
- [ ] Risks identified
