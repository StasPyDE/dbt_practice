{% macro log_length() %}
  {% set models_count = graph.nodes.values() | selectattr('resource_type', 'equalto', 'model') | list | length %}
  {% set seeds_count = graph.nodes.values() | selectattr('resource_type', 'equalto', 'seed') | list | length %}
  {% set snapshots_count = graph.nodes.values() | selectattr('resource_type', 'equalto', 'snapshot') | list | length %}

  {% do log(models_count ~ ' models', True) %}
  {% do log(seeds_count ~ ' seeds', True) %}
  {% do log(snapshots_count ~ ' snapshots', True) %}
{% endmacro %}

{% macro check_dependencies() %}
  {% set count_dependencies = (model.depends_on.nodes | length) + (model.depends_on.macros | length) %}
  {% if count_dependencies > 1 %}
    {% do log('Модель ' ~ model.name ~ ' зависит от ' ~ count_dependencies ~ ' объектов!', True) %}
  {% endif %}
{% endmacro %}