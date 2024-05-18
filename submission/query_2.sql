-- Create schema for user
-- devices activity datalist DDL
CREATE OR REPLACE TABLE user_devices_cumulated (
    user_id BIGINT,
    browser_type VARCHAR,
    dates_active ARRAY(DATE),
    date DATE
)
WITH (
    FORMAT = 'parquet',
    PARTITIONING = ARRAY['date']
)