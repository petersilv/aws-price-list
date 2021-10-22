with

t_all_dates as (
    select a.file_name         ::date   as date
         , b.value:ServiceCode ::string as service_code

      from LANDING_DESCRIBESERVICES a
         , lateral flatten (input => a.records) b
),

t_max_date as (
    select max(date) as max_date
      from t_all_dates
)

select service_code
  from t_all_dates
 inner join t_max_date
    on date = max_date