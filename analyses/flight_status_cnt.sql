{% set query %}
select distinct status from {{ ref('stg_flights__flights') }}
{% endset %}

{% set s = run_query(query) %}
{% if execute %}
    {% set statuses = s.columns[0].values() %}
{% else %}
    {% set statuses = [] %}
{% endif %}

select 
    {% for status in statuses %}
    sum(case when status = '{{ status }}' then 1 else 0 end) 
    as {% if status == 'On Time' %} status_On_Time {% else %} status_{{ status }} {%- endif %}
    {%- if not loop['last'] %}, {% endif %}
    {% endfor %}
from {{ ref('stg_flights__flights') }};
