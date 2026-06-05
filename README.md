# CRM Compiler Pipeline

## Overview
This project demonstrates a multi-stage AI pipeline that converts natural language product requests into strict, validated, and executable JSON configurations.

## Pipeline Stages
1. Intent Extraction → Parse user request into structured features.
2. System Design → Map features into architecture (entities, flows, roles).
3. Schema Generation → Generate UI, API, DB, Auth schemas.
4. Refinement + Validation → Ensure consistency and repair errors.
5. Runtime Simulation → Show how the app would run.
6. Failure Handling → Handle vague/conflicting inputs.
7. Metrics + Tradeoffs → Track success, retries, latency, and cost vs quality.

## Files
- `output.json` → Full pipeline output.
- `db_schema.sql` → Database schema.
- `auth_flow.png` → Auth flow diagram.
- `README.md` → Documentation.


