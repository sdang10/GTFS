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
	service_id TEXT, -- PRIMARY KEY REFERENCES calendar.service_id
	date TEXT, -- PRIMARY KEY
	exception_type TEXT
);


CREATE TABLE gtfs_test.transitland_shapes (
	shape_id TEXT, -- PRIMARY KEY
	shape_pt_lat TEXT,
	shape_pt_lon TEXT,
	shape_pt_sequence TEXT, -- PRIMARY KEY
	shape_dist_traveled TEXT
);


CREATE TABLE gtfs_test.transitland_fare_attributes (
	fare_id TEXT, -- PRIMARY KEY
	price TEXT,
	currency_type TEXT,
	payment_method TEXT,
	transfers TEXT,
	agency_id TEXT, -- REFERENCES agency.agency_id
	transfer_duration TEXT
);


CREATE TABLE gtfs_test.transitland_fare_rules (
	fare_id TEXT, -- REFERENCES fare_attributes.fare_id
	route_id TEXT, -- REFERENCES routes.route_id
	origin_id TEXT, -- REFERENCES stops.zone_id
	destination_id TEXT, -- REFERENCES stops.zone_id
	contains_id TEXT  -- REFERENCES stops.zone_id
);


CREATE TABLE gtfs_test.transitland_trips (
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
	timeframe_group_id TEXT,
	start_time TEXT,
	end_time TEXT,
	service_id TEXT -- REFERENCES calendar.service_id OR REFERENCES calendar_dates.service_id
);


CREATE TABLE gtfs_test.transitland_fare_media (
	fare_media_id TEXT, -- PRIMARY KEY
	fare_media_name TEXT,
	fare_media_type TEXT
);


CREATE TABLE gtfs_test.transitland_fare_products (
	fare_product_id TEXT, -- PRIMARY KEY
	fare_product_name TEXT,
	fare_media_id TEXT, -- PRIMARY KEY REFERENCES fare_media.fare_media_id
	amount TEXT,
	currency TEXT
);


CREATE TABLE gtfs_test.transitland_fare_leg_rules (
	leg_group_id TEXT,
	network_id TEXT, -- PRIMARY KEY REFERENCES networks.network_id OR routes.network_id
	from_area_id TEXT, -- PRIMARY KEY REFERENCES areas.area_id
	to_area_id TEXT, -- PRIMARY KEY REFERENCES areas.area_id
	from_timeframe_group_id TEXT, -- PRIMARY KEY REFERENCES timesframes.timeframe_group_id
	to_timeframe_group_id TEXT, -- PRIMARY KEY REFERENCES timesframes.timeframe_group_id
	fare_product_id TEXT -- PRIMARY KEY REFERENCES fare_products.fare_product_id
);


CREATE TABLE gtfs_test.transitland_fare_transfer_rules (
	from_leg_group_id TEXT, -- PRIMARY KEY REFERENCES fare_leg_rules.leg_group_id
	to_leg_group_id TEXT, -- PRIMARY KEY REFERENCES fare_leg_rules.leg_group_id
	transfer_count TEXT, -- PRIMARY KEY
	duration_limit TEXT, -- PRIMARY KEY
	duration_limit_type TEXT,
	fare_transfer_type TEXT,
	fare_product_id TEXT -- REFERENCES fare_products.fare_product_id
);


CREATE TABLE gtfs_test.transitland_areas (
	area_id TEXT, -- PRIMARY KEY
	area_name TEXT
);


CREATE TABLE gtfs_test.transitland_stop_areas (
	area_id TEXT, -- PRIMARY KEY REFERENCES areas.area_id
	stop_id TEXT -- PRIMARY KEY REFERENCES stops.stop_id
);


CREATE TABLE gtfs_test.transitland_networks (
	network_id TEXT, -- PRIMARY KEY
	network_name TEXT
);


CREATE TABLE gtfs_test.transitland_route_networks (
	network_id TEXT, -- REFERENCES networks.network_id
	route_id TEXT -- PRIMARY KEY REFERENCES routes.route_id
);


CREATE TABLE gtfs_test.transitland_frequencies (
	trip_id TEXT, -- PRIMARY KEY REFERENCES trips.trip_id
	start_time TEXT, -- PRIMARY KEY
	end_time TEXT,
	headway_secs TEXT,
	exact_times TEXT
);


CREATE TABLE gtfs_test.transitland_transfers (
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
	level_id TEXT, -- PRIMARY KEY
	level_index TEXT,
	level_name TEXT
);


CREATE TABLE gtfs_test.transitland_translations (
	table_name TEXT, -- PRIMARY KEY
	field_name TEXT, -- PRIMARY KEY
	language TEXT, -- PRIMARY KEY
	TRANSLATION TEXT,
	record_id TEXT, -- PRIMARY KEY
	record_sub_id TEXT, -- PRIMARY KEY
	field_value TEXT -- PRIMARY KEY
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
SELECT * FROM gtfs_test.gtfs_extra_attributes 
SELECT * FROM gtfs_test.gtfs_files



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
	agency_id UNIQUE ID PRIMARY KEY, -- NOT NULL?
	agency_name TEXT NOT NULL,
	agency_url URL NOT NULL,
	agency_timezone TIMEZONE NOT NULL,
	agency_lang LANGUAGE CODE,
	agency_phone PHONE NUMBER,
	agency_fare_url URL,
	agency_email EMAIL
);


CREATE TABLE gtfs_test.real_transitland_stops (
	stop_id UNIQUE ID PRRIMARY KEY NOT NULL, 
	stop_code TEXT,
	stop_name TEXT, -- NOT NULL?
	tts_stop_name TEXT,
	stop_desc TEXT,
	stop_lat LATITUDE, -- NOT NULL?
	stop_lon LONGITUDE, -- NOT NULL?
	zone_id ID, -- NOT NULL?
	stop_url URL,
	location_type ENUM,
	parent_station ID REFERENCES real_transitland_stops(stop_id), -- NOT NULL?
	stop_timezone TIMEZONE,
	wheelchair_boarding ENUM,
	level_id ID REFERENCES real_transitland_levels(level_id),
	platform_code TEXT
);


CREATE TABLE gtfs_test.real_transitland_routes (
	route_id UNIQUE ID PRIMARY KEY NOT NULL,
	agency_id ID REFERENCES real_transitland_agency(agency_id), -- NOT NULL?
	route_short_name TEXT, -- NOT NULL?
	route_long_name TEXT, -- NOT NULL?
	route_desc TEXT,
	route_type ENUM NOT NULL,
	route_url URL,
	route_color COLOR,
	route_text_color COLOR,
	route_sort_order NON-NEGATIVE INT,
	continuous_pickup ENUM,
	continuoues_dropoff ENUM,
	network_id ID
);


CREATE TABLE gtfs_test.real_transitland_calendar (
	service_id UNIQUE ID PRIMARY KEY NOT NULL,
	monday ENUM NOT NULL,
	tuesday ENUM NOT NULL,
	wednesday ENUM NOT NULL,
	thursday ENUM NOT NULL,
	friday ENUM NOT NULL,
	saturday ENUM NOT NULL,
	sunday ENUM NOT NULL,
	start_date DATE NOT NULL,
	end_date DATE NOT NULL
);


CREATE TABLE gtfs_test.real_transitland_calendar_dates (
	service_id ID REFERENCES real_transitland_calender(service_id) OR ID NOT NULL,
	date DATE NOT NULL, 
	exception_type ENUM NOT NULL,
	PRIMARY KEY(service_id, date)
);


CREATE TABLE gtfs_test.real_transitland_shapes (
	shape_id ID NOT NULL,
	shape_pt_lat LATITUDE NOT NULL,
	shape_pt_lon LONGITUDE NOT NULL,
	shape_pt_sequence NON NEGATIVE INTEGER NOT NULL,
	shape_dist_traveled NON NEGATIVE INTEGER,
	PRIMARY KEY(shape_id, shape_pt_sequence)
);


CREATE TABLE gtfs_test.real_transitland_fare_attributes (
	fare_id UNIQUE ID PRIMARY KEY NOT NULL,
	price NON NEGATIVE FLOAT NOT NULL,
	currency_type CURRENCY CODE NOT NULL,
	payment_method ENUM NOT NULL,
	transfers ENUM NOT NULL,
	agency_id ID REFERENCES real_transitland_agency(agency_id), -- NOT NULL?
	transfer_duration NON NEGATIVE INTEGER
);


CREATE TABLE gtfs_test.real_transitland_fare_rules (
	fare_id ID REFERENCES real_transitland_fare_attributes(fare_id) NOT NULL,
	route_id ID REFERENCES real_transitland_routes(route_id),
	origin_id ID REFERENCES real_transitland_stops(zone_id),
	destination_id ID REFERENCES real_transitland_stops(zone_id),
	contains_id ID REFERENCES real_transitland_stops(zone_id),
	PRIMARY KEY(fare_id, route_id, origin_id, destination_id, contains_id)
);


CREATE TABLE gtfs_test.real_transitland_trips (
	route_id ID REFERENCES real_transitland_routes(route_id) NOT NULL,
	service_id ID REFERENCES real_transitland_calendar(service_id) OR REFERENCES real_transitland_calendar_dates(service_id) NOT NULL,
	trip_id UNIQUE ID PRIMARY KEY NOT NULL,
	trip_headsign TEXT,
	trip_short_name TEXT,
	direction_id ENUM,
	block_id ID,
	shape_id ID REFERENCES real_transitland_shapes(shape_id), -- NOT NULL?
	wheelchair_accessible ENUM,
	bikes_allowed ENUM
);


CREATE TABLE gtfs_test.real_transitland_stop_times (
	trip_id ID REFERENCES real_transitland_trips(trip_id) NOT NULL,
	arrival_time TIME, -- NOT NULL?
	departure_time TIME, -- NOT NULL?
	stop_id ID REFERENCES real_transitland_stops(stop_id) NOT NULL,
	stop_sequence NON NEGATIVE INTEGER NOT NULL,
	stop_headsign TEXT,
	pickup_type ENUM,
	drop_off_type ENUM,
	continuous_pickup ENUM,
	continuous_dropoff ENUM,
	shape_dist_traveled NON NEGATIVE FLOAT,
	timepoint ENUM,
	PRIMARY KEY(trip_id, stop_sequence)
);


CREATE TABLE gtfs_test.real_transitland_timeframes (
	timeframe_group_id ID NOT NULL,
	start_time TIME, -- NOT NULL?
	end_time TIME, -- NOT NULL?
	service_id ID REFERENCES real_transitland_calendar(service_id) OR REFERENCES real_transitland_calendar_dates(service_id) NOT NULL,
	PRIMARY KEY(timeframe_group_id, start_time, end_time, service_id)
);


CREATE TABLE gtfs_test.real_transitland_fare_media (
	fare_media_id UNIQUE ID PRIMARY KEY NOT NULL,
	fare_media_name TEXT,
	fare_media_type ENUM NOT NULL
);


CREATE TABLE gtfs_test.real_transitland_fare_products (
	fare_product_id ID NOT NULL,
	fare_product_name TEXT,
	fare_media_id ID REFERENCES real_transitland_fare_media(fare_media_id),
	amount CURRENCY AMOUNT NOT NULL,
	currency CURRENCY CODE NOT NULL,
	PRIMARY KEY(fare_product_id, fare_media_id)
);


CREATE TABLE gtfs_test.real_transitland_fare_leg_rules (
	leg_group_id ID,
	network_id ID REFERENCES real_transitland_networks(network_id) OR REFERENCES real_transitland_routes(network_id),
	from_area_id ID REFERENCES real_transitland_areas(area_id),
	to_area_id ID REFERENCES real_transitland_areas(area_id),
	from_timeframe_group_id ID REFERENCES real_transitland_timeframes(timeframe_group_id),
	to_timeframe_group_id ID REFERENCES real_transitland_timeframes(timeframe_group_id),
	fare_product_id ID REFERENCES real_transitland_fare_products(fare_product_id) NOT NULL,
	PRIMARY KEY(network_id, from_area_id, to_area_id, from_timeframe_group_id, to_timeframe_group_id, fare_product_id)
);


CREATE TABLE gtfs_test.real_transitland_fare_transfer_rules (
	from_leg_group_id ID REFERENCES real_transitland_fare_leg_rules(leg_group_id),
	to_leg_group_id ID REFERENCES real_transitland_fare_leg_rules(leg_group_id),
	transfer_count NON ZERO INTEGER, -- NOT NULL?
	duration_limit POSITIVE INTEGER,
	duration_limit_type ENUM, -- NOT NULL?
	fare_transfer_type ENUM NOT NULL,
	fare_product_id ID REFERENCES real_transitland_fare_products(fare_product_id),
	PRIMARY KEY(from_leg_group_id, to_leg_group_id, fare_product_id, transfer_count, duration_limit)
);


CREATE TABLE gtfs_test.real_transitland_areas (
	area_id UNIQUE ID PRIMARY KEY NOT NULL,
	area_name TEXT
);


CREATE TABLE gtfs_test.real_transitland_stop_areas (
	area_id ID REFERENCES real_transitland_areas(area_id) NOT NULL,
	stop_id ID REFERENCES real_transitland_stops(stop_id) NOT NULL,
	PRIMARY KEY(area_id, stop_id)
);


CREATE TABLE gtfs_test.real_transitland_networks (
	network_id UNIQUE ID PRIMARY KEY NOT NULL,
	network_name TEXT
);


CREATE TABLE gtfs_test.real_transitland_route_networks (
	network_id ID REFERENCES real_transitland_networks(network_id) NOT NULL,
	route_id ID REFERENCES real_transitland_routes(route_id) NOT NULL,
	PRIMARY KEY(route_id)
);


CREATE TABLE gtfs_test.real_transitland_frequencies (
	trip_id ID REFERENCES real_transitland_trips(trip_id) NOT NULL,
	start_time TIME NOT NULL,
	end_time TIME NOT NULL,
	headway_secs POSITIVE INTEGER NOT NULL,
	exact_times ENUM,
	PRIMARY KEY(trip_id, start_time)
);


CREATE TABLE gtfs_test.real_transitland_transfers (
	from_stop_id ID REFERENCES real_transitland_stops(stop_id), -- NOT NULL?
	to_stop_id ID REFERENCES real_transitland_stops(stop_id), -- NOT NULL?
	from_route_id ID REFERENCES real_transitland_routes(route_id),
	to_route_id ID REFERENCES real_transitland_routes(route_id), 
	from_trip_id ID REFERENCES real_transitland_trips(trip_id), -- NOT NULL?
	to_trip_id ID REFERENCES real_transitland_trips(trip_id), -- NOT NULL?
	transfer_type ENUM NOT NULL,
	min_transfer_time NON NEGATIVE INTEGER,
	PRIMARY KEY(from_stop_id, to_stop_id, from_trip_id, to_trip_id, from_route_id, to_route_id)
);

CREATE TABLE gtfs_test.real_transitland_pathways (
	pathway_id UNIQUE ID PRIMARY KEY NOT NULL,
	from_stop_id ID REFERENCES real_transitland_stops(stop_id) NOT NULL,
	to_stop_id ID REFERENCES real_transitland_stops(stop_id) NOT NULL,
	pathway_mode ENUM NOT NULL,
	is_bidirectional ENUM NOT NULL,
	length NON NEGATIVE FLOAT,
	traversal_time POSITIVE INTEGER,
	stair_count NON NULL INTEGER,
	max_slope FLOAT,
	min_width POSITIVE FLOAT,
	signposted_as TEXT,
	reversed_signposted_as TEXT
);


CREATE TABLE gtfs_test.real_transitland_levels (
	level_id UNIQUE ID PRIMARY KEY NOT NULL,
	level_index FLOAT NOT NULL,
	level_name TEXT
);


CREATE TABLE gtfs_test.real_transitland_translations (
	table_name ENUM NO NULL,
	field_name TEXT NOT NULL,
	language LANGUAGE CODE NOT NULL,
	TRANSLATION Text or URL or Email or Phone number NOT NULL,
	record_id FOREIGN ID, -- NOT NULL?
	record_sub_id FOREIGN ID, -- NOT NULL?
	field_value Text or URL or Email or Phone number, -- NOT NULL?
	PRIMARY KEY(table_name, field_name, language, record_id, record_sub_id, field_value)
);


CREATE TABLE gtfs_test.real_transitland_feed_info (
	feed_publisher_name TEXT NOT NULL,
	feed_publisher_url URL NOT NULL,
	feed_lang LANGUAGE CODE NOT NULL,
	default_lang LANGUAGE CODE,
	feed_start_date DATE,
	feed_end_date DATE,
	feed_version TEXT,
	feed_contact_email EMAIL,
	feed_contact_url URL
);


CREATE TABLE gtfs_test.real_transitland_attributions (
	attribution_id UNIQUE ID PRIMARY KEY,
	agency_id ID REFERENCES real_transitland_agency(agency_id), 
	route_id ID REFERENCES real_transitland_routes(route_id), 
	trip_id ID REFERENCES real_transitland_trips(trip_id), 
	organization_name TEXT NOT NULL,
	is_producer ENUM,
	is_operator ENUM,
	is_authority ENUM,
	attribution_url URL,
	attribution_email EMAIL,
	attribution_phone PHONE NUMBER
);






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




