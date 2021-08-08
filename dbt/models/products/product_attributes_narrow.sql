{#- ----------------------------------------------------------------------------
Run query -#}

select a.service_code
     , a.product_family
     , a.product_sku
     , b.key as key_name
     , b.value ::string as value

  from {{ref('product_skus')}} a
     , lateral flatten (input => a.attributes) b
