-- ALL TABLES FOR COLUMNS THAT PERTAIN TO ENUMERATOR VALUES


CREATE TABLE gtfs_test.e_location_types(
	location_type SMALLINT PRIMARY KEY,
	location_descr TEXT
);
-- SELECT * FROM gtfs_test.e_location_types

CREATE TABLE gtfs_test.e_wheelchair_boardings(
	wheelchair_boarding SMALLINT PRIMARY KEY,
	wheelchair_boarding_descr TEXT
);
-- SELECT * FROM gtfs_test.e_wheelchair_boardings 

CREATE TABLE gtfs_test.e_route_types (
	route_type SMALLINT PRIMARY KEY,
	route_type_descr TEXT
);
-- SELECT * FROM gtfs_test.e_route_types

CREATE TABLE gtfs_test.e_continuous_pickup (
	continuous_pickup SMALLINT PRIMARY KEY,
	continuous_pickup_descr TEXT
);
-- SELECT * FROM gtfs_test.e_continuous_pickup

CREATE TABLE gtfs_test.e_continuous_drop_off (
	continuous_drop_off SMALLINT PRIMARY KEY,
	continuous_drop_off_descr TEXT
);
-- SELECT * FROM gtfs_test.e_continuous_drop_off

CREATE TABLE gtfs_test.e_service_availability (
	service_availability SMALLINT PRIMARY KEY,
	service_availability_descr TEXT
);
-- SELECT * FROM gtfs_test.e_service_availability

CREATE TABLE gtfs_test.e_exception_types (
	exception_type SMALLINT PRIMARY KEY,
	exception_type_descr TEXT
);
-- SELECT * FROM gtfs_test.e_exception_types

CREATE TABLE gtfs_test.e_payment_methods(
	payment_method SMALLINT PRIMARY KEY,
	payment_method_descr TEXT
);
-- SELECT * FROM gtfs_test.e_payment_methods

CREATE TABLE gtfs_test.e_transfers(
	transfer SMALLINT PRIMARY KEY,
	transfer_descr TEXT
);
-- SELECT * FROM gtfs_test.e_transfers

CREATE TABLE gtfs_test.e_direction_ids (
	direction_id SMALLINT PRIMARY KEY,
	direction_id_descr TEXT
);
-- SELECT * FROM gtfs_test.e_direction_ids

CREATE TABLE gtfs_test.e_wheelchair_accessibility(
	wheelchair_accessibility SMALLINT PRIMARY KEY,
	wheelchair_accessibility_descr TEXT
);
-- SELECT * FROM gtfs_test.e_wheelchair_accessibility

CREATE TABLE gtfs_test.e_bikes_allowed(
	bikes_allowed SMALLINT PRIMARY KEY,
	bikes_allowed_descr TEXT
);
-- SELECT * FROM gtfs_test.e_bikes_allowed

CREATE TABLE gtfs_test.e_pickup_types(
	pickup_type SMALLINT PRIMARY KEY,
	pickup_type_descr TEXT
);
-- SELECT * FROM gtfs_test.e_pickup_types

CREATE TABLE gtfs_test.e_drop_off_types(
	drop_off_type SMALLINT PRIMARY KEY,
	drop_off_type_descr TEXT
);
-- SELECT * FROM gtfs_test.e_drop_off_types

CREATE TABLE gtfs_test.e_timepoints (
	timepoint SMALLINT PRIMARY KEY,
	timepoint_descr TEXT
);
-- SELECT * FROM gtfs_test.e_timepoints

CREATE TABLE gtfs_test.e_fare_media_types(
	fare_media_type SMALLINT PRIMARY KEY,
	fare_media_type_descr TEXT
);
-- SELECT * FROM gtfs_test.e_fare_media_types

CREATE TABLE gtfs_test.e_duration_limit_types(
	duration_limit_type SMALLINT PRIMARY KEY,
	duration_limit_type_descr TEXT
);
-- SELECT * FROM gtfs_test.e_duration_limit_types

CREATE TABLE gtfs_test.e_fare_transfer_types(
	fare_transfer_type SMALLINT PRIMARY KEY,
	fare_transfer_type_descr TEXT
);
-- SELECT * FROM gtfs_test.e_fare_transfer_types

CREATE TABLE gtfs_test.e_exact_times (
	exact_times SMALLINT PRIMARY KEY,
	exact_times_descr TEXT
);
-- SELECT * FROM gtfs_test.e_exact_times

CREATE TABLE gtfs_test.e_transfer_types(
	transfer_type SMALLINT PRIMARY KEY,
	transfer_type_descr
);
-- SELECT * FROM gtfs_test.e_transfer_types

CREATE TABLE gtfs_test.e_pathway_modes (
	pathway_mode SMALLINT PRIMARY KEY,
	pathway_mode_descr TEXT
);
-- SELECT * FROM gtfs_test.e_pathway_modes

CREATE TABLE gtfs_test.e_is_bidirectonal (
	is_bidirectional SMALLINT PRIMARY KEY,
	is_bidirectional_descr TEXT
);
-- SELECT * FROM gtfs_test.e_is_bidirectional

CREATE TABLE gtfs_test.e_is_role (
	is_role SMALLINT PRIMARY KEY,
	is_role_descr TEXT
);
-- SELECT * FROM gtfs_test.e_is_role


---------------------------------------------------------------------------------------------

-- INSERTING THE VALUES INTO THE TABLES

INSERT INTO gtfs_test.e_location_types VALUES
	(0, 'stop or platform'),
	(1, 'station'),
	(2, 'entrance or exit'),
	(3, 'generic node'),
	(4, 'boarding area');

INSERT INTO gtfs_test.e_wheelchair_boardings VALUES
	(0, 'parentless stops: no info; 
child stops: inherit wheelchair_boarding behavior from parent station; 
stations entrance/exits: inherit wheelchair_boarding behavior from parent station'),
	(1, 'parentless stops: some vehicles at this stop can be boarded by a rider in wheelchair; 
child stops: some accessible path from outside the station to the specific stop/platform; 
stations entrance/exits: entrance is wheelchair accessible'),
	(2, 'parentless stops: wheelchair boarding not possible at this stop; 
child stops: no accessible path from outside the station to the specific stop/platform; 
stations entrance/exits: no accessible path from station entrance to stops/platforms');

INSERT INTO gtfs_test.e_route_types VALUES 
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

INSERT INTO gtfs_test.e_continuous_pickup VALUES 
	(0, 'continuous stopping pickup'),
	(1, 'no continuous stopping pickup'),
	(2, 'must phone agency to arrange continuous stopping pickup'),
	(3, 'must coordinate with driver to arrange continuous stopping pickup');

INSERT INTO gtfs_test.e_continuous_drop_off VALUES 
	(0, 'continuous stopping drop off'),
	(1, 'no continuous stopping drop off'),
	(2, 'must phone agency to arrange continuous stopping drop off'),
	(3, 'must coordinate with driver to arrange continuous stopping drop off');

INSERT INTO gtfs_test.e_service_availability VALUES 
	(0, 'service not available for all of this week day in the date range'),
	(1, 'service is available for all of this week day in the date range');

INSERT INTO gtfs_test.e_exception_types VALUES
	(1, 'service has been added for the specified date'),
	(2, 'service has been removed for the specified date');

INSERT INTO gtfs_test.e_payment_methods VALUES
	(0, 'fair is paid on board'),
	(1, 'fair must be payd before boarding');

INSERT INTO gtfs_test.e_transfers VALUES 
	(0, "no transfers permitted"),
	(1, "riders may transfer once"),
	(2, "riders may transfer twice"),
	('', "unlimited transfers are permitted");

INSERT INTO gtfs_test.e_direction_ids VALUES
	(0, 'travel in one direction (e.g. outbound travel)'),
	(1, 'travel in the opposite direction (e.g. inbound travel)');

INSERT INTO gtfs_test.e_wheelchair_accessibility VALUES
	(0, 'no accessibility info'),
	(1, 'vehicle being used on this particular trip can accommodate at least one rider in a wheelchair'),
	(2, 'no riders in wheelchairs can be accommodated on this trip');

INSERT INTO gtfs_test.e_bikes_allowed VALUES
	(0, 'no bike info'),
	(1, 'vehicle being used on this particular trip can accommodate at least one bicycle'),
	(2, 'no bicycles allowed on this trip');

INSERT INTO gtfs_test.e_pickup_types VALUES 
	(0, 'regularly_scheduled_pickup'),
	(1, 'no pickup available'),
	(2, 'must phone agency to arrange pickup'),
	(3, 'must coordinate with driver to arrange pickup');

INSERT INTO gtfs_test.e_drop_off_types VALUES 
	(0, 'regularly scheduled drop off'),
	(1, 'no pickup available'),
	(2, 'must phone agency to arrange drop off'),
	(3, 'must coordinate with driver to arrange drop off');

INSERT INTO gtfs_test.e_timepoints VALUES 
	(0, 'times are considered approximated'),
	(1, 'times are considered exact');

INSERT INTO gtfs_test.e_fare_media_types VALUES 
	(0, 'none, no fare media involved in purchasing or validating a fare product, such as paying cash to a driver or conductor with no physical ticket provided'),
	(1, 'Physical paper ticket that allows a passenger to take either a certain number of pre-purchased trips or unlimited trips within a fixed period of time'),
	(2, 'Physical transit card that has stored tickets, passes or monetary value'),
	(3, 'cEMV (contactless Europay, Mastercard and Visa) as an open-loop token container for account-based ticketing'),
	(4, 'Mobile app that have stored virtual transit cards, tickets, passes, or monetary value');

INSERT INTO gtfs_test.e_duration_limit_types VALUES
	(0, 'Between the departure fare validation of the current leg and the arrival fare validation of the next leg'),
	(1, 'Between the departure fare validation of the current leg and the departure fare validation of the next leg'),
	(2, 'Between the arrival fare validation of the current leg and the departure fare validation of the next leg'),
	(3, 'Between the arrival fare validation of the current leg and the arrival fare validation of the next leg');

INSERT INTO gtfs_test.e_fare_transfer_types VALUES 
	(0, 'From-leg fare_leg_rules.fare_product_id plus fare_transfer_rules.fare_product_id; A + AB'),
	(1, 'From-leg fare_leg_rules.fare_product_id plus fare_transfer_rules.fare_product_id plus to-leg fare_leg_rules.fare_product_id; A + AB + B'),
	(2, 'fare_transfer_rules.fare_product_id; AB');

INSERT INTO gtfs_test.e_exact_times VALUES 
	(0, 'frequency-based trips'),
	(1, 'schedule-based trips with the exact same headway throughout the day');

INSERT INTO gtfs_test.e_transfer_types VALUES 
	(0, 'Recommended transfer point between routes'),
	(1, 'Timed transfer point between two routes. The departing vehicle is expected to wait for the arriving one and leave sufficient time for a rider to transfer between routes'),
	(2, 'Transfer requires a minimum amount of time between arrival and departure to ensure a connection. The time required to transfer is specified by min_transfer_time'),
	(3, 'Transfers are not possible between routes at the location'),
	(4, 'Passengers can transfer from one trip to another by staying onboard the same vehicle (an in-seat transfer)'),
	(5, 'In-seat transfers are not allowed between sequential trips. The passenger must alight from the vehicle and re-board');

INSERT INTO gtfs_test.e_pathway_modes VALUES
	(1, 'walkway'),
	(2, 'stairs'),
	(3, 'moving sidewalk/travelator'),
	(4, 'escalator'),
	(5, 'elevator'),
	(6, 'fare gate (or payment gate): A pathway that crosses into an area of the station where proof of payment is required to cross. Fare gates may separate paid areas of the station from unpaid ones, or separate different payment areas within the same station from each other. This information can be used to avoid routing passengers through stations using shortcuts that would require passengers to make unnecessary payments, like directing a passenger to walk through a subway platform to reach a busway'),
	(7, 'exit gate: pathway exiting paid area into an unpaid area where proof of paymen is not required to cross');

INSERT INTO gtfs_test.is_bidirectional VALUES 
	(0, 'unidirectional pathway that can only be used from from_stop_id to to_stop_id'),
	(1, 'bidirectional pathway that can be used in both directions');

INSERT INTO gtfs_test.e_is_role VALUES 
	(0, 'organization does not have this role'),
	(1, 'organization does have this role');
