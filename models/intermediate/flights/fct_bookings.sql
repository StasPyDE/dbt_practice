{{
  config(
    materialized = 'table',
    meta={
      'owner': 'sql_file_owner@gmail.com'
    }
    )
}}

select {{ dbt_utils.generate_surrogate_key(['book_ref']) }}::text AS booking_sk,
       {{ show_columns_relation('stg_flights__bookings') }}
from {{ ref('stg_flights__bookings') }}