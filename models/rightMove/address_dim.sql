{{ config(
    materialized='table'
) }}


WITH RankedAddresses AS (
    SELECT
        postcode,
        address,
        longitude,
        latitude,
        ROW_NUMBER() OVER (PARTITION BY postcode, longitude, latitude ORDER BY postcode desc) AS row_num
 from static-retina-408319.right_move.properties_raw
    -- Add any additional conditions or ORDER BY clause as needed
)
SELECT
  row_number() over() as location_id,
    postcode,
    address,
    longitude,
    latitude
FROM
    RankedAddresses
WHERE
    row_num = 1