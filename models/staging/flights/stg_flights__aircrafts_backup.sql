{{
  config(
    materialized = 'table',
    post_hook = '
      {% set todays_date = run_started_at | string | truncate(10, True, "") %}

      {% set new_table_name = "stg_flights__aircrafts_backup_" ~ todays_date %}
      
      {% set relation = api.Relation.create(
        database=this.database, 
        schema=this.schema, 
        identifier=new_table_name,
        type="table"
      ) %}

      {% do adapter.drop_relation(relation) %}

      {% do adapter.rename_relation(this, relation) %}
    '
  )
}}

select aircraft_code, model, "range"
from {{ source('demo_src', 'aircrafts') }}