select t1.service_code
     , t1.product_family
     , t1.product_sku
     , t2.key                                      ::string    as pricing_type
     , t3.value:offerTermCode                      ::string    as offer_term_code
     , t3.value:effectiveDate                      ::timestamp as effective_date
     , t3.value:termAttributes:LeaseContractLength ::string    as lease_contract_length
     , t3.value:termAttributes:OfferingClass       ::string    as offering_class
     , t3.value:termAttributes:PurchaseOption      ::string    as purchase_option
     , t4.value:rateCode                           ::string    as rate_code
     , t4.value:description                        ::string    as description
     , t4.value:beginRange                         ::string    as begin_range
     , t4.value:endRange                           ::string    as end_range
     , t4.value:appliesTo                          ::string    as applies_to
     , t4.value:unit                               ::string    as unit
     , t5.key                                      ::string    as currency
     , t5.value                                    ::double    as price_per_unit

  from {{ref('products')}} t1
     , lateral flatten (input => t1.terms) t2
     , lateral flatten (input => t2.value) t3
     , lateral flatten (input => t3.value:priceDimensions) t4
     , lateral flatten (input => t4.value:pricePerUnit) t5
