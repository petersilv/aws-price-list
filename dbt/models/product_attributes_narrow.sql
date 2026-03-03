select a.service_code
     , a.product_family
     , a.product_sku
     , b.key as attribute_name
     , b.value ::string as value

  from {{ref('products')}} a
     , lateral flatten (input => a.attributes) b
