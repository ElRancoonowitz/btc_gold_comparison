-- Drop the existing intermediate table if it exists
DROP TABLE IF EXISTS mart.dim_category;

with category_set as (
	select distinct
		category as CategoryName		
	from staging.stg_category_metadata
)

	select 
		row_number() over (order by CategoryName) as CategoryKey, 
		*,
		CURRENT_TIMESTAMP as LoadTs
	into mart.dim_category
	from category_set