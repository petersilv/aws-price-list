select a.service_code
     , a.product_family
     , a.product_sku
     , c.value:offerTermCode                      ::string    as offer_term_code
     , b.key                                      ::string    as pricing_type
     , c.value:effectiveDate                      ::timestamp as effective_date
     , c.value:termAttributes:LeaseContractLength ::string    as lease_contract_length
     , c.value:termAttributes:OfferingClass       ::string    as offering_class
     , c.value:termAttributes:PurchaseOption      ::string    as purchase_option

  from {{ref('product_skus')}} a
     , lateral flatten (input => a.terms) b
     , lateral flatten (input => b.value) c
