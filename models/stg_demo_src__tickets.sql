
with source as (

    select * from {{ source('demo_src', 'tickets') }}

),

renamed as (

    select
        ticket_no,
        book_ref,
        passenger_id,
        passenger_name,
        contact_data

    from source

)

select * from renamed

