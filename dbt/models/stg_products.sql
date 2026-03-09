with

t_all_dates as (
  select directory                                       ::string       as directory
       , to_timestamp_tz(file_name, 'yyyy-mm-dd-hh24mi') ::timestamp_tz as updated_at
       , records                                         ::variant      as records
    from {{ source('aws_price_list', 'landing_getproducts') }}
),

t_max_date as (
  select directory as directory_group
       , max(updated_at) as max_updated_at
    from t_all_dates
   group by directory
),

t_most_recent as (
  select replace(t_all_dates.directory, 'data/getproducts/', '') as product_group
       , updated_at
       , records
    from t_all_dates
    inner join t_max_date
      on directory = directory_group
      and updated_at = max_updated_at
)

select t1.updated_at                  ::timestamp_tz as updated_at
     , t2.value:serviceCode           ::string       as service_code
     , t2.value:product:productFamily ::string       as product_family
     , t2.value:product:sku           ::string       as product_sku
     , t2.value:version               ::string       as version
     , t2.value:publicationDate       ::timestamp_tz as publication_date
     , t2.value:product:attributes    ::variant      as attributes
     , t2.value:terms                 ::variant      as terms

  from t_most_recent t1
     , lateral flatten (input => t1.records) t2
