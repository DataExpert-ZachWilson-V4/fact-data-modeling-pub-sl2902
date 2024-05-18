-- Filter duplicates from the nba_games_details
-- table. Pick the first record of the duplicates
WITH subset_fct_tbl AS (
    SELECT 
        game_id,
        team_id,
        team_abbreviation,
        team_city,
        player_id player_id,
        player_name,
        -- nickname,
        start_position,
        -- comment,
        comment LIKE '%DND%' AS dim_did_not_dress,
        comment LIKE '%NWT%' AS dim_not_with_team,
        min,
        fgm,
        fga,
        fg_pct,
        fg3m,
        fg3a,
        fg3_pct,
        ftm,
        fta,
        ft_pct,
        oreb,
        dreb,
        reb,
        ast,
        stl,
        blk,
        to,
        pf,
        pts,
        plus_minus,
        ROW_NUMBER() OVER(PARTITION BY game_id, team_id, player_id) AS dup_row
    FROM TABLE(EXCLUDE_COLUMNS(
                INPUT => TABLE(bootcamp.nba_game_details),
                COLUMNS => DESCRIPTOR(nickname)
    )
)
),
filter_duplicate_fcts AS (
  SELECT
    *
  FROM
    subset_fct_tbl
  WHERE
    dup_row = 1
)
SELECT
    *
FROM
    TABLE(EXCLUDE_COLUMNS(
            INPUT => TABLE(filter_duplicate_fcts),
            COLUMNS => DESCRIPTOR(dup_row)
    )
)
