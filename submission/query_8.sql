-- Incremental load for reduced host
-- activity for month of Jan
-- Data loaded for 7 days
-- Ignore overlapping data or
-- delete them using cardinality(metric_array) < 7
-- The date in today's query is the only one that
-- changes
WITH
  yesterday AS (
    SELECT
      *
    FROM
      sundeep.host_activity_reduced
    WHERE
      -- history table for month_start
      month_start = '2023-01-01'
),
  today AS (
    SELECT
      *
    FROM
      sundeep.daily_web_metrics
    WHERE
     -- Load snapshot for 7th Jan 2023
      date = DATE('2023-01-07')
    AND
      metric_name IS NOT NULL
)
SELECT
  COALESCE(y.host, t.host) AS host,
  COALESCE(y.metric_name, t.metric_name) AS metric_name,
  COALESCE(
    y.metric_array,
    -- Create array of NULLs whose length is based
    -- on difference in days between month_start and t.date
    REPEAT(
      NULL,
      CAST(
        DATE_DIFF('day', DATE('2023-01-01'), t.date) AS INTEGER
      )
    )
  ) || ARRAY[t.metric_value] AS metric_array,
  -- Data is for month of Jan 2023
  '2023-01-01' AS month_start
FROM
  today AS t
  FULL OUTER JOIN yesterday AS y ON t.host = y.host
  AND t.metric_name = y.metric_name


