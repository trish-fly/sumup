{{
  config(

    materialized = 'table',
    schema       = 'curated',
    tags         = ['daily_dag', 'tier_2_data_asset']
 )
}}

----------------------------------------------------------------------------------------
-- This model creates and curated devices table
----------------------------------------------------------------------------------------
--- IMPORT CTEs ---

with raw_import as (

    select *
    from `firsty-case.raw_import.firsty_use_case`



----- Proposal to filter for the latest data insertion based on timestamp, this shall be added to the raw table
--     where date(call_date_time)
--            between date_sub(date('{{ var("data_interval_end") }}'), interval 1 day )
--            and date('{{ var("data_interval_end") }}')

)

--- END of IMPORT CTEs ---
----------------------------------------------------------------------------------------
--- LOGICAL CTEs ---

, final as (

    select

        activeaddonid                                           as active_addon_id
        , activeaddonname                                       as active_addon_name
        , calltype                                              as call_type
        , cast(billableduration as int64)                       as billable_duration
        , cdrid                                                 as cdr_id
          -- convert epoch to timestamp
        , timestamp_millis(
            cast(callDateTimeInMilliseconds as int64))          as call_date_time
        , country                                               as country
        , cast(iccid as int64)                                  as icc_id
        , imsi                                                  as imsi
        , msisdn                                                as msisdn
        , operator                                              as operator
        , traffictype                                           as traffic_type
        , cast(zoneid as int64)                                 as zone_id
        , cast(actualusage as float64)                          as actual_usage
        -- categorizing usage for analysis
        , case
            when cast(actualusage as float64) > 1 then 'high_usage'
            when cast(actualusage as float64) > 0.5 then 'medium_usage'
            else 'low_usage'
          end                                                   as usage_category

    from raw_import
)

--- END of LOGICAL CTEs ---
----------------------------------------------------------------------------------------

select * from final
