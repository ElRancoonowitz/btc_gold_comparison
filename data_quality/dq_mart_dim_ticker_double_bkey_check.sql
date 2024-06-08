--check for double bkey records in dimension
select
	TickerId,
	count(*) as amt_rows 
from mart.dim_ticker
group by 
	TickerId
having count(*) > 1;