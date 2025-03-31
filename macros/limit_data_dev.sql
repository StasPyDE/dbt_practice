{% macro limit_data_dev(column_name, days=2) %}
  {% if target.name == 'dev' %}
  WHERE
     {{ column_name }} >= current_date - interval '{{ days }} days'
  {% endif %}
{% endmacro %}