select
distinct
  atr_instancetype
--  atr_normalizationsizefactor ,
--  atr_vcpu ::number ,
from
  misc.test_awspricelist.product_attributes
where
  atr_normalizationsizefactor = 'NA'
order by
  atr_instancetype
-- limit
--   1000
;