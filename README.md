# Daikibo Industries — Operational & People Risk Analysis

> Deloitte Data Analytics Job Simulation | PostgreSQL · Microsoft Excel · Power BI

---

## Project Overview

This project is based on the **Deloitte Australia Data Analytics Job Simulation** on Forage. The client, Daikibo Industries, is a global manufacturing company with 4 factory locations across Japan, Germany and China. They collected one month of IoT telemetry data from their machines and needed answers to two core business questions.

The simulation was originally designed for Tableau but this project was completed using **Power BI** and then enhanced further with **PostgreSQL** and **Microsoft Excel** to build a full three-tool portfolio analysis.

**Client:** Daikibo Industries — Global Manufacturing  
**Analyst:** Brinda Jat  
**Period:** May 2021  
**Simulation:** Deloitte Australia Data Analytics — Forage  

---

## Business Questions

1. Which factory location had the most machine breakdowns in May 2021?
2. Which machine type broke down most often in that location?
3. Which factories and job roles show the most compensation discrimination? *(Portfolio Enhancement)*

---

## Dataset

| Detail | Value |
|---|---|
| Source | Deloitte Australia Job Simulation — Forage |
| Telemetry Records | 160,704 IoT messages |
| Equality Records | 37 job roles across 4 factories |
| Period | May 2021 |
| Factories | Daikibo Factory Meiyo (Tokyo), Daikibo Factory Seiko (Osaka), Daikibo Berlin (Berlin), Daikibo Shenzhen (Shenzhen) |
| Machine Types | 9 types per factory |
| Message Frequency | Every 10 minutes per machine |
| Telemetry Format | JSON (58MB) |
| Equality Format | Excel (.xlsx) |

---

## Repository Structure

daikibo-deloitte-analytics/
│
├── README.md
│
├── sql/
│   ├── daikibo_analysis.sql
│   └── Daikibo_SQL_Analysis_Report.pdf
│
├── excel/
│   ├── Daikibo_Equality_Analysis.xlsx
│   └── Daikibo_Equality_Analysis_Report.pdf
│
├── powerbi/
│   ├── Daikibo_Dashboard.pbix
│   ├── 1_Factory_Analysis.png
│   ├── 2_Operational_Deep_Dive.png
│   ├── 3_People_Risk.png
│   └── 4_Executive_Summary.png
│
└── executive_summary/
└── Daikibo_Executive_Summary.pdf

---

## SQL Analysis — PostgreSQL

**What was done:**
- Loaded 58MB raw JSON telemetry file using psql client side `\copy` command
- Created staging table to hold raw JSON and extracted all nested fields into structured columns
- Wrote 10 SQL queries across two sections — data validation and operational analysis
- Used `EXTRACT`, `CASE WHEN`, `COUNT`, `AVG`, `ROUND` and `DIVIDE` logic throughout
- Validated dataset completeness with NULL checks across all 8 columns
- Calculated breakdown rate percentage per factory using decimal division
- Identified hourly and daily breakdown patterns
- Cross analysed factory and machine type combinations to find localised failure patterns

📄 [SQL Queries](sql/daikibo_analysis.sql) | 📊 [Full SQL Report with Outputs](sql/Daikibo_SQL_Analysis_Report.pdf)

### Query Summary & Findings

**Query 1 — Dataset Validation**  
Confirmed 160,704 total records covering 01 May to 10 May 2021 — matching the client brief exactly.

**Query 2 — NULL Value Check**  
All 8 critical columns returned zero NULL values. Dataset is fully clean.

**Query 3 — Scope Validation**  
Confirmed 4 factories, 9 machine types and 36 unique devices — exactly as specified.

**Query 4 — Breakdown Rate by Factory**  
Seiko recorded 48 breakdowns at 0.12% rate. Berlin recorded only 2 at 0.00% — a 24x difference.

**Query 5 — Healthy vs Unhealthy Ratio**  
Berlin achieved 100.00% healthy uptime. Seiko had the lowest at 99.88%.

**Query 6 — Machine Type Analysis at Seiko**  
LaserWelder is the only machine that broke down in Seiko — all 48 breakdowns from one machine type. All 8 others recorded zero.

**Query 7 — Hourly Breakdown Pattern**  
Peak hours are 12:00-13:00, 19:00 and 03:00 — correlating with shift changes and overnight low staffing.

**Query 8 — Factory and Machine Combination**  
Breakdowns are factory-specific not equipment-wide. LaserWelder fails only in Seiko, LaserCutter only in Shenzhen.

**Query 9 — Temperature Correlation**  
No meaningful correlation found. Temperature difference between healthy and unhealthy machines is less than 0.5°C — breakdowns are mechanical not heat-induced.

**Query 10 — Daily Breakdown Trend**  
89% of breakdowns in first 5 days of May 2021. Day 5 alone = 48 breakdowns. After Day 7 dropped to near zero — infant mortality pattern identified.

---

## Excel Analysis — Microsoft Excel Web

**What was done:**
- Opened client provided equality dataset with 3 columns across 37 rows
- Added `Equality Class` column using `SWITCH(TRUE())` — classified scores into Fair, Unfair and Highly Discriminative
- Added `Risk Flag` column using `IF` — binary 0/1 for quick risk identification
- Added `Priority Score` column using `SWITCH` — numerical weight 0 to 2 for severity ranking
- Added `Recommended Action` column — plain language HR action per classification
- Applied conditional formatting using exact cell value match to avoid partial text conflicts
- Built Pivot Table 1 — Equality Class count by Factory
- Built Pivot Table 2 — Average Equality Score and Max Priority Score by Job Role
- Built Pivot Chart — visual comparison of equality scores across all job roles
- Converted data range to Excel Table for structured formula references

📊 [Enhanced Equality Table](excel/Daikibo_Equality_Analysis.xlsx) | 📄 [Excel Analysis Report](excel/Daikibo_Equality_Analysis_Report.pdf)

### Findings

| Column Added | Formula | Purpose |
|---|---|---|
| Equality Class | SWITCH(TRUE()) | Fair / Unfair / Highly Discriminative |
| Risk Flag | IF | 0 = no risk, 1 = risk flagged |
| Priority Score | SWITCH | 0 = Fair, 1 = Unfair, 2 = Highly Discriminative |
| Recommended Action | SWITCH | Monitor Quarterly / Review Immediately / Escalate to HR & Legal |

- Daikibo Factory Meiyo has the most Highly Discriminative cases (3) and most total roles (11)
- Daikibo Berlin is the only factory with zero Highly Discriminative classifications
- Every leadership role from C-Level to Director scores negatively
- Every technical role from Engineer to Jr. Engineer scores close to zero or positive
- The higher the seniority the worse the discrimination — a clear systemic pattern

---

## Power BI Dashboard

**What was done:**
- Loaded 58MB JSON file via Power Query — expanded nested location and data objects
- Converted Unix millisecond timestamps to readable DateTime using custom M formula
- Typed all 10 columns correctly in Power Query
- Connected Excel equality data as a second table in the same model
- Created KPI Measures table with 9 DAX measures
- Used `CALCULATE`, `COUNTROWS`, `AVERAGE`, `DIVIDE` across all measures
- Applied custom dark industrial theme across all 4 pages
- Built cross-filtering interactions between visuals

📥 [Download Power BI File](powerbi/Daikibo_Dashboard.pbix) | 📄 [Executive Summary](executive_summary/Daikibo_Executive_Summary.pdf)

### Dashboard Pages

| Page | Name | Description |
|---|---|---|
| 1 | Factory Analysis | Original Deloitte output — Down Time per Factory and Down Time per Device Type |
| 2 | Operational Deep Dive | KPI cards, breakdown by factory-machine combination, temperature analysis |
| 3 | People Risk | Equality score by factory and job role, class distribution, avg score comparison |
| 4 | Executive Summary | Key findings and recommendations in client-facing format |

### Dashboard Screenshots

![Page 1 - Factory Analysis](https://github.com/BrindaJat/daikibo-deloitte-analytics/blob/main/powerbi/1.Factory%20Analysis.png)
![Page 2 - Operational Deep Dive](https://github.com/BrindaJat/daikibo-deloitte-analytics/blob/main/powerbi/2.Operational%20Deep%20Dive.png)
![Page 3 - People Risk](https://github.com/BrindaJat/daikibo-deloitte-analytics/blob/main/powerbi/3.People%20Risk.png)
![Page 4 - Executive Summary](https://github.com/BrindaJat/daikibo-deloitte-analytics/blob/main/powerbi/4.Executive%20Summary.png)

---

## Key Findings

1. **Daikibo Factory Seiko** recorded 48 breakdowns — highest across all 4 locations at 0.06% breakdown rate
2. **LaserWelder** is solely responsible for all 48 Seiko breakdowns — single point of failure confirmed
3. **89% of breakdowns** occurred in the first 5 days of May 2021 — infant mortality pattern identified
4. **Daikibo Factory Meiyo** has the worst equality score of -14.36 — most discriminative factory overall
5. **Every leadership role** scores negatively — C-Level at -25.0 is the most discriminative role across all factories
6. **Daikibo Berlin** has the best machine performance AND the best equality score — management quality correlates with both operational and people outcomes
7. **Temperature showed no link** to breakdowns — healthy and unhealthy machines ran at the same 25°C average

---

## Recommendations

| Priority | Recommendation | Action |
|---|---|---|
| Immediate | Audit all LaserWelder units at Seiko factory | One machine type caused 47% of all company-wide breakdowns |
| Immediate | HR and Legal review of C-Level and VP compensation | Both roles classified Highly Discriminative across all factories |
| Short Term | Replicate Berlin operational protocols at Meiyo and Seiko | Berlin = best machine performance and best equality score |
| Short Term | Implement breakdown alerts at 19:00 and 03:00 | Peak hours correlate with shift changes and overnight low staffing |
| Long Term | Monthly telemetry and equality review cadence | Track improvement over time with consistent measurement |

---

## Data Limitations

- Single month of data only — year on year trends cannot be confirmed
- No cost data available — financial impact of breakdowns not quantifiable
- No demographic data in equality dataset — gender or age breakdown not possible
- Temperature analysis ruled out heat as a cause — mechanical root cause investigation still needed

---

## Simulation Certificate

Completed **Deloitte Australia Data Analytics Job Simulation** on Forage — April 2026

---

*Project completed: April 2026 | Analyst: Brinda Jat | Tools: PostgreSQL · Microsoft Excel · Power BI*
