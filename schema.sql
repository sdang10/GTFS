------------------------------------------------------------
-- file: schema.sql
-- author: Shane K. Dang <dangit17@uw.edu>
-- description: gtfs data tables and processing
------------------------------------------------------------

-- GTFS spec: https://gtfs.org/schedule/reference/

-- transitland gtfs feed file information
CREATE TABLE gtfs.transitland_feeds (
    feed_id integer PRIMARY KEY -- use transitland internal id as file id
    ,agency_id smallint NOT NULL REFERENCES trac.agencies(agency_id)
    ,fetched_at_utc timestamptz NOT NULL        -- utc time
    ,earliest_calendar_date date NOT NULL
    ,latest_calendar_date date NOT NULL
    ,sha1 bytea NOT NULL UNIQUE
    ,url text
    ,created_utc timestamptz NOT NULL DEFAULT util.f_now_utc()
);

-- create indices
CREATE INDEX ON gtfs.transitland_feeds (agency_id);

-- view for getting transitland info
CREATE OR REPLACE VIEW gtfs.v_transitland_feed_info AS
WITH m AS ( -- get max id for each agency from feeds
    SELECT  f.agency_id
            ,max(feed_id) AS max_id
      FROM  gtfs.transitland_feeds f
    GROUP BY 1
)
SELECT  a.agency_id
        ,a.gtfs_agency_id
        ,ta.feed_onestop_id
        ,greatest(ta.min_feed_id, m.max_id) AS latest_id
  FROM  trac.agencies a
  JOIN  trac.transitland_agencies ta ON ta.agency_id = a.agency_id
  LEFT  JOIN m ON m.agency_id = a.agency_id
ORDER BY a.agency_id;

/**********************************************************/
/******************** GTFS ENUMERATIONS *******************/
/**********************************************************/

-- gtfs location types
CREATE TABLE gtfs.e_location_types(
    location_type smallint PRIMARY KEY
    ,location_descr text NOT NULL
);

INSERT INTO gtfs.e_location_types VALUES
    (-1, 'nan'),
    (0, 'stop or platform'),
    (1, 'station'),
    (2, 'entrance or exit'),
    (3, 'generic node'),
    (4, 'boarding area');

-- gtfs wheelchair boardings
CREATE TABLE gtfs.e_wheelchair_boardings(
    wheelchair_boarding smallint PRIMARY KEY,
    wheelchair_boarding_descr text NOT NULL
);

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

-- gtfs route types
CREATE TABLE gtfs.e_route_types (
    route_type smallint PRIMARY KEY,
    route_type_descr text NOT NULL
);

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

-- gtfs continuous pickup
CREATE TABLE gtfs.e_continuous_pickup (
    continuous_pickup smallint PRIMARY KEY,
    continuous_pickup_descr text NOT NULL
);

INSERT INTO gtfs.e_continuous_pickup VALUES 
    (-2, 'illegal value'),
    (-1, 'nan'),
    (0, 'continuous stopping pickup'),
    (1, 'no continuous stopping pickup'),
    (2, 'must phone agency to arrange continuous stopping pickup'),
    (3, 'must coordinate with driver to arrange continuous stopping pickup');

-- gtfs continuous drop_off
CREATE TABLE gtfs.e_continuous_drop_off (
    continuous_drop_off smallint PRIMARY KEY,
    continuous_drop_off_descr text NOT NULL
);

INSERT INTO gtfs.e_continuous_drop_off VALUES 
    (-2, 'illegal value'),
    (-1, 'nan'),
    (0, 'continuous stopping drop off'),
    (1, 'no continuous stopping drop off'),
    (2, 'must phone agency to arrange continuous stopping drop off'),
    (3, 'must coordinate with driver to arrange continuous stopping drop off');

-- gtfs service availability
CREATE TABLE gtfs.e_service_availability (
    service_availability smallint PRIMARY KEY,
    service_availability_descr text NOT NULL
);

INSERT INTO gtfs.e_service_availability VALUES 
    (0, 'service not available for all of this week day in the date range'),
    (1, 'service is available for all of this week day in the date range');

-- gtfs exception types
CREATE TABLE gtfs.e_exception_types (
    exception_type smallint PRIMARY KEY,
    exception_type_descr text NOT NULL
);

INSERT INTO gtfs.e_exception_types VALUES
    (1, 'service has been added for the specified date'),
    (2, 'service has been removed for the specified date');

-- gtfs payment methods
CREATE TABLE gtfs.e_payment_methods(
    payment_method smallint PRIMARY KEY,
    payment_method_descr text NOT NULL
);

INSERT INTO gtfs.e_payment_methods VALUES
    (0, 'fare is paid on board'),
    (1, 'fare must be paid before boarding');

-- gtfs transfers
CREATE TABLE gtfs.e_transfers(
    transfer smallint PRIMARY KEY,
    transfer_descr text NOT NULL
);

INSERT INTO gtfs.e_transfers VALUES 
    (-1, 'nan'),
    (0, 'no transfers permitted'),
    (1, 'riders may transfer once'),
    (2, 'riders may transfer twice'),
    (99, 'unlimited transfers are permitted');

-- gtfs direction ids
CREATE TABLE gtfs.e_direction_ids (
    direction_id smallint PRIMARY KEY,
    direction_id_descr text NOT NULL
);

INSERT INTO gtfs.e_direction_ids VALUES
    (0, 'travel in one direction (e.g. outbound travel)'),
    (1, 'travel in the opposite direction (e.g. inbound travel)');

-- gtfs wheelchair accessibility
CREATE TABLE gtfs.e_wheelchair_accessibility(
    wheelchair_accessibility smallint PRIMARY KEY,
    wheelchair_accessibility_descr text NOT NULL
);

INSERT INTO gtfs.e_wheelchair_accessibility VALUES
    (-1, 'nan'),
    (0, 'no accessibility info'),
    (1, 'vehicle being used on this particular trip can accommodate at least one rider in a wheelchair'),
    (2, 'no riders in wheelchairs can be accommodated on this trip');

-- gtfs bikes allowed
CREATE TABLE gtfs.e_bikes_allowed(
    bikes_allowed smallint PRIMARY KEY,
    bikes_allowed_descr text NOT NULL
);

INSERT INTO gtfs.e_bikes_allowed VALUES
    (-1, 'nan'),
    (0, 'no bike info'),
    (1, 'vehicle being used on this particular trip can accommodate at least one bicycle'),
    (2, 'no bicycles allowed on this trip');

-- gtfs pickup types
CREATE TABLE gtfs.e_pickup_types(
    pickup_type smallint PRIMARY KEY,
    pickup_type_descr text NOT NULL
);

INSERT INTO gtfs.e_pickup_types VALUES 
    (-1, 'nan'),
    (0, 'regularly scheduled pickup'),
    (1, 'no pickup available'),
    (2, 'must phone agency to arrange pickup'),
    (3, 'must coordinate with driver to arrange pickup');

-- gtfs drop_off types
CREATE TABLE gtfs.e_drop_off_types(
    drop_off_type smallint PRIMARY KEY,
    drop_off_type_descr text NOT NULL
);

INSERT INTO gtfs.e_drop_off_types VALUES 
    (-1, 'nan'),
    (0, 'regularly scheduled drop off'),
    (1, 'no drop off available'),
    (2, 'must phone agency to arrange drop off'),
    (3, 'must coordinate with driver to arrange drop off');

-- gtfs timepoints
CREATE TABLE gtfs.e_timepoints (
    timepoint smallint PRIMARY KEY,
    timepoint_descr text NOT NULL
);

INSERT INTO gtfs.e_timepoints VALUES 
    (0, 'times are considered approximated'),
    (1, 'times are considered exact');

-- gtfs fare media types
CREATE TABLE gtfs.e_fare_media_types(
    fare_media_type smallint PRIMARY KEY,
    fare_media_type_descr text NOT NULL
);

INSERT INTO gtfs.e_fare_media_types VALUES 
    (0, 'none, no fare media involved in purchasing or validating a fare product, such as paying cash to a driver or conductor with no physical ticket provided'),
    (1, 'physical paper ticket that allows a passenger to take either a certain number of pre-purchased trips or unlimited trips within a fixed period of time'),
    (2, 'physical transit card that has stored tickets, passes or monetary value'),
    (3, 'cEMV (contactless Europay, Mastercard and Visa) as an open-loop token container for account-based ticketing'),
    (4, 'mobile app that have stored virtual transit cards, tickets, passes, or monetary value');

-- gtfs duration limit types
CREATE TABLE gtfs.e_duration_limit_types(
    duration_limit_type smallint PRIMARY KEY,
    duration_limit_type_descr text NOT NULL
);

INSERT INTO gtfs.e_duration_limit_types VALUES
    (0, 'between the departure fare validation of the current leg and the arrival fare validation of the next leg'),
    (1, 'between the departure fare validation of the current leg and the departure fare validation of the next leg'),
    (2, 'between the arrival fare validation of the current leg and the departure fare validation of the next leg'),
    (3, 'between the arrival fare validation of the current leg and the arrival fare validation of the next leg');

-- gtfs fare transfer types
CREATE TABLE gtfs.e_fare_transfer_types(
    fare_transfer_type smallint PRIMARY KEY,
    fare_transfer_type_descr text NOT NULL
);

INSERT INTO gtfs.e_fare_transfer_types VALUES 
    (0, 'from-leg `fare_leg_rules.fare_product_id` plus `fare_transfer_rules.fare_product_id`; A + AB'),
    (1, 'from-leg `fare_leg_rules.fare_product_id` plus `fare_transfer_rules.fare_product_id` plus to-leg `fare_leg_rules.fare_product_id`; A + AB + B'),
    (2, '`fare_transfer_rules.fare_product_id`; AB');

-- gtfs exact times
CREATE TABLE gtfs.e_exact_times (
    exact_times smallint PRIMARY KEY,
    exact_times_descr text NOT NULL
);

INSERT INTO gtfs.e_exact_times VALUES 
    (0, 'frequency-based trips'),
    (1, 'schedule-based trips with the exact same headway throughout the day');

-- gtfs transfer types
CREATE TABLE gtfs.e_transfer_types(
    transfer_type smallint PRIMARY KEY,
    transfer_type_descr text NOT NULL
);

INSERT INTO gtfs.e_transfer_types VALUES 
    (0, 'Recommended transfer point between routes'),
    (1, 'Timed transfer point between two routes. The departing vehicle is expected to wait for the arriving one and leave sufficient time for a rider to transfer between routes'),
    (2, 'Transfer requires a minimum amount of time between arrival and departure to ensure a connection. The time required to transfer is specified by min_transfer_time'),
    (3, 'Transfers are not possible between routes at the location'),
    (4, 'Passengers can transfer from one trip to another by staying onboard the same vehicle (an in-seat transfer)'),
    (5, 'In-seat transfers are not allowed between sequential trips. The passenger must alight from the vehicle and re-board');

-- gtfs pathway modes
CREATE TABLE gtfs.e_pathway_modes (
    pathway_mode smallint PRIMARY KEY,
    pathway_mode_descr text NOT NULL
);

INSERT INTO gtfs.e_pathway_modes VALUES
    (1, 'walkway'),
    (2, 'stairs'),
    (3, 'moving sidewalk/travelator'),
    (4, 'escalator'),
    (5, 'elevator'),
    (6, 'fare gate (or payment gate): A pathway that crosses into an area of the station where proof of payment is required to cross. Fare gates may separate paid areas of the station from unpaid ones, or separate different payment areas within the same station from each other. This information can be used to avoid routing passengers through stations using shortcuts that would require passengers to make unnecessary payments, like directing a passenger to walk through a subway platform to reach a busway'),
    (7, 'exit gate: pathway exiting paid area into an unpaid area where proof of paymen is not required to cross');

-- gtfs is bidirectional
CREATE TABLE gtfs.e_is_bidirectional (
    is_bidirectional smallint PRIMARY KEY,
    is_bidirectional_descr text NOT NULL
);

INSERT INTO gtfs.e_is_bidirectional VALUES 
    (0, 'unidirectional pathway that can only be used from from_stop_id to to_stop_id'),
    (1, 'bidirectional pathway that can be used in both directions');

-- gtfs is role
CREATE TABLE gtfs.e_is_role (
    is_role smallint PRIMARY KEY,
    is_role_descr text NOT NULL
);

INSERT INTO gtfs.e_is_role VALUES 
    (0, 'organization does not have this role'),
    (1, 'organization does have this role');

/**********************************************************/
/******************** GTFS DATA TABLES ********************/
/**********************************************************/

-- bad feeds (feeds that are malformed or do not follow the spec
-- NOTE previously tried to fix, but ambiguous errors prevent fixing
CREATE TABLE gtfs.tl_bad_feeds (
    feed_id integer PRIMARY KEY REFERENCES gtfs.transitland_feeds(feed_id)
);

/* NOTE no longer preserving due to difficulty managing
-- extra attributes in standard tables
CREATE TABLE gtfs.real_gtfs_extra_attributes (
    feed_id integer NOT NULL REFERENCES gtfs.transitland_feeds(feed_id)
    ,file_name text NOT NULL
    ,column_name text NOT NULL
    ,value text
);
*/

-- extra files encountered in import process
CREATE TABLE gtfs.tl_extra_files (
    feed_id integer NOT NULL REFERENCES gtfs.transitland_feeds(feed_id)
    ,file_name text NOT NULL
);

-- agency file (required)
CREATE TABLE gtfs.tl_agency (
    feed_id integer NOT NULL REFERENCES gtfs.transitland_feeds(feed_id)
    ,agency_id text NOT NULL  -- conditionally required?
    ,agency_name text NOT NULL
    ,agency_url text NOT NULL
    ,agency_timezone text NOT NULL
    ,agency_lang text
    ,agency_phone text
    ,agency_fare_url text
    ,agency_email text
    ,PRIMARY KEY(feed_id, agency_id)
);

-- feed info file
CREATE TABLE gtfs.tl_feed_info (
    feed_id integer NOT NULL REFERENCES gtfs.transitland_feeds(feed_id)
    ,feed_publisher_name text NOT NULL
    ,feed_publisher_url text NOT NULL
    ,feed_lang text NOT NULL
    ,default_lang text
    ,feed_start_date DATE
    ,feed_end_date DATE
    ,feed_version text
    ,feed_contact_email text
    ,feed_contact_url text
);

-- translations file
CREATE TABLE gtfs.tl_translations (
    feed_id integer NOT NULL REFERENCES gtfs.transitland_feeds(feed_id)
    ,table_name text NOT NULL --????? ENUM allowed VALUES ARE: agency, stops, routes, trips, stop_times, pathways, levels, feed_info, attributions
    ,field_name text NOT NULL
    ,language text NOT NULL
    ,"translation" text NOT NULL
    ,record_id text -- conditionally required
    ,record_sub_id text -- conditionally required
    ,field_value text -- conditionally required
    ,PRIMARY KEY(feed_id, table_name, field_name, language, record_id, record_sub_id, field_value)
);

-- networks file
CREATE TABLE gtfs.tl_networks (
    feed_id integer NOT NULL REFERENCES gtfs.transitland_feeds(feed_id)
    ,network_id text NOT NULL
    ,network_name text
    ,PRIMARY KEY(feed_id, network_id)
);

-- fare media file
CREATE TABLE gtfs.tl_fare_media (
    feed_id integer NOT NULL REFERENCES gtfs.transitland_feeds(feed_id)
    ,fare_media_id text NOT NULL
    ,fare_media_name text
    ,fare_media_type smallint NOT NULL REFERENCES gtfs.e_fare_media_types(fare_media_type)
    ,PRIMARY KEY(feed_id, fare_media_id)
);

-- shapes file
CREATE TABLE gtfs.tl_shapes (
    feed_id integer NOT NULL REFERENCES gtfs.transitland_feeds(feed_id)
    ,shape_id text NOT NULL
    ,shape_pt_lat real NOT NULL
    ,shape_pt_lon real NOT NULL
    ,shape_pt_location geometry(Point,32610) -- CREATED A geometry point COLUMN USING the shape point lat lon values
    ,shape_pt_sequence integer NOT NULL -- NON-NEGATIVE
    ,shape_dist_traveled real   -- NON-NEGATIVE
    ,PRIMARY KEY(feed_id, shape_id, shape_pt_sequence)
);

-- calendar file (conditionally required)
CREATE TABLE gtfs.tl_calendar (
    feed_id integer NOT NULL REFERENCES gtfs.transitland_feeds(feed_id)
    ,service_id text NOT NULL
    ,monday smallint NOT NULL REFERENCES gtfs.e_service_availability(service_availability)
    ,tuesday smallint NOT NULL REFERENCES gtfs.e_service_availability(service_availability)
    ,wednesday smallint NOT NULL REFERENCES gtfs.e_service_availability(service_availability)
    ,thursday smallint NOT NULL REFERENCES gtfs.e_service_availability(service_availability)
    ,friday smallint NOT NULL REFERENCES gtfs.e_service_availability(service_availability)
    ,saturday smallint NOT NULL REFERENCES gtfs.e_service_availability(service_availability)
    ,sunday smallint NOT NULL REFERENCES gtfs.e_service_availability(service_availability)
    ,start_date date NOT NULL
    ,end_date date NOT NULL
    ,PRIMARY KEY(feed_id, service_id)
);

-- calendar dates file (conditionally required)
CREATE TABLE gtfs.tl_calendar_dates (
    feed_id integer NOT NULL REFERENCES gtfs.transitland_feeds(feed_id)
    ,service_id text NOT NULL -- REFERENCES tl_calender(service_id) OR this table's service_id
    ,"date" date NOT NULL
    ,exception_type smallint NOT NULL REFERENCES gtfs.e_exception_types(exception_type)
    ,PRIMARY KEY(feed_id, service_id, date)
);

-- levels file
CREATE TABLE gtfs.tl_levels (
    feed_id integer NOT NULL REFERENCES gtfs.transitland_feeds(feed_id)
    ,level_id text NOT NULL
    ,level_index real NOT NULL
    ,level_name text
    ,PRIMARY KEY(feed_id, level_id)
);

-- areas file
CREATE TABLE gtfs.tl_areas (
    feed_id integer NOT NULL REFERENCES gtfs.transitland_feeds(feed_id)
    ,area_id text NOT NULL
    ,area_name text
    ,PRIMARY KEY(feed_id, area_id)
);

-- stops file (required)
CREATE TABLE gtfs.tl_stops (
    feed_id integer NOT NULL REFERENCES gtfs.transitland_feeds(feed_id)
    ,stop_id text NOT NULL
    ,stop_code text
    ,stop_name text -- conditionally required
    ,tts_stop_name text
    ,stop_desc text
    ,stop_lat real -- conditionally required 
    ,stop_lon real -- conditionally required
    ,stop_location geometry(Point,32610) -- CREATED A geometry point COLUMN USING the shape point lat lon values
    ,zone_id text -- conditionally required
    ,stop_url text
    ,location_type smallint REFERENCES gtfs.e_location_types(location_type)
    ,parent_station text -- REFERENCES stop_id, so it REFERENCES itself
    ,stop_timezone text
    ,wheelchair_boarding smallint REFERENCES gtfs.e_wheelchair_boardings(wheelchair_boarding)
    ,level_id text
    ,platform_code text
    ,PRIMARY KEY(feed_id, stop_id)
    -- ,FOREIGN KEY(feed_id, parent_station) REFERENCES gtfs.tl_stops(feed_id, stop_id)
    -- ,FOREIGN KEY(feed_id, level_id) REFERENCES gtfs.tl_levels(feed_id, level_id)
);

-- routes file (required)
CREATE TABLE gtfs.tl_routes (
    feed_id integer NOT NULL REFERENCES gtfs.transitland_feeds(feed_id)
    ,route_id text NOT NULL
    ,agency_id text -- conditionally required
    ,route_short_name text -- conditionally required
    ,route_long_name text -- conditionally required
    ,route_desc text
    ,route_type smallint NOT NULL REFERENCES gtfs.e_route_types(route_type)
    ,route_url text
    ,route_color text
    ,route_text_color text
    ,route_sort_order integer 
    ,continuous_pickup smallint REFERENCES gtfs.e_continuous_pickup(continuous_pickup)
    ,continuous_drop_off smallint REFERENCES gtfs.e_continuous_drop_off(continuous_drop_off)
    ,network_id text -- conditionally forbidden
    ,PRIMARY KEY(feed_id, route_id)
    -- ,FOREIGN KEY(feed_id, agency_id) REFERENCES gtfs.tl_agency(feed_id, agency_id)
);

-- fare attributes file
CREATE TABLE gtfs.tl_fare_attributes (
    feed_id integer NOT NULL REFERENCES gtfs.transitland_feeds(feed_id)
    ,fare_id text NOT NULL
    ,price numeric(7,2) NOT NULL
    ,currency_type text NOT NULL
    ,payment_method smallint NOT NULL REFERENCES gtfs.e_payment_methods(payment_method)
    ,transfers smallint NOT NULL REFERENCES gtfs.e_transfers(transfer)
    ,agency_id text
    ,transfer_duration integer
    ,PRIMARY KEY(feed_id, fare_id)
    -- ,FOREIGN KEY(feed_id, agency_id) REFERENCES gtfs.tl_agency(feed_id, agency_id)
);

-- fare rules file
CREATE TABLE gtfs.tl_fare_rules (
    feed_id integer NOT NULL REFERENCES gtfs.transitland_feeds(feed_id)
    ,fare_id text NOT NULL
    ,route_id text
    ,origin_id text
    ,destination_id text
    ,contains_id text
    -- ,PRIMARY KEY(feed_id, fare_id, route_id, origin_id, destination_id, contains_id)
    -- ,FOREIGN KEY(feed_id, fare_id) REFERENCES gtfs.tl_fare_attributes(feed_id, fare_id)
    -- ,FOREIGN KEY(feed_id, route_id) REFERENCES gtfs.tl_routes(feed_id, route_id)
    -- ,FOREIGN KEY(feed_id, origin_id) REFERENCES gtfs.tl_stops(feed_id, zone_id)
    -- ,FOREIGN KEY(feed_id, destination_id) REFERENCES gtfs.tl_stops(feed_id, zone_id)
    -- ,FOREIGN KEY(feed_id, contains_id) REFERENCES gtfs.tl_stops(feed_id, zone_id)
);

-- trips file (required)
CREATE TABLE gtfs.tl_trips (
    feed_id integer NOT NULL REFERENCES gtfs.transitland_feeds(feed_id)
    ,route_id text NOT NULL
    ,service_id text NOT NULL -- REFERENCES tl_calendar(service_id) OR REFERENCES tl_calendar_dates(service_id)
    ,trip_id text NOT NULL
    ,trip_headsign text
    ,trip_short_name text
    ,direction_id smallint REFERENCES gtfs.e_direction_ids(direction_id)
    ,block_id text
    ,shape_id text -- conditionally required
    ,wheelchair_accessible smallint REFERENCES gtfs.e_wheelchair_accessibility(wheelchair_accessibility)
    ,bikes_allowed smallint REFERENCES gtfs.e_bikes_allowed(bikes_allowed)
    ,PRIMARY KEY(feed_id, trip_id)
    -- ,FOREIGN KEY(feed_id, route_id) REFERENCES gtfs.tl_routes(feed_id, route_id)
    -- ,FOREIGN KEY(feed_id, shape_id) REFERENCES gtfs.tl_shapes(feed_id, shape_id)
);

-- stop times file (required)
CREATE TABLE gtfs.tl_stop_times (
    feed_id integer NOT NULL REFERENCES gtfs.transitland_feeds(feed_id)
    ,trip_id text NOT NULL
    ,arrival_time interval -- interval because it can be greater than 24 hours, conditionally required
    ,departure_time interval -- interval because it can be greater than 24 hours, conditionally required
    ,stop_id text NOT NULL
    ,stop_sequence integer NOT NULL -- NON-NEGATIVE
    ,stop_headsign text
    ,pickup_type smallint REFERENCES gtfs.e_pickup_types(pickup_type)
    ,drop_off_type smallint REFERENCES gtfs.e_drop_off_types(drop_off_type)
    ,continuous_pickup smallint REFERENCES gtfs.e_continuous_pickup(continuous_pickup)
    ,continuous_drop_off smallint REFERENCES gtfs.e_continuous_drop_off(continuous_drop_off)
    ,shape_dist_traveled real
    ,timepoint smallint REFERENCES gtfs.e_timepoints(timepoint)
    ,PRIMARY KEY(feed_id, trip_id, stop_sequence)
    -- ,FOREIGN KEY(feed_id, trip_id) REFERENCES gtfs.tl_trips(feed_id, trip_id)
    -- ,FOREIGN KEY(feed_id, stop_id) REFERENCES gtfs.tl_stops(feed_id, stop_id)
);

-- timeframes file
CREATE TABLE gtfs.tl_timeframes (
    feed_id integer NOT NULL REFERENCES gtfs.transitland_feeds(feed_id)
    ,timeframe_group_id text NOT NULL
    ,start_time time NOT NULL DEFAULT '00:00:00'  -- conditionally required
    ,end_time time NOT NULL DEFAULT '24:00:00'    -- conditionally required
    ,service_id text NOT NULL -- REFERENCES tl_calendar(service_id) OR REFERENCES tl_calendar_dates(service_id)
    ,PRIMARY KEY(feed_id, timeframe_group_id, start_time, end_time, service_id)
);

-- fare products file
CREATE TABLE gtfs.tl_fare_products (
    feed_id integer NOT NULL REFERENCES gtfs.transitland_feeds(feed_id)
    ,fare_product_id text NOT NULL
    ,fare_product_name text
    ,fare_media_id text
    ,amount numeric(7,2) NOT NULL
    ,currency text NOT NULL
    ,PRIMARY KEY(feed_id, fare_product_id, fare_media_id)
    -- ,FOREIGN KEY(feed_id, fare_media_id) REFERENCES gtfs.tl_fare_media(feed_id, fare_media_id)
);

-- fare leg rules file
CREATE TABLE gtfs.tl_fare_leg_rules (
    feed_id integer NOT NULL REFERENCES gtfs.transitland_feeds(feed_id)
    ,leg_group_id text
    ,network_id text -- REFERENCES tl_networks(network_id) OR REFERENCES tl_routes(network_id)
    ,from_area_id text
    ,to_area_id text
    ,from_timeframe_group_id text
    ,to_timeframe_group_id text
    ,fare_product_id text NOT NULL
    ,PRIMARY KEY(feed_id, network_id, from_area_id, to_area_id, from_timeframe_group_id, to_timeframe_group_id, fare_product_id)
    -- ,FOREIGN KEY(feed_id, from_area_id) REFERENCES gtfs.tl_areas(feed_id, area_id)
    -- ,FOREIGN KEY(feed_id, to_area_id) REFERENCES gtfs.tl_areas(feed_id, area_id)
    -- ,FOREIGN KEY(feed_id, from_timeframe_group_id) REFERENCES gtfs.tl_timeframes(feed_id, timeframe_group_id)
    -- ,FOREIGN KEY(feed_id, to_timeframe_group_id) REFERENCES gtfs.tl_timeframes(feed_id, timeframe_group_id)
    -- ,FOREIGN KEY(feed_id, fare_product_id) REFERENCES gtfs.tl_fare_products(feed_id, fare_product_id)
);

-- fare transfer rules file
CREATE TABLE gtfs.tl_fare_transfer_rules (
    feed_id integer NOT NULL REFERENCES gtfs.transitland_feeds(feed_id)
    ,from_leg_group_id text
    ,to_leg_group_id text
    ,transfer_count integer -- NON-NEGATIVE condtitionally required
    ,duration_limit integer -- POSITIVE 
    ,duration_limit_type smallint REFERENCES gtfs.e_duration_limit_types(duration_limit_type) -- conditionally required
    ,fare_transfer_type smallint NOT NULL REFERENCES gtfs.e_fare_transfer_types(fare_transfer_type)
    ,fare_product_id text
    ,PRIMARY KEY(feed_id, from_leg_group_id, to_leg_group_id, fare_product_id, transfer_count, duration_limit)
    -- ,FOREIGN KEY(feed_id, from_leg_group_id) REFERENCES gtfs.tl_fare_leg_rules(feed_id, leg_group_id)
    -- ,FOREIGN KEY(feed_id, to_leg_group_id) REFERENCES gtfs.tl_fare_leg_rules(feed_id, leg_group_id)
    -- ,FOREIGN KEY(feed_id, fare_product_id) REFERENCES gtfs.tl_fare_products(feed_id, fare_product_id)
);

-- stop areas file
CREATE TABLE gtfs.tl_stop_areas (
    feed_id integer NOT NULL REFERENCES gtfs.transitland_feeds(feed_id)
    ,area_id text NOT NULL
    ,stop_id text NOT NULL
    ,PRIMARY KEY(feed_id, area_id, stop_id)
    -- ,FOREIGN KEY(feed_id, area_id) REFERENCES gtfs.tl_areas(feed_id, area_id)
    -- ,FOREIGN KEY(feed_id, stop_id) REFERENCES gtfs.tl_stops(feed_id, stop_id)
);

-- route networks file
CREATE TABLE gtfs.tl_route_networks (
    feed_id integer NOT NULL REFERENCES gtfs.transitland_feeds(feed_id)
    ,network_id text NOT NULL
    ,route_id text NOT NULL
    ,PRIMARY KEY(feed_id, route_id)
    -- ,FOREIGN KEY(feed_id, network_id) REFERENCES gtfs.tl_networks(feed_id, network_id)
    -- ,FOREIGN KEY(feed_id, route_id) REFERENCES gtfs.tl_routes(feed_id, route_id)
);

-- frequencies file
CREATE TABLE gtfs.tl_frequencies (
    feed_id integer NOT NULL REFERENCES gtfs.transitland_feeds(feed_id)
    ,trip_id text NOT NULL
    ,start_time INTERVAL NOT NULL
    ,end_time INTERVAL NOT NULL
    ,headway_secs integer NOT NULL
    ,exact_times smallint REFERENCES gtfs.e_exact_times(exact_times)
    ,PRIMARY KEY(feed_id, trip_id, start_time)
    -- ,FOREIGN KEY(feed_id, trip_id) REFERENCES gtfs.tl_trips(feed_id, trip_id)
);

-- transfers file
CREATE TABLE gtfs.tl_transfers (
    feed_id integer NOT NULL REFERENCES gtfs.transitland_feeds(feed_id)
    ,from_stop_id text
    ,to_stop_id text
    ,from_route_id text
    ,to_route_id text
    ,from_trip_id text
    ,to_trip_id text
    ,transfer_type smallint NOT NULL REFERENCES gtfs.e_transfer_types(transfer_type)
    ,min_transfer_time integer
    -- ,PRIMARY KEY(feed_id, from_stop_id, to_stop_id, from_trip_id, to_trip_id, from_route_id, to_route_id)
    -- ,FOREIGN KEY(feed_id, from_stop_id) REFERENCES gtfs.tl_stops(feed_id, stop_id)
    -- ,FOREIGN KEY(feed_id, to_stop_id) REFERENCES gtfs.tl_stops(feed_id, stop_id)
    -- ,FOREIGN KEY(feed_id, from_route_id) REFERENCES gtfs.tl_routes(feed_id, route_id)
    -- ,FOREIGN KEY(feed_id, to_route_id) REFERENCES gtfs.tl_routes(feed_id, route_id)
    -- ,FOREIGN KEY(feed_id, from_trip_id) REFERENCES gtfs.tl_trips(feed_id, trip_id)
    -- ,FOREIGN KEY(feed_id, to_trip_id) REFERENCES gtfs.tl_trips(feed_id, trip_id)
);

-- pathways file
CREATE TABLE gtfs.tl_pathways (
    feed_id integer NOT NULL REFERENCES gtfs.transitland_feeds(feed_id)
    ,pathway_id text NOT NULL
    ,from_stop_id text NOT NULL
    ,to_stop_id text NOT NULL
    ,pathway_mode smallint NOT NULL REFERENCES gtfs.e_pathway_modes(pathway_mode)
    ,is_bidirectional smallint NOT NULL REFERENCES gtfs.e_is_bidirectional(is_bidirectional)
    ,"length" real
    ,traversal_time integer
    ,stair_count integer NOT NULL
    ,max_slope real
    ,min_width real
    ,signposted_as text
    ,reversed_signposted_as text
    ,PRIMARY KEY(feed_id, pathway_id)
    -- ,FOREIGN KEY(feed_id, from_stop_id) REFERENCES gtfs.tl_stops(feed_id, stop_id)
    -- ,FOREIGN KEY(feed_id, to_stop_id) REFERENCES gtfs.tl_stops(feed_id, stop_id)
);

-- attributions file
CREATE TABLE gtfs.tl_attributions (
    feed_id integer NOT NULL REFERENCES gtfs.transitland_feeds(feed_id)
    ,attribution_id text
    ,agency_id text
    ,route_id text 
    ,trip_id text
    ,organization_name text NOT NULL
    ,is_producer smallint REFERENCES gtfs.e_is_role(is_role)
    ,is_operator smallint REFERENCES gtfs.e_is_role(is_role)
    ,is_authority smallint REFERENCES gtfs.e_is_role(is_role)
    ,attribution_url text
    ,attribution_email text
    ,attribution_phone text
    ,PRIMARY KEY(feed_id, attribution_id)
    -- ,FOREIGN KEY(feed_id, agency_id) REFERENCES gtfs.tl_agency(feed_id, agency_id)
    -- ,FOREIGN KEY(feed_id, route_id) REFERENCES gtfs.tl_routes(feed_id, route_id)
    -- ,FOREIGN KEY(feed_id, trip_id) REFERENCES gtfs.tl_trips(feed_id, trip_id)
);
