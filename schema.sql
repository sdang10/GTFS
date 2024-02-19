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




CREATE TABLE gtfs_test.transitland_agency (
	file_id TEXT,
	agency_id TEXT, -- PRIMARY KEY
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
	stop_id TEXT, -- PRIMARY KEY
	stop_code TEXT,
	stop_name TEXT,
	tts_stop_name TEXT,
	stop_desc TEXT,
	stop_lat TEXT,
	stop_lon TEXT,
	zone_id TEXT,
	stop_url TEXT,
	location_type TEXT,
	parent_station TEXT, -- REFERENCES stops.stop_id
	stop_timezone TEXT,
	wheelchair_boarding TEXT,
	level_id TEXT, -- REFERENCES levels.level_id
	platform_code TEXT
);


CREATE TABLE gtfs_test.transitland_routes (
	file_id TEXT,
	route_id TEXT, -- PRIMARY KEY
	agency_id TEXT, -- REFERENCES agency.agency_id
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
	file_id TEXT,
	service_id TEXT, -- PRIMARY KEY
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
	service_id TEXT, -- PRIMARY KEY REFERENCES calendar.service_id
	date TEXT, -- PRIMARY KEY
	exception_type TEXT
);


CREATE TABLE gtfs_test.transitland_shapes (
	file_id TEXT,
	shape_id TEXT, -- PRIMARY KEY
	shape_pt_lat TEXT,
	shape_pt_lon TEXT,
	shape_pt_sequence TEXT, -- PRIMARY KEY
	shape_dist_traveled TEXT
);


CREATE TABLE gtfs_test.transitland_fare_attributes (
	file_id TEXT,
	fare_id TEXT, -- PRIMARY KEY
	price TEXT,
	currency_type TEXT,
	payment_method TEXT,
	transfers TEXT,
	agency_id TEXT, -- REFERENCES agency.agency_id
	transfer_duration TEXT
);


CREATE TABLE gtfs_test.transitland_fare_rules (
	file_id TEXT,
	fare_id TEXT, -- REFERENCES fare_attributes.fare_id
	route_id TEXT, -- REFERENCES routes.route_id
	origin_id TEXT, -- REFERENCES stops.zone_id
	destination_id TEXT, -- REFERENCES stops.zone_id
	contains_id TEXT
);


CREATE TABLE gtfs_test.transitland_trips (
	file_id TEXT,
	route_id TEXT, -- REFERENCES routes.route_id
	service_id TEXT, -- REFERENCES calendar.service_id OR REFERENCES calendar_dates.service_id
	trip_id TEXT, -- PRIMARY KEY
	trip_headsign TEXT,
	trip_short_name TEXT,
	direction_id TEXT,
	block_id TEXT,
	shape_id TEXT, -- REFERENCES shapes.shape_id
	wheelchair_accessible TEXT,
	bikes_allowed TEXT
);


CREATE TABLE gtfs_test.transitland_stop_times (
	file_id TEXT,
	trip_id TEXT, -- PRIMARY KEY REFERENCES trips.trip_id
	arrival_time TEXT,
	departure_time TEXT,
	stop_id TEXT, -- REFERENCES stops.stop_id
	stop_sequence TEXT, -- PRIMARY KEY 
	stop_headsign TEXT,
	pickup_type TEXT,
	drop_off_type TEXT,
	continuous_pickup TEXT,
	continuous_dropoff TEXT,
	shape_dist_traveled TEXT,
	timepoint TEXT
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
	fare_media_id TEXT, -- PRIMARY KEY
	fare_media_name TEXT,
	fare_media_type TEXT
);


CREATE TABLE gtfs_test.transitland_fare_products (
	file_id TEXT,
	fare_product_id TEXT, -- PRIMARY KEY
	fare_product_name TEXT,
	fare_media_id TEXT, -- PRIMARY KEY REFERENCES fare_media.fare_media_id
	amount TEXT,
	currency TEXT
);


CREATE TABLE gtfs_test.transitland_fare_leg_rules (
	file_id TEXT,
	leg_group_id TEXT,
	network_id TEXT, -- PRIMARY KEY REFERENCES networks.network_id OR routes.network_id
	from_area_id TEXT, -- PRIMARY KEY REFERENCES areas.area_id
	to_area_id TEXT, -- PRIMARY KEY REFERENCES areas.area_id
	from_timeframe_group_id TEXT, -- PRIMARY KEY REFERENCES timesframes.timeframe_group_id
	to_timeframe_group_id TEXT, -- PRIMARY KEY REFERENCES timesframes.timeframe_group_id
	fare_product_id TEXT
);


CREATE TABLE gtfs_test.transitland_fare_transfer_rules (
	file_id TEXT,
	from_leg_group_id TEXT, -- PRIMARY KEY REFERENCES fare_leg_rules.leg_group_id
	to_leg_group_id TEXT, -- PRIMARY KEY REFERENCES fare_leg_rules.leg_group_id
	transfer_count TEXT, -- PRIMARY KEY
	duration_limit TEXT, -- PRIMARY KEY
	duration_limit_type TEXT,
	fare_transfer_type TEXT,
	fare_product_id TEXT
);


CREATE TABLE gtfs_test.transitland_areas (
	file_id TEXT,
	area_id TEXT, -- PRIMARY KEY
	area_name TEXT
);


CREATE TABLE gtfs_test.transitland_stop_areas (
	file_id TEXT,
	area_id TEXT, -- PRIMARY KEY REFERENCES areas.area_id
	stop_id TEXT
);


CREATE TABLE gtfs_test.transitland_networks (
	file_id TEXT,
	network_id TEXT, -- PRIMARY KEY
	network_name TEXT
);


CREATE TABLE gtfs_test.transitland_route_networks (
	file_id TEXT,
	network_id TEXT, -- REFERENCES networks.network_id
	route_id TEXT
);


CREATE TABLE gtfs_test.transitland_frequencies (
	file_id TEXT,
	trip_id TEXT, -- PRIMARY KEY REFERENCES trips.trip_id
	start_time TEXT, -- PRIMARY KEY
	end_time TEXT,
	headway_secs TEXT,
	exact_times TEXT
);


CREATE TABLE gtfs_test.transitland_transfers (
	file_id TEXT,
	from_stop_id TEXT, -- PRIMARY KEY REFERENCES stops.stop_id
	to_stop_id TEXT, -- PRIMARY KEY REFERENCES stops.stop_id
	from_route_id TEXT, -- PRIMARY KEY REFERENCES routes.route_id
	to_route_id TEXT, -- PRIMARY KEY REFERENCES routes.route_id
	from_trip_id TEXT, -- PRIMARY KEY REFERENCES trips.trip_id
	to_trip_id TEXT, -- PRIMARY KEY REFERENCES trips.trip_id
	transfer_type TEXT,
	min_transfer_time TEXT
);

CREATE TABLE gtfs_test.transitland_pathways (
	file_id TEXT,
	pathway_id TEXT, -- PRIMARY KEY
	from_stop_id TEXT, -- REFERENCES stops.stop_id
	to_stop_id TEXT, -- REFERENCES stops.stop_id
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
	level_id TEXT, -- PRIMARY KEY
	level_index TEXT,
	level_name TEXT
);


CREATE TABLE gtfs_test.transitland_translations (
	file_id TEXT,
	table_name TEXT, -- PRIMARY KEY
	field_name TEXT, -- PRIMARY KEY
	language TEXT, -- PRIMARY KEY
	TRANSLATION TEXT,
	record_id TEXT, -- PRIMARY KEY
	record_sub_id TEXT, -- PRIMARY KEY
	field_value TEXT
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


CREATE TABLE gtfs_test.transitland_attributions (
	file_id TEXT,
	attribution_id TEXT, -- PRIMARY KEY
	agency_id TEXT, -- REFERENCES agency.agency_id
	route_id TEXT, -- REFERENCES routes.route_id
	trip_id TEXT, -- REFERENCES trips.trip_id
	organization_name TEXT,
	is_producer TEXT,
	is_operator TEXT,
	is_authority TEXT,
	attribution_url TEXT,
	attribution_email TEXT,
	attribution_phone TEXT
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



-------------------------------------------------------------------------------------------


DROP TABLE gtfs_test.transitland_translations;
DROP TABLE gtfs_test.gtfs_extra_attributes;



CREATE TABLE gtfs_test.gtfs_extra_attributes (
    file_id TEXT,
   	file_name TEXT,
    column_name TEXT,
    value TEXT
);


CREATE TABLE gtfs_test.gtfs_files (
	id TEXT,
	fetched_at TEXT,
	earliest_calendar_date TEXT,
	latest_calendar_date TEXT,
	sha1 TEXT,
	url TEXT
);



SELECT * FROM gtfs_test.gtfs_extra_attributes 
SELECT * FROM gtfs_test.gtfs_files


--------------------------------------------------------------------------------------------


DROP TABLE gtfs_test.real_transitland_stop_times; 
DROP TABLE gtfs_test.real_transitland_trips ;
DROP TABLE gtfs_test.real_transitland_fare_rules ;
DROP TABLE gtfs_test.real_transitland_fare_attributes;
DROP TABLE gtfs_test.real_transitland_shapes;
DROP TABLE gtfs_test.real_transitland_calendar_dates;
DROP TABLE gtfs_test.real_transitland_calendar;
DROP TABLE gtfs_test.real_transitland_routes;
DROP TABLE gtfs_test.real_transitland_stops ;
DROP TABLE gtfs_test.real_transitland_agency;
DROP TABLE gtfs_test.real_transitland_timeframes;
DROP TABLE gtfs_test.real_transitland_fare_media;
DROP TABLE gtfs_test.real_transitland_fare_products;
DROP TABLE gtfs_test.real_transitland_fare_leg_rules;
DROP TABLE gtfs_test.real_transitland_fare_transfer_rules;
DROP TABLE gtfs_test.real_transitland_areas;
DROP TABLE gtfs_test.real_transitland_stop_areas;
DROP TABLE gtfs_test.real_transitland_networks;
DROP TABLE gtfs_test.real_transitland_route_networks;
DROP TABLE gtfs_test.real_transitland_frequencies;
DROP TABLE gtfs_test.real_transitland_transfers;
DROP TABLE gtfs_test.real_transitland_pathways;
DROP TABLE gtfs_test.real_transitland_levels;
DROP TABLE gtfs_test.real_transitland_feed_info;
DROP TABLE gtfs_test.real_transitland_attributions;





CREATE TABLE gtfs_test.real_transitland_agency (
	file_id INT REFERENCES gtfs_files(id),
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


-- when creating from the data: ST_SetSRID(ST_MakePoint(stop_lon::numeric(9,6), stop_lat::numeric(8,6)), 32610)

CREATE TABLE gtfs_test.real_transitland_stops (
	file_id ID REFERENCES gtfs_files(id),
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
	location_type SMALLINT REFERENCES e_location_type(location_type),
	parent_station TEXT REFERENCES real_transitland_stops(stop_id),
	stop_timezone TEXT,
	wheelchair_boarding SMALLINT REFERENCES e_wheelchair_boarding(wheelchair_boarding),
	level_id TEXT REFERENCES real_transitland_levels(level_id),
	platform_code TEXT,
	PRIMARY KEY(file_id,stop_id)
);

-- BLANK location types in STOPS.txt get defaulted to 0


CREATE TABLE gtfs_test.e_location_types(
	location_type SMALLINT PRIMARY KEY,
	location_descr TEXT
);


INSERT INTO gtfs_test.e_location_types VALUES
	(0, "stop or platform"),
	(1, "station"),
	(2, "entrance or exit"),
	(3, "generic node"),
	(4, "boarding area");


CREATE TABLE gtfs_test.e_wheelchair_boardings(
	wheelchair_boarding SMALLINT PRIMARY KEY,
	wheelchair_boarding_descr TEXT
);


INSERT INTO gtfs_test.e_wheelchair_boardings VALUES
	(0, "parentless stops: no info; 
		 child stops: inherit wheelchair_boarding behavior from parent station; 
		 stations entrance/exits: inherit wheelchair_boarding behavior from parent station"),
	(1, "parentless stops: some vehicles at this stop can be boarded by a rider in wheelchair; 
		 child stops: some accessible path from outside the station to the specific stop/platform; 
		 stations entrance/exits: entrance is wheelchair accessible"),
	(2, "parentless stops: wheelchair boarding not possible at this stop; 
		 child stops: no accessible path from outside the station to the specific stop/platform; 
		 stations entrance/exits: no accessible path from station entrance to stops/platforms");


CREATE TABLE gtfs_test.real_transitland_routes (
	file_id INT REFERENCES gtfs_files(id),
	route_id TEXT NOT NULL,
	agency_id TEXT REFERENCES real_transitland_agency(agency_id),
	route_short_name TEXT, 
	route_long_name TEXT,
	route_desc TEXT,
	route_type SMALLINT NOT NULL REFERENCES e_route_types(route_type),
	route_url TEXT,
	route_color TEXT,
	route_text_color TEXT,
	route_sort_order INT, 
	continuous_pickup SMALLINT REFERENCES e_continuous_pickup(continuous_pickup),
	continuoues_dropoff SMALLINT REFERENCES e_continuous_drop_off(continuous_drop_off),
	network_id TEXT,
	PRIMARY KEY(file_id, route_id)
);


CREATE TABLE gtfs_test.e_route_types (
	route_type SMALLINT,
	route_type_descr TEXT
);

INSERT INTO gtfs_test.e_route_types VALUES 
	(0, "Tram, Streetcar, Light rail. Any light rail or street level system within a metropolitan area"),
	(1, "Subway, Metro. Any underground rail system within a metropolitan area"),
	(2, "Rail. Used for intercity or long-distance travel"),
	(3, "Bus. Used for short- and long-distance bus routes"),
	(4, "Ferry. Used for short- and long-distance boat service"),
	(5, "Cable tram. Used for street-level rail cars where the cable runs beneath the vehicle (e.g., cable car in San Francisco)"),
	(6, "Aerial lift, suspended cable car (e.g., gondola lift, aerial tramway). Cable transport where cabins, cars, gondolas or open chairs are suspended by means of one or more cables"),
	(7, "Funicular. Any rail system designed for steep inclines"),
	(11, "Trolleybus. Electric buses that draw power from overhead wires using poles"),
	(12, "Monorail. Railway in which the track consists of a single rail or a beam");



CREATE TABLE gtfs_test.e_continuous_pickup (
	continuous_pickup SMALLINT,
	continuous_pickup_descr TEXT
);

-- FOR THIS ONE, BLANKS DEFAULT TO 1 NOT 0!!!
INSERT INTO gtfs_test.e_continuous_pickup VALUES 
	(0, "continuous stopping pickup"),
	(1, "no continuous stopping pickup"),
	(2, "must phone agency to arrange continuous stopping pickup"),
	(3, "must coordinate with driver to arrange continuous stopping pickup");



CREATE TABLE gtfs_test.e_continuous_drop_off (
	continuous_drop_off SMALLINT,
	continuous_drop_off_descr TEXT
);

-- FOR THIS ONE, BLANKS DEFAULT TO 1 NOT 0!!!
INSERT INTO gtfs_test.e_continuous_drop_off VALUES 
	(0, "continuous stopping drop off"),
	(1, "no continuous stopping drop off"),
	(2, "must phone agency to arrange continuous stopping drop off"),
	(3, "must coordinate with driver to arrange continuous stopping drop off");



CREATE TABLE gtfs_test.real_transitland_calendar (
	file_id INT REFERENCES gtfs_files(id),
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


CREATE TABLE gtfs_test.e_service_availability (
	service_availability SMALLINT,
	service_availability_descr TEXT
);


INSERT INTO gtfs_test.e_service_availability VALUES 
	(0, "service not available for all of this week day in the date range"),
	(1, "service is available for all of this week day in the date range")
;



CREATE TABLE gtfs_test.real_transitland_calendar_dates (
	file_id INT REFERENCES gtfs_files(id),
	service_id TEXT, -- REFERENCES real_transitland_calender(service_id) OR ID
	date DATE NOT NULL, 
	exception_type SMALLINT NOT NULL REFERENCES gtfs_test.e_exception_types(exception_type),
	PRIMARY KEY(file_id, service_id, date)
);


CREATE TABLE gtfs_test.e_exception_types (
	exception_type SMALLINT,
	exception_type_descr TEXT
);

INSERT INTO gtfs_test.e_exception_types VALUES
	(1, "service has been added for the specified date"),
	(2, "service has been removed for the specified date");


-- CREATE A POINT GEOMETRY USING LAT AND LON
CREATE TABLE gtfs_test.real_transitland_shapes (
	file_id INT REFERENCES gtfs_files(id),
	shape_id TEXT NOT NULL,
	shape_pt_lat TEXT NOT NULL,
	shape_pt_lon TEXT NOT NULL,
	shape_pt_location geometry(Point,32610),
	shape_pt_sequence INT NOT NULL,
	shape_dist_traveled INT,
	PRIMARY KEY(file_id, shape_id, shape_pt_sequence)
);


CREATE TABLE gtfs_test.real_transitland_fare_attributes (
	file_id INT REFERENCES gtfs_files(id),
	fare_id TEXT NOT NULL,
	price NUMERIC(7,2) NOT NULL,  --- CONVERT TO CENTS SO WE CAN USE INT INSTEAD OF FLOAT OR KEEP TEXT
	currency_type TEXT NOT NULL,
	payment_method SMALLINT NOT NULL REFERENCES gtfs_test.e_payment_methods(payment_method),
	transfers SMALLINT NOT NULL REFERENCES gtfs_test.e_transfers(transfer),
	agency_id TEXT REFERENCES real_transitland_agency(agency_id),
	transfer_duration INT,
	PRIMARY KEY(file_id, fare_id)
);


CREATE TABLE gtfs_test.e_payment_methods(
	payment_method SMALLINT,
	payment_method_descr TEXT
);

INSERT INTO gtfs_test.e_payment_methods VALUES
	(0, "fair is paid on board"),
	(1, "fair must be payd before boarding");



CREATE TABLE gtfs_test.e_transfers(
	transfer SMALLINT,
	transfer_descr TEXT
);

INSERT INTO gtfs_test.e_transfers VALUES 
	(0, "no transfers permitted"),
	(1, "riders may transfer once"),
	(2, "riders may transfer twice"),
	("", "unlimited transfers are permitted");



CREATE TABLE gtfs_test.real_transitland_fare_rules (
	file_id INT REFERENCES gtfs_files(id),
	fare_id TEXT REFERENCES real_transitland_fare_attributes(fare_id) NOT NULL,
	route_id TEXT REFERENCES real_transitland_routes(route_id),
	origin_id TEXT REFERENCES real_transitland_stops(zone_id),
	destination_id TEXT REFERENCES real_transitland_stops(zone_id),
	contains_id TEXT REFERENCES real_transitland_stops(zone_id),
	PRIMARY KEY(file_id, fare_id, route_id, origin_id, destination_id, contains_id)
);

-- EMPTIES DEFAULT TO 0 for TRIPS.txt
CREATE TABLE gtfs_test.real_transitland_trips (
	file_id INT REFERENCES gtfs_files(id),
	route_id TEXT REFERENCES real_transitland_routes(route_id) NOT NULL,
	service_id TEXT NOT NULL, -- REFERENCES real_transitland_calendar(service_id) OR REFERENCES real_transitland_calendar_dates(service_id)
	trip_id TEXT NOT NULL,
	trip_headsign TEXT,
	trip_short_name TEXT,
	direction_id SMALLINT REFERENCES gtfs_test.e_direction_ids(direction_id),
	block_id TEXT,
	shape_id TEXT REFERENCES real_transitland_shapes(shape_id),
	wheelchair_accessible SMALLINT REFERENCES gtfs_test.e_wheelchair_accessibility(wheelchair_accessible),
	bikes_allowed SMALLINT REFERENCES gtfs_test.e_bikes_allowed(bikes_allowed),
	PRIMARY KEY(file_id, trip_id)
);


CREATE TABLE gtfs_test.e_direction_ids (
	direction_id SMALLINT,
	direction_id_descr TEXT
);

INSERT INTO gtfs_test.e_direction_ids VALUES
	(0, "travel in one direction (e.g. outbound travel)"),
	(1, "travel in the opposite direction (e.g. inbound travel)");


CREATE TABLE gtfs_test.e_wheelchair_accessibility(
	wheelchair_accessibility SMALLINT,
	wheelchair_accessibility_descr TEXT
);

INSERT INTO gtfs_test.e_wheelchair_accessibility VALUES
	(0, "no accessibility info"),
	(1, "vehicle being used on this particular trip can accommodate at least one rider in a wheelchair"),
	(2, "no riders in wheelchairs can be accommodated on this trip");


CREATE TABLE gtfs_test.e_bikes_allowed(
	bikes_allowed SMALLINT,
	bikes_allowed_descr TEXT
);

INSERT INTO gtfs_test.e_bikes_allowed VALUES
	(0, "no bike info"),
	(1, "vehicle being used on this particular trip can accommodate at least one bicycle"),
	(2, "no bicycles allowed on this trip");


-- IF VARIABLES PICKUP AND DROP OFF TYPES ARE BLANK THEY DEFAULT TO 0
-- IF VARIBLES CONTINUOUS PICKUP AND DROP OFF AND TIMEPOINT ARE BLANK, DEFAULT TO 1
CREATE TABLE gtfs_test.real_transitland_stop_times (
	file_id INT REFERENCES gtfs_files(id),
	trip_id TEXT REFERENCES real_transitland_trips(trip_id) NOT NULL,
	arrival_time INTERVAL,
	departure_time INTERVAL,
	stop_id ID REFERENCES real_transitland_stops(stop_id) NOT NULL,
	stop_sequence INT NOT NULL,
	stop_headsign TEXT,
	pickup_type SMALLINT REFERENCES gtfs_test.e_pickup_types(pickup_type),
	drop_off_type SMALLINT REFERENCES gtfs_test.e_drop_odd_types(drop_off_type),
	continuous_pickup REFERENCES gtfs_test.e_continuous_pickup(continuous_pickup),
	continuous_dropoff REFERENCE gtfs_test.e_continuous_drop_off(continuous_drop_off),
	shape_dist_traveled FLOAT,
	timepoint SMALLINT REFERENCES gtfs_test.e_timepoints(timepoint),
	PRIMARY KEY(file_id, trip_id, stop_sequence)
);


CREATE TABLE gtfs_test.e_pickup_types(
	pickup_type SMALLINT,
	pickup_type_descr TEXT
);

INSERT INTO gtfs_test.e_pickup_types VALUES 
	(0, "regularly_scheduled_pickup"),
	(1, "no pickup available"),
	(2, "must phone agency to arrange pickup"),
	(3, "must coordinate with driver to arrange pickup");

CREATE TABLE gtfs_test.e_drop_off_types(
	drop_off_type SMALLINT,
	drop_off_type_descr TEXT
);

INSERT INTO gtfs_test.e_drop_off_types VALUES 
	(0, "regularly scheduled drop off"),
	(1, "no pickup available"),
	(2, "must phone agency to arrange drop off"),
	(3, "must coordinate with driver to arrange drop off");


CREATE TABLE gtfs_test.e_timepoints (
	timepoint SMALLINT,
	timepoint_descr TEXT
);

INSERT INTO gtfs_test.e_timepoint VALUES 
	(0, "times are considered approximated"),
	(1, "times are considered exact");



CREATE TABLE gtfs_test.real_transitland_timeframes (
	file_id INT REFERENCES gtfs_files(id),
	timeframe_group_id TEXT NOT NULL,
	start_time TIME,  -- KEEP TIME FOR THESE
	end_time TIME, 
	service_id TEXT NOT NULL -- REFERENCES real_transitland_calendar(service_id) OR REFERENCES real_transitland_calendar_dates(service_id)
	PRIMARY KEY(file_id, timeframe_group_id, start_time, end_time, service_id)
);


CREATE TABLE gtfs_test.real_transitland_fare_media (
	file_id INT REFERENCES gtfs_files(id),
	fare_media_id TEXT NOT NULL,
	fare_media_name TEXT,
	fare_media_type SMALLINT NOT NULL REFERENCES gtfs_test.e_fare_media_types(fare_media_type),
	PRIMARY KEY(file_id, fare_media_id)
);


CREATE TABLE gtfs_test.e_fare_media_types(
	fare_media_type SMALLINT,
	fare_media_type_descr TEXT
);

INSERT INTO gtfs_test.e_fare_media_types VALUES 
	(0, "none, no fare media involved in purchasing or validating a fare product, such as paying cash to a driver or conductor with no physical ticket provided"),
	(1, "Physical paper ticket that allows a passenger to take either a certain number of pre-purchased trips or unlimited trips within a fixed period of time"),
	(2, "Physical transit card that has stored tickets, passes or monetary value"),
	(3, "cEMV (contactless Europay, Mastercard and Visa) as an open-loop token container for account-based ticketing"),
	(4, "Mobile app that have stored virtual transit cards, tickets, passes, or monetary value")



CREATE TABLE gtfs_test.real_transitland_fare_products (
	file_id INT REFERENCES gtfs_files(id),
	fare_product_id TEXT NOT NULL,
	fare_product_name TEXT,
	fare_media_id ID REFERENCES real_transitland_fare_media(fare_media_id),
	amount NUMERIC(7,2) NOT NULL,
	currency TEXT NOT NULL,
	PRIMARY KEY(file_id, fare_product_id, fare_media_id)
);


CREATE TABLE gtfs_test.real_transitland_fare_leg_rules (
	file_id INT REFERENCES gtfs_files(id),
	leg_group_id TEXT,
	network_id TEXT -- REFERENCES real_transitland_networks(network_id) OR REFERENCES real_transitland_routes(network_id)
	from_area_id TEXT REFERENCES real_transitland_areas(area_id),
	to_area_id TEXT REFERENCES real_transitland_areas(area_id),
	from_timeframe_group_id TEXT REFERENCES real_transitland_timeframes(timeframe_group_id),
	to_timeframe_group_id TEXT REFERENCES real_transitland_timeframes(timeframe_group_id),
	fare_product_id TEXT REFERENCES real_transitland_fare_products(fare_product_id) NOT NULL,
	PRIMARY KEY(file_id, network_id, from_area_id, to_area_id, from_timeframe_group_id, to_timeframe_group_id, fare_product_id)
);


CREATE TABLE gtfs_test.real_transitland_fare_transfer_rules (
	file_id INT REFERENCES gtfs_files(id),
	from_leg_group_id TEXT REFERENCES real_transitland_fare_leg_rules(leg_group_id),
	to_leg_group_id TEXT REFERENCES real_transitland_fare_leg_rules(leg_group_id),
	transfer_count INT,
	duration_limit INT,
	duration_limit_type SMALLINT REFERENCES gtfs_test.e_duration_limit_types(duration_limit_type), 
	fare_transfer_type SMALLINT NOT NULL REFERENCES gtfs_test.e_fare_transfer_types(fare_transfer_type),
	fare_product_id TEXT REFERENCES real_transitland_fare_products(fare_product_id),
	PRIMARY KEY(file_id, from_leg_group_id, to_leg_group_id, fare_product_id, transfer_count, duration_limit)
);


CREATE TABLE gtfs_test.e_duration_limit_types(
	duration_limit_type SMALLINT,
	duration_limit_type_descr TEXT
);

INSERT INTO gtfs_test.e_duration_limit_types VALUES
	(0, "Between the departure fare validation of the current leg and the arrival fare validation of the next leg"),
	(1, "Between the departure fare validation of the current leg and the departure fare validation of the next leg"),
	(2, "Between the arrival fare validation of the current leg and the departure fare validation of the next leg"),
	(3, "Between the arrival fare validation of the current leg and the arrival fare validation of the next leg");


CREATE TABLE gtfs_test.e_fare_transfer_types(
	fare_transfer_type SMALLINT,
	fare_transfer_type_descr TEXT
);

-- UUHHHHHHH????
INSERT INTO gtfs_test.e_fare_transfer_types VALUES 
	(),




CREATE TABLE gtfs_test.real_transitland_areas (
	file_id INT REFERENCES gtfs_files(id),
	area_id TEXT NOT NULL,
	area_name TEXT,
	PRIMARY KEY(file_id, area_id)
);


CREATE TABLE gtfs_test.real_transitland_stop_areas (
	file_id INT REFERENCES gtfs_files(id),
	area_id TEXT REFERENCES real_transitland_areas(area_id) NOT NULL,
	stop_id TEXT REFERENCES real_transitland_stops(stop_id) NOT NULL,
	PRIMARY KEY(file_id, area_id, stop_id)
);


CREATE TABLE gtfs_test.real_transitland_networks (
	file_id INT REFERENCES gtfs_files(id),
	network_id TEXT NOT NULL,
	network_name TEXT,
	PRIMARY KEY(file_id, network_id)
);


CREATE TABLE gtfs_test.real_transitland_route_networks (
	file_id INT REFERENCES gtfs_files(id),
	network_id TEXT REFERENCES real_transitland_networks(network_id) NOT NULL,
	route_id TEXT REFERENCES real_transitland_routes(route_id) NOT NULL,
	PRIMARY KEY(file_id, route_id)
);


CREATE TABLE gtfs_test.real_transitland_frequencies (
	file_id ID REFERENCES gtfs_files(id),
	trip_id ID REFERENCES real_transitland_trips(trip_id) NOT NULL,
	start_time INTERVAL NOT NULL, 
	end_time INTERVAL NOT NULL,
	headway_secs POSITIVE INTEGER NOT NULL,
	exact_times ENUM,
	PRIMARY KEY(file_id, trip_id, start_time)
);

-- TRANSFER TYPE BLANKS DEFAULT TO 0
CREATE TABLE gtfs_test.real_transitland_transfers (
	file_id INT REFERENCES gtfs_files(id),
	from_stop_id TEXT REFERENCES real_transitland_stops(stop_id),
	to_stop_id TEXT REFERENCES real_transitland_stops(stop_id), 
	from_route_id TEXT REFERENCES real_transitland_routes(route_id),
	to_route_id TEXT REFERENCES real_transitland_routes(route_id), 
	from_trip_id TEXT REFERENCES real_transitland_trips(trip_id), 
	to_trip_id TEXT REFERENCES real_transitland_trips(trip_id),
	transfer_type SMALLINT NOT NULL REFERENCES gtfs_test.e_transfer_types(transfer_type),
	min_transfer_time INT,
	PRIMARY KEY(file_id, from_stop_id, to_stop_id, from_trip_id, to_trip_id, from_route_id, to_route_id)
);


CREATE TABLE gtfs_test.e_transfer_types(
	transfer_type SMALLINT,
	transfer_type_descr
);

INSERT INTO gtfs_test.e_transfer_types VALUES 
	(0, "Recommended transfer point between routes"),
	(1, "Timed transfer point between two routes. The departing vehicle is expected to wait for the arriving one and leave sufficient time for a rider to transfer between routes"),
	(2, "Transfer requires a minimum amount of time between arrival and departure to ensure a connection. The time required to transfer is specified by min_transfer_time"),
	(3, "Transfers are not possible between routes at the location"),
	(4, "Passengers can transfer from one trip to another by staying onboard the same vehicle (an 'in-seat transfer')"),
	(5, "In-seat transfers are not allowed between sequential trips. The passenger must alight from the vehicle and re-board");



CREATE TABLE gtfs_test.real_transitland_pathways (
	file_id INT REFERENCES gtfs_files(id),
	pathway_id TEXT PRIMARY KEY NOT NULL,
	from_stop_id TEXT REFERENCES real_transitland_stops(stop_id) NOT NULL,
	to_stop_id TEXT REFERENCES real_transitland_stops(stop_id) NOT NULL,
	pathway_mode SMALLINT NOT NULL REFERENCES gtfs_test.e_patyhway_modes(pathway_mode),
	is_bidirectional SMALLINT NOT NULL REFERENCES gtfs_test.e_is_bidirectional(is_bidirectional),
	length FLOAT,
	traversal_time INT,
	stair_count INT NOT NULL,
	max_slope FLOAT,
	min_width FLOAT,
	signposted_as TEXT,
	reversed_signposted_as TEXT,
	PRIMARY KEY(file_id)
);


CREATE TABLE gtfs_test.e_pathway_modes (
	pathway_mode SMALLINT,
	pathway_mode_descr TEXT
);

INSERT INTO gtfs_test.e_pathway_modes VALUES
	(1, "walkway"),
	(2, "stairs"),
	(3, "moving sidewalk/travelator"),
	(4, "escalator"),
	(5, "elevator"),
	(6, "fare gate (or payment gate): A pathway that crosses into an area of the station where proof of payment is required to cross. Fare gates may separate paid areas of the station from unpaid ones, or separate different payment areas within the same station from each other. This information can be used to avoid routing passengers through stations using shortcuts that would require passengers to make unnecessary payments, like directing a passenger to walk through a subway platform to reach a busway"),
	(7, "exit gate: pathway exiting paid area into an unpaid area where proof of paymen is not required to cross");


CREATE TABLE gtfs_test.e_is_bidirectonal (
	is_bidirectional SMALLINT,
	is_bidirectional_descr TEXT
);

INSERT INTO gtfs_test.is_bidirectional VALUES 
	(0, "unidirectional pathway that can only be used from from_stop_id to to_stop_id"),
	(1, "bidirectional pathway that can be used in both directions");




CREATE TABLE gtfs_test.real_transitland_levels (
	file_id INT REFERENCES gtfs_files(id),
	level_id TEXT PRIMARY KEY NOT NULL,
	level_index FLOAT NOT NULL,
	level_name TEXT,
	PRIMARY KEY(file_id, level_id)
);


CREATE TABLE gtfs_test.real_transitland_translations (
	file_id INT REFERENCES gtfs_files(id),
	table_name ENUM NO NULL, -----------------------?????
	field_name TEXT NOT NULL,
	language TEXT NOT NULL,
	TRANSLATION TEXT NOT NULL,
	record_id TEXT, 
	record_sub_id TEXT, 
	field_value TEXT, 
	PRIMARY KEY(file_id, table_name, field_name, language, record_id, record_sub_id, field_value)
);


CREATE TABLE gtfs_test.real_transitland_feed_info (
	file_id INT REFERENCES gtfs_files(id),
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

-- empties default to 0's 
CREATE TABLE gtfs_test.real_transitland_attributions (
	file_id INT REFERENCES gtfs_files(id),
	attribution_id TEXT,
	agency_id TEXT REFERENCES real_transitland_agency(agency_id), 
	route_id TEXT REFERENCES real_transitland_routes(route_id), 
	trip_id TEXT REFERENCES real_transitland_trips(trip_id), 
	organization_name TEXT NOT NULL,
	is_producer SMALLINT REFERENCES gtfs_test.e_is_role(is_role),
	is_operator SMALLINT REFERENCES gtfs_test.e_is_role(is_role),
	is_authority SMALLINT REFERENCES gtfs_test.e_is_role(is_role),
	attribution_url TEXT,
	attribution_email TEXT,
	attribution_phone TEXT,
	PRIMARY KEY(file_id, attribution_id)
);

CREATE TABLE gtfs_test.e_is_role (
	is_role SMALLINT,
	is_role_descr TEXT
);

INSERT INTO gtfs_test.e_is_role VALUES 
	(0, "organization does not have this role"),
	(1, "organization does have this role");





SELECT * FROM gtfs_test.real_transitland_agency
SELECT * FROM gtfs_test.real_transitland_stops
SELECT * FROM gtfs_test.real_transitland_routes
SELECT * FROM gtfs_test.real_transitland_calendar
SELECT * FROM gtfs_test.real_transitland_calendar_dates
SELECT * FROM gtfs_test.real_transitland_shapes
SELECT * FROM gtfs_test.real_transitland_fare_attributes
SELECT * FROM gtfs_test.real_transitland_fare_rules
SELECT * FROM gtfs_test.real_transitland_trips
SELECT * FROM gtfs_test.real_transitland_stop_times
SELECT * FROM gtfs_test.real_transitland_timeframes
SELECT * FROM gtfs_test.real_transitland_fare_media
SELECT * FROM gtfs_test.real_transitland_fare_products
SELECT * FROM gtfs_test.real_transitland_fare_leg_rules
SELECT * FROM gtfs_test.real_transitland_fare_transfer_rules
SELECT * FROM gtfs_test.real_transitland_areas
SELECT * FROM gtfs_test.real_transitland_stop_areas
SELECT * FROM gtfs_test.real_transitland_networks
SELECT * FROM gtfs_test.real_transitland_route_networks
SELECT * FROM gtfs_test.real_transitland_frequencies
SELECT * FROM gtfs_test.real_transitland_transfers
SELECT * FROM gtfs_test.real_transitland_pathways
SELECT * FROM gtfs_test.real_transitland_levels
SELECT * FROM gtfs_test.real_transitland_translations
SELECT * FROM gtfs_test.real_transitland_feed_info
SELECT * FROM gtfs_test.real_transitland_attributions




