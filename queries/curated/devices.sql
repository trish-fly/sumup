{{
  config(

    materialized = 'table',
    schema       = 'curated',
    cluster_by   = ['type'],
    tags         = ['daily_dag', 'tier_2_data_asset']
 )
}}

----------------------------------------------------------------------------------------
-- This model creates and curated devices table
----------------------------------------------------------------------------------------
--- IMPORT CTEs ---

with devices as (

    select *

    from {{ source ('raw_layer', 'sumup_device') }}

----- Proposal to filter for the latest data insertion based on timestamp, this shall be added to the raw table
--     where date(ingestion_timestamp)
--            between date_sub(date('{{ var("data_interval_end") }}'), interval 1 day )
--            and date('{{ var("data_interval_end") }}')
)

--- END of IMPORT CTEs ---
----------------------------------------------------------------------------------------
--- LOGICAL CTEs ---

, final as(

    select
          cast(id as int64)                 as device_uuid
        , cast(type as int64)               as type_id
        , cast(store_id as int64)           as store_id

    from devices
)

--- END of LOGICAL CTEs ---
----------------------------------------------------------------------------------------

select * from final
