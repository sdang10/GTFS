#! /usr/bin/env python3
"""-----------------------------------------------------------------------------
SCRIPT: shane_gtfs_static.py
AUTHOR: Shane Khaykham Dang <dangit17@uw.edu>
DESCRIPTION:  This script runs a data import of gtfs files from transitland to a database in postgres

RELEASE HISTORY:
  v  1.0    2024-03-18  initial code development (first bulk push to db)

-----------------------------------------------------------------------------"""

# when parse error, keep feed data in transitland feeds, but scrap the other data 
# make gtfs.tl_bad_feeds bad feeds table with JUST FILE ID

# system imports
import os
import datetime as dt
import zipfile
import argparse
import sys
import warnings
from urllib.parse import urljoin
import numpy as np
import pandas as pd
from sqlalchemy import create_engine, text
# import json
# import shutil

# external module imports
import requests
# import psycopg2

# import class definitions
from shane_pyutils.logutil import LogUtil
from shane_pyutils.cfgutil import ConfigUtil
from shane_pyutils.dbutil import PostgresDB

# only use python 3.6 or higher due to f-strings
assert sys.version_info >= (3,6)

# global variables
log = None
logutil = None
cfgutil = None
pgdb = None
desktop_path = os.path.join(os.path.expanduser('~'), 'Desktop')


def main():
    # setup catch on warnings for exception clauses
    warnings.filterwarnings("error")

    # parser setup
    parser = argparse.ArgumentParser(description='desc')
    parser.add_argument('config_file', default='shane_gtfs_static_config.ini', help='location of configuration file', metavar='Config File')
    parser.add_argument('log_dir', default='logs', help='directory where log files are saved', metavar='Log Directory')
    parser.add_argument('output_dir', default='processed', help='directory where input files are moved and output results are saved', metavar='Output Directory')
    # parser.add_argument('-v', '--verbosity', action='count', default=2, help='increase logging detail', metavar='Log Detail Level')
    parser.add_argument('-i', '--input_dir', default='', help='directory containing input csv files', metavar='Input Directory')
    args = parser.parse_args()

    # create logging utility class instance, add file log, and store reference to log
    logutil = LogUtil(2) #args.verbosity)
    #if args.log_dir: 
    logutil.add_file_log(args.log_dir)
    log = logutil.log

    # create configuration utility class instance, parse config file and exit on failure
    cfgutil = ConfigUtil(log)
    if not cfgutil.load(args.config_file): sys.exit()

    # local variables
    pg_username = cfgutil.get_item('db_postgres', 'username')
    pg_password = cfgutil.get_item('db_postgres','password')
    pg_host = cfgutil.get_item('db_postgres','host')
    pg_port = cfgutil.get_item('db_postgres','port')
    pg_db_name = cfgutil.get_item('db_postgres','db_name')
    pg_schema = cfgutil.get_item('db_postgres','schema_name')
    # transitland api info
    api_key = cfgutil.get_item('feed_info','api_key')
    api_url = cfgutil.get_item('feed_info','api_endpoint')
    feed_url = api_url + cfgutil.get_item('feed_info','feed_list')
    download_url = api_url + cfgutil.get_item('feed_info','feed_download')
    # file metadata variables
    file_data_variables = cfgutil.get_item('data_tracking', 'gtfs_file_data_variables').split(',') # Read gtfs_file_data_variables as a list
    # transitland allowables
    allowed_files = cfgutil.get_item('data_tracking', 'allowed_files').split(',') # Read allowed_files as a list
    # file paths
    # zip_dl_url = cfgutil.get_item('feed_info','file_path')
    # archive_file_path = '/shane_gtfs_static_archive/'
    
    try:

        # create postgres database instance
        connection_params = cfgutil.get_section('db_postgres')
        log.info(f'Attempting to connect with parameters: {connection_params}')
        pgdb = PostgresDB(log, desc='dashboard postgres database')

        # check postgres database connection
        if not pgdb.open(cfgutil, 'db_postgres'):
            log.error(f'unable to connect to {pgdb.desc}! Error: {e}')
            sys.exit()

        # connect to Postgres db via sqlalchemy for df.to_sql
        conn_string = f'postgresql://{pg_username}:{pg_password}@{pg_host}:{pg_port}/{pg_db_name}?options=-csearch_path={pg_schema}'
        db = create_engine(conn_string) 
        conn = db.connect() 

        # perform all other checks without exiting first so we can check for all errors
        xit = False

        # verify that tables exist in pgdb
        # for t in ['gtfs_stops']:
        #     if not pgdb.table_exists(t, pg_schema):
        #         log.error(f'table {t} does not exist in {pgdb.desc}!')
        #         xit = True

        if xit: 
            sys.exit()

        # if args.input_dir:

        # start
        log.info('----- desc -----')
        # iterate over each agency - get agency id (0) feed endpoints (1) and latest id (2) from database
        for agency in pgdb.fetchall(f"SELECT agency_id, feed_onestop_id, latest_id FROM gtfs.v_transitland_feed_info"):

            # get list of feeds from transitland for agency
            r = requests.get(feed_url + agency[1], params={'api_key': api_key})

            # expect 200 code from transitland instead of using r.raise_for_status()
            if r.status_code == 200:

                # get feeds and reverse list to work in chronological order
                feed_list_of_agency = r.json()['feeds'][0]['feed_versions']
                feed_list_of_agency = sorted(feed_list_of_agency, key=lambda x: x['id'])

                # iterate over all the feeds in the feed list of agency
                for feed in feed_list_of_agency:

                    # define feed variables
                    feed_id = feed['id']
                    fetched_at_date = dt.datetime.strptime(feed['fetched_at'], '%Y-%m-%dT%H:%M:%S.%fZ').date()

                    # these are to get the april 2023 data
                    # april_1_2023 = dt.date(2023, 4, 1)
                    # april_30_2023 = dt.date(2023, 4, 30)
                    # id_list = [317910, 318000, 315351, 316759, 318002, 317989, 317982, 318001, 289332, 318022] chunk of the seattlechildrens data that has repeating data over a period of time
                    # check if fetched_at date is > specified date (to only import newer feeds)
                    # if january_1_2019 < fetched_at_date < january_1_2020:
                    # if fetched_at_date > dt.date(2020, 4, 3):
                    # if (feed_id in id_list) or (april_1_2023 <= fetched_at_date <= april_30_2023):

                    bad_files = [58406]  # 58406 more columns than column names, 251143 date attribute not in range 20222508

                    # check if feed id > latest_id (to only import unimported feeds)
                    if feed_id > agency[2] or feed_id in bad_files:

                        log.info(f'{agency[1]}, {feed_id}, {fetched_at_date}')

                        # retrieve feed data in list format for columns and values in feed table
                        columns = list(feed.keys())
                        columns.append('agency_id')
                        columns_string = ', '.join(columns)
                        values = [f"'{value}'" for value in feed.values()]
                        values.append(f"'{agency[0]}'")
                        values_string = ', '.join(values)

                        # import the feed data into transitland_feeds table
                        sql_query = f'INSERT INTO gtfs_transitland_feeds ({columns_string}) VALUES ({values_string})'
                        pgdb.query(sql_query)
                        pgdb.cnxn.commit()

                        # Construct download URL
                        dl_url = urljoin(download_url.replace('{feed_version_key}', str(feed['id'])), f"?api_key={api_key}")

                        # Set file paths
                        zip_path = os.path.join(desktop_path, f"{feed_id}.zip")
                        extracted_path = os.path.join(desktop_path, f"{feed_id}_extracted")

                        # Download the feed version
                        try:

                            response = requests.get(dl_url)
                            # Check if the request was successful (status code 200)
                            response.raise_for_status()
                            # Save the content to a local file
                            with open(zip_path, 'wb') as file:
                                file.write(response.content)
                            log.info(f"Downloaded successfully: {zip_path}")

                        except requests.exceptions.RequestException as e:

                            log.info(f"Error: {e}")

                        # Unzip the downloaded file
                        try:

                            with zipfile.ZipFile(zip_path, 'r') as zip_ref:
                                zip_ref.extractall(extracted_path)
                            log.info(f"Unzipped successfully as: {extracted_path}")

                        except zipfile.BadZipFile as e:

                            log.info(f"Error: {e}")

                        # List all files in the folder
                        file_list = os.listdir(extracted_path)

                        # if we encounter a warning, abort this feed and move on to the next one
                        try:

                            # Iterate through each file in the folder
                            for file in file_list:

                                if file in allowed_files:
                            
                                    file_path = os.path.join(extracted_path, file)
                                    
                                    # Check if it's a file (not a subfolder)
                                    if os.path.isfile(file_path):

                                        log.info(f"Importing file: {file}")
                                        # Split the filename and extension
                                        file_name, file_extension = os.path.splitext(file)
                                        table_name = f"gtfs_tl_{file_name}" 

                                        df = pd.read_csv(file_path, dtype=str, delimiter=',', header=0, index_col=False, on_bad_lines='warn')

                                        # Get column names from the DataFrame and from SQL table
                                        df_columns = df.columns.tolist()
                                        sql_columns = pd.read_sql(f"SELECT * FROM {table_name} LIMIT 0", conn).columns.tolist()

                                        # identify column mismatching
                                        df_extra_columns = set(df_columns) - set(sql_columns)
                                        sql_extra_columns = set(sql_columns) - set(df_columns)

                                        # Remove extra columns from DataFrame
                                        if df_extra_columns:

                                            log.info(f'Not including the following columns from the DataFrame as they are not present in the SQL table: {df_extra_columns}')

                                            # for column in df_extra_columns:
                                            #     values = df[column]
                                            #     if values is not None and not values.empty:
                                            #         column_name = column

                                                    # Insert values for the extra columns into gtfs_extra_attributes table
                                                    # insert_query = text(f"INSERT INTO gtfs_extra_attributes (file_id, file_name, column_name, value) VALUES ('{file_id}', '{file_name}', '{column_name}', '{values}')")
                                                    # conn.execute(insert_query)

                                            df.drop(columns=df_extra_columns, inplace=True)

                                        else:

                                            log.info("No extra columns found in the DataFrame.")

                                        if sql_extra_columns:
                                            default_value = np.nan  # Adjust the default value based on your requirements

                                            log.info(f'Columns missing from the DataFrame that will be defined with default value ({default_value}): {sql_extra_columns}')

                                            for column in sql_extra_columns:

                                                df[column] = default_value

                                        # imort dataframe data into postgressql
                                        log.info(f'pushing {file} dataframe to sql')
                                        df.to_sql(table_name, con=conn, if_exists='append', index=False) 
                                        # log.info(pd.read_sql(f"SELECT * FROM {table_name}", conn))
                                        conn.commit()
                                        log.info(f'Successfully pushed {file} dataframe to sql')
                                    
                                    else: 
                                
                                        # note extra text files in the extra files table 
                                        sql_query = f"INSERT INTO gtfs_tl_extra_files VALUES ('{feed_id}', '{file}');"
                                        pgdb.query(sql_query)
                                        pgdb.cnxn.commit()
                                        log.info(f'Updated gtfs_extra_files with {feed_id} and {file}')

                        except Warning as w:

                            # log error message
                            log.info(f"Error reading {file_name}: {str(w)}")

                            # in the case a warning was raised, truncate import tables
                            query = f'CALL truncate_temp_tables()'
                            pgdb.query(query)
                            pgdb.cnxn.commit()
                            query = f"INSERT INTO gtfs_tl_bad_feeds VALUES('{feed_id}');"
                            pgdb.query(query)
                            pgdb.cnxn.commit()
                            # Move on to the next CSV file
                            continue

                        # shutil.move(extracted_path, archive_file_path)
                            

                        query = f'CALL insert_into_real_tables()'
                        pgdb.query(query)
                        pgdb.cnxn.commit()
                        query = f'CALL truncate_temp_tables()'
                        pgdb.query(query)
                        pgdb.cnxn.commit()


    except Exception as e:
        #import pdb
        #pdb.set_trace()
        import traceback as tb
        log.error(tb.format_exc())

    finally:
        pgdb.close(True)
        # close the log file with final message
        logutil.remove_file_log('script completed')

    

if __name__ == "__main__": main()
