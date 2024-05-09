drop table if exists mart.dim_ticker;
select 
	row_number() over (order by Ticker) as TickerKey,
	Ticker as TickerId,
	Ticker_name as TickerName,
	current_timestamp as LoadTs
into mart.dim_ticker
from "staging".stg_tickers_metadata;