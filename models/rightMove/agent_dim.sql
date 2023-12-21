{{ config(
    materialized='table'
) }}
with unique_agents as (
	select distinct `Agent Name` 
	from static-retina-408319.right_move.properties_raw
	)
select row_number() over () as agent_id
,*
from (
select distinct
IF(ARRAY_LENGTH(SPLIT(ua.`Agent Name`, ',')) > 1, SPLIT(ua.`Agent Name`, ',')[OFFSET(0)], ua.`Agent Name`) as agent_name
	,IF(ARRAY_LENGTH(SPLIT(ua.`Agent Name`, ',')) > 1, SPLIT(ua.`Agent Name`, ',')[OFFSET(1)], NULL) as agent_branch
	,src.`Agent Address`
	,src.agent_url
from unique_agents ua
left join static-retina-408319.right_move.properties_raw src 
on ua.`Agent Name` = src.`Agent Name`
where ua.`Agent Name` is not null
and src.agent_url is not null
and src.`Agent Address` is not null)
