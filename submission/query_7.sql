-- Create DDL for cumulative table
-- that stores aggregted monthly web events
CREATE OR REPLACE TABLE sundeep.host_activity_reduced (
    -- Page visited
    host VARCHAR,
    -- Name of the web event
    metric_name VARCHAR,
    -- Array containing the frequency of the event
    metric_array ARRAY(INTEGER),
    month_start VARCHAR
)
WITH (
    FORMAT = 'PARQUET',
    PARTITIONING = ARRAY['metric_name', 'month_start']
)