select a.service_code
     , a.product_family
     , a.product_sku
     , b.key                                      ::string    as pricing_type
     , c.value:offerTermCode                      ::string    as offer_term_code
     , c.value:effectiveDate                      ::timestamp as effective_date
     , c.value:termAttributes:LeaseContractLength ::string    as lease_contract_length
     , c.value:termAttributes:OfferingClass       ::string    as offering_class
     , c.value:termAttributes:PurchaseOption      ::string    as purchase_option
     , d.value:rateCode                           ::string    as rate_code
     , d.value:description                        ::string    as description
     , d.value:beginRange                         ::string    as begin_range
     , d.value:endRange                           ::string    as end_range
     , d.value:appliesTo                          ::string    as applies_to
     , d.value:unit                               ::string    as unit
     , e.key                                      ::string    as currency
     , e.value                                    ::number    as price_per_unit

  from {{ref('products')}} a
     , lateral flatten (input => a.terms) b
     , lateral flatten (input => b.value) c
     , lateral flatten (input => c.value:priceDimensions) d
     , lateral flatten (input => d.value:pricePerUnit) e
