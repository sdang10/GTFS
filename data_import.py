#! /usr/bin/env python3
"""-----------------------------------------------------------------------------
SCRIPT: etl_gtfs_transitland.py
AUTHOR: Shane Khaykham Dang <dangit17@uw.edu>
DESCRIPTION:  This script runs a data import of gtfs files from transitland 
                to a defined database in postgres

DEPENDENCIES:
    requests
    psycopg2
    numpy
    pandas
    sqlalchemy

TODO:
    switch to only use sqlalchemy; drop dependency on psycopg2
    allow import of single file if given switch (requires refactor of some code)
    check if file has already been downloaded prior to fetching from url

RELEASE HISTORY:
  v  0.8    2024-07-03  final testing
  v  0.6    2024-04-23  logging to database implemented
  v  0.5    2024-03-18  initial code development (first bulk push to db)

-----------------------------------------------------------------------------"""

# import bundled modules
import argparse, datetime as dt, os, shutil, sys, warnings, zipfile  # distutils.util, glob, math

# system imports
from urllib.parse import urljoin

# external module imports
import requests
import psycopg2
import numpy as np
import pandas as pd
from sqlalchemy import create_engine, text
#import colorama
#from colorama import Fore, Style

# import class definitions
from pyutils.logutil import LogUtil
from pyutils.cfgutil import ConfigUtil
from pyutils.dbutil import PostgresDB

# only use python 3.6 or higher due to f-strings
assert sys.version_info >= (3,6)

# global variables
log = None
logutil = None
cfgutil = None
pgdb = None
#save_path = '/opt/gtfs_transitland/'


# downloading a feed
def download_feed(log, dl_link, path):
    try:

        response = requests.get(dl_link)
        # Check if the request was successful (status code 200)
        response.raise_for_status()
        # Save the content to a local file
        with open(path, 'wb') as file:
            file.write(response.content)
        log.info(f"Downloaded successfully: {path}")

    except requests.exceptions.RequestException as e:

        #log.info(f"{Fore.Red}Error: {e}{Style.RESET_ALL}")
        log.info(f"Error: {e}")


# unzipping a feed
def unzip_feed(log, zip, extracted):
    try:

        with zipfile.ZipFile(zip, 'r') as zip_ref:
            zip_ref.extractall(extracted)
        log.info(f"Unzipped successfully as: {extracted}")

    except zipfile.BadZipFile as e:

        #log.info(f"{Fore.Red}Error: {e}{Style.RESET_ALL}")
        log.info(f"Error: {e}")

# truncating import tables in database
# def truncate_tables(pgdb):
#         pgdb.query('CALL gtfs.p_truncate_import_tables()')
#         pgdb.cnxn.commit()


# inserting bad feeds into bad feeds table
def insert_bad_feeds(pgdb, feed_id):
    # truncate_tables(pgdb)
    pgdb.query(f"CALL gtfs.p_insert_bad_feed('{feed_id}');")
    pgdb.cnxn.commit()


def main():

    # start time
    start_time_stamp = dt.datetime.now()

    #colorama.init()
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

    # counter for feed processing
    feed_count = 0
    
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

        # check that output path exists:
        if not os.path.isdir(args.output_dir):
            log.error(f'path {args.output_dir} does not exist; exiting')
            xit = True
        
        # verify that tables exist in pgdb
        # for t in ['gtfs_stops']:
        #     if not pgdb.table_exists(t, pg_schema):
        #         log.error(f'table {t} does not exist in {pgdb.desc}!')
        #         xit = True

        if xit: 
            sys.exit()

        # if args.input_dir:

        # start
        log.info('---------- desc ----------')
        # iterate over each agency - get agency id (0) feed endpoints (1) and latest id (2) from database
        for agency in pgdb.fetchall(f"SELECT agency_id, feed_onestop_id, latest_id FROM gtfs.v_transitland_feed_info"):

            # set zip path to start with folder for agency
            save_path = os.path.join(args.output_dir, f'{agency[0]}')

            # ensure directory exists
            if not os.path.isdir(save_path):
                os.mkdir(save_path)

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

                    # bad_feeds = [58406, 251143, 317910, 318000]
                    # check if feed id > latest_id (to only import unimported feeds)
                    #if feed_id == 36311:      # use to look at an individual file
                    if feed_id > agency[2]:     # process all files after latest in database

                        log.info(f'{agency[1]}, {feed_id}, {fetched_at_date}')
                            
                        # first ensure import tables are clear
                        #pgdb.query(f"CALL gtfs.p_truncate_import_gtfs_tables();")

                        # retrieve feed data in list format for columns and values in feed table
                        columns = list(feed.keys())
                        columns.append('agency_id')
                        columns_string = ', '.join(columns)
                        values = [f"'{value}'" for value in feed.values()]
                        values.append(f"'{agency[0]}'")
                        values_string = ', '.join(values)

                        # import the feed data into transitland_feeds table
                        sql_query = f'INSERT INTO gtfs_tl_feeds ({columns_string}) VALUES ({values_string})'
                        pgdb.query(sql_query)
                        # commit this since we want it in database even for bad feed, when next transaction is rolled back
                        pgdb.cnxn.commit()

                        # Construct download URL
                        dl_url = urljoin(download_url.replace('{feed_version_key}', str(feed['sha1'])), f"?api_key={api_key}")

                        # Set file paths
                        extracted_path = os.path.join(save_path, f'{feed_id}')
                        zip_path = os.path.join(save_path, f'{feed_id}.zip')

                        # Download the feed version
                        download_feed(log, dl_url, zip_path)

                        # Unzip the downloaded file
                        unzip_feed(log, zip_path, extracted_path)


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

                                        # else:

                                        #     log.info("No extra columns found in the DataFrame.")

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
                                        pgdb.query(f"INSERT INTO gtfs_tl_extra_files VALUES ('{feed_id}', '{file}');")
                                        #pgdb.cnxn.commit()
                                        log.info(f'Updated gtfs_extra_files with {feed_id} and {file}')

                            # finished working through all files in zip - insert into db
                            pgdb.query('CALL gtfs.p_import_gtfs_transitland()')
                            feed_count += 1

                            # shutil.move(extracted_path, archive_file_path)

                        # if there are more values than columns or if we have primary key issues
                        except (Warning, psycopg2.Error) as e:

                            pgdb.cnxn.rollback()
                            #log.info(f"{Fore.RED}Error reading {file_name}: {str(e)}{Style.RESET_ALL}")
                            log.info(f"Error reading {file_name}: {str(e)}")

                            # in the case a error was raised, truncate import tables
                            pgdb.query(f"CALL gtfs.p_insert_bad_feed('{feed_id}');")
                            # pgdb.cnxn.commit()
                            # Move on to the next CSV file
                            continue

                        finally:
                            # check if feed is not in final table, something must have failed
                            if not pgdb.fetchone(f'SELECT gtfs.f_feed_exists({feed_id})'):
                                # truncate tables and completely exit
                                pgdb.query(f"CALL gtfs.p_truncate_import_gtfs_tables();")
                                pgdb.cnxn.commit() 
                                sys.exit()

                            pgdb.cnxn.commit()
                            # truncate_tables(pgdb) # called from sql procedure
                            log.info('')
                            log.info('---------- break ----------')
                            log.info('')

                            # delete extracted zip file
                            shutil.rmtree(extracted_path)

    except Exception as e:
        #import pdb
        #pdb.set_trace()
        import traceback as tb
        log.error(tb.format_exc())

    finally:
        # calculate time interval
        time_interval = str(dt.datetime.now() - start_time_stamp)

        # writing final log messages into database
        #pgdb.query(f"SELECT _log.f_write_message('info', 'import_orca_transactions', 'completed successfully', '{time_interval}'::interval)")
        #pgdb.query(f"SELECT _log.f_write_table_update('gtfs.feeds', 'insert', {feed_count})")
        pgdb.close(True)
        # close the log file with final message
        logutil.remove_file_log('---------- script completed ----------')



if __name__ == "__main__": main()
