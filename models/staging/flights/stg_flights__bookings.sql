{{
  config(
    materialized = 'table'
    ) 
}}

{% if execute %}
  
{{ check_dependencies() }} 
{% endif %}
 
select {{ bookref_to_bigint('book_ref') }} as book_ref,  
       book_date,  
       {{ kopeck_to_ruble('total_amount', 2) }} as total_amount
from {{ source('demo_src', 'bookings') }}
{{ limit_data_dev('book_date', 3000) }}  


{% if execute %}
  {% for node in graph.nodes.values() %}
    {% if node.resource_type == 'model' or node.resource_type == 'seed' %}
      -- {{ node.name }}  
      -- _____________________
      -- {{ node.depends_on }}
    {% endif %}
  {% endfor %}
  
{% endif %} 