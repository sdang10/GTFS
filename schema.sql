---------------------------------------------------------------------------
SELECT * FROM gtfs.v_transitland_feed_info;
---------------------------------------------------------------------------
-- NOTES:
	-- SEATTLESHILDRENSHOSPITALSHUTTLE DATA STARTS AFTER APRIL 3rd 2020

-- TEMP TABLES FOR A STRAIGHT FORWARD IMPORT

--DROP TABLE _import.gtfs_extra_files;
--DROP TABLE _import.gtfs_extra_attributes;
--DROP TABLE _import.gtfs_transitland_feeds;

--DROP TABLE _import.gtfs_tl_stop_times; 
--DROP TABLE _import.gtfs_tl_trips;
--DROP TABLE _import.gtfs_tl_shapes;
--DROP TABLE _import.gtfs_tl_calendar_dates;
--DROP TABLE _import.gtfs_tl_calendar;
--DROP TABLE _import.gtfs_tl_routes;
--DROP TABLE _import.gtfs_tl_stops;
--DROP TABLE _import.gtfs_tl_agency;
--DROP TABLE _import.gtfs_tl_feed_info;
--DROP TABLE _import.gtfs_tl_transfers;
--DROP TABLE _import.gtfs_tl_fare_attributes;
--DROP TABLE _import.gtfs_tl_fare_rules;
--DROP TABLE _import.gtfs_tl_frequencies;
--DROP TABLE _import.gtfs_tl_areas;
--DROP TABLE _import.gtfs_tl_timeframes;
--DROP TABLE _import.gtfs_tl_fare_media;
--DROP TABLE _import.gtfs_tl_fare_products;
--DROP TABLE _import.gtfs_tl_fare_leg_rules;
--DROP TABLE _import.gtfs_tl_fare_transfer_rules;
--DROP TABLE _import.gtfs_tl_stop_areas;
--DROP TABLE _import.gtfs_tl_networks;
--DROP TABLE _import.gtfs_tl_route_networks;
--DROP TABLE _import.gtfs_tl_pathways;
--DROP TABLE _import.gtfs_tl_levels;
--DROP TABLE _import.gtfs_tl_attributions;
--DROP TABLE _import.gtfs_tl_translations;


CREATE TABLE _import.gtfs_tl_bad_feeds (
	id TEXT
);

CREATE TABLE _import.gtfs_transitland_feeds (
	id TEXT,
	agency_id TEXT,
	fetched_at TEXT,
	earliest_calendar_date TEXT,
	latest_calendar_date TEXT,
	sha1 TEXT,
	url TEXT
);

--CREATE TABLE _import.gtfs_extra_attributes (
--    feed_id TEXT,
--   	file_name TEXT,
--    column_name TEXT,
--    value TEXT
--);

CREATE TABLE _import.gtfs_tl_extra_files (
	feed_id TEXT,
	file_name TEXT
);

CREATE TABLE _import.gtfs_tl_agency (
	agency_id TEXT,
	agency_name TEXT,
	agency_url TEXT,
	agency_timezone TEXT,
	agency_lang TEXT,
	agency_phone TEXT,
	agency_fare_url TEXT,
	agency_email TEXT
);

CREATE TABLE _import.gtfs_tl_stops (
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

CREATE TABLE _import.gtfs_tl_routes (
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

CREATE TABLE _import.gtfs_tl_calendar (
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

CREATE TABLE _import.gtfs_tl_calendar_dates (
	service_id TEXT, 
	date TEXT, 
	exception_type TEXT
);

CREATE TABLE _import.gtfs_tl_shapes (
	shape_id TEXT, 
	shape_pt_lat TEXT,
	shape_pt_lon TEXT,
	shape_pt_sequence TEXT, 
	shape_dist_traveled TEXT
);

CREATE TABLE _import.gtfs_tl_trips (
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

CREATE TABLE _import.gtfs_tl_stop_times (
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

CREATE TABLE _import.gtfs_tl_transfers (
	from_stop_id TEXT,
	to_stop_id TEXT,
	from_route_id TEXT,
	to_route_id TEXT,
	from_trip_id TEXT,
	to_trip_id TEXT,
	transfer_type TEXT,
	min_transfer_time TEXT
);

CREATE TABLE _import.gtfs_tl_feed_info (
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

CREATE TABLE _import.gtfs_tl_fare_attributes (
	fare_id TEXT,
	price TEXT,
	currency_type TEXT,
	payment_method TEXT,
	transfers TEXT,
	agency_id TEXT,
	transfer_duration TEXT
);

CREATE TABLE _import.gtfs_tl_fare_rules (
	fare_id TEXT,
	route_id TEXT, 
	origin_id TEXT,
	destination_id TEXT,
	contains_id TEXT
);

CREATE TABLE _import.gtfs_tl_frequencies (
	trip_id TEXT,
	start_time TEXT,
	end_time TEXT,
	headway_secs TEXT,
	exact_times TEXT
);

CREATE TABLE _import.gtfs_tl_areas (
	area_id TEXT,
	area_name TEXT
);

CREATE TABLE _import.gtfs_tl_timeframes (
	timeframe_group_id TEXT,
	start_time TEXT,
	end_time TEXT,
	service_id TEXT
);

CREATE TABLE _import.gtfs_tl_fare_media (
	fare_media_id TEXT,
	fare_media_name TEXT,
	fare_media_type TEXT
);

--CREATE TABLE _import.gtfs_tl_fare_products (
--	fare_product_id TEXT,
--	fare_product_name TEXT,
--	fare_media_id TEXT,
--	amount TEXT,
--	currency TEXT
--);

CREATE TABLE _import.gtfs_tl_fare_leg_rules (
	leg_group_id TEXT,
	network_id TEXT,
	from_area_id TEXT, 
	to_area_id TEXT,
	from_timeframe_group_id TEXT,
	to_timeframe_group_id TEXT,
	fare_product_id TEXT
);

CREATE TABLE _import.gtfs_tl_fare_transfer_rules (
	from_leg_group_id TEXT, 
	to_leg_group_id TEXT,
	transfer_count TEXT,
	duration_limit TEXT,
	duration_limit_type TEXT,
	fare_transfer_type TEXT,
	fare_product_id TEXT
);

CREATE TABLE _import.gtfs_tl_stop_areas (
	area_id TEXT,
	stop_id TEXT
);

CREATE TABLE _import.gtfs_tl_networks (
	network_id TEXT,
	network_name TEXT
);

CREATE TABLE _import.gtfs_tl_route_networks (
	network_id TEXT,
	route_id TEXT
);

CREATE TABLE _import.gtfs_tl_pathways (
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

CREATE TABLE _import.gtfs_tl_levels (
	level_id TEXT,
	level_index TEXT,
	level_name TEXT
);

CREATE TABLE _import.gtfs_tl_translations (
	table_name TEXT,
	field_name TEXT,
	language TEXT,
	TRANSLATION TEXT,
	record_id TEXT,
	record_sub_id TEXT,
	field_value TEXT
);

CREATE TABLE _import.gtfs_tl_attributions (
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



---------------------------------------------------------------------------

-- ALL TABLES FOR COLUMNS THAT PERTAIN TO ENUMERATOR VALUES


CREATE TABLE gtfs.e_location_types(
	location_type SMALLINT PRIMARY KEY,
	location_descr TEXT
);
-- SELECT * FROM gtfs.e_location_types

CREATE TABLE gtfs.e_wheelchair_boardings(
	wheelchair_boarding SMALLINT PRIMARY KEY,
	wheelchair_boarding_descr TEXT
);
-- SELECT * FROM gtfs.e_wheelchair_boardings 

CREATE TABLE gtfs.e_route_types (
	route_type SMALLINT PRIMARY KEY,
	route_type_descr TEXT
);
-- SELECT * FROM gtfs.e_route_types

CREATE TABLE gtfs.e_continuous_pickup (
	continuous_pickup SMALLINT PRIMARY KEY,
	continuous_pickup_descr TEXT
);
-- SELECT * FROM gtfs.e_continuous_pickup

CREATE TABLE gtfs.e_continuous_drop_off (
	continuous_drop_off SMALLINT PRIMARY KEY,
	continuous_drop_off_descr TEXT
);
-- SELECT * FROM gtfs.e_continuous_drop_off

CREATE TABLE gtfs.e_service_availability (
	service_availability SMALLINT PRIMARY KEY,
	service_availability_descr TEXT
);
-- SELECT * FROM gtfs.e_service_availability

CREATE TABLE gtfs.e_exception_types (
	exception_type SMALLINT PRIMARY KEY,
	exception_type_descr TEXT
);
-- SELECT * FROM gtfs.e_exception_types

CREATE TABLE gtfs.e_payment_methods(
	payment_method SMALLINT PRIMARY KEY,
	payment_method_descr TEXT
);
-- SELECT * FROM gtfs.e_payment_methods

CREATE TABLE gtfs.e_transfers(
	transfer SMALLINT PRIMARY KEY,
	transfer_descr TEXT
);
-- SELECT * FROM gtfs.e_transfers

CREATE TABLE gtfs.e_direction_ids (
	direction_id SMALLINT PRIMARY KEY,
	direction_id_descr TEXT
);
-- SELECT * FROM gtfs.e_direction_ids

CREATE TABLE gtfs.e_wheelchair_accessibility(
	wheelchair_accessibility SMALLINT PRIMARY KEY,
	wheelchair_accessibility_descr TEXT
);
-- SELECT * FROM gtfs.e_wheelchair_accessibility

CREATE TABLE gtfs.e_bikes_allowed(
	bikes_allowed SMALLINT PRIMARY KEY,
	bikes_allowed_descr TEXT
);
-- SELECT * FROM gtfs.e_bikes_allowed

CREATE TABLE gtfs.e_pickup_types(
	pickup_type SMALLINT PRIMARY KEY,
	pickup_type_descr TEXT
);
-- SELECT * FROM gtfs.e_pickup_types

CREATE TABLE gtfs.e_drop_off_types(
	drop_off_type SMALLINT PRIMARY KEY,
	drop_off_type_descr TEXT
);
-- SELECT * FROM gtfs.e_drop_off_types

CREATE TABLE gtfs.e_timepoints (
	timepoint SMALLINT PRIMARY KEY,
	timepoint_descr TEXT
);
-- SELECT * FROM gtfs.e_timepoints

CREATE TABLE gtfs.e_fare_media_types(
	fare_media_type SMALLINT PRIMARY KEY,
	fare_media_type_descr TEXT
);
-- SELECT * FROM gtfs.e_fare_media_types

CREATE TABLE gtfs.e_duration_limit_types(
	duration_limit_type SMALLINT PRIMARY KEY,
	duration_limit_type_descr TEXT
);
-- SELECT * FROM gtfs.e_duration_limit_types

CREATE TABLE gtfs.e_fare_transfer_types(
	fare_transfer_type SMALLINT PRIMARY KEY,
	fare_transfer_type_descr TEXT
);
-- SELECT * FROM gtfs.e_fare_transfer_types

CREATE TABLE gtfs.e_exact_times (
	exact_times SMALLINT PRIMARY KEY,
	exact_times_descr TEXT
);
-- SELECT * FROM gtfs.e_exact_times

CREATE TABLE gtfs.e_transfer_types(
	transfer_type SMALLINT PRIMARY KEY,
	transfer_type_descr TEXT
);
-- SELECT * FROM gtfs.e_transfer_types

CREATE TABLE gtfs.e_pathway_modes (
	pathway_mode SMALLINT PRIMARY KEY,
	pathway_mode_descr TEXT
);
-- SELECT * FROM gtfs.e_pathway_modes

CREATE TABLE gtfs.e_is_bidirectional (
	is_bidirectional SMALLINT PRIMARY KEY,
	is_bidirectional_descr TEXT
);
-- SELECT * FROM gtfs.e_is_bidirectional

CREATE TABLE gtfs.e_is_role (
	is_role SMALLINT PRIMARY KEY,
	is_role_descr TEXT
);
-- SELECT * FROM gtfs.e_is_role


---------------------------------------------------------------------------------------------

-- INSERTING THE VALUES INTO THE TABLES

INSERT INTO gtfs.e_location_types VALUES
	(-1, 'nan'),
	(0, 'stop or platform'),
	(1, 'station'),
	(2, 'entrance or exit'),
	(3, 'generic node'),
	(4, 'boarding area');

INSERT INTO gtfs.e_wheelchair_boardings VALUES
	(-1, 'nan'),
	(0, 'parentless stops: no info; 
child stops: inherit wheelchair_boarding behavior from parent station; 
stations entrance/exits: inherit wheelchair_boarding behavior from parent station'),
	(1, 'parentless stops: some vehicles at this stop can be boarded by a rider in wheelchair; 
child stops: some accessible path from outside the station to the specific stop/platform; 
stations entrance/exits: entrance is wheelchair accessible'),
	(2, 'parentless stops: wheelchair boarding not possible at this stop; 
child stops: no accessible path from outside the station to the specific stop/platform; 
stations entrance/exits: no accessible path from station entrance to stops/platforms');

INSERT INTO gtfs.e_route_types VALUES 
	(0, 'Tram, Streetcar, Light rail. Any light rail or street level system within a metropolitan area'),
	(1, 'Subway, Metro. Any underground rail system within a metropolitan area'),
	(2, 'Rail. Used for intercity or long-distance travel'),
	(3, 'Bus. Used for short- and long-distance bus routes'),
	(4, 'Ferry. Used for short- and long-distance boat service'),
	(5, 'Cable tram. Used for street-level rail cars where the cable runs beneath the vehicle (e.g., cable car in San Francisco)'),
	(6, 'Aerial lift, suspended cable car (e.g., gondola lift, aerial tramway). Cable transport where cabins, cars, gondolas or open chairs are suspended by means of one or more cables'),
	(7, 'Funicular. Any rail system designed for steep inclines'),
	(11, 'Trolleybus. Electric buses that draw power from overhead wires using poles'),
	(12, 'Monorail. Railway in which the track consists of a single rail or a beam');

INSERT INTO gtfs.e_continuous_pickup VALUES 
	(-2, 'illegal value'),
	(-1, 'nan'),
	(0, 'continuous stopping pickup'),
	(1, 'no continuous stopping pickup'),
	(2, 'must phone agency to arrange continuous stopping pickup'),
	(3, 'must coordinate with driver to arrange continuous stopping pickup');

INSERT INTO gtfs.e_continuous_drop_off VALUES 
	(-2, 'illegal value'),
	(-1, 'nan'),
	(0, 'continuous stopping drop off'),
	(1, 'no continuous stopping drop off'),
	(2, 'must phone agency to arrange continuous stopping drop off'),
	(3, 'must coordinate with driver to arrange continuous stopping drop off');

INSERT INTO gtfs.e_service_availability VALUES 
	(0, 'service not available for all of this week day in the date range'),
	(1, 'service is available for all of this week day in the date range');

INSERT INTO gtfs.e_exception_types VALUES
	(1, 'service has been added for the specified date'),
	(2, 'service has been removed for the specified date');

INSERT INTO gtfs.e_payment_methods VALUES
	(0, 'fair is paid on board'),
	(1, 'fair must be paid before boarding');

INSERT INTO gtfs.e_transfers VALUES 
	(-1, 'nan'),
	(0, 'no transfers permitted'),
	(1, 'riders may transfer once'),
	(2, 'riders may transfer twice'),
	(99, 'unlimited transfers are permitted');

INSERT INTO gtfs.e_direction_ids VALUES
	(0, 'travel in one direction (e.g. outbound travel)'),
	(1, 'travel in the opposite direction (e.g. inbound travel)');

INSERT INTO gtfs.e_wheelchair_accessibility VALUES
	(-1, 'nan'),
	(0, 'no accessibility info'),
	(1, 'vehicle being used on this particular trip can accommodate at least one rider in a wheelchair'),
	(2, 'no riders in wheelchairs can be accommodated on this trip');

INSERT INTO gtfs.e_bikes_allowed VALUES
	(-1, 'nan'),
	(0, 'no bike info'),
	(1, 'vehicle being used on this particular trip can accommodate at least one bicycle'),
	(2, 'no bicycles allowed on this trip');

INSERT INTO gtfs.e_pickup_types VALUES 
	(-1, 'nan'),
	(0, 'regularly_scheduled_pickup'),
	(1, 'no pickup available'),
	(2, 'must phone agency to arrange pickup'),
	(3, 'must coordinate with driver to arrange pickup');

INSERT INTO gtfs.e_drop_off_types VALUES 
	(-1, 'nan'),
	(0, 'regularly scheduled drop off'),
	(1, 'no drop off available'),
	(2, 'must phone agency to arrange drop off'),
	(3, 'must coordinate with driver to arrange drop off');

INSERT INTO gtfs.e_timepoints VALUES 
	(0, 'times are considered approximated'),
	(1, 'times are considered exact');

INSERT INTO gtfs.e_fare_media_types VALUES 
	(0, 'none, no fare media involved in purchasing or validating a fare product, such as paying cash to a driver or conductor with no physical ticket provided'),
	(1, 'Physical paper ticket that allows a passenger to take either a certain number of pre-purchased trips or unlimited trips within a fixed period of time'),
	(2, 'Physical transit card that has stored tickets, passes or monetary value'),
	(3, 'cEMV (contactless Europay, Mastercard and Visa) as an open-loop token container for account-based ticketing'),
	(4, 'Mobile app that have stored virtual transit cards, tickets, passes, or monetary value');

INSERT INTO gtfs.e_duration_limit_types VALUES
	(0, 'Between the departure fare validation of the current leg and the arrival fare validation of the next leg'),
	(1, 'Between the departure fare validation of the current leg and the departure fare validation of the next leg'),
	(2, 'Between the arrival fare validation of the current leg and the departure fare validation of the next leg'),
	(3, 'Between the arrival fare validation of the current leg and the arrival fare validation of the next leg');

INSERT INTO gtfs.e_fare_transfer_types VALUES 
	(0, 'From-leg fare_leg_rules.fare_product_id plus fare_transfer_rules.fare_product_id; A + AB'),
	(1, 'From-leg fare_leg_rules.fare_product_id plus fare_transfer_rules.fare_product_id plus to-leg fare_leg_rules.fare_product_id; A + AB + B'),
	(2, 'fare_transfer_rules.fare_product_id; AB');

INSERT INTO gtfs.e_exact_times VALUES 
	(0, 'frequency-based trips'),
	(1, 'schedule-based trips with the exact same headway throughout the day');

INSERT INTO gtfs.e_transfer_types VALUES 
	(0, 'Recommended transfer point between routes'),
	(1, 'Timed transfer point between two routes. The departing vehicle is expected to wait for the arriving one and leave sufficient time for a rider to transfer between routes'),
	(2, 'Transfer requires a minimum amount of time between arrival and departure to ensure a connection. The time required to transfer is specified by min_transfer_time'),
	(3, 'Transfers are not possible between routes at the location'),
	(4, 'Passengers can transfer from one trip to another by staying onboard the same vehicle (an in-seat transfer)'),
	(5, 'In-seat transfers are not allowed between sequential trips. The passenger must alight from the vehicle and re-board');

INSERT INTO gtfs.e_pathway_modes VALUES
	(1, 'walkway'),
	(2, 'stairs'),
	(3, 'moving sidewalk/travelator'),
	(4, 'escalator'),
	(5, 'elevator'),
	(6, 'fare gate (or payment gate): A pathway that crosses into an area of the station where proof of payment is required to cross. Fare gates may separate paid areas of the station from unpaid ones, or separate different payment areas within the same station from each other. This information can be used to avoid routing passengers through stations using shortcuts that would require passengers to make unnecessary payments, like directing a passenger to walk through a subway platform to reach a busway'),
	(7, 'exit gate: pathway exiting paid area into an unpaid area where proof of paymen is not required to cross');

INSERT INTO gtfs.e_is_bidirectional VALUES 
	(0, 'unidirectional pathway that can only be used from from_stop_id to to_stop_id'),
	(1, 'bidirectional pathway that can be used in both directions');

INSERT INTO gtfs.e_is_role VALUES 
	(0, 'organization does not have this role'),
	(1, 'organization does have this role');



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- REAL FILE TABLES WITH PRIMARY KEYS, REFERENCES, AND CORRECT VARIABLE TYPES


--DROP TABLE gtfs.tl_extra_attributes;
--DROP TABLE gtfs.tl_extra_files;
--DROP TABLE gtfs.transitland_feeds;

--DROP TABLE gtfs.tl_feed_info;
--DROP TABLE gtfs.tl_networks;
--DROP TABLE gtfs.tl_translations;
--DROP TABLE gtfs.tl_fare_media;
--DROP TABLE gtfs.tl_shapes;
--DROP TABLE gtfs.tl_calendar;
--DROP TABLE gtfs.tl_levels;
--DROP TABLE gtfs.tl_agency;
--DROP TABLE gtfs.tl_areas;
--DROP TABLE gtfs.tl_stop_times; 
--DROP TABLE gtfs.tl_trips ;
--DROP TABLE gtfs.tl_fare_rules ;
--DROP TABLE gtfs.tl_fare_attributes;
--DROP TABLE gtfs.tl_calendar_dates;
--DROP TABLE gtfs.tl_routes;
--DROP TABLE gtfs.tl_stops;
--DROP TABLE gtfs.tl_frequencies;
--DROP TABLE gtfs.tl_transfers;
--DROP TABLE gtfs.tl_timeframes;
--DROP TABLE gtfs.tl_fare_products;
--DROP TABLE gtfs.tl_fare_leg_rules;
--DROP TABLE gtfs.tl_fare_transfer_rules;
--DROP TABLE gtfs.tl_stop_areas;
--DROP TABLE gtfs.tl_route_networks;
--DROP TABLE gtfs.tl_pathways;
--DROP TABLE gtfs.tl_attributions;


--CREATE TABLE gtfs.transitland_feeds (
--	feed_id INT NOT NULL PRIMARY KEY,
--	agency_id SMALLINT,
--	fetched_at TEXT,
--	earliest_calendar_date DATE,
--	latest_calendar_date DATE,
--	sha1 TEXT,
--	url TEXT
--);
-- SELECT * FROM _import.gtfs_feeds
-- SELECT * FROM gtfs.transitland_feeds

--CREATE TABLE gtfs.real_gtfs_extra_attributes (
--    feed_id INT NOT NULL REFERENCES gtfs.transitland_feeds(feed_id),
--   	file_name TEXT,
--    column_name TEXT,
--    value TEXT
--);
-- SELECT * FROM _import.gtfs_extra_attributes
-- SELECT * FROM gtfs.real_gtfs_extra_attributes 

CREATE TABLE gtfs.tl_bad_feeds (
	id INT NOT NULL,
	PRIMARY KEY(id)
);

CREATE TABLE gtfs.tl_extra_files (
	feed_id INT NOT NULL,-- INT NOT NULL REFERENCES gtfs.transitland_feeds(feed_id),
	file_name TEXT
);
-- SELECT * FROM _import.gtfs_tl_extra_files
-- SELECT * FROM gtfs.tl_extra_files



CREATE TABLE gtfs.tl_agency (
	feed_id INT NOT NULL,-- INT NOT NULL REFERENCES gtfs.transitland_feeds(feed_id),
	agency_id TEXT NOT NULL, -- conditionally required?
	agency_name TEXT NOT NULL,
	agency_url TEXT NOT NULL,
	agency_timezone TEXT NOT NULL,
	agency_lang TEXT,
	agency_phone TEXT,
	agency_fare_url TEXT,
	agency_email TEXT,
	PRIMARY KEY(feed_id, agency_id)
);
-- SELECT * FROM _import.gtfs_tl_agency
-- SELECT * FROM gtfs.tl_agency

CREATE TABLE gtfs.tl_feed_info (
	feed_id INT NOT NULL, -- INT NOT NULL REFERENCES gtfs.transitland_feeds(feed_id),
	feed_publisher_name TEXT NOT NULL,
	feed_publisher_url TEXT NOT NULL,
	feed_lang TEXT NOT NULL,
	default_lang TEXT,
	feed_start_date DATE,
	feed_end_date DATE,
	feed_version TEXT,
	feed_contact_email TEXT,
	feed_contact_url TEXT
);
-- SELECT * FROM _import.gtfs_tl_feed_info
-- SELECT * FROM gtfs.tl_feed_info

CREATE TABLE gtfs.tl_translations (
	feed_id INT NOT NULL, -- NOT NULL REFERENCES gtfs.transitland_feeds(feed_id),
	table_name TEXT NOT NULL, -----------------------????? ENUM allowed VALUES ARE: agency, stops, routes, trips, stop_times, pathways, levels, feed_info, attributions
	field_name TEXT NOT NULL,
	language TEXT NOT NULL,
	TRANSLATION TEXT NOT NULL,
	record_id TEXT, -- conditionally required
	record_sub_id TEXT, -- conditionally required
	field_value TEXT, -- conditionally required
	PRIMARY KEY(feed_id, table_name, field_name, language, record_id, record_sub_id, field_value)
);
-- SELECT * FROM _import.gtfs_tl_translations
-- SELECT * FROM gtfs.tl_translations

CREATE TABLE gtfs.tl_networks (
	feed_id INT NOT NULL, -- INT NOT NULL REFERENCES gtfs.transitland_feeds(feed_id),
	network_id TEXT NOT NULL,
	network_name TEXT,
	PRIMARY KEY(feed_id, network_id)
);
-- SELECT * FROM _import.gtfs_tl_networks
-- SELECT * FROM gtfs.tl_networks

CREATE TABLE gtfs.tl_fare_media (
	feed_id INT NOT NULL, -- INT NOT NULL REFERENCES gtfs.transitland_feeds(feed_id),
	fare_media_id TEXT NOT NULL,
	fare_media_name TEXT,
	fare_media_type SMALLINT NOT NULL REFERENCES gtfs.e_fare_media_types(fare_media_type),
	PRIMARY KEY(feed_id, fare_media_id)
);
-- SELECT * FROM _import.gtfs_tl_fare_media
-- SELECT * FROM gtfs.tl_fare_media

CREATE TABLE gtfs.tl_shapes (
	feed_id INT NOT NULL, -- INT NOT NULL REFERENCES gtfs.transitland_feeds(feed_id),
	shape_id TEXT NOT NULL,
	shape_pt_lat TEXT NOT NULL,
	shape_pt_lon TEXT NOT NULL,
	shape_pt_location geometry(Point,32610), -- CREATED A geometry point COLUMN USING the shape point lat lon values
	shape_pt_sequence INT NOT NULL, -- NON-NEGATIVE
	shape_dist_traveled FLOAT, -- NON-NEGATIVE
	PRIMARY KEY(feed_id, shape_id, shape_pt_sequence)
);
-- SELECT * FROM _import.gtfs_tl_shapes
-- SELECT * FROM gtfs.tl_shapes

CREATE TABLE gtfs.tl_calendar (
	feed_id INT NOT NULL, -- INT NOT NULL REFERENCES gtfs.transitland_feeds(feed_id),
	service_id TEXT NOT NULL,
	monday SMALLINT NOT NULL REFERENCES gtfs.e_service_availability(service_availability),
	tuesday SMALLINT NOT NULL REFERENCES gtfs.e_service_availability(service_availability),
	wednesday SMALLINT NOT NULL REFERENCES gtfs.e_service_availability(service_availability),
	thursday SMALLINT NOT NULL REFERENCES gtfs.e_service_availability(service_availability),
	friday SMALLINT NOT NULL REFERENCES gtfs.e_service_availability(service_availability),
	saturday SMALLINT NOT NULL REFERENCES gtfs.e_service_availability(service_availability),
	sunday SMALLINT NOT NULL REFERENCES gtfs.e_service_availability(service_availability),
	start_date DATE NOT NULL,
	end_date DATE NOT NULL,
	PRIMARY KEY(feed_id, service_id)
);
-- SELECT * FROM _import.gtfs_tl_calendar
-- SELECT * FROM gtfs.tl_calendar

CREATE TABLE gtfs.tl_levels (
	feed_id INT NOT NULL, -- INT NOT NULL REFERENCES gtfs.transitland_feeds(feed_id),
	level_id TEXT NOT NULL,
	level_index FLOAT NOT NULL,
	level_name TEXT,
	PRIMARY KEY(feed_id, level_id)
);
-- SELECT * FROM _import.gtfs_tl_levels
-- SELECT * FROM gtfs.tl_levels

CREATE TABLE gtfs.tl_areas (
	feed_id INT NOT NULL, -- INT NOT NULL REFERENCES gtfs.transitland_feeds(feed_id),
	area_id TEXT NOT NULL,
	area_name TEXT,
	PRIMARY KEY(feed_id, area_id)
);
-- SELECT * FROM _import.gtfs_tl_areas
-- SELECT * FROM gtfs.tl_areas

CREATE TABLE gtfs.tl_stops (
	feed_id INT NOT NULL, -- INT NOT NULL REFERENCES gtfs.transitland_feeds(feed_id),
	stop_id TEXT NOT NULL,
	stop_code TEXT,
	stop_name TEXT, -- conditionally required
	tts_stop_name TEXT,
	stop_desc TEXT,
	stop_lat TEXT, -- conditionally required 
	stop_lon TEXT, -- conditionally required
	stop_location geometry(Point,32610), -- CREATED A geometry point COLUMN USING the shape point lat lon values
	zone_id TEXT, -- conditionally required
	stop_url TEXT,
	location_type SMALLINT REFERENCES gtfs.e_location_types(location_type),
	parent_station TEXT, -- REFERENCES stop_id, so it REFERENCES itself
	stop_timezone TEXT,
	wheelchair_boarding SMALLINT REFERENCES gtfs.e_wheelchair_boardings(wheelchair_boarding),
	level_id TEXT,
	platform_code TEXT,
	PRIMARY KEY(feed_id, stop_id)
	-- FOREIGN KEY(feed_id, parent_station) REFERENCES gtfs.tl_stops(feed_id, stop_id),
	-- FOREIGN KEY(feed_id, level_id) REFERENCES gtfs.tl_levels(feed_id, level_id)
);
-- SELECT * FROM _import.gtfs_tl_stops
-- SELECT * FROM gtfs.tl_stops

CREATE TABLE gtfs.tl_routes (
	feed_id INT NOT NULL, -- INT NOT NULL REFERENCES gtfs.transitland_feeds(feed_id),
	route_id TEXT NOT NULL,
	agency_id TEXT, -- conditionally required
	route_short_name TEXT, -- conditionally required
	route_long_name TEXT, -- conditionally required
	route_desc TEXT,
	route_type SMALLINT NOT NULL REFERENCES gtfs.e_route_types(route_type),
	route_url TEXT,
	route_color TEXT,
	route_text_color TEXT,
	route_sort_order INT, 
	continuous_pickup SMALLINT REFERENCES gtfs.e_continuous_pickup(continuous_pickup),
	continuous_drop_off SMALLINT REFERENCES gtfs.e_continuous_drop_off(continuous_drop_off),
	network_id TEXT, -- conditionally forbidden
	PRIMARY KEY(feed_id, route_id)
	-- FOREIGN KEY(feed_id, agency_id) REFERENCES gtfs.tl_agency(feed_id, agency_id)
);
-- SELECT * FROM _import.gtfs_tl_routes
-- SELECT * FROM gtfs.tl_routes

CREATE TABLE gtfs.tl_calendar_dates (
	feed_id INT NOT NULL, -- INT NOT NULL REFERENCES gtfs.transitland_feeds(feed_id),
	service_id TEXT NOT NULL, -- REFERENCES tl_calender(service_id) OR this table's service_id
	date DATE NOT NULL, 
	exception_type SMALLINT NOT NULL REFERENCES gtfs.e_exception_types(exception_type),
	PRIMARY KEY(feed_id, service_id, date)
);
-- SELECT * FROM _import.gtfs_tl_calendar_dates
-- SELECT * FROM gtfs.tl_calendar_dates

SELECT count(*) FROM gtfs.transitland_feeds
CREATE TABLE gtfs.tl_fare_attributes (
	feed_id INT NOT NULL, -- INT NOT NULL REFERENCES gtfs.transitland_feeds(feed_id),
	fare_id TEXT NOT NULL,
	price TEXT NOT NULL,  --- CONVERT TO CENTS SO WE CAN USE INT INSTEAD OF FLOAT OR KEEP TEXT, NON-NEGATIVE
	currency_type TEXT NOT NULL,
	payment_method SMALLINT NOT NULL REFERENCES gtfs.e_payment_methods(payment_method),
	transfers SMALLINT NOT NULL REFERENCES gtfs.e_transfers(transfer),
	agency_id TEXT,
	transfer_duration INT, -- NON-NEGATIVE
	PRIMARY KEY(feed_id, fare_id)
	-- FOREIGN KEY(feed_id, agency_id) REFERENCES gtfs.tl_agency(feed_id, agency_id)
);
-- SELECT * FROM _import.gtfs_tl_fare_attributes
-- SELECT * FROM gtfs.tl_fare_attributes

CREATE TABLE gtfs.tl_fare_rules (
	feed_id INT NOT NULL, -- INT NOT NULL REFERENCES gtfs.transitland_feeds(feed_id),
	fare_id TEXT NOT NULL,
	route_id TEXT,
	origin_id TEXT,
	destination_id TEXT,
	contains_id TEXT
	-- PRIMARY KEY(feed_id, fare_id, route_id, origin_id, destination_id, contains_id)
	-- FOREIGN KEY(feed_id, fare_id) REFERENCES gtfs.tl_fare_attributes(feed_id, fare_id)
	-- FOREIGN KEY(feed_id, route_id) REFERENCES gtfs.tl_routes(feed_id, route_id)
	-- FOREIGN KEY(feed_id, origin_id) REFERENCES gtfs.tl_stops(feed_id, zone_id),
	-- FOREIGN KEY(feed_id, destination_id) REFERENCES gtfs.tl_stops(feed_id, zone_id),
	-- FOREIGN KEY(feed_id, contains_id) REFERENCES gtfs.tl_stops(feed_id, zone_id)
);
-- SELECT * FROM _import.gtfs_tl_fare_rules
-- SELECT * FROM gtfs.tl_fare_rules

CREATE TABLE gtfs.tl_trips (
	feed_id INT NOT NULL, -- INT NOT NULL REFERENCES gtfs.transitland_feeds(feed_id),
	route_id TEXT NOT NULL,
	service_id TEXT NOT NULL, -- REFERENCES tl_calendar(service_id) OR REFERENCES tl_calendar_dates(service_id)
	trip_id TEXT NOT NULL,
	trip_headsign TEXT,
	trip_short_name TEXT,
	direction_id SMALLINT REFERENCES gtfs.e_direction_ids(direction_id),
	block_id TEXT,
	shape_id TEXT, -- conditionally required
	wheelchair_accessible SMALLINT REFERENCES gtfs.e_wheelchair_accessibility(wheelchair_accessibility),
	bikes_allowed SMALLINT REFERENCES gtfs.e_bikes_allowed(bikes_allowed),
	PRIMARY KEY(feed_id, trip_id)
	-- FOREIGN KEY(feed_id, route_id) REFERENCES gtfs.tl_routes(feed_id, route_id)
	-- FOREIGN KEY(feed_id, shape_id) REFERENCES gtfs.tl_shapes(feed_id, shape_id)
);
-- SELECT * FROM _import.gtfs_tl_trips
-- SELECT * FROM gtfs.tl_trips

CREATE TABLE gtfs.tl_stop_times (
	feed_id INT NOT NULL, -- INT NOT NULL REFERENCES gtfs.transitland_feeds(feed_id),
	trip_id TEXT NOT NULL,
	arrival_time INTERVAL, -- conditionally required
	departure_time INTERVAL, -- conditionally required
	stop_id TEXT NOT NULL,
	stop_sequence INT NOT NULL, -- NON-NEGATIVE
	stop_headsign TEXT,
	pickup_type SMALLINT REFERENCES gtfs.e_pickup_types(pickup_type),
	drop_off_type SMALLINT REFERENCES gtfs.e_drop_off_types(drop_off_type),
	continuous_pickup SMALLINT REFERENCES gtfs.e_continuous_pickup(continuous_pickup),
	continuous_drop_off SMALLINT REFERENCES gtfs.e_continuous_drop_off(continuous_drop_off),
	shape_dist_traveled FLOAT, -- NON-NEGATIVE
	timepoint SMALLINT REFERENCES gtfs.e_timepoints(timepoint),
	PRIMARY KEY(feed_id, trip_id, stop_sequence)
	-- FOREIGN KEY(feed_id, trip_id) REFERENCES gtfs.tl_trips(feed_id, trip_id),
	-- FOREIGN KEY(feed_id, stop_id) REFERENCES gtfs.tl_stops(feed_id, stop_id)
);
-- SELECT * FROM _import.gtfs_tl_stop_times
-- SELECT * FROM gtfs.tl_stop_times

CREATE TABLE gtfs.tl_timeframes (
	feed_id INT NOT NULL, -- INT NOT NULL REFERENCES gtfs.transitland_feeds(feed_id),
	timeframe_group_id TEXT NOT NULL,
	start_time TIME, -- conditionally required
	end_time TIME, -- conditionally required
	service_id TEXT NOT NULL, -- REFERENCES tl_calendar(service_id) OR REFERENCES tl_calendar_dates(service_id)
	PRIMARY KEY(feed_id, timeframe_group_id, start_time, end_time, service_id)
);
-- SELECT * FROM _import.gtfs_tl_timeframes
-- SELECT * FROM gtfs.tl_timeframes

CREATE TABLE gtfs.tl_fare_products (
	feed_id INT NOT NULL, -- INT NOT NULL REFERENCES gtfs.transitland_feeds(feed_id),
	fare_product_id TEXT NOT NULL,
	fare_product_name TEXT,
	fare_media_id TEXT,
	amount NUMERIC(7,2) NOT NULL,
	currency TEXT NOT NULL,
	PRIMARY KEY(feed_id, fare_product_id, fare_media_id)
	-- FOREIGN KEY(feed_id, fare_media_id) REFERENCES gtfs.tl_fare_media(feed_id, fare_media_id)
);
-- SELECT * FROM _import.gtfs_tl_fare_products
-- SELECT * FROM gtfs.tl_fare_products

CREATE TABLE gtfs.tl_fare_leg_rules (
	feed_id INT NOT NULL, -- INT NOT NULL REFERENCES gtfs.transitland_feeds(feed_id),
	leg_group_id TEXT,
	network_id TEXT, -- REFERENCES tl_networks(network_id) OR REFERENCES tl_routes(network_id)
	from_area_id TEXT,
	to_area_id TEXT,
	from_timeframe_group_id TEXT,
	to_timeframe_group_id TEXT,
	fare_product_id TEXT NOT NULL,
	PRIMARY KEY(feed_id, network_id, from_area_id, to_area_id, from_timeframe_group_id, to_timeframe_group_id, fare_product_id)
	-- FOREIGN KEY(feed_id, from_area_id) REFERENCES gtfs.tl_areas(feed_id, area_id),
	-- FOREIGN KEY(feed_id, to_area_id) REFERENCES gtfs.tl_areas(feed_id, area_id)
	-- FOREIGN KEY(feed_id, from_timeframe_group_id) REFERENCES gtfs.tl_timeframes(feed_id, timeframe_group_id),
	-- FOREIGN KEY(feed_id, to_timeframe_group_id) REFERENCES gtfs.tl_timeframes(feed_id, timeframe_group_id),
	-- FOREIGN KEY(feed_id, fare_product_id) REFERENCES gtfs.tl_fare_products(feed_id, fare_product_id)
);
-- SELECT * FROM _import.gtfs_tl_fare_leg_rules
-- SELECT * FROM gtfs.tl_fare_leg_rules

CREATE TABLE gtfs.tl_fare_transfer_rules (
	feed_id INT NOT NULL, -- INT NOT NULL REFERENCES gtfs.transitland_feeds(feed_id),
	from_leg_group_id TEXT,
	to_leg_group_id TEXT,
	transfer_count INT, -- NON-NEGATIVE condtitionally required
	duration_limit INT, -- POSITIVE 
	duration_limit_type SMALLINT REFERENCES gtfs.e_duration_limit_types(duration_limit_type), -- conditionally required
	fare_transfer_type SMALLINT NOT NULL REFERENCES gtfs.e_fare_transfer_types(fare_transfer_type),
	fare_product_id TEXT,
	PRIMARY KEY(feed_id, from_leg_group_id, to_leg_group_id, fare_product_id, transfer_count, duration_limit)
	-- FOREIGN KEY(feed_id, from_leg_group_id) REFERENCES gtfs.tl_fare_leg_rules(feed_id, leg_group_id),
	-- FOREIGN KEY(feed_id, to_leg_group_id) REFERENCES gtfs.tl_fare_leg_rules(feed_id, leg_group_id),
	-- FOREIGN KEY(feed_id, fare_product_id) REFERENCES gtfs.tl_fare_products(feed_id, fare_product_id)
);
-- SELECT * FROM _import.gtfs_tl_fare_transfer_rules
-- SELECT * FROM gtfs.tl_fare_transfer_rules

CREATE TABLE gtfs.tl_stop_areas (
	feed_id INT NOT NULL, -- INT NOT NULL REFERENCES gtfs.transitland_feeds(feed_id),
	area_id TEXT NOT NULL,
	stop_id TEXT NOT NULL,
	PRIMARY KEY(feed_id, area_id, stop_id)
	-- FOREIGN KEY(feed_id, area_id) REFERENCES gtfs.tl_areas(feed_id, area_id),
	-- FOREIGN KEY(feed_id, stop_id) REFERENCES gtfs.tl_stops(feed_id, stop_id)
);
-- SELECT * FROM _import.gtfs_tl_stop_areas
-- SELECT * FROM gtfs.tl_stop_areas

CREATE TABLE gtfs.tl_route_networks (
	feed_id INT NOT NULL, -- INT NOT NULL REFERENCES gtfs.transitland_feeds(feed_id),
	network_id TEXT NOT NULL,
	route_id TEXT NOT NULL,
	PRIMARY KEY(feed_id, route_id)
	-- FOREIGN KEY(feed_id, network_id) REFERENCES gtfs.tl_networks(feed_id, network_id),
	-- FOREIGN KEY(feed_id, route_id) REFERENCES gtfs.tl_routes(feed_id, route_id)
);
-- SELECT * FROM _import.gtfs_tl_route_networks
-- SELECT * FROM gtfs.tl_route_networks

CREATE TABLE gtfs.tl_frequencies (
	feed_id INT NOT NULL, -- INT NOT NULL REFERENCES gtfs.transitland_feeds(feed_id),
	trip_id TEXT NOT NULL,
	start_time INTERVAL NOT NULL, 
	end_time INTERVAL NOT NULL,
	headway_secs INT NOT NULL,
	exact_times SMALLINT REFERENCES gtfs.e_exact_times(exact_times),
	PRIMARY KEY(feed_id, trip_id, start_time)
	-- FOREIGN KEY(feed_id, trip_id) REFERENCES gtfs.tl_trips(feed_id, trip_id)
);
-- SELECT * FROM _import.gtfs_tl_frequencies
-- SELECT * FROM gtfs.tl_frequencies

CREATE TABLE gtfs.tl_transfers (
	feed_id INT NOT NULL, -- INT NOT NULL REFERENCES gtfs.transitland_feeds(feed_id),
	from_stop_id TEXT,
	to_stop_id TEXT, 
	from_route_id TEXT,
	to_route_id TEXT, 
	from_trip_id TEXT, 
	to_trip_id TEXT,
	transfer_type SMALLINT NOT NULL REFERENCES gtfs.e_transfer_types(transfer_type),
	min_transfer_time INT
	-- PRIMARY KEY(feed_id, from_stop_id, to_stop_id, from_trip_id, to_trip_id, from_route_id, to_route_id)
	-- FOREIGN KEY(feed_id, from_stop_id) REFERENCES gtfs.tl_stops(feed_id, stop_id),
	-- FOREIGN KEY(feed_id, to_stop_id) REFERENCES gtfs.tl_stops(feed_id, stop_id),
	-- FOREIGN KEY(feed_id, from_route_id) REFERENCES gtfs.tl_routes(feed_id, route_id),
	-- FOREIGN KEY(feed_id, to_route_id) REFERENCES gtfs.tl_routes(feed_id, route_id),
	-- FOREIGN KEY(feed_id, from_trip_id) REFERENCES gtfs.tl_trips(feed_id, trip_id),
	-- FOREIGN KEY(feed_id, to_trip_id) REFERENCES gtfs.tl_trips(feed_id, trip_id)
);
-- SELECT * FROM _import.gtfs_tl_transfers
-- SELECT * FROM gtfs.tl_transfers

CREATE TABLE gtfs.tl_pathways (
	feed_id INT NOT NULL, -- INT NOT NULL REFERENCES gtfs.transitland_feeds(feed_id),
	pathway_id TEXT NOT NULL,
	from_stop_id TEXT NOT NULL,
	to_stop_id TEXT NOT NULL,
	pathway_mode SMALLINT NOT NULL REFERENCES gtfs.e_pathway_modes(pathway_mode),
	is_bidirectional SMALLINT NOT NULL REFERENCES gtfs.e_is_bidirectional(is_bidirectional),
	length FLOAT,
	traversal_time INT,
	stair_count INT NOT NULL,
	max_slope FLOAT,
	min_width FLOAT,
	signposted_as TEXT,
	reversed_signposted_as TEXT,
	PRIMARY KEY(feed_id, pathway_id)
	-- FOREIGN KEY(feed_id, from_stop_id) REFERENCES gtfs.tl_stops(feed_id, stop_id),
	-- FOREIGN KEY(feed_id, to_stop_id) REFERENCES gtfs.tl_stops(feed_id, stop_id)
);
-- SELECT * FROM _import.gtfs_tl_pathways
-- SELECT * FROM gtfs.tl_pathways

CREATE TABLE gtfs.tl_attributions (
	feed_id INT NOT NULL, -- INT NOT NULL REFERENCES gtfs.transitland_feeds(feed_id),
	attribution_id TEXT,
	agency_id TEXT, 
	route_id TEXT, 
	trip_id TEXT, 
	organization_name TEXT NOT NULL,
	is_producer SMALLINT REFERENCES gtfs.e_is_role(is_role),
	is_operator SMALLINT REFERENCES gtfs.e_is_role(is_role),
	is_authority SMALLINT REFERENCES gtfs.e_is_role(is_role),
	attribution_url TEXT,
	attribution_email TEXT,
	attribution_phone TEXT,
	PRIMARY KEY(feed_id, attribution_id)
	-- FOREIGN KEY(feed_id, agency_id) REFERENCES gtfs.tl_agency(feed_id, agency_id),
	-- FOREIGN KEY(feed_id, route_id) REFERENCES gtfs.tl_routes(feed_id, route_id),
	-- FOREIGN KEY(feed_id, trip_id) REFERENCES gtfs.tl_trips(feed_id, trip_id)
);
-- SELECT * FROM _import.gtfs_tl_attributions
-- SELECT * FROM gtfs.tl_attributions

