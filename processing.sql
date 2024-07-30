/**********************************************************/
/******************** GTFS DATA PROCESSING ****************/
/**********************************************************/

-- procedure to truncate import gtfs tables
CREATE OR REPLACE PROCEDURE gtfs.p_truncate_import_gtfs_tables()
LANGUAGE SQL SECURITY DEFINER SET search_path = _import, pg_temp AS $$
    TRUNCATE TABLE _import.gtfs_tl_feeds;
    TRUNCATE TABLE _import.gtfs_tl_agency;
    TRUNCATE TABLE _import.gtfs_tl_areas;
    TRUNCATE TABLE _import.gtfs_tl_attributions;
    TRUNCATE TABLE _import.gtfs_tl_calendar;
    TRUNCATE TABLE _import.gtfs_tl_calendar_dates;
    --TRUNCATE TABLE _import.gtfs_tl_extra_attributes;
    TRUNCATE TABLE _import.gtfs_tl_extra_files;
    TRUNCATE TABLE _import.gtfs_tl_fare_attributes;
    TRUNCATE TABLE _import.gtfs_tl_fare_leg_rules;
    TRUNCATE TABLE _import.gtfs_tl_fare_media;
    TRUNCATE TABLE _import.gtfs_tl_fare_products;
    TRUNCATE TABLE _import.gtfs_tl_fare_rules;
    TRUNCATE TABLE _import.gtfs_tl_fare_transfer_rules;
    TRUNCATE TABLE _import.gtfs_tl_feed_info;
    TRUNCATE TABLE _import.gtfs_tl_frequencies;
    TRUNCATE TABLE _import.gtfs_tl_levels;
    TRUNCATE TABLE _import.gtfs_tl_networks;
    TRUNCATE TABLE _import.gtfs_tl_pathways;
    TRUNCATE TABLE _import.gtfs_tl_route_networks;
    TRUNCATE TABLE _import.gtfs_tl_routes;
    TRUNCATE TABLE _import.gtfs_tl_shapes;
    TRUNCATE TABLE _import.gtfs_tl_stops;
    TRUNCATE TABLE _import.gtfs_tl_stop_areas;
    TRUNCATE TABLE _import.gtfs_tl_stop_times;
    TRUNCATE TABLE _import.gtfs_tl_timeframes;
    TRUNCATE TABLE _import.gtfs_tl_transfers;
    TRUNCATE TABLE _import.gtfs_tl_translations;
    TRUNCATE TABLE _import.gtfs_tl_trips;
$$;

-- procedure to insert _import feed data into main gtfs transitland feeds table
CREATE OR REPLACE PROCEDURE gtfs.p_insert_transitland_feed_info()
LANGUAGE SQL AS $$
    -- insert new transitland feed data first to allow foreign key checks
    INSERT INTO gtfs.transitland_feeds
    SELECT DISTINCT
        cast(id AS integer) AS feed_id
        ,cast(agency_id AS smallint) AS trac_agency_id
        ,cast(fetched_at AS timestamptz) AS fetched_at_utc
        ,cast(earliest_calendar_date AS date) AS earliest_calendar_date
        ,cast(latest_calendar_date AS date) AS latest_calendar_date
        ,cast(decode(sha1, 'hex') AS bytea) AS sha1
        ,url
    FROM _import.gtfs_tl_feeds;
$$;

-- use security definer to allow less privileged user to execute
-- NOTE https://www.postgresql.org/docs/current/sql-createfunction.html#SQL-CREATEFUNCTION-SECURITY
--      https://www.cybertec-postgresql.com/en/abusing-security-definer-functions/

-- function to verify feed exists
CREATE OR REPLACE FUNCTION gtfs.f_feed_exists(_feed_id integer) RETURNS boolean
LANGUAGE SQL SECURITY DEFINER SET search_path = gtfs, pg_temp AS $$
    SELECT EXISTS (SELECT 1 FROM gtfs.transitland_feeds WHERE feed_id = _feed_id);
$$;

-- procedure to store a bad feed
CREATE OR REPLACE PROCEDURE gtfs.p_insert_bad_feed(_feed_id integer)
LANGUAGE SQL SECURITY DEFINER SET search_path = gtfs, pg_temp AS $$
    -- insert transitland feed info
    CALL gtfs.p_insert_transitland_feed_info();

    -- write bad feed and truncate tables
    INSERT INTO gtfs.tl_bad_feeds VALUES (_feed_id);
    CALL gtfs.p_truncate_import_gtfs_tables();
$$;

-- procedure to move data from _import.gtfs* tables to gtfs.*
CREATE OR REPLACE PROCEDURE gtfs.p_import_gtfs_transitland()
LANGUAGE plpgsql SECURITY DEFINER SET search_path = gtfs, _import, pg_temp AS $$
DECLARE
    --_s_dtm timestamptz := util.f_now_utc();
    --_proc text := 'import_gtfs_transitland';
    --_asof timestamptz;
    _res integer;
    _msg text;
BEGIN

    -- verify that there is only one feed in the feeds table
    SELECT count(*) FROM _import.gtfs_tl_feeds INTO _res;
    IF _res <> 1 THEN
        -- TODO log error and truncate all tables
        CALL gtfs.p_truncate_import_gtfs_tables();
        RETURN;
    END IF;

    -- insert transitland feed info
    CALL gtfs.p_insert_transitland_feed_info();

    /*
    -- extra attributes
    -- NOTE too many issues with malformed files
    INSERT INTO gtfs.tl_extra_attributes
    SELECT DISTINCT 
        cast(feed_id AS integer) AS feed_id
        ,file_name
        ,column_name
        ,value
    FROM _import.gtfs_tl_extra_attributes;
    */

    -- extra files in a GTFS feed
    INSERT INTO gtfs.tl_extra_files
    SELECT DISTINCT 
        cast(id AS integer) AS feed_id
        ,file_name
    FROM _import.gtfs_tl_extra_files;

    -- agency data
    -- NOTE cross join works because there should only be one feed_id in the feeds table
    INSERT INTO gtfs.tl_agency 
    SELECT DISTINCT 
        cast(b.id AS integer) AS feed_id
        ,m.agency_id
        ,m.agency_name
        ,m.agency_url
        ,m.agency_timezone
        ,m.agency_lang
        ,m.agency_phone
        ,m.agency_fare_url
        ,m.agency_email
    FROM _import.gtfs_tl_agency AS m
    CROSS JOIN _import.gtfs_tl_feeds AS b;

    -- feed info data
    INSERT INTO gtfs.tl_feed_info
    SELECT DISTINCT 
        cast(b.id AS integer) AS feed_id
        ,m.feed_publisher_name
        ,m.feed_publisher_url
        ,m.feed_lang
        ,m.default_lang
        ,CASE WHEN lower(m.feed_start_date) = 'nan' THEN NULL
              ELSE cast(m.feed_start_date AS date)
            END AS feed_start_date
        ,CASE WHEN lower(m.feed_end_date) = 'nan' THEN NULL
              ELSE cast(m.feed_end_date AS date)
            END AS feed_end_date
        ,m.feed_version
        ,m.feed_contact_email
        ,m.feed_contact_url
    FROM _import.gtfs_tl_feed_info AS m
    CROSS JOIN _import.gtfs_tl_feeds AS b;

    -- translation data
    INSERT INTO gtfs.tl_translations
    SELECT DISTINCT 
        cast(b.id AS integer) AS feed_id
        ,m.table_name
        ,m.field_name
        ,m.language
        ,m.translation
        ,m.record_id
        ,m.record_sub_id
        ,m.field_value
    FROM _import.gtfs_tl_translations AS m
    CROSS JOIN _import.gtfs_tl_feeds AS b;

    -- network data
    INSERT INTO gtfs.tl_networks
    SELECT DISTINCT 
        cast(b.id AS integer) AS feed_id
        ,m.network_id
        ,m.network_name
    FROM _import.gtfs_tl_networks AS m
    CROSS JOIN _import.gtfs_tl_feeds AS b;

    -- fare media data
    INSERT INTO gtfs.tl_fare_media
    SELECT DISTINCT 
        cast(b.id AS integer) AS feed_id
        ,m.fare_media_id
        ,m.fare_media_name
        ,cast(m.fare_media_type AS smallint) AS fare_media_type
    FROM _import.gtfs_tl_fare_media AS m
    CROSS JOIN _import.gtfs_tl_feeds AS b;

    -- shape data
    INSERT INTO gtfs.tl_shapes
    SELECT DISTINCT 
        cast(b.id AS integer) AS feed_id
        ,m.shape_id
        ,cast(m.shape_pt_lat AS real) AS shape_pt_lat
        ,cast(m.shape_pt_lon AS real) AS shape_pt_lon
        ,util.f_get_location_from_text_coords(m.shape_pt_lon, m.shape_pt_lat) AS shape_pt_location
        ,cast(m.shape_pt_sequence AS integer) AS shape_pt_sequence
        ,cast(m.shape_dist_traveled AS real) AS shape_dist_traveled
    FROM _import.gtfs_tl_shapes AS m
    CROSS JOIN _import.gtfs_tl_feeds AS b;

    -- calendar data
    INSERT INTO gtfs.tl_calendar
    SELECT DISTINCT 
        cast(b.id AS integer) AS feed_id
        ,m.service_id
        ,cast(m.monday AS smallint) AS monday
        ,cast(m.tuesday AS smallint) AS tuesday
        ,cast(m.wednesday AS smallint) AS wednesday
        ,cast(m.thursday AS smallint) AS thursday
        ,cast(m.friday AS smallint) AS friday
        ,cast(m.saturday AS smallint) AS saturday
        ,cast(m.sunday AS smallint) AS sunday
        ,cast(m.start_date AS date) AS start_date
        ,cast(m.end_date AS date) AS end_date
    FROM _import.gtfs_tl_calendar AS m
    CROSS JOIN _import.gtfs_tl_feeds AS b;

    -- levels data
    INSERT INTO gtfs.tl_levels
    SELECT DISTINCT 
        cast(b.id AS integer) AS feed_id
        ,m.level_id
        ,cast(m.level_index AS real) AS level_index
        ,m.level_name
    FROM _import.gtfs_tl_levels AS m
    CROSS JOIN _import.gtfs_tl_feeds AS b;

    -- areas data
    INSERT INTO gtfs.tl_areas
    SELECT DISTINCT 
        cast(b.id AS integer) AS feed_id
        ,m.area_id
        ,m.area_name
    FROM _import.gtfs_tl_areas AS m
    CROSS JOIN _import.gtfs_tl_feeds AS b;

    -- stops data
    INSERT INTO gtfs.tl_stops
    SELECT DISTINCT 
        cast(b.id AS integer) AS feed_id
        ,m.stop_id
        ,m.stop_code
        ,m.stop_name
        ,m.tts_stop_name
        ,m.stop_desc
        ,cast(m.stop_lat AS real) AS stop_lat
        ,cast(m.stop_lon AS real) AS stop_lon
        ,util.f_get_location_from_text_coords(m.stop_lon, m.stop_lat) AS stop_location
        ,m.zone_id
        ,m.stop_url
        ,CASE WHEN m.location_type = 'nan' THEN -1
              WHEN m.location_type IS NULL THEN 0
              ELSE cast(m.location_type AS smallint)
            END AS location_type
        ,m.parent_station
        ,m.stop_timezone
        ,CASE WHEN m.wheelchair_boarding = 'nan' THEN -1
              WHEN m.wheelchair_boarding IS NULL THEN 0
              ELSE cast(m.wheelchair_boarding AS smallint)
            END AS wheelchair_boarding
        ,m.level_id
        ,m.platform_code
    FROM _import.gtfs_tl_stops AS m
    CROSS JOIN _import.gtfs_tl_feeds AS b;

    -- routes data
    INSERT INTO gtfs.tl_routes
    SELECT DISTINCT 
        cast(b.id AS integer) AS feed_id
        ,m.route_id
        ,m.agency_id
        ,m.route_short_name
        ,m.route_long_name
        ,m.route_desc
        ,cast(m.route_type AS smallint) AS route_type
        ,m.route_url
        ,m.route_color
        ,m.route_text_color
        ,cast(m.route_sort_order AS integer) AS route_sort_order
        ,CASE WHEN m.continuous_pickup = 'nan' THEN -1
              WHEN m.continuous_pickup IS NULL THEN 1
              ELSE cast(m.continuous_pickup AS smallint)
            END AS continuous_pickup
        ,CASE WHEN m.continuous_drop_off = 'nan' THEN -1
              WHEN m.continuous_drop_off IS NULL THEN 1
              ELSE cast(m.continuous_drop_off AS smallint)
            END AS continuous_drop_off
        ,m.network_id
    FROM _import.gtfs_tl_routes AS m
    CROSS JOIN _import.gtfs_tl_feeds AS b;

    -- calendar dates data
    INSERT INTO gtfs.tl_calendar_dates
    SELECT DISTINCT 
        cast(b.id AS integer) AS feed_id
        ,m.service_id
        ,cast(m.date AS date) AS "date"
        ,cast(m.exception_type AS smallint) AS exception_type
    FROM _import.gtfs_tl_calendar_dates AS m
    CROSS JOIN _import.gtfs_tl_feeds AS b;

    -- fare attributes data
    INSERT INTO gtfs.tl_fare_attributes
    SELECT DISTINCT 
        cast(b.id AS integer) AS feed_id
        ,m.fare_id
        ,cast(m.price AS numeric(7,2)) AS price
        ,m.currency_type
        ,cast(m.payment_method AS smallint) AS payment_method
        ,CASE WHEN m.transfers IS NULL THEN 99
              WHEN m.transfers = 'nan' THEN -1
              ELSE cast(m.transfers AS smallint) 
            END AS transfers
        ,m.agency_id
        ,cast(m.transfer_duration AS integer) AS transfer_duration
    FROM _import.gtfs_tl_fare_attributes AS m
    CROSS JOIN _import.gtfs_tl_feeds AS b;

    -- fare rules data
    INSERT INTO gtfs.tl_fare_rules
    SELECT DISTINCT 
        cast(b.id AS integer) AS feed_id
        ,m.fare_id
        ,m.route_id
        ,m.origin_id
        ,m.destination_id
        ,m.contains_id
    FROM _import.gtfs_tl_fare_rules AS m
    CROSS JOIN _import.gtfs_tl_feeds AS b;

    -- trips data
    INSERT INTO gtfs.tl_trips
    SELECT DISTINCT 
        cast(b.id AS integer) AS feed_id
        ,m.route_id
        ,m.service_id
        ,m.trip_id
        ,m.trip_headsign
        ,m.trip_short_name
        ,CASE WHEN m.direction_id = 'nan' THEN -1
              ELSE cast(m.direction_id AS smallint)
            END AS direction_id
        ,m.block_id
        ,m.shape_id
        ,CASE WHEN m.wheelchair_accessible IS NULL THEN 0 
              WHEN m.wheelchair_accessible = 'nan' THEN -1
              ELSE cast(m.wheelchair_accessible AS smallint) 
            END AS wheelchair_accessible
        ,CASE WHEN m.bikes_allowed IS NULL THEN 0 
              WHEN m.bikes_allowed = 'nan' THEN -1
              ELSE cast(m.bikes_allowed AS smallint) 
            END AS bikes_allowed
    FROM _import.gtfs_tl_trips AS m
    CROSS JOIN _import.gtfs_tl_feeds AS b;

    -- stop times data
    INSERT INTO gtfs.tl_stop_times
    SELECT DISTINCT 
        cast(b.id AS integer) AS feed_id
        ,m.trip_id
        ,cast(m.arrival_time AS interval) AS arrival_time
        ,cast(m.departure_time AS interval) AS departure_time
        ,m.stop_id
        ,cast(m.stop_sequence AS integer) AS stop_sequence
        ,m.stop_headsign
        ,CASE WHEN m.pickup_type IS NULL THEN 0 
              WHEN m.pickup_type = 'nan' THEN -1
              ELSE cast(m.pickup_type AS smallint) 
            END AS pickup_type
        ,CASE WHEN m.drop_off_type IS NULL THEN 0 
              WHEN m.drop_off_type = 'nan' THEN -1
              ELSE cast(m.drop_off_type AS smallint) 
            END AS drop_off_type
        ,CASE WHEN m.continuous_pickup IS NULL THEN 1 
              WHEN m.continuous_pickup = 'nan' THEN -1
              WHEN cp.continuous_pickup IS NULL THEN -2
              ELSE cast(m.continuous_pickup AS smallint) 
            END AS continuous_pickup
        ,CASE WHEN m.continuous_drop_off IS NULL THEN 1 
              WHEN m.continuous_drop_off = 'nan' THEN -1
              WHEN cd.continuous_drop_off IS NULL THEN -2
              ELSE cast(m.continuous_drop_off AS smallint) 
            END AS continuous_drop_off
        ,cast(m.shape_dist_traveled AS real) AS shape_dist_traveled
        ,CASE WHEN m.timepoint IS NULL THEN 1 
              WHEN m.timepoint = 'nan' THEN -1
              ELSE cast(m.timepoint AS smallint) 
            END AS timepoint
    FROM _import.gtfs_tl_stop_times AS m
    CROSS JOIN _import.gtfs_tl_feeds AS b
    LEFT JOIN gtfs.e_continuous_pickup cp ON cp.continuous_pickup = cast(m.continuous_pickup AS smallint)
    LEFT JOIN gtfs.e_continuous_drop_off cd ON cd.continuous_drop_off = cast(m.continuous_drop_off AS smallint);

    -- timeframes data
    INSERT INTO gtfs.tl_timeframes
    SELECT DISTINCT 
        cast(b.id AS integer) AS feed_id
        ,m.timeframe_group_id
        ,cast(m.start_time AS time) AS start_time
        ,cast(m.end_time AS time) AS end_time
        ,m.service_id
    FROM _import.gtfs_tl_timeframes AS m
    CROSS JOIN _import.gtfs_tl_feeds AS b;

    -- fare products data
    INSERT INTO gtfs.tl_fare_products
    SELECT DISTINCT 
        cast(b.id AS integer) AS feed_id
        ,m.fare_product_id
        ,m.fare_product_name
        ,m.fare_media_id
        ,cast(m.amount AS numeric(7,2)) AS amount
        ,m.currency
    FROM _import.gtfs_tl_fare_products AS m
    CROSS JOIN _import.gtfs_tl_feeds AS b;

    -- fare leg rules data
    INSERT INTO gtfs.tl_fare_leg_rules
    SELECT DISTINCT 
        cast(b.id AS integer) AS feed_id
        ,m.leg_group_id
        ,m.network_id
        ,m.from_area_id
        ,m.to_area_id
        ,m.from_timeframe_group_id
        ,m.to_timeframe_group_id
        ,m.fare_product_id
    FROM _import.gtfs_tl_fare_leg_rules AS m
    CROSS JOIN _import.gtfs_tl_feeds AS b;

    -- fare transfer rules data
    INSERT INTO gtfs.tl_fare_transfer_rules
    SELECT DISTINCT 
        cast(b.id AS integer) AS feed_id
        ,m.from_leg_group_id
        ,m.to_leg_group_id
        ,cast(m.transfer_count AS integer) AS transfer_count
        ,cast(m.duration_limit AS integer) AS duration_limit
        ,cast(m.duration_limit_type AS smallint) AS duration_limit_type
        ,cast(m.fare_transfer_type AS smallint) AS fare_transfer_type
        ,m.fare_product_id
    FROM _import.gtfs_tl_fare_transfer_rules AS m
    CROSS JOIN _import.gtfs_tl_feeds AS b;

    -- stop areas data
    INSERT INTO gtfs.tl_stop_areas
    SELECT DISTINCT 
        cast(b.id AS integer) AS feed_id
        ,m.area_id
        ,m.stop_id
    FROM _import.gtfs_tl_stop_areas AS m
    CROSS JOIN _import.gtfs_tl_feeds AS b;

    -- route networks data
    INSERT INTO gtfs.tl_route_networks
    SELECT DISTINCT 
        cast(b.id AS integer) AS feed_id
        ,m.network_id
        ,m.route_id
    FROM _import.gtfs_tl_route_networks AS m
    CROSS JOIN _import.gtfs_tl_feeds AS b;

    -- frequencies data
    INSERT INTO gtfs.tl_frequencies
    SELECT DISTINCT 
        cast(b.id AS integer) AS feed_id
        ,m.trip_id
        ,cast(m.start_time AS interval) AS start_time
        ,cast(m.end_time AS interval) AS end_time
        ,cast(m.headway_secs AS integer) AS headway_secs
        ,coalesce(cast(m.exact_times AS smallint),0)  AS exact_times
    FROM _import.gtfs_tl_frequencies AS m
    CROSS JOIN _import.gtfs_tl_feeds AS b;

    -- transfers data
    INSERT INTO gtfs.tl_transfers
    SELECT DISTINCT 
        cast(b.id AS integer) AS feed_id
        ,m.from_stop_id
        ,m.to_stop_id
        ,m.from_route_id
        ,m.to_route_id
        ,m.from_trip_id
        ,m.to_trip_id
        ,CASE WHEN m.transfer_type IS NULL THEN 0
              ELSE cast(m.transfer_type AS smallint)
            END AS transfer_type
        ,cast(m.min_transfer_time AS integer) AS min_transfer_time
    FROM _import.gtfs_tl_transfers AS m
    CROSS JOIN _import.gtfs_tl_feeds AS b;

    -- pathways data
    INSERT INTO gtfs.tl_pathways
    SELECT DISTINCT 
        cast(b.id AS integer) AS feed_id
        ,m.pathway_id
        ,m.from_stop_id
        ,m.to_stop_id
        ,cast(m.pathway_mode AS smallint) AS pathway_mode
        ,cast(m.is_bidirectional AS smallint) AS is_bidirectional
        ,cast(m.length AS real) AS "length"
        ,cast(m.traversal_time AS integer) AS traversal_time
        ,cast(m.stair_count AS integer) AS stair_count
        ,cast(m.max_slope AS real) AS max_slope
        ,cast(m.min_width AS real) AS min_width
        ,m.signposted_as
        ,m.reversed_signposted_as
    FROM _import.gtfs_tl_pathways AS m
    CROSS JOIN _import.gtfs_tl_feeds AS b;

    -- attributions data
    INSERT INTO gtfs.tl_attributions
    SELECT DISTINCT 
        cast(b.id AS integer) AS feed_id
        ,m.attribution_id
        ,m.agency_id
        ,m.route_id
        ,m.trip_id
        ,m.organization_name
        ,coalesce(cast(m.is_producer AS smallint),0) AS is_producer
        ,coalesce(cast(m.is_operator AS smallint),0) AS is_operator
        ,coalesce(cast(m.is_authority AS smallint),0) AS is_authority
        ,m.attribution_url
        ,m.attribution_email
        ,m.attribution_phone
    FROM _import.gtfs_tl_attributions AS m
    CROSS JOIN _import.gtfs_tl_feeds AS b;

    -- TODO update gtfs process state to latest fetched_at timestamp in feeds
    --SELECT _log.f_update_process_state(_proc, (SELECT asof_dtm_utc INTO _asof FROM orca.m_latest_file_upload));

    -- truncate import tables after completion
    CALL gtfs.p_truncate_import_gtfs_tables();

END $$;
