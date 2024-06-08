	Ticker;

--alpha ventures 
select 
	Ticker,
	sum(case when volume = 0 then 1 else 0 end) as amt_zero_volume_values,
	sum(1) as amt_all_values
from staging.stg_alpha_vantage_gold_ticker_figures
group by  
	Ticker;