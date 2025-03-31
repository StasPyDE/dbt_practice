{{
  config(
    materialized = 'table'
    )
}}

select {{ bookref_to_bigint('book_ref') }},  
       book_date, 
       {{ kopeck_to_ruble('total_amount') }} as total_amount
from {{ source('demo_src', 'bookings') }}
{{ limit_data_dev('book_date', 3000) }} 