-- =========================================
-- DAIKIBO INDUSTRIES — TELEMETRY ANALYSIS
-- Data Operations Analysis | May 2021
-- Analyst: Brinda Jat
-- Tool: PostgreSQL
-- =========================================

-- SECTION A: DATA VALIDATION QUERIES
-- =========================================

-- Query 1: Dataset Validation: Total Records, Data Range and distinct Status Types  
SELECT COUNT(*) AS total_records,
       MIN(event_time) AS earliest_record,
       MAX(event_time) AS latest_record,
	   count(Distinct status) as Status
FROM telemetry_raw;

-- Query 2: Data Quality Check — NULL Value Validation Across Critical Columns
SELECT 
   SUM(CASE WHEN deviceid IS NULL THEN 1 ELSE 0 END) as null_deviceid,
   SUM(CASE WHEN devicetype is null then 1 else 0 end) as null_devicetype,
   SUM(CASE WHEN event_time is null then 1 else 0 end) as null_event_time,
   sum(case when country is null then 1 else 0 end) as null_country,
   sum(case when city is null then 1 else 0 end) as null_city,
   sum(case when factory is null then 1 else 0 end) as null_factory,
   sum(case when status is null then 1 else 0 end) as null_status,
   sum(case when temperature is null then 1 else 0 end) as null_temperature
FROM telemetry_raw;

-- Query 3: Dataset Scope Validation — Unique Devices, Machine Types & Factories
Select count(distinct deviceid) as deviceid,
       count(distinct devicetype) as devicetype,
	   count(distinct factory) as factory
from telemetry_raw;		

-- =========================================
-- SECTION B: OPERATIONAL ANALYSIS QUERIES
-- =========================================

-- Query 4: Breakdown Count & Rate Percentage by Factory
SELECT 
    factory,
    COUNT(case when status = 'unhealthy' then 1 end) as breakdowns,
    COUNT(*) as total_messages,
    ROUND(COUNT(case when status = 'unhealthy' then 1 end) * 100.0 / COUNT(*),2) AS breakdown_rate_pct
FROM telemetry_raw
GROUP BY factory
ORDER BY breakdowns DESC;

-- Query 5: Factory Reliability — Healthy vs Unhealthy Message Ratio
select factory, count(case when status = 'healthy' then 1 end) as healthy,
       count(case when status = 'unhealthy' then 1 end) as unhealthy,count(*) as total_msg,
	   round(count(case when status = 'healthy' then 1 end)*100.0/count(*),2) as healthy_rate_pct
from telemetry_raw
group by factory
order by count(case when status = 'unhealthy' then 1 end) desc;

-- Query 6: Machine Type Breakdown Analysis — Daikibo Factory Seiko
select devicetype,count(case when status = 'unhealthy' then 1 end) as breakdowns
from telemetry_raw
where factory = 'daikibo-factory-seiko'
group by devicetype
order by breakdowns desc;

-- Query 7: Hourly Breakdown Pattern — Peak Failure Hours Analysis
select extract(hour from event_time) as hour_of_day,
       count(case when status = 'unhealthy' then 1 end) as breakdowns
from telemetry_raw
group by hour_of_day
order by breakdowns desc
limit 5;

-- Query 8: Cross-Factory Device Performance — Breakdown Count by Factory and Machine Type
select factory,devicetype,count(case when status='unhealthy' then 1 end) as breakdowns
from telemetry_raw
group by factory,devicetype
order by breakdowns desc
limit 10;

-- Query 9: Temperature Analysis — Average Temperature During Healthy vs Unhealthy Status
select factory,status,
     round(avg(temperature),2) as avg_temperature
from telemetry_raw
group by factory,status
order by factory;

-- Query 10: Daily Breakdown Trend — Identifying Peak Failure Days in May 2021
select extract(day from event_time) as day_in_month,
       count(case when status='unhealthy' then 1 end) as breakdowns
from telemetry_raw
group by day_in_month
order by breakdowns desc
limit 10;



