{% set aircrafts_codes_with_flights = dbt_utils.get_column_values(
    table=ref('stg_flights__flights'),
    column='aircraft_code'
) %}

select *
from {{ ref('stg_flights__aircrafts') }}
where aircraft_code IN ('{{ aircrafts_codes_with_flights | join("', '") }}')