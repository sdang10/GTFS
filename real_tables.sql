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
    	
    )
    SELECT DISTINCT 
    	CAST(file_id AS INT),
    	file_name
    FROM gtfs_test.gtfs_extra_files

END;
$$;

CALL create__table()

































CREATE OR REPLACE PROCEDURE create_real__table()
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO gtfs_test.real_ (
    	
    )
    SELECT DISTINCT 
    	* 
    FROM gtfs_test.;

END;
$$;

CALL create__table()
