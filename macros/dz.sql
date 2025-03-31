{# Task 1 #}
{% macro bookref_to_bigint(bookref) %}
  ('0x' || book_ref)::bigint
{% endmacro %}


{# Task 2 #}
{% macro safe_select(table_name) %}
    

    {% set all_tables_query %} 
        select UPPER(TABLE_CATALOG || '.' || TABLE_SCHEMA || '.' || TABLE_NAME) AS table_name
        from {{ target.database }}.INFORMATION_SCHEMA.TABLES
        where (TABLE_CATALOG || '.' || TABLE_SCHEMA || '.' || TABLE_NAME) = '{{ table_name }}';
    {% endset %}

    {% if execute %}
        {% set all_tables = run_query(all_tables_query).columns[0].values() %}
    {% else %}
        {% set all_tables = false %}
    {% endif %}
    

    {% if all_tables %}
        {% if (table_name | upper) in all_tables %}
            select * from {{ table_name }}
        {% else %}
            select null
        {% endif %}
    {% endif %}


{% endmacro %}

{# Task 3 #}
{%- macro show_columns_relation(model_name) %}
  {%- set relation = ref(model_name) %} 
  {%- set columns = adapter.get_columns_in_relation(relation) %}
  {%- for column in columns -%}
    {{- column.column -}}
    {%- if not loop.last -%},   
    {%- endif -%}
  {%- endfor -%}
{% endmacro %}