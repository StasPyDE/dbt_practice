{%- macro concat_columns(columns, delim=', ') %}
    {%- for column in columns -%}
    {{ column }} {% if not loop.last %} || '{{ delim }}' || {% endif %}
  {%- endfor -%}
{% endmacro %} 


{% macro drop_old_relations(dryrun=False) %}
  {# находим все модели, seeds, snapshots проекта dbt #}
   {% set current_models = [] %}
   {% for node in graph.nodes.values() | selectattr("resource_type", "in", ['model', 'seed', 'snapshot']) %}
     {% do current_models.append(node.name) %}
   {% endfor %}

  {# формирование скрипта удаления всех таблиц и вьюшек, которым не соответствует ни одна модель, сид и снэпшот #}
    {% set cleanup_query %}
    with models_to_drop as (
        select case when TABLE_TYPE = 'BASE TABLE' then 'TABLE'
                when TABLE_TYPE = 'VIEW' then 'VIEW'
                end as relation_type,
                TABLE_CATALOG || '.' || TABLE_SCHEMA || '.' || TABLE_NAME AS relation_name
        from {{ target.database }}.INFORMATION_SCHEMA.TABLES
        where TABLE_SCHEMA = '{{ target.schema }}' and UPPER(TABLE_NAME) not in 
                    ({%- for model in current_models -%}
                        '{{ model.upper() }}'
                        {%- if not loop.last -%}, {%- endif %}
                    {%- endfor -%})
    )
    select 'DROP ' || RELATION_TYPE || ' ' || RELATION_NAME || ' CASCADE;' as DROP_COMMANDS
    FROM models_to_drop;
    {% endset %}
    {% do log(cleanup_query) %}
    {% set drop_commands = run_query(cleanup_query).columns[0].values() %}

    {% if drop_commands %}
        {% if dryrun | as_bool == False %}
            {% do log('Executing DROP commands...', True)%}
        {% else %}
            {% do log('Printing DROP commands...', True)%}
    {% endif %}
      
    {% for drop_command in drop_commands %}
      {% do log(drop_command, True) %}
      {% if dryrun | as_bool == False %}
        {% do run_query(drop_command) %}
      {% endif %}
    {% endfor %}
    {% else %}
        {% do log('No relation to delete', True) %}
    {% endif %}
  {# удаление лишних таблиц и вьюх или вывод скрипта удаления#}
{% endmacro %}