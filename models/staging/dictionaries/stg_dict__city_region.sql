{{
  config(
    materialized = 'table'
    )
}}

select * from {{ ref('city_region') }}