{#- ----------------------------------------------------------------------------
Set variables -#}

{%- set columns_to_show = 'service_code, product_family, product_sku'  -%}
{%- set pivot_column = 'key_name' -%}
{%- set aggregate_column = 'value' -%}

{#- ----------------------------------------------------------------------------
Get list of header names -#}

{%- set col_query -%}
select distinct {{pivot_column}} from {{ref('product_attributes_narrow')}};
{%- endset -%}

{%- set results = run_query(col_query) -%} 

{%- if execute -%}
{%- set items = results.columns[0].values() -%}
{%- endif -%}

{%- set col_list -%}
{%- for i in items %}
'{{i}}'
{%- if not loop.last %}, {% endif -%}
{% endfor -%}
{%- endset -%}

{%- set col_list_labels -%}
{%- for i in items %}
atr_{{i}}
{%- if not loop.last %}, {% endif -%}
{% endfor -%}
{%- endset -%}

{#- ----------------------------------------------------------------------------
Run query -#}

select *
  from {{ref('product_attributes_narrow')}}
 pivot ( max({{aggregate_column}}) for {{pivot_column}} in ({{col_list}}) )
    as p ( {{columns_to_show}}, {{col_list_labels}} )
 order by {{columns_to_show}}
