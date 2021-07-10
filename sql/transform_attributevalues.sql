create or replace table ${database}.${schema}.${table} as

with 

t_all_dates as (
    select a.file_name           ::date   as date
         , b.value:ServiceCode   ::string as service_code
         , b.value:AttributeName ::string as attribute_name
         , c.value:Value         ::string as attribute_value

    from ${database}.${schema}.${json_table}                 a
        , lateral flatten (input => a.records)               b
        , lateral flatten (input => b.value:AttributeValues) c
),

t_max_date as (
    select max(date) as max_date
         , service_code
      from t_all_dates
     group by service_code
)

select t_all_dates.service_code
     , t_all_dates.attribute_name
     , t_all_dates.attribute_value
  from t_all_dates
 inner join t_max_date
    on t_all_dates.date         = t_max_date.max_date
   and t_all_dates.service_code = t_max_date.service_code
