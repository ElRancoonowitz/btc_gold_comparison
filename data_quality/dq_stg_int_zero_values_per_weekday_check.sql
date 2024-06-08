select 
	d.WeekDayName,
	b.ticker,
	count(*) as amt_rows 
from staging.stg_alpha_vantage_gold_ticker_figures b left join mart.dim_date d 
on b.timestamp = d.Date 
where b.volume = 0 
group by 
	d.WeekDayName,
	b.ticker
order by 
	d.WeekDayName,
	b.ticker;

--check for zero volume values in intermediate base table
select 
	d.WeekDayName,
	b.*
from intermediate.int_ticker_figures_base b left join mart.dim_date d 
on b.date = d.Date 
where b.volume = 0 
order by
	b.date,
	b.ticker;
