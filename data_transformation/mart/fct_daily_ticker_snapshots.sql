drop table if exists mart.fct_daily_ticker_snapshots;
select 
	d.DateKey,
	b.Date,
	t.TickerKey,
	t.TickerName,
	b.ticker as TickerId,
	b."open" as "Open", 
	b."close" as "Close", 
	b."high" as "High", 
	b."low" as "Low", 
	b."volume" as "Volume",
	b.previous_close_value as "ClosePreviousDay",
	b.perc_diff_close as "PercentageDiff_ClosePreviousDay",
	current_timestamp as "LoadTs"
into mart.fct_daily_ticker_snapshots
from "intermediate".int_ticker_figures_perc_diff b left join mart.dim_date d 
on b.date = d.Date
left join mart.dim_ticker t 
on b.ticker = t.TickerId;