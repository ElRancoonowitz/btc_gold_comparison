-- Drop the existing fact table if it exists
DROP TABLE IF EXISTS [mart].[fct_daily_ticker_snapshots];

-- Create the fact table
SELECT 
    d.[DateKey],
    b.[date] AS [Date],
    t.[TickerKey] AS [Tickerkey],
    t.[TickerName] AS [Tickername],
    b.[ticker] AS [TickerId],
    b.[open] AS [Open], 
    b.[close] AS [Close], 
    b.[high] AS [High], 
    b.[low] AS [Low], 
    b.[volume] AS [Volume],
    b.[previous_close_value] AS [ClosePreviousDay],
    b.[perc_diff_close] AS [PercentageDiff_ClosePreviousDay],
	b.[previous_volume_value] AS [VolumePreviousDay],
    b.[perc_diff_volume] AS [PercentageDiff_VolumePreviousDay],
    c.[CategoryKey],
    c.[CategoryName] AS [Category],
    CURRENT_TIMESTAMP AS [LoadTs]
INTO [mart].[fct_daily_ticker_snapshots]
FROM [intermediate].[int_ticker_figures_perc_diff] b 
LEFT JOIN [mart].[dim_date] d ON b.[date] = d.[Date]
LEFT JOIN [mart].[dim_ticker] t ON b.[ticker] = t.[TickerId]
LEFT JOIN [mart].[dim_category] c ON b.[category] = c.[CategoryName];
