drop table if exists "intermediate".int_ticker_figures_perc_diff;
with base_set as (
	select
		date,
		case 
			when ticker = '^DJI' then 'DOW'
			when ticker = '^GSPC' then 'SP500'
			when ticker = 'DX-Y.NYB' then 'USD'
			when ticker = 'BTC-USD' then 'BTC/USD'
			else ticker
		end as ticker,
		round("open", 2) as "open",
		round("close", 2) as "close",
		round("high", 2) as "high",
		round("low", 2) as "low",
		volume
		category
	from "intermediate".int_ticker_figures_base
)

	select
		*,
		lag("close") over (partition by ticker order by date) as previous_close_value,
		round((("close"/lag("close") over (partition by ticker order by date))-1)*100, 2) as perc_diff_close
	into "intermediate".int_ticker_figures_perc_diff
	from base_set
	order by 
		ticker, date


