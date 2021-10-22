select a.service_code
     , a.product_family
     , a.product_sku
     , c.value:offerTermCode :: string as offer_term_code
     , d.value:rateCode      :: string as rate_code
     , d.value:appliesTo     :: string as applies_to
     , d.value:unit          :: string as unit
     , d.value:description   :: string as description
     , d.value:endRange      :: string as end_range
     , d.value:beginRange    :: string as begin_range
     , e.value               :: float  as price_per_unit
     , e.key                 :: string as price_per_unit_currency

  from {{ref('product_skus')}} a
     , lateral flatten (input => a.terms) b
     , lateral flatten (input => b.value) c
     , lateral flatten (input => c.value:priceDimensions) d
     , lateral flatten (input => d.value:pricePerUnit) e
