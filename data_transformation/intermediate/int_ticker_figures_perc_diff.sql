-- Drop the existing table if it exists
DROP TABLE IF EXISTS "intermediate".int_ticker_figures_perc_diff;

-- Add window functions to calculate percentage diffs for close & volume measures
SELECT
    base_set.*,
    LAG("close") OVER (PARTITION BY base_set.ticker ORDER BY base_set.date) AS previous_close_value,
    ROUND((("close" / LAG("close") OVER (PARTITION BY base_set.ticker ORDER BY base_set.date)) - 1) * 100, 2) AS perc_diff_close,
	LAG("volume") OVER (PARTITION BY base_set.ticker ORDER BY base_set.date) AS previous_volume_value,
    ROUND((("volume" / LAG("volume") OVER (PARTITION BY base_set.ticker ORDER BY base_set.date)) - 1) * 100, 2) AS perc_diff_volume
INTO "intermediate".int_ticker_figures_perc_diff
FROM "intermediate".int_ticker_figures_base base_set
ORDER BY 
    base_set.ticker, base_set.date;



