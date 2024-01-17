CREATE TABLE gtfs_test.transitland_agency (
	agency_id INT2 PRIMARY KEY,
	agency_name TEXT,
	agency_url TEXT,
	-- onestop_id TEXT
	agency_timezone TEXT, 
	agency_lang TEXT,
	agency_phone TEXT,
	agency_fare_url TEXT
);

SELECT * FROM gtfs_test.transitland_agency


CREATE TABLE gtfs_test.transitland_stops (
	stop_id INT PRIMARY KEY,
	-- agency_id INT2 REFERENCES gtfs_test.transitland_agencies(agency_id),
	stop_code TEXT,
	stop_name TEXT,
	stop_desc TEXT,
	stop_lat TEXT,
	stop_lon TEXT,
	zone_id INT,
	stop_url TEXT,
	location_type INT,
	parent_station INT REFERENCES gtfs_test.transitland_stops(stop_id),
	stop_timezone TEXT
);


CREATE TABLE gtfs_test.transitland_routes (
	route_id INT PRIMARY KEY,
	agency_id INT2 REFERENCES gtfs_test.transitland_agency(agency_id),
	route_short_name TEXT,
	route_long_name TEXT,
	route_desc TEXT,
	route_type INT,
	route_url TEXT,
	route_color TEXT,
	route_text_color TEXT
);


CREATE TABLE gtfs_test.transitland_calendar (
	service_id INT PRIMARY KEY,
	monday INT,
	tuesday INT,
	wednesday INT,
	thursday INT,
	friday INT,
	saturday INT,
	sunday INT,
	start_date TEXT,
	end_date TEXT
);

SELECT * FROM gtfs_test.transitland_calendar


CREATE TABLE gtfs_test.transitland_calendar_dates (
	service_id INT REFERENCES gtfs_test.transitland_calendar(service_id),
	date TEXT,
	exception_type INT
);

SELECT * FROM gtfs_test.transitland_calendar_dates


CREATE TABLE gtfs_test.transitland_shapes (
	shape_id INT PRIMARY KEY,
	shape_pt_lat TEXT,
	shape_pt_lon TEXT,
	shape_pt_sequence INT,
	shape_dist_traveled FLOAT
);


CREATE TABLE gtfs_test.transitland_fare_attributes (
	fare_id INT PRIMARY KEY,
	agency_id INT REFERENCES gtfs_test.transitland_agency(agency_id),
	fare_period_id TEXT, -- ?????
	price FLOAT,
	descriptions TEXT,
	currency_type TEXT,
	payment_method INT,
	transfers INT,
	transfer_duration INT
);


CREATE TABLE gtfs_test.transitland_fare_rules (
	fare_id INT REFERENCES gtfs_test.transitland_fare_attributes(fare_id),
	route_id INT REFERENCES gtfs_test.transitland_routes(route_id),
	origin_id INT, --REFERENCES gtfs_test.transitland_stops(zone_id), ??
	destination_id INT, --REFERENCES gtfs_test.transitland_stops(zone_id), ??
	contains_id INT --REFERENCES gtfs_test.transitland_stops(zone_id) ??
);


CREATE TABLE gtfs_test.transitland_trips (
	route_id INT REFERENCES gtfs_test.transitland_routes(route_id),
	service_id INT REFERENCES gtfs_test.transitland_calendar(service_id),
	trip_id INT PRIMARY KEY,
	trip_headsign TEXT,
	trip_short_name TEXT,
	direction_id INT,
	block_id INT,
	shape_id INT REFERENCES gtfs_test.transitland_shapes(shape_id),
	peak_flag TEXT, -- ????
	fare_id INT REFERENCES gtfs_test.transitland_fare_attributes(fare_id)
);


CREATE TABLE gtfs_test.transitland_stop_times (
	trip_id INT REFERENCES gtfs_test.transitland_trips(trip_id),
	arrival_time TEXT,
	departure_time TEXT,
	stop_id INT REFERENCES gtfs_test.transitland_stops(stop_id),
	stop_sequence INT,
	stop_headsign TEXT,
	pickup_type INT,
	drop_off_type INT,
	shape_dist_traveled FLOAT,
	timepoint INT
);

SELECT * FROM gtfs.v_transitland_feed_info;


















DROP TABLE gtfs_test.transitland_test

CREATE TABLE gtfs_test.transitland_test(
	agency_id INT2 PRIMARY KEY,
	agency_name TEXT,
	agency_url TEXT,
	-- onestop_id TEXT
	agency_timezone TEXT, 
	agency_lang TEXT,
	agency_phone TEXT,
	agency_fare_url TEXT
);

SELECT * FROM gtfs_test.transitland_test






