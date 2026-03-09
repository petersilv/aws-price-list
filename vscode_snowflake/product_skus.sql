select
*
from
misc.test_awspricelist.product_skus
where
atr_instancetype = 'r6i.4xlarge'
and
pricing_type = 'OnDemand'
order by
product_sku
;