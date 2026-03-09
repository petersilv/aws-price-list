select t1.service_code
     , t1.product_family
     , t1.product_sku
     , t2.key as attribute_name
     , t2.value ::string as value

  from {{ref('stg_products')}} t1
     , lateral flatten (input => t1.attributes) t2
