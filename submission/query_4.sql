WITH
  today AS (
    SELECT
      *
    FROM
      sundeep.user_devices_cumulated
    WHERE
      DATE = DATE('2023-01-07')
  ),
date_list_int AS (
  SELECT
    user_id,
    browser_type,
    CAST(
      SUM(
        CASE
          WHEN CONTAINS(dates_active, sequence_date) THEN POW(2, 8 - DATE_DIFF('day', sequence_date, DATE))
          ELSE 0
        END
        ) AS SMALLINT) AS history_int
  FROM
    today
    CROSS JOIN UNNEST (SEQUENCE(DATE('2023-01-01'), DATE('2023-01-07'))) AS t(sequence_date)
  GROUP BY
    user_id,
    browser_type
  ORDER BY
    user_id
)
SELECT
  *,
  LPAD(
    TO_BASE(history_int, 2),
    16,
    '0'
  ) AS history_in_binary,
  LPAD('1111111', 16, '0') mask,
  BIT_COUNT(history_int, 16) AS num_days_active,
  BIT_COUNT(
    BITWISE_AND(
      history_int,
      FROM_BASE(LPAD('1111111', 16, '0'), 2)
    ),
    16
  ) AS daily_streak
      
FROM
  date_list_int
  