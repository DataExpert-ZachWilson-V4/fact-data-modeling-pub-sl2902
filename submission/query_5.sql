-- Create DDL Schema for monthly
-- aggregated host data
CREATE OR REPLACE TABLE sundeep.hosts_cumulated (
    host VARCHAR,
    host_activity_datelist ARRAY(date),
    date DATE
)
WITH (
    FORMAT = 'PARQUET',
    PARTITIONING = ARRAY['date']
)