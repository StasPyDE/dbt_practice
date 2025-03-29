select scheduled_departure
from {{ ref('fct_flights') }}
where scheduled_departure < '{{ run_started_at|string|truncate(10, True, "") }}';

{% do adapter.drop_schema(
    api.Relation.create(
        database="dwh_flights", 
        schema="new_schema"
        )
    )
%}

{% set my_relation = load_relation(ref('stg_flights__flights')) %}

{% set columns = adapter.get_columns_in_relation(my_relation) %}

{% for column in columns %}
    {{ column }}
{% endfor %}