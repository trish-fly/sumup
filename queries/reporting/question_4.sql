-- Percentage of transactions per device type
---- assumption: we are interested in all transactions even if it's cancelled or refused as that has costs

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

----------------------------------------------------------------------------------------
--- LOGICAL CTEs ---

, device_agg as (
-- calculate transactions per device type

    select

         devices.type_id
        , count(distinct transactions.transaction_uuid) as number_of_transactions

    from transactions
    left join devices
        on devices.device_uuid = transactions.device_id

    group by all
)

, totals as (
-- calculate total number of transactions
   select

        count(distinct transaction_uuid)                    as total_transactions

   from transactions
)

--- END of LOGICAL CTEs ---
----------------------------------------------------------------------------------------
--- FINAL CTEs ---

, final as (
-- calculate percentage

    select
          device_agg.type_id
        , device_agg.number_of_transactions
        , round(
            device_agg.number_of_transactions / totals.total_transactions * 100
            , 2)                                             as percentage_of_transactions

    from device_agg
    cross join totals
)

--- END of FINAL CTEs ---
----------------------------------------------------------------------------------------

select * from final
