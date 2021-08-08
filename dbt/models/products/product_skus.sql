{#- ----------------------------------------------------------------------------
Set variables -#}

{%- set original_table = 'getproducts_json' -%}

{#- ----------------------------------------------------------------------------
Run query -#}

with

t_all_dates as (
    select directory ::string  as directory
         , file_name ::date    as updated_date
         , records   ::variant as records
      from {{var('database') ~ '.' ~ var('schema') ~ '.' ~ original_table}}
),

t_max_date as (
    select directory as directory_group
         , max(updated_date) as max_updated_date
      from t_all_dates
     group by directory
),

t_most_recent as (
    select replace(t_all_dates.directory, 'data/getproducts/', '') as product_group
         , updated_date 
         , records
      from t_all_dates
     inner join t_max_date
        on directory = directory_group
       and updated_date = max_updated_date 
)

select b.value:serviceCode           ::string  as service_code
     , b.value:product:productFamily ::string  as product_family
     , b.value:product:sku           ::string  as product_sku
     , b.value:version               ::string  as version
     , b.value:publicationDate       ::string  as publication_date
     , b.value:product:attributes    ::variant as attributes
     , b.value:terms                 ::variant as terms

  from t_most_recent a
     , lateral flatten (input => a.records) b
