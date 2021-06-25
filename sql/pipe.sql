copy into ${database}.${schema}.${table}
  from (

    select 
           $1::variant
         , metadata$filename
         , regexp_replace(metadata$filename, '(.*/).*?.json','\\1')
         , regexp_replace(metadata$filename, '.*/(.*?).json','\\1')
         , current_timestamp::timestamp_tz

      from 
           @${database}.${schema}.${stage}/${stage_folder}
  )
  file_format = (type=json)
  on_error= skip_file
