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


select a.updated_at                  ::timestamp_tz as updated_at
     , b.value:serviceCode           ::string       as service_code
     , b.value:product:productFamily ::string       as product_family
     , b.value:product:sku           ::string       as product_sku
     , b.value:version               ::string       as version
     , b.value:publicationDate       ::timestamp_tz as publication_date
     , b.value:product:attributes    ::variant      as attributes
     , b.value:terms                 ::variant      as terms

  from t_most_recent a
     , lateral flatten (input => a.records) b
