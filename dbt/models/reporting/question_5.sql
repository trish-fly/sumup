-- Average time for a store to perform its 5 first transactions

---- assumption: we are interested in all transactions even if it's cancelled or refused as that has costs

{{
  config(
    materialized            = 'view',
    schema                  = 'reporting',
    tags                    = ['daily_dag', 'tier_2_data_asset']
 )
}}

---- TASK: get AVG time for a store to perform its 5 first transactions
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

, joined as (
-- get first 5 transactions based on happened_at
------- assumption: created_at is a timestamp when the record was created on a server (both table)
----------- happened_at when the transaction actually happened

    select

        devices.store_id
      , stores.name
      , transactions.happened_at

    from devices
    left join stores
      on stores.store_uuid = devices.store_id
    join transactions
      on devices.device_uuid = transactions.device_id

    group by all

    qualify
      row_number() over (partition by store_id order by happened_at asc) <= 5
)

, get_time_diff as (
-- calculate time between two transactions in minutes

    select
        name
      , store_id
      , ifnull(
          timestamp_diff(
              lead(happened_at) over (partition by store_id order by happened_at)
          , happened_at, minute)
        , 0)                                as time_diff
    from joined
)

, avg_time as (
-- get average time per store and count number of transactions

  select

      store_id
    , name
    , avg(time_diff) as avg_time_in_minutes
    , count(*) as nb_transactions

    from get_time_diff

  group by all
)

--- END of LOGICAL CTEs ---
----------------------------------------------------------------------------------------
--- FINAL CTEs ---

, final as (
-- set a flag to differentiate if a store has made already 5 transactions

    select
        store_id
      , name
      , avg_time_in_minutes
      , if(nb_transactions = 5, true, false) as has_5_transactions

    from avg_time
)

--- END of FINAL CTEs ---
----------------------------------------------------------------------------------------

select * from final
