-- Average transacted amount per store typology and country

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

, stores as (

    select *

    from {{ ref('stores') }}
)

, devices as (

    select *

    from {{ ref('devices') }}
)

--- END of IMPORT CTEs ---
----------------------------------------------------------------------------------------
--- LOGICAL CTEs ---

, joined as (
-- join CTEs and calculate total amount transacted and the number of transactions

    select

        stores.typology
      , stores.country
      , sum(transactions.amount)    as amount
      , count(distinct transactions.transaction_uuid) as number_of_transactions

    from devices
    left join stores
      on stores.store_uuid = devices.store_id
    join transactions
      on devices.device_uuid = transactions.device_id

    group by all

)

--- END of IMPORT CTEs ---
----------------------------------------------------------------------------------------
--- FINAL CTEs ---

, final as (
-- calculate average per typology and country

    select

        *
      , round(amount / number_of_transactions, 2) as avg_transacted_amount

    from joined
    group by all
)

--- END of FINAL CTEs ---
----------------------------------------------------------------------------------------
select * from final
