    select t1.service_code
         , t1.product_family
         , t1.product_sku
         , t1.pricing_type
         , t1.offer_term_code
         , t1.effective_date
         , t1.lease_contract_length
         , t1.offering_class
         , t1.purchase_option
         , t1.rate_code
         , t1.description
         , t1.begin_range
         , t1.end_range
         , t1.applies_to
         , t1.unit
         , t1.currency
         , t1.price_per_unit ::double as price_per_unit
         , t2.atr_clockspeed
         , t2.atr_instancetype
         , t2.atr_normalizationsizefactor
         , t2.atr_physicalprocessor
         , t2.atr_servicecode
         , t2.atr_storage
         , t2.atr_location
         , t2.atr_processorarchitecture
         , t2.atr_tenancy
         , t2.atr_intelturboavailable
         , t2.atr_capacitystatus
         , t2.atr_ecu
         , t2.atr_networkperformance
         , t2.atr_memory
         , t2.atr_availabilityzone
         , t2.atr_dedicatedebsthroughput
         , t2.atr_dedicatedebsthroughputdescription
         , t2.atr_intelavx2available
         , t2.atr_intelavxavailable
         , t2.atr_operatingsystem
         , t2.atr_regioncode
         , t2.atr_vpcnetworkingsupport
         , t2.atr_marketoption
         , t2.atr_currentgeneration
         , t2.atr_gpumemory
         , t2.atr_instancesku
         , t2.atr_operation
         , t2.atr_servicename
         , t2.atr_instancefamily
         , t2.atr_processorfeatures
         , t2.atr_licensemodel
         , t2.atr_preinstalledsw
         , t2.atr_vcpu
         , t2.atr_classicnetworkingsupport
         , t2.atr_enhancednetworkingsupported
         , t2.atr_usagetype
         , t2.atr_locationtype

      from {{ref('product_terms')}} t1
inner join {{ref('product_attributes')}} t2

        on t1.service_code = t2.service_code
       and t1.product_family = t2.product_family
       and t1.product_sku = t2.product_sku
