{{ config(
    materialized='table',
) }}
with prop_subtypes as (
select distinct
	propertyType as property_type 
    ,propertySubType as property_sub_type
    
from static-retina-408319.right_move.properties_raw
)

select ROW_NUMBER() OVER () AS property_type_id
	,property_type
	,property_sub_type
from prop_subtypes
where property_type is not null


