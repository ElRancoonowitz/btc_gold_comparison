drop table if exists "intermediate".int_ticker_figures_base;
with gold_ticker_figures as (
	select 
		cast(timestamp as date) as date, 
		ticker,
		"open",
		"close",
		"high",
		"low", 
		volume
	from [staging].[stg_alpha_vantage_gold_ticker_figures]
), btc_gspc_dji_dxy_ticker_figures as (
	select 
		cast(Date as date) as date, 
		Ticker as ticker,
		"Open" as "open",
		"Close" as "close", 
		"High" as "high",
		"Low" as "low", 
		Volume as volume
	from [staging].[stg_yahoo_fin_btc_gspc_dji_dxy_ticker_figures]
), ticker_figures as (
	select 
		*
	from gold_ticker_figures
	union 
	select 
		*
	from btc_gspc_dji_dxy_ticker_figures
)

	select 
		*
	into "intermediate".int_ticker_figures_base
	from ticker_figures