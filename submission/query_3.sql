-- Incrementally build th user devices table
-- Currently it holds 7 days worth of data
-- from 2023-01-01 to 2023-01-07
INSERT INTO sundeep.user_devices_cumulated
WITH
 yesterday AS (
   SELECT
     *
   FROM
     sundeep.user_devices_cumulated
   WHERE
     date = DATE('2023-01-06')
 ),
 today AS (
   SELECT
     user_id,
     browser_type,
     DATE_TRUNC('day', event_time) AS event_date,
     COUNT(1) AS num_users_per_browser
   FROM
     bootcamp.web_events AS we
   LEFT JOIN bootcamp.devices AS d ON we.device_id = d.device_id
   WHERE
     DATE_TRUNC('day', event_time) = DATE('2023-01-07')
   GROUP BY
     user_id,
     browser_type,
     DATE_TRUNC('day', event_time)
 )
 SELECT
   COALESCE(y.user_id, t.user_id) AS user_id,
   COALESCE(y.browser_type, t.browser_type) AS browser_type,
   CASE
     WHEN y.dates_active IS NOT NULL THEN ARRAY[t.event_date] || y.dates_active
     ELSE ARRAY[t.event_date]
   END AS dates_active,
   DATE('2023-01-07') AS DATE
 FROM
   yesterday AS y
 FULL OUTER JOIN today AS t on y.user_id = t.user_id
