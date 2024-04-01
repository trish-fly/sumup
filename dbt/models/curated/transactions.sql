{{
  config(

    materialized            = 'incremental',
    incremental_strategy    = 'insert_overwrite',
    schema                  = 'curated',
    partition_by            =
        {
          "field": "created_at",
          "data_type": "timestamp",
          "granularity": "day",
          "time_ingestion_partitioning": true,
          "copy_partitions": true
    },
    cluster_by              = 'device_id',
    tags                    = ['daily_dag', 'tier_2_data_asset']
 )
}}

----------------------------------------------------------------------------------------
-- This model creates and curated devices table
----------------------------------------------------------------------------------------
--- IMPORT CTEs ---

with transactions as (

    select *
    from  {{ source ('raw_layer', 'sumup_transaction') }}

    --- if incremental then take latest input, otherwise recreate the whole timeframe
    --- assumption here is that there are no late arriving events with created_at ts
    {% if is_incremental() %}

    where
        date(created_at) >= (select max(date(created_at)) from {{ this }})

    {% endif %}

)

--- END of IMPORT CTEs ---
----------------------------------------------------------------------------------------
--- LOGICAL CTEs ---

, final as(

    select
          cast(id as int64)                                     as transaction_uuid
        , cast(device_id as int64)                              as device_id
        , cast(product_name as string)                          as product_name
        , cast(product_sku as string)                           as product_sku
        , cast(category_name as string)                         as category_name
        , cast(amount as float64) / 10                          as amount
        , cast(status as string)                                as status
        , cast(replace(card_number, " ", "") as float64)        as card_number
        , cast(cvv as int64)                                    as cvv
        , PARSE_TIMESTAMP('%m/%d/%Y %H:%M:%S', created_at)      as created_at
        , PARSE_TIMESTAMP('%m/%d/%Y %H:%M:%S', happened_at)     as happened_at

    from transactions
)

--- END of LOGICAL CTEs ---
----------------------------------------------------------------------------------------

select * from final
