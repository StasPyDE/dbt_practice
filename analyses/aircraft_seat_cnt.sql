select aircraft_code, count(*) 
from {{ ref('stg_flights__seats') }}
group by aircraft_code;