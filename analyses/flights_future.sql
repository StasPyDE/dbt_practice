{% set current_date = run_started_at|string|truncate(10, True, "") %}
{% set current_year = run_started_at|string|truncate(4, True, "")|int %}
{% set prev_year = current_year - 10 %}
{% set prev_date = prev_year|string ~ current_date[4:] %}

select count(*)
from {{ ref('fct_flights') }}
where scheduled_departure <= '{{ current_date }}' and scheduled_departure >= '{{ prev_date }}';