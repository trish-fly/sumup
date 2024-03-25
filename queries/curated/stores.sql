{{
  config(

    materialized            = 'incremental',
    incremental_strategy    = 'insert_overwrite',
    schema                  = 'curated',
    partition_by            = 'created_at',
    cluster_by              = ['country', 'city'],
    tags                    = ['daily_dag', 'tier_2_data_asset']
 )
}}

----------------------------------------------------------------------------------------
-- This model creates and curated stores table
----------------------------------------------------------------------------------------
--- IMPORT CTEs ---

with stores as (

    select *

    from {{ source ('raw_layer', 'sumup_store') }}

    --- if incremental then take latest input, otherwise recreate the whole timeframe
    --- assumption here is that there are no late arriving events with created_at ts
    {% if is_incremental() %}

    where
        created_at >= (select max(created_at) from {{ this }})

    {% endif %}



--- END of IMPORT CTEs ---
----------------------------------------------------------------------------------------
--- LOGICAL CTEs ---

, final as(

    select
          cast(id as int64)                                     as store_uuid
        , cast(customer_id as string)                           as customer_id
        , cast(name as string)                                  as type_id
        , cast(address as string)                               as address
        , cast(country as string)                               as country
        , cast(city as string)                                  as city
        , cast(typology as string)                              as typology
        , parse_timestamp('%m/%d/%Y %H:%M:%S', created_at)      as created_at

    from stores
)

--- END of LOGICAL CTEs ---
----------------------------------------------------------------------------------------

select * from final
