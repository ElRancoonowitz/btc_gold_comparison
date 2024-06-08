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
), ticker_figures_enriched_with_category_and_data_cleaning as (
	select 
		f.date,
        CASE 
            WHEN f.ticker = '^DJI' THEN 'DOW'
            WHEN f.ticker = '^GSPC' THEN 'SP500'
            WHEN f.ticker = 'DX-Y.NYB' THEN 'USD'
            WHEN f.ticker = 'BTC-USD' THEN 'BTC'
            ELSE f.ticker
        END AS ticker,
        ROUND(f."open", 2) AS "open",
        ROUND(f."close", 2) AS "close",
        ROUND(f."high", 2) AS "high",
        ROUND(f."low", 2) AS "low",
        case 
			when f.volume = 0 then null 
			else f.volume
		end as volume,
        c.category
	from ticker_figures f left join staging.stg_category_metadata c 
	on f.ticker = c.Ticker
)
	
	select 
		*
	into "intermediate".int_ticker_figures_base
	from ticker_figures_enriched_with_category_and_data_cleaning