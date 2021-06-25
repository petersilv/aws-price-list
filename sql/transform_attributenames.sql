create or replace table ${database}.${schema}.${table} as

with 

t_all_dates as (
    select a.file_name         ::date   as date
         , b.value:ServiceCode ::string as service_code
         , c.value             ::string as attribute_names

      from awspricelist_json_describeservices a
         , lateral flatten (input => a.records) b
         , lateral flatten (input => b.value:AttributeNames) c
),

t_max_date as (
    select max(date) as max_date
      from t_all_dates
)

select service_code
     , attribute_names
  from t_all_dates
 inner join t_max_date
    on date = max_date
