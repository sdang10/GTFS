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




CREATE TABLE gtfs_test.transitland_agency (
	agency_id TEXT PRIMARY KEY,
	agency_name TEXT,
	agency_url TEXT,
	agency_timezone TEXT, 
	agency_lang TEXT,
	agency_phone TEXT,
	agency_fare_url TEXT
);


CREATE TABLE gtfs_test.transitland_stops (
	stop_id TEXT PRIMARY KEY,
	stop_code TEXT,
	stop_name TEXT,
	stop_desc TEXT,
	stop_lat TEXT,
	stop_lon TEXT,
	zone_id TEXT,
	stop_url TEXT,
	location_type TEXT,
	parent_station TEXT,
	stop_timezone TEXT
);


CREATE TABLE gtfs_test.transitland_routes (
	route_id TEXT PRIMARY KEY,
	agency_id TEXT,
	route_short_name TEXT,
	route_long_name TEXT,
	route_desc TEXT,
	route_type TEXT,
	route_url TEXT,
	route_color TEXT,
	route_text_color TEXT
);


CREATE TABLE gtfs_test.transitland_calendar (
	service_id TEXT PRIMARY KEY,
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
	fare_id TEXT PRIMARY KEY,
	agency_id TEXT,
	fare_period_id TEXT,
	price TEXT,
	descriptions TEXT,
	currency_type TEXT,
	payment_method TEXT,
	transfers TEXT,
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
	trip_id TEXT PRIMARY KEY,
	trip_headsign TEXT,
	trip_short_name TEXT,
	direction_id TEXT,
	block_id TEXT,
	shape_id TEXT,
	peak_flag TEXT,
	fare_id TEXT
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
	shape_dist_traveled TEXT,
	timepoTEXT TEXT
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



