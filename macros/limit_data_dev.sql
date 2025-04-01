{% macro limit_data_dev(column_name, days=2) %}
  {% if days < 0 %}
    {{ exceptions.raise_compiler_error("Invalid `days`. Got: " ~ days) }}
  {% endif %}


  {% if target.name == 'dev' %}
  WHERE
 --    {{ column_name }} >= current_date - interval '{{ days }} days'
       {{ column_name }} >= {{ dbt.dateadd(datepart="day", interval=-days, from_date_or_timestamp="current_date")}}
  {% endif %}
{% endmacro %} 