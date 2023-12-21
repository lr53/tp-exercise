{{ config(
    materialized='table',
) }}

with properties as (
select 

    CAST(REGEXP_EXTRACT(url, r'property-(\d+)') AS INT64) AS rightmove_id
    ,price
    ,number_bedrooms
    ,cast(added as date FORMAT 'YYYYMMDD') as date_added
    ,cast(maxSizeFt as decimal) as max_size_ft
    ,cast(retirement as boolean) as retirement
    ,preOwned as pre_owned
    ,location.location_id
    ,prop_type.property_type_id
    ,agent.agent_id

from static-retina-408319.right_move.properties_raw src
left join {{ref('address_dim')}} location 
on src.address = location.address and src.postcode = location.postcode
left join {{ref('property_type_dim')}} prop_type 
on src.propertyType = prop_type.property_type and src.propertySubType = prop_type.property_sub_type
left join {{ref('agent_dim')}} agent
on IF(ARRAY_LENGTH(SPLIT(src.`Agent Name`, ',')) > 1, SPLIT(src.`Agent Name`, ',')[OFFSET(0)], src.`Agent Name`) = agent.agent_name 
and IF(ARRAY_LENGTH(SPLIT(src.`Agent Name`, ',')) > 1, SPLIT(src.`Agent Name`, ',')[OFFSET(1)], NULL) = agent.agent_branch

)
select 
    concat(rightmove_id, coalesce(cast(date_added as string), cast(rand() as string))) as property_id
    ,*
from properties