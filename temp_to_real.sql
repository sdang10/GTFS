-- PROCEDURES TO MOVE DATA FROM TEMP TABLES TO OFFICIAL ONES

CREATE OR REPLACE PROCEDURE _import.to_gtfs_tl_feeds_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs.transitland_feeds (
          feed_id
        , agency_id
        , fetched_at
        , earliest_calendar_date
        , latest_calendar_date
        , sha1
        , url
    )
    SELECT DISTINCT 
          CAST(id AS INT)
        , CAST(agency_id AS SMALLINT)
        , CAST(fetched_at AS TIMESTAMP)
        , CAST(earliest_calendar_date AS DATE)
        , CAST(latest_calendar_date AS DATE)
        , sha1
        , url
    FROM _import.gtfs_transitland_feeds;

END;
$$;
-- CALL _import.to_gtfs_tl_feeds_table()

--CREATE OR REPLACE PROCEDURE _import.to_gtfs_tl_extra_attributes_table()
--LANGUAGE plpgsql
--AS $$
--BEGIN
--
--    INSERT INTO gtfs.real_gtfs_extra_attributes (
--        feed_id, 
--        file_name,
--        column_name,
--        value
--    )
--    SELECT DISTINCT 
--        CAST(feed_id AS INT), 
--        file_name, 
--        column_name,
--        value
--    FROM _import.gtfs_extra_attributes;
--
--END;
--$$;
-- CALL _import.to_gtfs_tl_extra_attributes_table()

CREATE OR REPLACE PROCEDURE _import.to_gtfs_tl_bad_feeds_table()
LANGUAGE plpgsql
AS $$
BEGIN 
    
    INSERT INTO gtfs.tl_bad_feeds (
        feed_id
    )
    SELECT DISTINCT 
        CAST(feed_id AS INT)
    FROM _import.gtfs_tl_bad_feeds;
    
END;
$$;
-- CALL _import.to_gtfs_tl_bad_feeds_table()

CREATE OR REPLACE PROCEDURE _import.to_gtfs_tl_extra_files_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs.tl_extra_files (
          feed_id
        , file_name
    )
    SELECT DISTINCT 
         CAST(feed_id AS INT)
        , file_name
    FROM _import.gtfs_tl_extra_files;

END;
$$;
-- CALL _import.to_gtfs_tl_extra_files_table()

CREATE OR REPLACE PROCEDURE _import.to_gtfs_tl_agency_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs.tl_agency (
          feed_id
        , agency_id
        , agency_name
        , agency_url
        , agency_timezone
        , agency_lang
        , agency_phone
        , agency_fare_url
        , agency_email
    )
    SELECT DISTINCT 
          CAST(b.id AS INT)
        , m.agency_id
        , m.agency_name
        , m.agency_url
        , m.agency_timezone
        , m.agency_lang
        , m.agency_phone
        , m.agency_fare_url
        , m.agency_email
    FROM _import.gtfs_tl_agency AS m
    CROSS JOIN _import.gtfs_transitland_feeds AS b;

END;
$$;
-- CALL _import.to_gtfs_tl_agency_table()

CREATE OR REPLACE PROCEDURE _import.to_gtfs_tl_feed_info_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs.tl_feed_info (
          feed_id
        , feed_publisher_name
        , feed_publisher_url
        , feed_lang
        , default_lang
        , feed_start_date
        , feed_end_date
        , feed_version
        , feed_contact_email
        , feed_contact_url
    )
    SELECT DISTINCT 
          CAST(b.id AS INT)
        , m.feed_publisher_name
        , m.feed_publisher_url
        , m.feed_lang
        , m.default_lang
        , CASE
            WHEN m.feed_start_date = 'nan' 
                THEN NULL
            WHEN m.feed_start_date LIKE '%.0' 
                THEN CAST(SUBSTRING(m.feed_start_date, 1, LENGTH(m.feed_start_date) - 2) AS DATE)
            ELSE CAST(m.feed_start_date AS DATE)
          END
        , CASE
            WHEN m.feed_end_date = 'nan' 
                THEN NULL
            WHEN m.feed_end_date LIKE '%.0' 
                THEN CAST(SUBSTRING(m.feed_end_date, 1, LENGTH(m.feed_end_date) - 2) AS DATE)
            ELSE CAST(m.feed_end_date AS DATE)
          END
        , m.feed_version
        , m.feed_contact_email
        , m.feed_contact_url
    FROM _import.gtfs_tl_feed_info AS m, _import.gtfs_transitland_feeds AS b;

END;
$$;
-- CALL _import.to_gtfs_tl_feed_info_table()

CREATE OR REPLACE PROCEDURE _import.to_gtfs_tl_translations_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs.tl_translations (
          feed_id
        , table_name 
        , field_name
        , language
        , TRANSLATION
        , record_id
        , record_sub_id
        , field_value
    )
    SELECT DISTINCT 
          CAST(b.id AS INT)
        , m.table_name
        , m.field_name
        , m.language
        , m.TRANSLATION
        , m.record_id
        , m.record_sub_id
        , m.field_value
    FROM _import.gtfs_tl_translations AS m, _import.gtfs_transitland_feeds AS b;

END;
$$;
-- CALL _import.to_gtfs_tl_translations_table()

CREATE OR REPLACE PROCEDURE _import.to_gtfs_tl_networks_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs.tl_networks (
          feed_id
        , network_id
        , network_name
    )
    SELECT DISTINCT 
          CAST(b.id AS INT)
        , m.network_id,
        , m.network_name
    FROM _import.gtfs_tl_networks AS m, _import.gtfs_transitland_feeds AS b;

END;
$$;
-- CALL _import.to_gtfs_tl_networks_table()

CREATE OR REPLACE PROCEDURE _import.to_gtfs_tl_fare_media_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs.tl_fare_media (
          feed_id
        , fare_media_id
        , fare_media_name
        , fare_media_type
    )
    SELECT DISTINCT 
          CAST(b.id AS INT)
        , m.fare_media_id
        , m.fare_media_name
        , CAST(m.fare_media_type AS SMALLINT)
    FROM _import.gtfs_tl_fare_media AS m, _import.gtfs_transitland_feeds AS b;

END;
$$;
-- CALL _import.to_gtfs_tl_fare_media_table()

CREATE OR REPLACE PROCEDURE _import.to_gtfs_tl_shapes_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs.tl_shapes (
          feed_id
        , shape_id
        , shape_pt_lat
        , shape_pt_lon
        , shape_pt_location
        , shape_pt_sequence
        , shape_dist_traveled
    )
    SELECT DISTINCT 
          CAST(b.id AS INT)
        , m.shape_id TEXT
        , m.shape_pt_lat TEXT
        , m.shape_pt_lon TEXT
        , public.ST_Transform(public.ST_SetSRID(public.ST_MakePoint(m.shape_pt_lon::numeric(9,6), m.shape_pt_lat::numeric(8,6)), 4326), 32610)
        , CASE
            WHEN m.shape_pt_sequence LIKE '%.0' 
                THEN CAST(SUBSTRING(m.shape_pt_sequence, 1, LENGTH(m.shape_pt_sequence) - 2) AS INT)
            ELSE CAST(m.shape_pt_sequence AS INT)
          END
        , CAST(m.shape_dist_traveled AS FLOAT)
    FROM _import.gtfs_tl_shapes AS m, _import.gtfs_transitland_feeds AS b;

END;
$$;
-- CALL _import.to_gtfs_tl_shapes_table()

CREATE OR REPLACE PROCEDURE _import.to_gtfs_tl_calendar_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs.tl_calendar (
          feed_id
        , service_id
        , monday
        , tuesday
        , wednesday
        , thursday
        , friday
        , saturday
        , sunday
        , start_date
        , end_date
    )
    SELECT DISTINCT 
          CAST(b.id AS INT)
        , m.service_id
        , CAST(m.monday AS SMALLINT)
        , CAST(m.tuesday AS SMALLINT)
        , CAST(m.wednesday AS SMALLINT)
        , CAST(m.thursday AS SMALLINT)
        , CAST(m.friday AS SMALLINT)
        , CAST(m.saturday AS SMALLINT)
        , CAST(m.sunday AS SMALLINT)
        , CAST(m.start_date AS DATE)
        , CAST(m.end_date AS DATE)
    FROM _import.gtfs_tl_calendar AS m, _import.gtfs_transitland_feeds AS b;

END;
$$;
-- CALL _import.to_gtfs_tl_calendar_table()

CREATE OR REPLACE PROCEDURE _import.to_gtfs_tl_levels_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs.tl_levels (
          feed_id
        , level_id
        , level_index
        , level_name
    )
    SELECT DISTINCT 
          CAST(b.id AS INT)
        , m.level_id
        , CAST(m.level_index AS FLOAT)
        , m.level_name
    FROM _import.gtfs_tl_levels AS m, _import.gtfs_transitland_feeds AS b;

END;
$$;
-- CALL _import.to_gtfs_tl_levels_table()

CREATE OR REPLACE PROCEDURE _import.to_gtfs_tl_areas_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs.tl_areas (
          feed_id
        , area_id
        , area_name
    )
    SELECT DISTINCT 
          CAST(b.id AS INT)
        , m.area_id TEXT
        , m.area_name TEXT
    FROM _import.gtfs_tl_areas AS m, _import.gtfs_transitland_feeds AS b;

END;
$$;
-- CALL _import.to_gtfs_tl_areas_table()

CREATE OR REPLACE PROCEDURE _import.to_gtfs_tl_stops_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs.tl_stops (
          feed_id
        , stop_id
        , stop_code
        , stop_name
        , tts_stop_name
        , stop_desc
        , stop_lat
        , stop_lon
        , stop_location
        , zone_id
        , stop_url
        , location_type
        , parent_station
        , stop_timezone
        , wheelchair_boarding
        , level_id
        , platform_code
    )
    SELECT DISTINCT 
          CAST(b.id AS INT)
        , m.stop_id
        , m.stop_code
        , m.stop_name
        , m.tts_stop_name
        , m.stop_desc
        , m.stop_lat
        , m.stop_lon
        , public.ST_Transform(public.ST_SetSRID(public.ST_MakePoint(m.stop_lon::numeric(9,6), m.stop_lat::numeric(8,6)), 4326), 32610)
        , m.zone_id
        , m.stop_url
        , CASE 
            WHEN m.location_type = 'nan'
                THEN -1
            WHEN m.location_type IS NULL 
                THEN 0 
            WHEN m.location_type LIKE '%.0' 
                THEN CAST(SUBSTRING(m.location_type, 1, LENGTH(m.location_type) - 2) AS SMALLINT)
            ELSE CAST(m.location_type AS SMALLINT) 
          END
        , m.parent_station
        , m.stop_timezone
        , CASE 
            WHEN m.wheelchair_boarding = 'nan'
                THEN -1
            WHEN m.wheelchair_boarding IS NULL
                THEN 0 
            WHEN m.wheelchair_boarding LIKE '%.0' 
                THEN CAST(SUBSTRING(m.wheelchair_boarding, 1, LENGTH(m.wheelchair_boarding) - 2) AS SMALLINT)
            ELSE CAST(m.wheelchair_boarding AS SMALLINT) 
          END
        , m.level_id
        , m.platform_code
    FROM _import.gtfs_tl_stops AS m, _import.gtfs_transitland_feeds AS b;

END;
$$;
-- CALL _import.to_gtfs_tl_stops_table()

CREATE OR REPLACE PROCEDURE _import.to_gtfs_tl_routes_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs.tl_routes (
          feed_id
        , route_id
        , agency_id
        , route_short_name 
        , route_long_name
        , route_desc
        , route_type
        , route_url
        , route_color
        , route_text_color
        , route_sort_order
        , continuous_pickup
        , continuous_drop_off
        , network_id
    )
    SELECT DISTINCT 
          CAST(b.id AS INT)
        , m.route_id
        , m.agency_id
        , m.route_short_name
        , m.route_long_name
        , m.route_desc
        , CAST(m.route_type AS SMALLINT)
        , m.route_url
        , m.route_color
        , m.route_text_color
        , CAST(m.route_sort_order AS INT)
        , CASE 
            WHEN m.continuous_pickup = 'nan'
                THEN -1
            WHEN m.continuous_pickup IS NULL
                THEN 1 
            ELSE CAST(m.continuous_pickup AS SMALLINT) 
          END
        , CASE 
            WHEN m.continuous_drop_off = 'nan'
                THEN -1
            WHEN m.continuous_drop_off IS NULL
                THEN 1 
            ELSE CAST(m.continuous_drop_off AS SMALLINT) 
          END
        , m.network_id
    FROM _import.gtfs_tl_routes AS m, _import.gtfs_transitland_feeds AS b;

END;
$$;
-- CALL _import.to_gtfs_tl_routes_table()

CREATE OR REPLACE PROCEDURE _import.to_gtfs_tl_calendar_dates_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs.tl_calendar_dates (
          feed_id
        , service_id
        , date
        , exception_type
    )
    SELECT DISTINCT 
          CAST(b.id AS INT)
        , m.service_id
        , CAST(m.date AS DATE)
        , CAST(m.exception_type AS SMALLINT)
    FROM _import.gtfs_tl_calendar_dates AS m, _import.gtfs_transitland_feeds AS b;

END;
$$;
-- CALL _import.to_gtfs_tl_calendar_dates_table()

CREATE OR REPLACE PROCEDURE _import.to_gtfs_tl_fare_attributes_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs.tl_fare_attributes (
          feed_id
        , fare_id
        , price
        , currency_type
        , payment_method
        , transfers
        , agency_id
        , transfer_duration
    )
    SELECT DISTINCT 
          CAST(b.id AS INT)
        , m.fare_id
        , m.price
        , m.currency_type
        , CAST(m.payment_method AS SMALLINT)
        , CASE 
            WHEN m.transfers IS NULL
                THEN 99
            WHEN m.transfers = 'nan'
                THEN -1
            WHEN m.transfers LIKE '%.0'
                THEN CAST(SUBSTRING(m.transfers, 1, LENGTH(m.transfers) - 2) AS SMALLINT)
            ELSE CAST(m.transfers AS SMALLINT) 
          END
        , m.agency_id
        , CASE
            WHEN m.transfer_duration LIKE '%.0'
                THEN CAST(SUBSTRING(m.transfer_duration, 1, LENGTH(m.transfer_duration) - 2) AS INT)
            ELSE CAST(m.transfer_duration AS INT)
          END
    FROM _import.gtfs_tl_fare_attributes AS m, _import.gtfs_transitland_feeds AS b;

END;
$$;
-- CALL _import.to_gtfs_tl_fare_attributes_table()

CREATE OR REPLACE PROCEDURE _import.to_gtfs_tl_fare_rules_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs.tl_fare_rules (
          feed_id
        , fare_id
        , route_id
        , origin_id
        , destination_id
        , contains_id
    )
    SELECT DISTINCT 
          CAST(b.id AS INT)
        , m.fare_id
        , m.route_id
        , m.origin_id
        , m.destination_id
        , m.contains_id
    FROM _import.gtfs_tl_fare_rules AS m, _import.gtfs_transitland_feeds AS b;

END;
$$;
-- CALL _import.to_gtfs_tl_fare_rules_table()

CREATE OR REPLACE PROCEDURE _import.to_gtfs_tl_trips_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs.tl_trips (
          feed_id
        , route_id
        , service_id
        , trip_id
        , trip_headsign
        , trip_short_name
        , direction_id
        , block_id
        , shape_id
        , wheelchair_accessible
        , bikes_allowed
    )
    SELECT DISTINCT 
          CAST(b.id AS INT)
        , m.route_id
        , m.service_id
        , m.trip_id
        , m.trip_headsign
        , m.trip_short_name
        , CASE 
            WHEN m.direction_id = 'nan'
                THEN -1
            WHEN m.direction_id LIKE '%.0'
                THEN CAST(SUBSTRING(m.direction_id, 1, LENGTH(m.direction_id) - 2) AS SMALLINT)
            ELSE CAST(m.direction_id AS SMALLINT)
          END
        , m.block_id
        , m.shape_id
        , CASE 
            WHEN m.wheelchair_accessible IS NULL
                THEN 0 
            WHEN m.wheelchair_accessible = 'nan'
                THEN -1
            WHEN m.wheelchair_accessible LIKE '%.0'
                THEN CAST(SUBSTRING(m.wheelchair_accessible, 1, LENGTH(m.wheelchair_accessible) - 2) AS SMALLINT)
            ELSE CAST(m.wheelchair_accessible AS SMALLINT) 
          END
        , CASE 
            WHEN m.bikes_allowed IS NULL
                THEN 0 
            WHEN m.bikes_allowed = 'nan'
                THEN -1
            WHEN m.bikes_allowed LIKE '%.0'
                THEN CAST(SUBSTRING(m.bikes_allowed, 1, LENGTH(m.bikes_allowed) - 2) AS SMALLINT)
            ELSE CAST(m.bikes_allowed AS SMALLINT) 
          END
    FROM _import.gtfs_tl_trips AS m, _import.gtfs_transitland_feeds AS b;

END;
$$;
-- CALL _import.to_gtfs_tl_trips_table()

CREATE OR REPLACE PROCEDURE _import.to_gtfs_tl_stop_times_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs.tl_stop_times (
          feed_id
        , trip_id
        , arrival_time
        , departure_time
        , stop_id
        , stop_sequence
        , stop_headsign
        , pickup_type
        , drop_off_type
        , continuous_pickup
        , continuous_drop_off
        , shape_dist_traveled
        , timepoint
    )
    SELECT DISTINCT 
        , CAST(b.id AS INT)
        , m.trip_id
        , CAST(m.arrival_time AS INTERVAL)
        , CAST(m.departure_time AS INTERVAL)
        , m.stop_id
        , CAST(m.stop_sequence AS INT)
        , m.stop_headsign
        , CASE 
            WHEN m.pickup_type IS NULL
                THEN 0 
            WHEN m.pickup_type = 'nan'
                THEN -1
            WHEN m.pickup_type LIKE '%.0'
                THEN CAST(SUBSTRING(m.pickup_type, 1, LENGTH(m.pickup_type) - 2) AS SMALLINT)
            ELSE CAST(m.pickup_type AS SMALLINT) 
          END
        , CASE 
            WHEN m.drop_off_type IS NULL
                THEN 0 
            WHEN m.drop_off_type = 'nan'
                THEN -1
            WHEN m.drop_off_type LIKE '%.0'
                THEN CAST(SUBSTRING(m.drop_off_type, 1, LENGTH(m.drop_off_type) - 2) AS SMALLINT)
            ELSE CAST(m.drop_off_type AS SMALLINT) 
          END
        , CASE 
            WHEN m.continuous_pickup IS NULL
                THEN 1 
            WHEN m.continuous_pickup = 'nan'
                THEN -1
            WHEN m.continuous_pickup LIKE '%.0'
                THEN CAST(SUBSTRING(m.continuous_pickup, 1, LENGTH(m.continuous_pickup) - 2) AS SMALLINT)
            WHEN NOT EXISTS (
                SELECT 1
                FROM gtfs.e_continuous_pickup AS l
                WHERE l.continuous_pickup = CAST(m.continuous_pickup AS SMALLINT)
            )
                THEN -2
            ELSE CAST(m.continuous_pickup AS SMALLINT) 
          END
        , CASE 
            WHEN m.continuous_drop_off IS NULL
                THEN 1 
            WHEN m.continuous_drop_off = 'nan'
                THEN -1
            WHEN m.continuous_drop_off LIKE '%.0'
                THEN CAST(SUBSTRING(m.continuous_drop_off, 1, LENGTH(m.continuous_drop_off) - 2) AS SMALLINT)
            WHEN NOT EXISTS (
                SELECT 1
                FROM gtfs.e_continuous_drop_off AS l
                WHERE l.continuous_drop_off = CAST(m.continuous_drop_off AS SMALLINT)
            )
                THEN -2
            ELSE CAST(m.continuous_drop_off AS SMALLINT) 
          END
        , CAST(m.shape_dist_traveled AS FLOAT)
        , CASE 
            WHEN m.timepoint IS NULL
                THEN 1 
            WHEN m.timepoint = 'nan'
                THEN -1
            WHEN m.timepoint LIKE '%.0'
                THEN CAST(SUBSTRING(m.timepoint, 1, LENGTH(m.timepoint) - 2) AS SMALLINT)
            ELSE CAST(m.timepoint AS SMALLINT) 
          END
    FROM _import.gtfs_tl_stop_times AS m, _import.gtfs_transitland_feeds AS b;

END;
$$;
-- CALL _import.to_gtfs_tl_stop_times_table()

CREATE OR REPLACE PROCEDURE _import.to_gtfs_tl_transfers_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs.tl_transfers (
          feed_id
        , from_stop_id
        , to_stop_id
        , from_route_id
        , to_route_id
        , from_trip_id
        , to_trip_id
        , transfer_type
        , min_transfer_time
    )
    SELECT DISTINCT 
          CAST(b.id AS INT)
        , m.from_stop_id
        , m.to_stop_id
        , m.from_route_id
        , m.to_route_id
        , m.from_trip_id
        , m.to_trip_id
        , CASE 
            WHEN m.transfer_type IS NULL
                THEN 0 
            ELSE CAST(m.transfer_type AS SMALLINT) 
          END
        , CAST(m.min_transfer_time AS INT)
    FROM _import.gtfs_tl_transfers AS m, _import.gtfs_transitland_feeds AS b;

END;
$$;
-- CALL _import.to_gtfs_tl_transfers_table()

CREATE OR REPLACE PROCEDURE _import.to_gtfs_tl_timeframes_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs.tl_timeframes (
          feed_id
        , timeframe_group_id
        , start_time
        , end_time
        , service_id
    )
    SELECT DISTINCT 
          CAST(b.id AS INT)
        , m.timeframe_group_id
        , CAST(m.start_time AS TIME)
        , CAST(m.end_time AS TIME)
        , m.service_id
    FROM _import.gtfs_tl_timeframes AS m, _import.gtfs_transitland_feeds AS b;

END;
$$;
-- CALL _import.to_gtfs_tl_timeframes_table()

CREATE OR REPLACE PROCEDURE _import.to_gtfs_tl_fare_products_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs.tl_fare_products (
          feed_id
        , fare_product_id
        , fare_product_name
        , fare_media_id
        , amount
        , currency
    )
    SELECT DISTINCT 
          CAST(b.id AS INT)
        , m.fare_product_id
        , m.fare_product_name
        , m.fare_media_id
        , CAST(m.amount AS NUMERIC(7,2))
        , m.currency
    FROM _import.gtfs_tl_fare_products AS m, _import.gtfs_transitland_feeds AS b;

END;
$$;
-- CALL _import.to_gtfs_tl_fare_products_table()

CREATE OR REPLACE PROCEDURE _import.to_gtfs_tl_fare_leg_rules_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs.tl_fare_leg_rules (
          feed_id
        , leg_group_id
        , network_id
        , from_area_id
        , to_area_id
        , from_timeframe_group_id
        , to_timeframe_group_id
        , fare_product_id
    )
    SELECT DISTINCT 
          CAST(b.id AS INT)
        , m.leg_group_id
        , m.network_id
        , m.from_area_id
        , m.to_area_id
        , m.from_timeframe_group_id
        , m.to_timeframe_group_id
        , m.fare_product_id
    FROM _import.gtfs_tl_fare_leg_rules AS m, _import.gtfs_transitland_feeds AS b;

END;
$$;
-- CALL _import.to_gtfs_tl_fare_leg_rules_table()

CREATE OR REPLACE PROCEDURE _import.to_gtfs_tl_fare_transfer_rules_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs.tl_fare_transfer_rules (
          feed_id
        , from_leg_group_id
        , to_leg_group_id
        , transfer_count
        , duration_limit
        , duration_limit_type
        , fare_transfer_type
        , fare_product_id
    )
    SELECT DISTINCT 
          CAST(b.id AS INT)
        , m.from_leg_group_id
        , m.to_leg_group_id
        , CAST(m.transfer_count AS INT)
        , CAST(m.duration_limit AS INT)
        , CAST(m.duration_limit_type AS SMALLINT)
        , CAST(m.fare_transfer_type AS SMALLINT)
        , m.fare_product_id
    FROM _import.gtfs_tl_fare_transfer_rules AS m, _import.gtfs_transitland_feeds AS b;

END;
$$;
-- CALL _import.to_gtfs_tl_fare_transfer_rules_table()

CREATE OR REPLACE PROCEDURE _import.to_gtfs_tl_stop_areas_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs.tl_stop_areas (
          feed_id
        , area_id
        , stop_id
    )
    SELECT DISTINCT 
          CAST(b.id AS INT)
        , m.area_id
        , m.stop_id
    FROM _import.gtfs_tl_stop_areas AS m, _import.gtfs_transitland_feeds AS b;

END;
$$;
-- CALL _import.to_gtfs_tl_stop_areas_table()

CREATE OR REPLACE PROCEDURE _import.to_gtfs_tl_route_networks_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs.tl_route_networks (
          feed_id
        , network_id
        , route_id
    )
    SELECT DISTINCT 
          CAST(b.id AS INT)
        , m.network_id
        , m.route_id
    FROM _import.gtfs_tl_route_networks AS m, _import.gtfs_transitland_feeds AS b;

END;
$$;
-- CALL _import.to_gtfs_tl_route_networks_table()

CREATE OR REPLACE PROCEDURE _import.to_gtfs_tl_frequencies_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs.tl_frequencies (
          feed_id
        , trip_id
        , start_time
        , end_time
        , headway_secs
        , exact_times
    )
    SELECT DISTINCT 
          CAST(b.id AS INT)
        , m.trip_id
        , CAST(m.start_time AS INTERVAL)
        , CAST(m.end_time AS INTERVAL)
        , CAST(m.headway_secs AS INT)
        , CASE 
            WHEN m.exact_times IS NULL
                THEN 0 
            ELSE CAST(m.exact_times AS SMALLINT) 
          END
    FROM _import.gtfs_tl_frequencies AS m, _import.gtfs_transitland_feeds AS b;

END;
$$;
-- CALL _import.to_gtfs_tl_frequencies_table()

CREATE OR REPLACE PROCEDURE _import.to_gtfs_tl_pathways_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs.tl_pathways (
          feed_id
        , pathway_id
        , from_stop_id
        , to_stop_id
        , pathway_mode
        , is_bidirectional
        , length
        , traversal_time
        , stair_count
        , max_slope
        , min_width
        , signposted_as
        , reversed_signposted_as
    )
    SELECT DISTINCT 
          CAST(b.id AS INT)
        , m.pathway_id
        , m.from_stop_id
        , m.to_stop_id
        , CAST(m.pathway_mode AS SMALLINT)
        , CAST(m.is_bidirectional AS SMALLINT)
        , CAST(m.length AS FLOAT)
        , CAST(m.traversal_time AS INT)
        , CAST(m.stair_count AS INT)
        , CAST(m.max_slope AS FLOAT)
        , CAST(m.min_width AS FLOAT)
        , m.signposted_as
        , m.reversed_signposted_as
    FROM _import.gtfs_tl_pathways AS m, _import.gtfs_transitland_feeds AS b;

END;
$$;
-- CALL _import.to_gtfs_tl_pathways_table()

CREATE OR REPLACE PROCEDURE _import.to_gtfs_tl_attributions_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs.tl_attributions (
          feed_id
        , attribution_id
        , agency_id
        , route_id
        , trip_id
        , organization_name
        , is_producer
        , is_operator
        , is_authority
        , attribution_url
        , attribution_email
        , attribution_phone
    )
    SELECT DISTINCT 
          CAST(b.id AS INT)
        , m.attribution_id
        , m.agency_id
        , m.route_id
        , m.trip_id
        , m.organization_name
        , CASE 
            WHEN m.is_producer IS NULL
                THEN 0 
            ELSE CAST(m.is_producer AS SMALLINT) 
          END
        , CASE 
            WHEN m.is_operator IS NULL
                THEN 0 
            ELSE CAST(m.is_operator AS SMALLINT) 
          END
        , CASE 
            WHEN m.is_authority IS NULL
                THEN 0 
            ELSE CAST(m.is_authority AS SMALLINT) 
          END
        , m.attribution_url
        , m.attribution_email
        , m.attribution_phone
    FROM _import.gtfs_tl_attributions AS m, _import.gtfs_transitland_feeds AS b;

END;
$$;
-- CALL _import.to_gtfs_tl_attributions_table()

----------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE _import.to_gtfs_tl_tables()
LANGUAGE plpgsql
AS $$
BEGIN

    CALL _import.to_gtfs_tl_bad_feeds_table();
    CALL _import.to_gtfs_tl_feeds_table();
--    CALL _import.to_gtfs_tl_extra_attributes_table();
    CALL _import.to_gtfs_tl_extra_files_table();
    CALL _import.to_gtfs_tl_agency_table();
    CALL _import.to_gtfs_tl_feed_info_table();
    CALL _import.to_gtfs_tl_translations_table();
    CALL _import.to_gtfs_tl_networks_table();
    CALL _import.to_gtfs_tl_fare_media_table();
    CALL _import.to_gtfs_tl_shapes_table();
    CALL _import.to_gtfs_tl_calendar_table();
    CALL _import.to_gtfs_tl_levels_table();
    CALL _import.to_gtfs_tl_areas_table();
    CALL _import.to_gtfs_tl_stops_table();
    CALL _import.to_gtfs_tl_routes_table();
    CALL _import.to_gtfs_tl_calendar_dates_table();
    CALL _import.to_gtfs_tl_fare_attributes_table();
    CALL _import.to_gtfs_tl_fare_rules_table();
    CALL _import.to_gtfs_tl_trips_table();
    CALL _import.to_gtfs_tl_stop_times_table();
    CALL _import.to_gtfs_tl_timeframes_table();
    CALL _import.to_gtfs_tl_fare_products_table();
    CALL _import.to_gtfs_tl_fare_leg_rules_table();
    CALL _import.to_gtfs_tl_fare_transfer_rules_table();
    CALL _import.to_gtfs_tl_stop_areas_table();
    CALL _import.to_gtfs_tl_route_networks_table();
    CALL _import.to_gtfs_tl_frequencies_table();
    CALL _import.to_gtfs_tl_transfers_table();
    CALL _import.to_gtfs_tl_pathways_table();
    CALL _import.to_gtfs_tl_attributions_table();

END;
$$;

-- CALL _import.insert_into_real_tables()


CREATE OR REPLACE PROCEDURE _import.truncate_temp_tables()
LANGUAGE plpgsql AS $$
BEGIN 
    
    TRUNCATE TABLE _import.gtfs_tl_stop_times; 
    TRUNCATE TABLE _import.gtfs_tl_trips;
    TRUNCATE TABLE _import.gtfs_tl_shapes;
    TRUNCATE TABLE _import.gtfs_tl_calendar_dates;
    TRUNCATE TABLE _import.gtfs_tl_calendar;
    TRUNCATE TABLE _import.gtfs_tl_routes;
    TRUNCATE TABLE _import.gtfs_tl_stops;
    TRUNCATE TABLE _import.gtfs_tl_agency;
    TRUNCATE TABLE _import.gtfs_tl_feed_info;
    TRUNCATE TABLE _import.gtfs_tl_transfers;
    TRUNCATE TABLE _import.gtfs_tl_fare_attributes;
    TRUNCATE TABLE _import.gtfs_tl_fare_rules;
    TRUNCATE TABLE _import.gtfs_tl_frequencies;
    TRUNCATE TABLE _import.gtfs_tl_areas;
    TRUNCATE TABLE _import.gtfs_tl_timeframes;
    TRUNCATE TABLE _import.gtfs_tl_fare_media;
    TRUNCATE TABLE _import.gtfs_tl_fare_products;
    TRUNCATE TABLE _import.gtfs_tl_fare_leg_rules;
    TRUNCATE TABLE _import.gtfs_tl_fare_transfer_rules;
    TRUNCATE TABLE _import.gtfs_tl_stop_areas;
    TRUNCATE TABLE _import.gtfs_tl_networks;
    TRUNCATE TABLE _import.gtfs_tl_route_networks;
    TRUNCATE TABLE _import.gtfs_tl_pathways;
    TRUNCATE TABLE _import.gtfs_tl_levels;
    TRUNCATE TABLE _import.gtfs_tl_attributions;
    TRUNCATE TABLE _import.gtfs_tl_translations;
    TRUNCATE TABLE _import.gtfs_tl_extra_files;
    TRUNCATE TABLE _import.gtfs_tl_feeds;
    TRUNCATE TABLE _import.gtfs_tl_bad_feeds;
    
END; 
$$;

-- CALL _import.truncate_temp_tables()
