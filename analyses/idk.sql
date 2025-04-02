{% set statuses = dbt_utils.get_column_values(table=ref('fct_flights'), column='status') %}

select departure_airport as dep_air,
       {{ dbt_utils.pivot('status', statuses) }}
from {{ ref('fct_flights') }}
group by departure_airport