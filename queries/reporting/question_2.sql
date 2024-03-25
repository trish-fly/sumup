-- Top 10 products sold

{{
  config(
    materialized            = 'view',
    schema                  = 'reporting',
    tags                    = ['daily_dag', 'tier_2_data_asset']
 )
}}

----------------------------------------------------------------------------------------
--- IMPORT CTEs ---

with transactions as (

    select *

    from {{ ref('transactions') }}
    where status = 'accepted'
)

--- END of IMPORT CTEs ---
----------------------------------------------------------------------------------------
--- LOGICAL CTEs ---

, get_top_products as (
-- take top 10 stores based on the transaction amount

    select
          product_sku
        , sum(amount)       as amount

    from transactions

    group by 1
    qualify
        row_number() over (order by amount desc) <= 10
)

--- END of LOGICAL CTEs ---
----------------------------------------------------------------------------------------
--- FINAL CTEs ---

, final as (

  select *
  from get_top_products

)

--- END of FINAL CTEs ---
----------------------------------------------------------------------------------------

select * from final
