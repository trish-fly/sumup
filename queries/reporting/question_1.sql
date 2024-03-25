-- Top 10 stores per transacted amount

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

, get_top_stores as (
-- take top 10 stores based on the transaction amount

    select
        devices.store_id
      , sum(transactions.amount) as amount

    from devices
    join transactions
      on devices.device_uuid = transactions.device_id

    group by all

    qualify
      row_number() over (order by amount desc) <= 10
)

--- END of LOGICAL CTEs ---
----------------------------------------------------------------------------------------
--- FINAL CTEs ---

, final as (
-- populated store dimensions

    select

        get_top_stores.*
      , stores.name
      , stores.country
      , stores.city
      , stores.address

    from get_top_stores
    left join stores
      on stores.store_uuid = get_top_stores.store_id

)

--- END of FINAL CTEs ---
----------------------------------------------------------------------------------------

select * from final
