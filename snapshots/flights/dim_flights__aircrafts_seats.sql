{% snapshot dim_flights__aircrafts_seats %}

{{
   config(
       target_schema='snapshot',
       unique_key=['aircraft_code', 'seat_no'],

       strategy='check',
       check_cols=['aircraft_code', 'seat_no', 'fare_conditions'],
       dbt_valid_to_current = "'9999-01-01'::date",

       hard_deletes='invalidate',

       snapshot_meta_column_names={
            "dbt_valid_from": "dbt_effective_date_from",
            "dbt_valid_to": "dbt_effective_date_to"
        }
   )
}}

select * from {{ ref('stg_flights__seats') }}

{% endsnapshot %}