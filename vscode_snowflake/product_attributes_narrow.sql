with

t0 as (
  select
    service_code, product_family, product_sku, attribute_name, value
  from
    misc.test_awspricelist.product_attributes_narrow
  where
    attribute_name != 'normalizationSizeFactor'
),

t1 as (
  select
    service_code, product_family, product_sku, attribute_name,
    value as value
  from
    misc.test_awspricelist.product_attributes_narrow
  where
    attribute_name = 'normalizationSizeFactor'
  and
    value != 'NA'
),

t2 as (
  select
    service_code, product_family, product_sku, attribute_name,
    NULL::number as value,
  from
    misc.test_awspricelist.product_attributes_narrow
  where
    attribute_name = 'normalizationSizeFactor'
  and
    value = 'NA'
)

select * from t0
union
select * from t1
union
select * from t2



-- select
--   service_code, product_family, product_sku, attribute_name, value
-- from
--   x
-- where
--   attribute_name = 'normalizationSizeFactor'
-- and
--   product_sku = '29DB7K3HUMPUYK9W'
-- order by
--   value desc
;



--------------------------------------------------------------------------------
select
  service_code   ,
  product_family ,
  product_sku    ,
  attribute_name ,
  value          ,
from
  misc.test_awspricelist.product_attributes_narrow
-- where
--   product_sku = '29DB7K3HUMPUYK9W'
-- and
--   attribute_name = 'normalizationSizeFactor'
-- and
--   value = 'NA'
;