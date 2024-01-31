---------------------------------------------------------------------------
SELECT * FROM gtfs.v_transitland_feed_info;
---------------------------------------------------------------------------


DROP TABLE gtfs_test.transitland_stop_times; 
DROP TABLE gtfs_test.transitland_trips ;
DROP TABLE gtfs_test.transitland_fare_rules ;
DROP TABLE gtfs_test.transitland_fare_attributes;
DROP TABLE gtfs_test.transitland_shapes;
DROP TABLE gtfs_test.transitland_calendar_dates;
DROP TABLE gtfs_test.transitland_calendar;
DROP TABLE gtfs_test.transitland_routes;
DROP TABLE gtfs_test.transitland_stops ;
DROP TABLE gtfs_test.transitland_agency;
DROP TABLE gtfs_test.transitland_timeframes;
DROP TABLE gtfs_test.transitland_fare_media;
DROP TABLE gtfs_test.transitland_fare_products;
DROP TABLE gtfs_test.transitland_fare_leg_rules;
DROP TABLE gtfs_test.transitland_fare_transfer_rules;
DROP TABLE gtfs_test.transitland_areas;
DROP TABLE gtfs_test.transitland_stop_areas;
DROP TABLE gtfs_test.transitland_networks;
DROP TABLE gtfs_test.transitland_route_networks;
DROP TABLE gtfs_test.transitland_frequencies;
DROP TABLE gtfs_test.transitland_transfers;
DROP TABLE gtfs_test.transitland_pathways;
DROP TABLE gtfs_test.transitland_levels;
DROP TABLE gtfs_test.transitland_feed_info;
DROP TABLE gtfs_test.transitland_attributions;
DROP TABLE gtfs_test.transitland_translations;
DROP TABLE gtfs_test.gtfs_extra_attributes;



CREATE TABLE gtfs_test.transitland_agency (
	agency_id TEXT,
	agency_name TEXT,
	agency_url TEXT,
	agency_timezone TEXT,
	agency_lang TEXT,
	agency_phone TEXT,
	agency_fare_url TEXT,
	agency_email TEXT
);


CREATE TABLE gtfs_test.transitland_stops (
	stop_id TEXT,
	stop_code TEXT,
	stop_name TEXT,
	tts_stop_name TEXT,
	stop_desc TEXT,
	stop_lat TEXT,
	stop_lon TEXT,
	zone_id TEXT,
	stop_url TEXT,
	location_type TEXT,
	parent_station TEXT,
	stop_timezone TEXT,
	wheelchair_boarding TEXT,
	level_id TEXT,
	platform_code TEXT
);


CREATE TABLE gtfs_test.transitland_routes (
	route_id TEXT,
	agency_id TEXT,
	route_short_name TEXT,
	route_long_name TEXT,
	route_desc TEXT,
	route_type TEXT,
	route_url TEXT,
	route_color TEXT,
	route_text_color TEXT,
	route_sort_order TEXT,
	continuous_pickup TEXT,
	continuoues_dropoff TEXT,
	network_id TEXT
);


CREATE TABLE gtfs_test.transitland_calendar (
	service_id TEXT,
	monday TEXT,
	tuesday TEXT,
	wednesday TEXT,
	thursday TEXT,
	friday TEXT,
	saturday TEXT,
	sunday TEXT,
	start_date DATE,
	end_date DATE
);


CREATE TABLE gtfs_test.transitland_calendar_dates (
	service_id TEXT,
	date TEXT,
	exception_type TEXT
);


CREATE TABLE gtfs_test.transitland_shapes (
	shape_id TEXT,
	shape_pt_lat TEXT,
	shape_pt_lon TEXT,
	shape_pt_sequence TEXT,
	shape_dist_traveled TEXT
);


CREATE TABLE gtfs_test.transitland_fare_attributes (
	fare_id TEXT,
	price TEXT,
	currency_type TEXT,
	payment_method TEXT,
	transfers TEXT,
	agency_id TEXT,
	transfer_duration TEXT
);


CREATE TABLE gtfs_test.transitland_fare_rules (
	fare_id TEXT,
	route_id TEXT,
	origin_id TEXT,
	destination_id TEXT,
	contains_id TEXT
);


CREATE TABLE gtfs_test.transitland_trips (
	route_id TEXT,
	service_id TEXT,
	trip_id TEXT,
	trip_headsign TEXT,
	trip_short_name TEXT,
	direction_id TEXT,
	block_id TEXT,
	shape_id TEXT,
	wheelchair_accessible TEXT,
	bikes_allowed TEXT
);


CREATE TABLE gtfs_test.transitland_stop_times (
	trip_id TEXT,
	arrival_time TEXT,
	departure_time TEXT,
	stop_id TEXT,
	stop_sequence TEXT,
	stop_headsign TEXT,
	pickup_type TEXT,
	drop_off_type TEXT,
	continuous_pickup TEXT,
	continuous_dropoff TEXT,
	shape_dist_traveled TEXT,
	timepoint TEXT
);


CREATE TABLE gtfs_test.transitland_timeframes (
	timeframe_group_id TEXT,
	start_time TEXT,
	end_time TEXT,
	service_id TEXT
);


CREATE TABLE gtfs_test.transitland_fare_media (
	fare_media_id TEXT,
	fare_media_name TEXT,
	fare_media_type TEXT
);


CREATE TABLE gtfs_test.transitland_fare_products (
	fare_product_id TEXT,
	fare_product_name TEXT,
	fare_media_id TEXT,
	amount TEXT,
	currecny TEXT
);


CREATE TABLE gtfs_test.transitland_fare_leg_rules (
	leg_group_id TEXT,
	network_id TEXT,
	from_area_id TEXT,
	to_area_id TEXT,
	from_timeframe_group_id TEXT,
	to_timeframe_group_id TEXT,
	fare_product_id TEXT
);


CREATE TABLE gtfs_test.transitland_fare_transfer_rules (
	from_leg_group_id TEXT,
	to_leg_group_id TEXT,
	transfer_count TEXT,
	duration_limit TEXT,
	duration_limit_type TEXT,
	fare_transfer_type TEXT,
	fare_product_id TEXT
);


CREATE TABLE gtfs_test.transitland_areas (
	area_id TEXT,
	area_name TEXT
);


CREATE TABLE gtfs_test.transitland_stop_areas (
	area_id TEXT,
	stop_id TEXT
);


CREATE TABLE gtfs_test.transitland_networks (
	network_id TEXT,
	network_name TEXT
);


CREATE TABLE gtfs_test.transitland_route_networks (
	network_id TEXT,
	route_id TEXT
);


CREATE TABLE gtfs_test.transitland_frequencies (
	trip_id TEXT,
	start_time TEXT,
	end_time TEXT,
	headway_secs TEXT,
	exact_times TEXT
);


CREATE TABLE gtfs_test.transitland_transfers (
	from_stop_id TEXT,
	to_stop_id TEXT,
	from_route_id TEXT,
	to_route_id TEXT,
	from_trip_id TEXT,
	to_trip_id TEXT,
	transfer_type TEXT,
	min_transfer_time TEXT
);

CREATE TABLE gtfs_test.transitland_pathways (
	pathway_id TEXT,
	from_stop_id TEXT,
	to_stop_id TEXT,
	pathway_mode TEXT,
	is_bidirectional TEXT,
	length TEXT,
	traversal_time TEXT,
	stair_count TEXT,
	max_slope TEXT,
	min_width TEXT,
	signposted_as TEXT,
	reversed_signposted_as TEXT
);


CREATE TABLE gtfs_test.transitland_levels (
	level_id TEXT,
	level_index TEXT,
	level_name TEXT
);


CREATE TABLE gtfs_test.transitland_translations (
	table_name TEXT,
	field_name TEXT,
	language TEXT,
	TRANSLATION TEXT,
	record_id TEXT,
	record_sub_id TEXT,
	field_value TEXT
);


CREATE TABLE gtfs_test.transitland_feed_info (
	feed_publisher_name TEXT,
	feed_publisher_url TEXT,
	feed_lang TEXT,
	default_lang TEXT,
	feed_start_date TEXT,
	feed_end_date TEXT,
	feed_version TEXT,
	feed_contact_email TEXT,
	feed_contact_url TEXT
);


CREATE TABLE gtfs_test.transitland_attributions (
	attribution_id TEXT,
	agency_id TEXT,
	route_id TEXT,
	trip_id TEXT,
	organization_name TEXT,
	is_producer TEXT,
	is_operator TEXT,
	is_authority TEXT,
	attribution_url TEXT,
	attribution_email TEXT,
	attribution_phone TEXT
);


CREATE TABLE gtfs_test.gtfs_extra_attributes (
    file_id TEXT,
   	file_name TEXT,
    column_name TEXT,
    value TEXT
);




SELECT * FROM gtfs_test.transitland_agency
SELECT * FROM gtfs_test.transitland_stops
SELECT * FROM gtfs_test.transitland_routes
SELECT * FROM gtfs_test.transitland_calendar
SELECT * FROM gtfs_test.transitland_calendar_dates
SELECT * FROM gtfs_test.transitland_shapes
SELECT * FROM gtfs_test.transitland_fare_attributes
SELECT * FROM gtfs_test.transitland_fare_rules
SELECT * FROM gtfs_test.transitland_trips
SELECT * FROM gtfs_test.transitland_stop_times
SELECT * FROM gtfs_test.transitland_timeframes
SELECT * FROM gtfs_test.transitland_fare_media
SELECT * FROM gtfs_test.transitland_fare_products
SELECT * FROM gtfs_test.transitland_fare_leg_rules
SELECT * FROM gtfs_test.transitland_fare_transfer_rules
SELECT * FROM gtfs_test.transitland_areas
SELECT * FROM gtfs_test.transitland_stop_areas
SELECT * FROM gtfs_test.transitland_networks
SELECT * FROM gtfs_test.transitland_route_networks
SELECT * FROM gtfs_test.transitland_frequencies
SELECT * FROM gtfs_test.transitland_transfers
SELECT * FROM gtfs_test.transitland_pathways
SELECT * FROM gtfs_test.transitland_levels
SELECT * FROM gtfs_test.transitland_translations
SELECT * FROM gtfs_test.transitland_feed_info
SELECT * FROM gtfs_test.transitland_attributions
SELECT * FROM gtfs_test.gtfs_extra_attributes 




