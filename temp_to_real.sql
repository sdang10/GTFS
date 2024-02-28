CREATE OR REPLACE PROCEDURE create_real_gtfs_files_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs_test.real_gtfs_files (
    	file_id, 
    	fetched_at, 
    	earliest_calandar_date,
    	latest_calendar_date,
    	sha1,
    	url
    )
    SELECT DISTINCT 
    	CAST(id AS INT),
    	fetched_at,
    	CAST(earliest_calandar_date AS DATE),
    	CAST(latest_calendar_date AS DATE),
    	sha1,
    	url
    FROM gtfs_test.gtfs_files;

END;
$$;

CALL create_gtfs_files_table()



CREATE OR REPLACE PROCEDURE create_real_gtfs_extra_attributes_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs_test.real_gtfs_extra_attributes (
    	file_id, 
    	file_name,
    	column_name,
    	value
    )
    SELECT DISTINCT 
    	CAST(file_id AS INT), 
    	file_name, 
    	column_name,
    	value
    FROM gtfs_test.gtfs_extra_attributes;

END;
$$;

CALL create_real_gtfs_extra_attributes_table()



CREATE OR REPLACE PROCEDURE create_real_gtfs_extra_files_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs_test.real_gtfs_extra_files (
    	file_id,
    	file_name
    )
    SELECT DISTINCT 
    	CAST(file_id AS INT),
    	file_name
    FROM gtfs_test.gtfs_extra_files

END;
$$;

CALL create__table()



CREATE OR REPLACE PROCEDURE create_real_agency_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs_test.real_transitland_agency (
    	file_id,
    	agency_id,
    	agency_name,
    	agency_url,
    	agency_timezone,
    	agency_lang,
    	agency_phone,
    	agency_fare_url,
    	agency_email
    )
    SELECT DISTINCT 
    	CAST(file_id AS INT),
    	agency_id,
    	agency_name,
    	agency_url,
    	agency_timezone,
    	agency_lang,
    	agency_phone,
    	agency_fare_url,
    	agency_email
    FROM gtfs_test.transitland_agency;

END;
$$;

CALL create_real_agency_table()



CREATE OR REPLACE PROCEDURE create_real_stops_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs_test.real_transitland_stops (
    	file_id,
		stop_id,
		stop_code,
		stop_name, 
		tts_stop_name,
		stop_desc,
		stop_lat, 
		stop_lon, 
		stop_location,
		zone_id,
		stop_url,
		location_type,
		parent_station,
		stop_timezone,
		wheelchair_boarding,
		level_id,
		platform_code
    )
    SELECT DISTINCT 
    	CAST(file_id AS INT),
		stop_id,
		stop_code,
		stop_name, 
		tts_stop_name,
		stop_desc,
		stop_lat, 
		stop_lon, 
		ST_SetSRID(ST_MakePoint(stop_lon::numeric(9,6), stop_lat::numeric(8,6)), 32610),
		zone_id,
		stop_url,
		CASE WHEN COALESCE(location_type, '') = '' THEN 0 ELSE CAST(location_type AS SMALLINT) END,
	    parent_station,
	    stop_timezone,
	    CASE WHEN COALESCE(wheelchair_boarding, '') = '' THEN 0 ELSE CAST(wheelchair_boarding AS SMALLINT) END,
		level_id,
		platform_code
    FROM gtfs_test.transitland_stops;

END;
$$;

CALL create_real_stops_table()



CREATE OR REPLACE PROCEDURE create_real_routes_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs_test.real_transitland_routes (
    	file_id,
		route_id,
		agency_id,
		route_short_name, 
		route_long_name,
		route_desc,
		route_type,
		route_url,
		route_color,
		route_text_color,
		route_sort_order, 
		continuous_pickup,
		continuous_drop_off,
		network_id
    )
    SELECT DISTINCT 
    	CAST(file_id AS INT),
		route_id,
		agency_id,
		route_short_name, 
		route_long_name,
		route_desc,
		CAST(route_type AS SMALLINT),
		route_url,
		route_color,
		route_text_color,
		CAST(route_sort_order AS INT), 
		CASE WHEN COALESCE(continuous_pickup, '') = '' THEN 1 ELSE CAST(continuous_pickup AS SMALLINT) END,
		CASE WHEN COALESCE(continuous_drop_off, '') = '' THEN 1 ELSE CAST(continuous_drop_off AS SMALLINT) END,
		network_id
    FROM gtfs_test.transitland_routes;

END;
$$;

CALL create_real_routes_table()



CREATE OR REPLACE PROCEDURE create_real_calendar_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs_test.real_transitland_calendar (
    	file_id,
		service_id,
		monday,
		tuesday,
		wednesday,
		thursday,
		friday,
		saturday,
		sunday,
		start_date,
		end_date
    )
    SELECT DISTINCT 
    	CAST(file_id AS INT),
		service_id,
		CAST(monday AS SMALLINT),
		CAST(tuesday AS SMALLINT),
		CAST(wednesday AS SMALLINT),
		CAST(thursday AS SMALLINT),
		CAST(friday AS SMALLINT),
		CAST(saturday AS SMALLINT),
		CAST(sunday AS SMALLINT),
		CAST(start_date AS DATE),
		CAST(end_date AS DATE)
    FROM gtfs_test.transitland_calendar;

END;
$$;

CALL create_real_calendar_table()



CREATE OR REPLACE PROCEDURE create_real_calendar_dates_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs_test.real_transitland_calendar_dates (
    	file_id,
		service_id,
		date, 
		exception_type
    )
    SELECT DISTINCT 
    	CAST(file_id AS INT),
		service_id,
		CAST(date AS DATE), 
		CAST(exception_type AS SMALLINT)
    FROM gtfs_test.transitland_calendar_dates;

END;
$$;

CALL create_real_calendar_dates_table()



CREATE OR REPLACE PROCEDURE create_real_shapes_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs_test.real_transitland_shapes (
    	file_id,
		shape_id,
		shape_pt_lat,
		shape_pt_lon,
		shape_pt_location,
		shape_pt_sequence,
		shape_dist_traveled
    )
    SELECT DISTINCT 
    	CAST(file_id AS INT),
		shape_id TEXT,
		shape_pt_lat TEXT,
		shape_pt_lon TEXT,
		ST_SetSRID(ST_MakePoint(shape_pt_lon::numeric(9,6), shape_pt_lat::numeric(8,6)), 32610),
		CAST(shape_pt_sequence AS INT),
		CAST(shape_dist_traveled AS INT)
    FROM gtfs_test.transitland_shapes;

END;
$$;

CALL create_real_shapes_table()



CREATE OR REPLACE PROCEDURE create_real_fare_attributes_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs_test.real_transitland_fare_attributes (
    	file_id,
		fare_id,
		price,
		currency_type,
		payment_method,
		transfers,
		agency_id,
		transfer_duration
    )
    SELECT DISTINCT 
    	CAST(file_id AS INT),
		fare_id,
		price, 
		currency_type,
		CAST(payment_method AS SMALLINT),
		CAST(transfers AS SMALLINT),
		agency_id,
		CAST(transfer_duration AS INT)
    FROM gtfs_test.transitland_fare_attributes;

END;
$$;

CALL create_real_fare_attributes_table()



CREATE OR REPLACE PROCEDURE create_real_fare_rules_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs_test.real_transitland_fare_rules (
    	file_id,
		fare_id,
		route_id,
		origin_id,
		destination_id,
		contains_id
    )
    SELECT DISTINCT 
    	CAST(file_id AS INT),
		fare_id,
		route_id,
		origin_id,
		destination_id,
		contains_id
    FROM gtfs_test.transitland_fare_rules;

END;
$$;

CALL create_real_fare_rules_table()



CREATE OR REPLACE PROCEDURE create_real_trips_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs_test.real_transitland_trips (
    	file_id,
		route_id,
		service_id,
		trip_id,
		trip_headsign,
		trip_short_name,
		direction_id,
		block_id,
		shape_id,
		wheelchair_accessible,
		bikes_allowed
    )
    SELECT DISTINCT 
    	CAST(file_id AS INT),
		route_id,
		service_id,
		trip_id,
		trip_headsign,
		trip_short_name,
		CAST(direction_id AS SMALLINT),
		block_id,
		shape_id,
		CASE WHEN COALESCE(wheelchair_accessible, '') = '' THEN 0 ELSE CAST(wheelchair_accessible AS SMALLINT) END,
		CASE WHEN COALESCE(bikes_allowed, '') = '' THEN 0 ELSE CAST(bikes_allowed AS SMALLINT) END
    FROM gtfs_test.transitland_trips;

END;
$$;

CALL create_real_trips_table()



CREATE OR REPLACE PROCEDURE create_real_stop_times_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs_test.real_transitland_stop_times (
    	file_id,
		trip_id,
		arrival_time,
		departure_time,
		stop_id,
		stop_sequence,
		stop_headsign,
		pickup_type,
		drop_off_type,
		continuous_pickup,
		continuous_drop_off,
		shape_dist_traveled,
		timepoint
    )
    SELECT DISTINCT 
    	CAST(file_id AS INT),
		trip_id,
		CAST(arrival_time AS INTERVAL),
		CAST(departure_time AS INTERVAL),
		stop_id,
		CAST(stop_sequence AS INT),
		stop_headsign,
		CASE WHEN COALESCE(pickup_type, '') = '' THEN 0 ELSE CAST(pickup_type AS SMALLINT) END,
		CASE WHEN COALESCE(drop_off_type, '') = '' THEN 0 ELSE CAST(drop_off_type AS SMALLINT) END,
		CASE WHEN COALESCE(continuous_pickup, '') = '' THEN 1 ELSE CAST(continuous_pickup AS SMALLINT) END,
		CASE WHEN COALESCE(continuous_drop_off, '') = '' THEN 1 ELSE CAST(continuous_drop_off AS SMALLINT) END,
		CAST(shape_dist_traveled AS FLOAT),
		CASE WHEN COALESCE(timepoint, '') = '' THEN 0 ELSE CAST(timepoint AS SMALLINT) END
    FROM gtfs_test.transitland_stop_times;

END;
$$;

CALL create_real_stop_times_table()



CREATE OR REPLACE PROCEDURE create_real_timeframes_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs_test.real_transitland_timeframes (
    	file_id,
		timeframe_group_id,
		start_time,
		end_time, 
		service_id
    )
    SELECT DISTINCT 
    	CAST(file_id AS INT),
		timeframe_group_id,
		CAST(start_time AS TIME),
		CAST(end_time AS TIME), 
		service_id
    FROM gtfs_test.transitland_timeframes;

END;
$$;

CALL create_real_timeframes_table()



CREATE OR REPLACE PROCEDURE create_real_fare_media_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs_test.real_transitland_fare_media (
    	file_id,
		fare_media_id,
		fare_media_name,
		fare_media_type
    )
    SELECT DISTINCT 
    	CAST(file_id AS INT),
		fare_media_id,
		fare_media_name,
		CAST(fare_media_type AS SMALLINT)
    FROM gtfs_test.transitland_fare_media;

END;
$$;

CALL create_real_fare_media_table()



CREATE OR REPLACE PROCEDURE create_real_fare_products_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs_test.real_transitland_fare_products (
    	file_id,
		fare_product_id,
		fare_product_name,
		fare_media_id,
		amount,
		currency
    )
    SELECT DISTINCT 
    	CAST(file_id AS INT),
		fare_product_id,
		fare_product_name,
		fare_media_id,
		CAST(amount AS NUMERIC(7,2)),
		currency
    FROM gtfs_test.transitland_fare_products;

END;
$$;

CALL create_real_fare_products_table()



CREATE OR REPLACE PROCEDURE create_real_fare_leg_rules_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs_test.real_transitland_fare_leg_rules (
    	file_id,
		leg_group_id,
		network_id,
		from_area_id,
		to_area_id,
		from_timeframe_group_id,
		to_timeframe_group_id,
		fare_product_id
    )
    SELECT DISTINCT 
    	CAST(file_id AS INT),
		leg_group_id,
		network_id,
		from_area_id,
		to_area_id,
		from_timeframe_group_id,
		to_timeframe_group_id,
		fare_product_id
    FROM gtfs_test.transitland_fare_leg_rules;

END;
$$;

CALL create_real_fare_leg_rules_table()



CREATE OR REPLACE PROCEDURE create_real_fare_transfer_rules_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs_test.real_transitland_fare_transfer_rules (
    	file_id,
		from_leg_group_id,
		to_leg_group_id,
		transfer_count,
		duration_limit,
		duration_limit_type, 
		fare_transfer_type,
		fare_product_id
    )
    SELECT DISTINCT 
    	CAST(file_id AS INT),
		from_leg_group_id,
		to_leg_group_id,
		CAST(transfer_count AS INT),
		CAST(duration_limit AS INT),
		CAST(duration_limit_type AS SMALLINT), 
		CAST(fare_transfer_type AS SMALLINT),
		fare_product_id
    FROM gtfs_test.transitland_fare_transfer_rules;

END;
$$;

CALL create_real_fare_transfer_rules_table()



CREATE OR REPLACE PROCEDURE create_real_areas_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs_test.real_transitland_areas (
    	file_id,
		area_id,
		area_name
    )
    SELECT DISTINCT 
    	CAST(file_id AS INT),
		area_id TEXT NOT,
		area_name TEXT
    FROM gtfs_test.transitland_areas;

END;
$$;

CALL create_real_areas_table()



CREATE OR REPLACE PROCEDURE create_real_stop_areas_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs_test.real_transitland_stop_areas (
    	file_id,
		area_id,
		stop_id
    )
    SELECT DISTINCT 
    	CAST(file_id AS INT),
		area_id,
		stop_id
    FROM gtfs_test.transitland_stop_areas;

END;
$$;

CALL create_real_stop_areas_table()



CREATE OR REPLACE PROCEDURE create_real_networks_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs_test.real_transitland_networks (
    	file_id,
		network_id,
		network_name
    )
    SELECT DISTINCT 
    	CAST(file_id AS INT),
		network_id,
		network_name
    FROM gtfs_test.transitland_networks;

END;
$$;

CALL create_real_networks_table()



CREATE OR REPLACE PROCEDURE create_real_route_networks_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs_test.real_transitland_route_networks (
    	file_id,
		network_id,
		route_id
    )
    SELECT DISTINCT 
    	CAST(file_id AS INT),
		network_id,
		route_id
    FROM gtfs_test.transitland_route_neworks;

END;
$$;

CALL create_real_route_networks_table()



CREATE OR REPLACE PROCEDURE create_real_frequencies_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs_test.real_transitland_frequencies (
    	file_id,
		trip_id,
		start_time, 
		end_time,
		headway_secs,
		exact_times
    )
    SELECT DISTINCT 
    	CAST(file_id AS INT),
		trip_id,
		CAST(start_time AS INTERVAL), 
		CAST(end_time AS INTERVAL),
		CAST(headway_secs AS INT),
		CASE WHEN COALESCE(exact_times, '') = '' THEN 0 ELSE CAST(exact_times AS SMALLINT) END
    FROM gtfs_test.transitland_frequencies;

END;
$$;

CALL create_real_frequencies_table()



CREATE OR REPLACE PROCEDURE create_real_transfers_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs_test.real_transitland_transfers (
    	file_id,
		from_stop_id,
		to_stop_id, 
		from_route_id,
		to_route_id, 
		from_trip_id, 
		to_trip_id,
		transfer_type,
		min_transfer_time
    )
    SELECT DISTINCT 
    	CAST(file_id AS INT),
		from_stop_id,
		to_stop_id, 
		from_route_id,
		to_route_id, 
		from_trip_id, 
		to_trip_id,
		CASE WHEN COALESCE(transfer_type, '') = '' THEN 0 ELSE CAST(transfer_type AS SMALLINT) END,
		CAST(min_transfer_time AS INT)
    FROM gtfs_test.transitland_transfers;

END;
$$;

CALL create_real_transfers_table()



CREATE OR REPLACE PROCEDURE create_real_pathways_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs_test.real_transitland_pathways (
    	file_id,
		pathway_id,
		from_stop_id,
		to_stop_id,
		pathway_mode,
		is_bidirectional,
		length,
		traversal_time,
		stair_count,
		max_slope,
		min_width,
		signposted_as,
		reversed_signposted_as
    )
    SELECT DISTINCT 
    	CAST(file_id AS INT),
		pathway_id,
		from_stop_id,
		to_stop_id,
		CAST(pathway_mode AS SMALLINT),
		CAST(is_bidirectional AS SMALLINT),
		CAST(length AS FLOAT),
		CAST(traversal_time AS INT),
		CAST(stair_count AS INT),
		CAST(max_slope AS FLOAT),
		CAST(min_width AS FLOAT),
		signposted_as,
		reversed_signposted_as
    FROM gtfs_test.transitland_pathways;

END;
$$;

CALL create_real_pathways_table()



CREATE OR REPLACE PROCEDURE create_real_levels_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs_test.real_transitland_levels (
    	file_id,
		level_id,
		level_index,
		level_name
    )
    SELECT DISTINCT 
    	CAST(file_id AS INT),
		level_id,
		CAST(level_index AS FLOAT),
		level_name
    FROM gtfs_test.transitland_levels;

END;
$$;

CALL create_real_levels_table()



CREATE OR REPLACE PROCEDURE create_real_translations_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs_test.real_transitland_translations (
    	file_id,
		table_name, 
		field_name,
		language,
		TRANSLATION,
		record_id, 
		record_sub_id, 
		field_value
    )
    SELECT DISTINCT 
    	CAST(file_id AS INT),
		table_name,
		field_name,
		language,
		TRANSLATION,
		record_id, 
		record_sub_id, 
		field_value
    FROM gtfs_test.transitland_translations;

END;
$$;

CALL create_real_translations_table()



CREATE OR REPLACE PROCEDURE create_real_feed_info_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs_test.real_transitland_feed_info (
    	file_id,
		feed_publisher_name,
		feed_publisher_url,
		feed_lang,
		default_lang,
		feed_start_date,
		feed_end_date,
		feed_version,
		feed_contact_email,
		feed_contact_url
    )
    SELECT DISTINCT 
    	CAST(file_id AS INT),
		feed_publisher_name,
		feed_publisher_url,
		feed_lang,
		default_lang,
		CAST(feed_start_date AS DATE),
		CAST(feed_end_date AS DATE),
		feed_version,
		feed_contact_email,
		feed_contact_url
    FROM gtfs_test.transitland_feed_info;

END;
$$;

CALL create_real_feed_info_table()



CREATE OR REPLACE PROCEDURE create_real_attributions_table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs_test.real_transitland_attributions (
    	file_id,
		attribution_id,
		agency_id, 
		route_id, 
		trip_id, 
		organization_name,
		is_producer,
		is_operator,
		is_authority,
		attribution_url,
		attribution_email,
		attribution_phone
    )
    SELECT DISTINCT 
    	CAST(file_id AS INT),
		attribution_id,
		agency_id, 
		route_id, 
		trip_id, 
		organization_name,
		CASE WHEN COALESCE(is_producer, '') = '' THEN 0 ELSE CAST(is_producer AS SMALLINT) END,
		CASE WHEN COALESCE(is_operator, '') = '' THEN 0 ELSE CAST(is_operator AS SMALLINT) END,
		CASE WHEN COALESCE(is_authority, '') = '' THEN 0 ELSE CAST(is_authority AS SMALLINT) END,
		attribution_url,
		attribution_email,
		attribution_phone
    FROM gtfs_test.transitland_attributions;

END;
$$;

CALL create_real_attributions_table()




















CREATE OR REPLACE PROCEDURE create_real__table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs_test.real_transitland_ (
    	
    )
    SELECT DISTINCT 
    	
    FROM gtfs_test.transitland_;

END;
$$;

CALL create_real__table()
