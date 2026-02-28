# Integrated Instrumentation Health Monitoring Dashboard Database

A PostgreSQL-based database system designed to model nuclear power plant instrumentation health monitoring workflows. This project implements sensor data ingestion, automated quality checks, calibration drift tracking, anomaly detection, and regulatory compliance documentation — mirroring real-world nuclear I&C (Instrumentation & Control) engineering practices.

## Purpose

Nuclear power plants rely on thousands of instruments to monitor critical parameters such as temperature, pressure, coolant flow, and neutron flux. Ensuring these instruments remain accurate and reliable is essential to safe plant operations. This database system provides:

- **Instrumentation hierarchy modeling** — Plants, systems, instrument loops, and redundant sensor channels organized to reflect defense-in-depth safety architecture
- **Time-series data ingestion** — Structured storage of high-frequency sensor readings with source tracking and audit traceability
- **Automated quality assurance** — Stored procedures implementing range validation, stuck-sensor detection, and redundant channel consistency checks
- **Calibration & drift tracking** — Full calibration history with as-found/as-left documentation, drift rate analysis, and tolerance band monitoring
- **Anomaly detection** — Statistical methods applied via SQL window functions to identify sensor degradation trends and flag deviations
- **Compliance-ready reporting** — Views and reports structured to support 10 CFR 50 Appendix B quality assurance documentation requirements

## Project Structure

```
instrumentation-health-monitoring/
├── sql/
│   ├── schema/        # DDL: table definitions, constraints, indexes
│   ├── views/         # Reporting and dashboard views
│   ├── procedures/    # Stored procedures for quality checks and anomaly detection
│   └── seed_data/     # Simulated plant instrumentation and sensor data
├── docs/              # Design documentation, ER diagrams, data dictionary
├── scripts/           # Utility scripts (database setup, data generation)
├── tests/             # Validation queries and test cases
└── README.md
```

## Technical Stack

- **Database:** PostgreSQL
- **Design Tool:** pgModeler (ER diagrams)
- **Key SQL Features:** Window functions, CTEs, stored procedures, custom ENUMs, table partitioning, indexing strategies for time-series data

## Domain Context

This project uses simulated data modeled after real nuclear plant instrumentation structures. The schema design, quality assurance logic, and reporting outputs are informed by:

- Nuclear I&C engineering fundamentals (RTDs, pressure transmitters, neutron flux detectors, instrument loops)
- Defense-in-depth redundancy principles (multi-channel, multi-division safety system architecture)
- 10 CFR 50 Appendix B quality assurance requirements
- Industry-standard calibration and drift management practices

## Status

🔧 **In Development** — Schema design phase

## Author

Andrew — Aspiring nuclear I&C data analyst building domain expertise through hands-on project work.
