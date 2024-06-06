-- Drop the existing table if it exists
DROP TABLE IF EXISTS "intermediate".int_ticker_figures_perc_diff;

-- Create a common table expression (CTE) named base_set
WITH base_set AS (
    SELECT
        date,
        CASE 
            WHEN ticker = '^DJI' THEN 'DOW'
            WHEN ticker = '^GSPC' THEN 'SP500'
            WHEN ticker = 'DX-Y.NYB' THEN 'USD'
            WHEN ticker = 'BTC-USD' THEN 'BTC/USD'
            ELSE ticker
        END AS ticker,
        ROUND("open", 2) AS "open",
        ROUND("close", 2) AS "close",
        ROUND("high", 2) AS "high",
        ROUND("low", 2) AS "low",
        volume,
        category
    FROM "intermediate".int_ticker_figures_base
)

-- Ensure the category data is correctly joined and no unintended numerical values exist
SELECT
    base_set.*,
    LAG("close") OVER (PARTITION BY base_set.ticker ORDER BY base_set.date) AS previous_close_value,
    ROUND((("close" / LAG("close") OVER (PARTITION BY base_set.ticker ORDER BY base_set.date)) - 1) * 100, 2) AS perc_diff_close
INTO "intermediate".int_ticker_figures_perc_diff
FROM base_set
ORDER BY 
    base_set.ticker, base_set.date;


