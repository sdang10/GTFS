---------------------------------------------------------------------------
SELECT * FROM gtfs.v_transitland_feed_info;
---------------------------------------------------------------------------

-- TEMP TABLES FOR A STRAIGHT FORWARD IMPORT

DROP TABLE gtfs_test.transitland_stop_times; 
DROP TABLE gtfs_test.transitland_trips;
DROP TABLE gtfs_test.transitland_shapes;
DROP TABLE gtfs_test.transitland_calendar_dates;
DROP TABLE gtfs_test.transitland_calendar;
DROP TABLE gtfs_test.transitland_routes;
DROP TABLE gtfs_test.transitland_stops;
DROP TABLE gtfs_test.transitland_agency;
DROP TABLE gtfs_test.transitland_feed_info;
DROP TABLE gtfs_test.transitland_transfers;
DROP TABLE gtfs_test.transitland_fare_attributes;
DROP TABLE gtfs_test.transitland_fare_rules;
DROP TABLE gtfs_test.transitland_frequencies;
DROP TABLE gtfs_test.transitland_areas;
DROP TABLE gtfs_test.transitland_timeframes;
DROP TABLE gtfs_test.transitland_fare_media;
DROP TABLE gtfs_test.transitland_fare_products;
DROP TABLE gtfs_test.transitland_fare_leg_rules;
DROP TABLE gtfs_test.transitland_fare_transfer_rules;
DROP TABLE gtfs_test.transitland_stop_areas;
DROP TABLE gtfs_test.transitland_networks;
DROP TABLE gtfs_test.transitland_route_networks;
DROP TABLE gtfs_test.transitland_pathways;
DROP TABLE gtfs_test.transitland_levels;
DROP TABLE gtfs_test.transitland_attributions;



CREATE TABLE gtfs_test.transitland_agency (
	file_id TEXT,
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
	file_id TEXT,
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
	file_id TEXT,
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
	continuous_drop_off TEXT,
	network_id TEXT
);

CREATE TABLE gtfs_test.transitland_calendar (
	file_id TEXT,
	service_id TEXT,
	monday TEXT,
	tuesday TEXT,
	wednesday TEXT,
	thursday TEXT,
	friday TEXT,
	saturday TEXT,
	sunday TEXT,
	start_date TEXT,
	end_date TEXT
);

CREATE TABLE gtfs_test.transitland_calendar_dates (
	file_id TEXT,
	service_id TEXT, 
	date TEXT, 
	exception_type TEXT
);

CREATE TABLE gtfs_test.transitland_shapes (
	file_id TEXT,
	shape_id TEXT, 
	shape_pt_lat TEXT,
	shape_pt_lon TEXT,
	shape_pt_sequence TEXT, 
	shape_dist_traveled TEXT
);

CREATE TABLE gtfs_test.transitland_trips (
	file_id TEXT,
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
	file_id TEXT,
	trip_id TEXT, 
	arrival_time TEXT,
	departure_time TEXT,
	stop_id TEXT, 
	stop_sequence TEXT, 
	stop_headsign TEXT,
	pickup_type TEXT,
	drop_off_type TEXT,
	continuous_pickup TEXT,
	continuous_drop_off TEXT,
	shape_dist_traveled TEXT,
	timepoint TEXT
);

CREATE TABLE gtfs_test.transitland_transfers (
	file_id TEXT,
	from_stop_id TEXT,
	to_stop_id TEXT,
	from_route_id TEXT,
	to_route_id TEXT,
	from_trip_id TEXT,
	to_trip_id TEXT,
	transfer_type TEXT,
	min_transfer_time TEXT
);

CREATE TABLE gtfs_test.transitland_feed_info (
	file_id TEXT,
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

CREATE TABLE gtfs_test.transitland_fare_attributes (
	file_id TEXT,
	fare_id TEXT,
	price TEXT,
	currency_type TEXT,
	payment_method TEXT,
	transfers TEXT,
	agency_id TEXT,
	transfer_duration TEXT
);

CREATE TABLE gtfs_test.transitland_fare_rules (
	file_id TEXT,
	fare_id TEXT,
	route_id TEXT, 
	origin_id TEXT,
	destination_id TEXT,
	contains_id TEXT
);

CREATE TABLE gtfs_test.transitland_frequencies (
	file_id TEXT,
	trip_id TEXT,
	start_time TEXT,
	end_time TEXT,
	headway_secs TEXT,
	exact_times TEXT
);

CREATE TABLE gtfs_test.transitland_areas (
	file_id TEXT,
	area_id TEXT,
	area_name TEXT
);

CREATE TABLE gtfs_test.transitland_timeframes (
	file_id TEXT,
	timeframe_group_id TEXT,
	start_time TEXT,
	end_time TEXT,
	service_id TEXT
);

CREATE TABLE gtfs_test.transitland_fare_media (
	file_id TEXT,
	fare_media_id TEXT,
	fare_media_name TEXT,
	fare_media_type TEXT
);

CREATE TABLE gtfs_test.transitland_fare_products (
	file_id TEXT,
	fare_product_id TEXT,
	fare_product_name TEXT,
	fare_media_id TEXT,
	amount TEXT,
	currency TEXT
);

CREATE TABLE gtfs_test.transitland_fare_leg_rules (
	file_id TEXT,
	leg_group_id TEXT,
	network_id TEXT,
	from_area_id TEXT, 
	to_area_id TEXT,
	from_timeframe_group_id TEXT,
	to_timeframe_group_id TEXT,
	fare_product_id TEXT
);

CREATE TABLE gtfs_test.transitland_fare_transfer_rules (
	file_id TEXT,
	from_leg_group_id TEXT, 
	to_leg_group_id TEXT,
	transfer_count TEXT,
	duration_limit TEXT,
	duration_limit_type TEXT,
	fare_transfer_type TEXT,
	fare_product_id TEXT
);

CREATE TABLE gtfs_test.transitland_stop_areas (
	file_id TEXT,
	area_id TEXT,
	stop_id TEXT
);

CREATE TABLE gtfs_test.transitland_networks (
	file_id TEXT,
	network_id TEXT,
	network_name TEXT
);

CREATE TABLE gtfs_test.transitland_route_networks (
	file_id TEXT,
	network_id TEXT,
	route_id TEXT
);

CREATE TABLE gtfs_test.transitland_pathways (
	file_id TEXT,
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
	file_id TEXT,
	level_id TEXT,
	level_index TEXT,
	level_name TEXT
);

CREATE TABLE gtfs_test.transitland_translations (
	file_id TEXT,
	table_name TEXT,
	field_name TEXT,
	language TEXT,
	TRANSLATION TEXT,
	record_id TEXT,
	record_sub_id TEXT,
	field_value TEXT
);

CREATE TABLE gtfs_test.transitland_attributions (
	file_id TEXT,
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


SELECT * FROM gtfs_test.transitland_agency;
SELECT * FROM gtfs_test.transitland_stops;
SELECT * FROM gtfs_test.transitland_routes;
SELECT * FROM gtfs_test.transitland_calendar;
SELECT * FROM gtfs_test.transitland_calendar_dates;
SELECT * FROM gtfs_test.transitland_shapes;
SELECT * FROM gtfs_test.transitland_fare_attributes;
SELECT * FROM gtfs_test.transitland_fare_rules;
SELECT * FROM gtfs_test.transitland_trips;
SELECT * FROM gtfs_test.transitland_stop_times;
SELECT * FROM gtfs_test.transitland_timeframes;
SELECT * FROM gtfs_test.transitland_fare_media;
SELECT * FROM gtfs_test.transitland_fare_products;
SELECT * FROM gtfs_test.transitland_fare_leg_rules;
SELECT * FROM gtfs_test.transitland_fare_transfer_rules;
SELECT * FROM gtfs_test.transitland_areas;
SELECT * FROM gtfs_test.transitland_stop_areas;
SELECT * FROM gtfs_test.transitland_networks;
SELECT * FROM gtfs_test.transitland_route_networks;
SELECT * FROM gtfs_test.transitland_frequencies;
SELECT * FROM gtfs_test.transitland_transfers;
SELECT * FROM gtfs_test.transitland_pathways;
SELECT * FROM gtfs_test.transitland_levels;
SELECT * FROM gtfs_test.transitland_translations;
SELECT * FROM gtfs_test.transitland_feed_info;
SELECT * FROM gtfs_test.transitland_attributions;



-------------------------------------------------------------------------------------------

-- TEMP TABLES FOR FILE DATA FOR A STRAIGHT FORWARD IMPORT


DROP TABLE gtfs_test.gtfs_extra_attributes;
DROP TABLE gtfs_test.gtfs_extra_files;
DROP TABLE gtfs_test.gtfs_files;


CREATE TABLE gtfs_test.gtfs_files (
	id TEXT,
	fetched_at TEXT,
	earliest_calendar_date TEXT,
	latest_calendar_date TEXT,
	sha1 TEXT,
	url TEXT
);

CREATE TABLE gtfs_test.gtfs_extra_attributes (
    file_id TEXT,
   	file_name TEXT,
    column_name TEXT,
    value TEXT
);

CREATE TABLE gtfs_test.gtfs_extra_files (
	file_id TEXT,
	file_name TEXT
);


SELECT * FROM gtfs_test.gtfs_extra_attributes 
SELECT * FROM gtfs_test.gtfs_files
SELECT * FROM gtfs_test.gtfs_extra_files


---------------------------------------------------------------------------

-- REAL FILE TABLES WITH PRIMARY KEYS, REFERENCES, AND CORRECT VARIABLE TYPES


DROP TABLE gtfs_test.real_gtfs_extra_attributes;
DROP TABLE gtfs_test.real_gtfs_extra_files;
DROP TABLE gtfs_test.real_gtfs_files;


CREATE TABLE gtfs_test.real_gtfs_files (
	file_id INT PRIMARY KEY,
	fetched_at TEXT,
	earliest_calendar_date DATE,
	latest_calendar_date DATE,
	sha1 TEXT,
	url TEXT
);

CREATE TABLE gtfs_test.real_gtfs_extra_attributes (
    file_id INT REFERENCES gtfs_test.real_gtfs_files(file_id),
   	file_name TEXT,
    column_name TEXT,
    value TEXT
);

CREATE TABLE gtfs_test.real_gtfs_extra_files (
	file_id INT REFERENCES gtfs_test.real_gtfs_files(file_id),
	file_name TEXT
);


SELECT * FROM gtfs_test.real_gtfs_extra_attributes 
SELECT * FROM gtfs_test.real_gtfs_files
SELECT * FROM gtfs_test.real_gtfs_extra_files


--------------------------------------------------------------------------------------------

-- REAL TABLES WITH PRIMARY KEYS, REFERENCES, AND CORRECT VARIABLE TYPES


-- THESE TABLES DON'T HAVE DEPENDENCIES SO THEY CAN BE CREATED FIRST

DROP TABLE gtfs_test.real_transitland_feed_info;
DROP TABLE gtfs_test.real_transitland_networks;
DROP TABLE gtfs_test.real_transitland_translations;
DROP TABLE gtfs_test.real_transitland_fare_media;
DROP TABLE gtfs_test.real_transitland_shapes;
DROP TABLE gtfs_test.real_transitland_calendar;
DROP TABLE gtfs_test.real_transitland_levels;


CREATE TABLE gtfs_test.real_transitland_feed_info (
	file_id INT REFERENCES gtfs_test.real_gtfs_files(file_id),
	feed_publisher_name TEXT NOT NULL,
	feed_publisher_url TEXT NOT NULL,
	feed_lang TEXT NOT NULL,
	default_lang TEXT,
	feed_start_date DATE,
	feed_end_date DATE,
	feed_version TEXT,
	feed_contact_email TEXT,
	feed_contact_url TEXT,
	PRIMARY KEY(file_id)
);
-- SELECT * FROM gtfs_test.transitland_feed_info
-- SELECT * FROM gtfs_test.real_transitland_feed_info


CREATE TABLE gtfs_test.real_transitland_translations (
	file_id INT REFERENCES gtfs_test.real_gtfs_files(file_id),
	table_name TEXT NOT NULL, -----------------------?????
	field_name TEXT NOT NULL,
	language TEXT NOT NULL,
	TRANSLATION TEXT NOT NULL,
	record_id TEXT, 
	record_sub_id TEXT, 
	field_value TEXT, 
	PRIMARY KEY(file_id, table_name, field_name, language, record_id, record_sub_id, field_value)
);
-- SELECT * FROM gtfs_test.transitland_translations
-- SELECT * FROM gtfs_test.real_transitland_translations


CREATE TABLE gtfs_test.real_transitland_networks (
	file_id INT REFERENCES gtfs_test.real_gtfs_files(file_id),
	network_id TEXT NOT NULL,
	network_name TEXT,
	PRIMARY KEY(file_id, network_id)
);
-- SELECT * FROM gtfs_test.transitland_networks
-- SELECT * FROM gtfs_test.real_transitland_networks


CREATE TABLE gtfs_test.real_transitland_fare_media (
	file_id INT REFERENCES gtfs_test.real_gtfs_files(file_id),
	fare_media_id TEXT NOT NULL,
	fare_media_name TEXT,
	fare_media_type SMALLINT NOT NULL REFERENCES gtfs_test.e_fare_media_types(fare_media_type),
	PRIMARY KEY(file_id, fare_media_id)
);
-- SELECT * FROM gtfs_test.transitland_fare_media
-- SELECT * FROM gtfs_test.real_transitland_fare_media



CREATE TABLE gtfs_test.real_transitland_shapes (
	file_id INT REFERENCES gtfs_test.real_gtfs_files(file_id),
	shape_id TEXT NOT NULL,
	shape_pt_lat TEXT NOT NULL,
	shape_pt_lon TEXT NOT NULL,
	shape_pt_location geometry(Point,32610),
	shape_pt_sequence INT NOT NULL,
	shape_dist_traveled INT,
	PRIMARY KEY(file_id, shape_id, shape_pt_sequence)
);
-- SELECT * FROM gtfs_test.transitland_shapes
-- SELECT * FROM gtfs_test.real_transitland_shapes


CREATE TABLE gtfs_test.real_transitland_calendar (
	file_id INT REFERENCES gtfs_test.real_gtfs_files(file_id),
	service_id TEXT NOT NULL REFERENCES gtfs_test.e_service_availability(service_availability),
	monday SMALLINT NOT NULL REFERENCES gtfs_test.e_service_availability(service_availability),
	tuesday SMALLINT NOT NULL REFERENCES gtfs_test.e_service_availability(service_availability),
	wednesday SMALLINT NOT NULL REFERENCES gtfs_test.e_service_availability(service_availability),
	thursday SMALLINT NOT NULL REFERENCES gtfs_test.e_service_availability(service_availability),
	friday SMALLINT NOT NULL REFERENCES gtfs_test.e_service_availability(service_availability),
	saturday SMALLINT NOT NULL REFERENCES gtfs_test.e_service_availability(service_availability),
	sunday SMALLINT NOT NULL REFERENCES gtfs_test.e_service_availability(service_availability),
	start_date DATE NOT NULL,
	end_date DATE NOT NULL,
	PRIMARY KEY(file_id, service_id)
);
-- SELECT * FROM gtfs_test.transitland_calendar
-- SELECT * FROM gtfs_test.real_transitland_calendar


CREATE TABLE gtfs_test.real_transitland_levels (
	file_id INT REFERENCES gtfs_test.real_gtfs_files(file_id),
	level_id TEXT NOT NULL,
	level_index FLOAT NOT NULL,
	level_name TEXT,
	PRIMARY KEY(file_id, level_id)
);
-- SELECT * FROM gtfs_test.transitland_levels
-- SELECT * FROM gtfs_test.real_transitland_levels


-- TABLES WITH REFERENCE RESTRICTED ORDERING IN CREATION

DROP TABLE gtfs_test.real_transitland_stop_times; 
DROP TABLE gtfs_test.real_transitland_trips ;
DROP TABLE gtfs_test.real_transitland_fare_rules ;
DROP TABLE gtfs_test.real_transitland_fare_attributes;
DROP TABLE gtfs_test.real_transitland_calendar_dates;
DROP TABLE gtfs_test.real_transitland_routes;
DROP TABLE gtfs_test.real_transitland_stops ;
DROP TABLE gtfs_test.real_transitland_areas;
DROP TABLE gtfs_test.real_transitland_frequencies;
DROP TABLE gtfs_test.real_transitland_transfers;
DROP TABLE gtfs_test.real_transitland_agency;
DROP TABLE gtfs_test.real_transitland_timeframes;
DROP TABLE gtfs_test.real_transitland_fare_products;
DROP TABLE gtfs_test.real_transitland_fare_leg_rules;
DROP TABLE gtfs_test.real_transitland_fare_transfer_rules;
DROP TABLE gtfs_test.real_transitland_stop_areas;
DROP TABLE gtfs_test.real_transitland_route_networks;
DROP TABLE gtfs_test.real_transitland_frequencies;
DROP TABLE gtfs_test.real_transitland_pathways;
DROP TABLE gtfs_test.real_transitland_attributions;


CREATE TABLE gtfs_test.real_transitland_agency (
	file_id INT REFERENCES gtfs_test.real_gtfs_files(file_id),
	agency_id TEXT NOT NULL,
	agency_name TEXT NOT NULL,
	agency_url TEXT NOT NULL,
	agency_timezone TEXT NOT NULL,
	agency_lang TEXT,
	agency_phone TEXT,
	agency_fare_url TEXT,
	agency_email TEXT,
	PRIMARY KEY(file_id, agency_id)
);

SELECT * FROM gtfs_test.transitland_agency
SELECT * FROM gtfs_test.real_transitland_agency



CREATE TABLE gtfs_test.real_transitland_stops (
	file_id INT REFERENCES gtfs_test.real_gtfs_files(file_id),
	stop_id TEXT NOT NULL,
	stop_code TEXT,
	stop_name TEXT, 
	tts_stop_name TEXT,
	stop_desc TEXT,
	stop_lat TEXT, 
	stop_lon TEXT, 
	stop_location geometry(Point,32610),
	zone_id TEXT,
	stop_url TEXT,
	location_type SMALLINT REFERENCES gtfs_test.e_location_type(location_type),
	parent_station TEXT REFERENCES gtfs_test.real_transitland_stops(stop_id),
	stop_timezone TEXT,
	wheelchair_boarding SMALLINT REFERENCES gtfs_test.e_wheelchair_boarding(wheelchair_boarding),
	level_id TEXT REFERENCES gtfs_test.real_transitland_levels(level_id),
	platform_code TEXT,
	PRIMARY KEY(file_id,stop_id)
);

SELECT * FROM gtfs_test.transitland_stops
SELECT * FROM gtfs_test.real_transitland_stops


CREATE TABLE gtfs_test.real_transitland_routes (
	file_id INT REFERENCES gtfs_test.real_gtfs_files(file_id),
	route_id TEXT NOT NULL,
	agency_id TEXT REFERENCES gtfs_test.real_transitland_agency(agency_id),
	route_short_name TEXT, 
	route_long_name TEXT,
	route_desc TEXT,
	route_type SMALLINT NOT NULL REFERENCES gtfs_test.e_route_types(route_type),
	route_url TEXT,
	route_color TEXT,
	route_text_color TEXT,
	route_sort_order INT, 
	continuous_pickup SMALLINT REFERENCES gtfs_test.e_continuous_pickup(continuous_pickup),
	continuous_drop_off SMALLINT REFERENCES gtfs_test.e_continuous_drop_off(continuous_drop_off),
	network_id TEXT,
	PRIMARY KEY(file_id, route_id)
);

SELECT * FROM gtfs_test.transitland_routes
SELECT * FROM gtfs_test.real_transitland_routes



CREATE TABLE gtfs_test.real_transitland_calendar_dates (
	file_id INT REFERENCES gtfs_test.real_gtfs_files(file_id),
	service_id TEXT, -- REFERENCES real_transitland_calender(service_id) OR ID
	date DATE NOT NULL, 
	exception_type SMALLINT NOT NULL REFERENCES gtfs_test.e_exception_types(exception_type),
	PRIMARY KEY(file_id, service_id, date)
);

SELECT * FROM gtfs_test.transitland_calendar_dates
SELECT * FROM gtfs_test.real_transitland_calendar_dates



CREATE TABLE gtfs_test.real_transitland_fare_attributes (
	file_id INT REFERENCES gtfs_test.real_gtfs_files(file_id),
	fare_id TEXT NOT NULL,
	price TEXT NOT NULL,  --- CONVERT TO CENTS SO WE CAN USE INT INSTEAD OF FLOAT OR KEEP TEXT
	currency_type TEXT NOT NULL,
	payment_method SMALLINT NOT NULL REFERENCES gtfs_test.e_payment_methods(payment_method),
	transfers SMALLINT NOT NULL REFERENCES gtfs_test.e_transfers(transfer),
	agency_id TEXT REFERENCES gtfs_test.real_transitland_agency(agency_id),
	transfer_duration INT,
	PRIMARY KEY(file_id, fare_id)
);

SELECT * FROM gtfs_test.transitland_fare_attributes
SELECT * FROM gtfs_test.real_transitland_fare_attributes



CREATE TABLE gtfs_test.real_transitland_fare_rules (
	file_id INT REFERENCES gtfs_test.real_gtfs_files(file_id),
	fare_id TEXT NOT NULL REFERENCES gtfs_test.real_transitland_fare_attributes(fare_id),
	route_id TEXT REFERENCES gtfs_test.real_transitland_routes(route_id),
	origin_id TEXT REFERENCES gtfs_test.real_transitland_stops(zone_id),
	destination_id TEXT REFERENCES gtfs_test.real_transitland_stops(zone_id),
	contains_id TEXT REFERENCES gtfs_test.real_transitland_stops(zone_id),
	PRIMARY KEY(file_id, fare_id, route_id, origin_id, destination_id, contains_id)
);

SELECT * FROM gtfs_test.transitland_fare_rules
SELECT * FROM gtfs_test.real_transitland_fare_rules


CREATE TABLE gtfs_test.real_transitland_trips (
	file_id INT REFERENCES gtfs_test.real_gtfs_files(file_id),
	route_id TEXT NOT NULL REFERENCES gtfs_test.real_transitland_routes(route_id),
	service_id TEXT NOT NULL, -- REFERENCES real_transitland_calendar(service_id) OR REFERENCES real_transitland_calendar_dates(service_id)
	trip_id TEXT NOT NULL,
	trip_headsign TEXT,
	trip_short_name TEXT,
	direction_id SMALLINT REFERENCES gtfs_test.e_direction_ids(direction_id),
	block_id TEXT,
	shape_id TEXT REFERENCES gtfs_test.real_transitland_shapes(shape_id),
	wheelchair_accessible SMALLINT REFERENCES gtfs_test.e_wheelchair_accessibility(wheelchair_accessible),
	bikes_allowed SMALLINT REFERENCES gtfs_test.e_bikes_allowed(bikes_allowed),
	PRIMARY KEY(file_id, trip_id)
);

SELECT * FROM gtfs_test.transitland_trips
SELECT * FROM gtfs_test.real_transitland_trips



CREATE TABLE gtfs_test.real_transitland_stop_times (
	file_id INT REFERENCES gtfs_test.real_gtfs_files(file_id),
	trip_id TEXT REFERENCES gtfs_test.real_transitland_trips(trip_id) NOT NULL,
	arrival_time INTERVAL,
	departure_time INTERVAL,
	stop_id TEXT REFERENCES gtfs_test.real_transitland_stops(stop_id) NOT NULL,
	stop_sequence INT NOT NULL,
	stop_headsign TEXT,
	pickup_type SMALLINT REFERENCES gtfs_test.e_pickup_types(pickup_type),
	drop_off_type SMALLINT REFERENCES gtfs_test.e_drop_odd_types(drop_off_type),
	continuous_pickup SMALLINT REFERENCES gtfs_test.e_continuous_pickup(continuous_pickup),
	continuous_drop_off SMALLINT REFERENCES gtfs_test.e_continuous_drop_off(continuous_drop_off),
	shape_dist_traveled FLOAT,
	timepoint SMALLINT REFERENCES gtfs_test.e_timepoints(timepoint),
	PRIMARY KEY(file_id, trip_id, stop_sequence)
);

SELECT * FROM gtfs_test.transitland_stop_times
SELECT * FROM gtfs_test.real_transitland_stop_times



CREATE TABLE gtfs_test.real_transitland_timeframes (
	file_id INT REFERENCES gtfs_test.real_gtfs_files(file_id),
	timeframe_group_id TEXT NOT NULL,
	start_time TIME,  -- KEEP TIME FOR THESE
	end_time TIME, 
	service_id TEXT NOT NULL -- REFERENCES real_transitland_calendar(service_id) OR REFERENCES real_transitland_calendar_dates(service_id)
	PRIMARY KEY(file_id, timeframe_group_id, start_time, end_time, service_id)
);

SELECT * FROM gtfs_test.transitland_timeframes
SELECT * FROM gtfs_test.real_transitland_timeframes



CREATE TABLE gtfs_test.real_transitland_fare_products (
	file_id INT REFERENCES gtfs_Test.real_gtfs_files(file_id),
	fare_product_id TEXT NOT NULL,
	fare_product_name TEXT,
	fare_media_id TEXT REFERENCES gtfs_test.real_transitland_fare_media(fare_media_id),
	amount NUMERIC(7,2) NOT NULL,
	currency TEXT NOT NULL,
	PRIMARY KEY(file_id, fare_product_id, fare_media_id)
);

SELECT * FROM gtfs_test.transitland_fare_products
SELECT * FROM gtfs_test.real_transitland_fare_products


CREATE TABLE gtfs_test.real_transitland_fare_leg_rules (
	file_id INT REFERENCES gtfs_test.real_gtfs_files(file_id),
	leg_group_id TEXT,
	network_id TEXT, -- REFERENCES real_transitland_networks(network_id) OR REFERENCES real_transitland_routes(network_id)
	from_area_id TEXT REFERENCES gtfs_test.real_transitland_areas(area_id),
	to_area_id TEXT REFERENCES gtfs_test.real_transitland_areas(area_id),
	from_timeframe_group_id TEXT REFERENCES gtfs_test.real_transitland_timeframes(timeframe_group_id),
	to_timeframe_group_id TEXT REFERENCES gtfs_test.real_transitland_timeframes(timeframe_group_id),
	fare_product_id TEXT REFERENCES gtfs_test.real_transitland_fare_products(fare_product_id) NOT NULL,
	PRIMARY KEY(file_id, network_id, from_area_id, to_area_id, from_timeframe_group_id, to_timeframe_group_id, fare_product_id)
);

SELECT * FROM gtfs_test.transitland_fare_leg_rules
SELECT * FROM gtfs_test.real_transitland_fare_leg_rules


CREATE TABLE gtfs_test.real_transitland_fare_transfer_rules (
	file_id INT REFERENCES gtfs_test.real_gtfs_files(file_id),
	from_leg_group_id TEXT REFERENCES gtfs_test.real_transitland_fare_leg_rules(leg_group_id),
	to_leg_group_id TEXT REFERENCES gtfs_test.real_transitland_fare_leg_rules(leg_group_id),
	transfer_count INT,
	duration_limit INT,
	duration_limit_type SMALLINT REFERENCES gtfs_test.e_duration_limit_types(duration_limit_type), 
	fare_transfer_type SMALLINT REFERENCES gtfs_test.e_fare_transfer_types(fare_transfer_type) NOT NULL,
	fare_product_id TEXT REFERENCES gtfs_test.real_transitland_fare_products(fare_product_id),
	PRIMARY KEY(file_id, from_leg_group_id, to_leg_group_id, fare_product_id, transfer_count, duration_limit)
);

SELECT * FROM gtfs_test.transitland_fare_transfer_rules
SELECT * FROM gtfs_test.real_transitland_fare_transfer_rules



CREATE TABLE gtfs_test.real_transitland_areas (
	file_id INT REFERENCES gtfs_test.real_gtfs_files(file_id),
	area_id TEXT NOT NULL,
	area_name TEXT,
	PRIMARY KEY(file_id, area_id)
);

SELECT * FROM gtfs_test.transitland_areas
SELECT * FROM gtfs_test.real_transitland_areas


CREATE TABLE gtfs_test.real_transitland_stop_areas (
	file_id INT REFERENCES gtfs_test.real_gtfs_files(file_id),
	area_id TEXT REFERENCES gtfs_test.real_transitland_areas(area_id) NOT NULL,
	stop_id TEXT REFERENCES gtfs_test.real_transitland_stops(stop_id) NOT NULL,
	PRIMARY KEY(file_id, area_id, stop_id)
);

SELECT * FROM gtfs_test.transitland_stop_areas
SELECT * FROM gtfs_test.real_transitland_stop_areas



CREATE TABLE gtfs_test.real_transitland_route_networks (
	file_id INT REFERENCES gtfs_test.real_gtfs_files(file_id),
	network_id TEXT REFERENCES gtfs_test.real_transitland_networks(network_id) NOT NULL,
	route_id TEXT REFERENCES gtfs_test.real_transitland_routes(route_id) NOT NULL,
	PRIMARY KEY(file_id, route_id)
);

SELECT * FROM gtfs_test.transitland_route_networks
SELECT * FROM gtfs_test.real_transitland_route_networks


CREATE TABLE gtfs_test.real_transitland_frequencies (
	file_id INT REFERENCES gtfs_test.real_gtfs_files(file_id),
	trip_id TEXT REFERENCES gtfs_test.real_transitland_trips(trip_id) NOT NULL,
	start_time INTERVAL NOT NULL, 
	end_time INTERVAL NOT NULL,
	headway_secs INT NOT NULL,
	exact_times SMALLINT REFERENCES gtfs_test.e_exact_times(exact_times),
	PRIMARY KEY(file_id, trip_id, start_time)
);

SELECT * FROM gtfs_test.transitland_frequencies
SELECT * FROM gtfs_test.real_transitland_frequencies



CREATE TABLE gtfs_test.real_transitland_transfers (
	file_id INT REFERENCES gtfs_test.real_gtfs_files(file_id),
	from_stop_id TEXT REFERENCES gtfs_test.real_transitland_stops(stop_id),
	to_stop_id TEXT REFERENCES gtfs_test.real_transitland_stops(stop_id), 
	from_route_id TEXT REFERENCES gtfs_test.real_transitland_routes(route_id),
	to_route_id TEXT REFERENCES gtfs_test.real_transitland_routes(route_id), 
	from_trip_id TEXT REFERENCES gtfs_test.real_transitland_trips(trip_id), 
	to_trip_id TEXT REFERENCES gtfs_test.real_transitland_trips(trip_id),
	transfer_type SMALLINT REFERENCES gtfs_test.e_transfer_types(transfer_type) NOT NULL,
	min_transfer_time INT,
	PRIMARY KEY(file_id, from_stop_id, to_stop_id, from_trip_id, to_trip_id, from_route_id, to_route_id)
);

SELECT * FROM gtfs_test.transitland_transfers
SELECT * FROM gtfs_test.real_transitland_transfers



CREATE TABLE gtfs_test.real_transitland_pathways (
	file_id INT REFERENCES gtfs_test.real_gtfs_files(file_id),
	pathway_id TEXT NOT NULL,
	from_stop_id TEXT REFERENCES gtfs_test.real_transitland_stops(stop_id) NOT NULL,
	to_stop_id TEXT REFERENCES gtfs_test.real_transitland_stops(stop_id) NOT NULL,
	pathway_mode SMALLINT NOT NULL REFERENCES gtfs_test.e_patyhway_modes(pathway_mode),
	is_bidirectional SMALLINT NOT NULL REFERENCES gtfs_test.e_is_bidirectional(is_bidirectional),
	length FLOAT,
	traversal_time INT,
	stair_count INT NOT NULL,
	max_slope FLOAT,
	min_width FLOAT,
	signposted_as TEXT,
	reversed_signposted_as TEXT,
	PRIMARY KEY(file_id, pathway_id)
);

SELECT * FROM gtfs_test.transitland_pathways
SELECT * FROM gtfs_test.real_transitland_pathways



CREATE TABLE gtfs_test.real_transitland_attributions (
	file_id INT REFERENCES gtfs_test.real_gtfs_files(file_id),
	attribution_id TEXT,
	agency_id TEXT REFERENCES gtfs_test.real_transitland_agency(agency_id), 
	route_id TEXT REFERENCES gtfs_test.real_transitland_routes(route_id), 
	trip_id TEXT REFERENCES gtfs_test.real_transitland_trips(trip_id), 
	organization_name TEXT NOT NULL,
	is_producer SMALLINT REFERENCES gtfs_test.e_is_role(is_role),
	is_operator SMALLINT REFERENCES gtfs_test.e_is_role(is_role),
	is_authority SMALLINT REFERENCES gtfs_test.e_is_role(is_role),
	attribution_url TEXT,
	attribution_email TEXT,
	attribution_phone TEXT,
	PRIMARY KEY(file_id, attribution_id)
);

SELECT * FROM gtfs_test.transitland_attributions
SELECT * FROM gtfs_test.real_transitland_attributions


SELECT * FROM gtfs_test.real_transitland_agency;
SELECT * FROM gtfs_test.real_transitland_stops;
SELECT * FROM gtfs_test.real_transitland_routes;
SELECT * FROM gtfs_test.real_transitland_calendar;
SELECT * FROM gtfs_test.real_transitland_calendar_dates;
SELECT * FROM gtfs_test.real_transitland_shapes;
SELECT * FROM gtfs_test.real_transitland_fare_attributes;
SELECT * FROM gtfs_test.real_transitland_fare_rules;
SELECT * FROM gtfs_test.real_transitland_trips;
SELECT * FROM gtfs_test.real_transitland_stop_times;
SELECT * FROM gtfs_test.real_transitland_timeframes;
SELECT * FROM gtfs_test.real_transitland_fare_media;
SELECT * FROM gtfs_test.real_transitland_fare_products;
SELECT * FROM gtfs_test.real_transitland_fare_leg_rules;
SELECT * FROM gtfs_test.real_transitland_fare_transfer_rules;
SELECT * FROM gtfs_test.real_transitland_areas;
SELECT * FROM gtfs_test.real_transitland_stop_areas;
SELECT * FROM gtfs_test.real_transitland_networks;
SELECT * FROM gtfs_test.real_transitland_route_networks;
SELECT * FROM gtfs_test.real_transitland_frequencies;
SELECT * FROM gtfs_test.real_transitland_transfers;
SELECT * FROM gtfs_test.real_transitland_pathways;
SELECT * FROM gtfs_test.real_transitland_levels;
SELECT * FROM gtfs_test.real_transitland_translations;
SELECT * FROM gtfs_test.real_transitland_feed_info;
SELECT * FROM gtfs_test.real_transitland_attributions;
