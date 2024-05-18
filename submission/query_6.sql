-- Incremental load to populate
-- hosts from 2023-01-01 to 2023-01-07
INSERT INTO sundeep.hosts_cumulated
WITH
  yesterday AS (
    SELECT
      *
    FROM
      sundeep.hosts_cumulated
    WHERE
      date = DATE('2022-12-31')
),
  today AS (
    SELECT
      host,
      CAST(DATE_TRUNC('day', event_time) AS DATE) AS date,
      COUNT(1)
    FROM
      bootcamp.web_events
    WHERE
      DATE_TRUNC('day', event_time) = DATE('2023-01-01')
    GROUP BY
      host,
      DATE_TRUNC('day', event_time)
)
SELECT
  COALESCE(y.host, t.host) AS host,
  CASE
    WHEN y.host_activity_datelist IS NOT NULL THEN ARRAY[t.date] || y.host_activity_datelist
    ELSE ARRAY[t.date] END AS host_activity_datelist,
    DATE('2023-01-01') AS date
FROM yesterday AS y
FULL OUTER JOIN today AS t ON y.host = t.host