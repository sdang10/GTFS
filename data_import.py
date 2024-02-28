# INSERT DOCUMENTATION HERE


# system imports
import os
import datetime as dt
import zipfile
import argparse
import sys
from urllib.parse import urljoin
# import numpy as np
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

    parser = argparse.ArgumentParser(description='desc')
    parser.add_argument('config_file', default='shane_gtfs_static_config.ini', help='location of configuration file', metavar='Config File')
    parser.add_argument('log_dir', default='logs', help='directory where log files are saved', metavar='Log Directory')
    parser.add_argument('output_dir', default='processed', help='directory where input files are moved and output results are saved', metavar='Output Directory')
    # parser.add_argument('-v', '--verbosity', action='count', default=2, help='increase logging detail', metavar='Log Detail Level')
    parser.add_argument('-i', '--input_dir', default='', help='directory containing input csv files', metavar='Input Directory')
    args = parser.parse_args()


    # create logging utility class instance, add file log, and store reference to log
    logutil = LogUtil(2) #args.verbosity)
    if args.log_dir: logutil.add_file_log(args.log_dir)
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
    dl_url = api_url + cfgutil.get_item('feed_info','feed_download')
    # file metadata variables
    file_data_variables = cfgutil.get_item('data_tracking', 'gtfs_file_data_variables').split(',') # Read gtfs_file_data_variables as a list
    # transitland allowables
    allowed_files = cfgutil.get_item('data_tracking', 'allowed_files').split(',') # Read allowed_files as a list
    # file path
    zip_file_path = cfgutil.get_item('feed_info','file_path')
    # archive_file_path = '/shane_gtfs_static_archive/'
    
    # dt_fmt = '%Y-%m-%d'
    # orca_start = dt.datetime.strptime('2019-01-01',dt_fmt)


    try:

        # create postgres database instance
        pgdb = PostgresDB(log, desc='dashboard postgres database')
        connection_params = cfgutil.get_section('db_postgres')
        log.info(f'Attempting to connect with parameters: {connection_params}')

        # connect to postgres database
        if not pgdb.open(cfgutil, 'db_postgres'):
            log.error(f'unable to connect to {pgdb.desc}! Error: {e}')
            sys.exit()


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
        #log.info('----- desc -----')
        # iterate over each agency - get agency id (0) feed endpoints (1) and latest id (2) from database
        for a in pgdb.fetchall('SELECT feed_onestop_id, latest_id FROM gtfs.v_transitland_feed_info'):

            # initialize agency file path with onestop_id (still missing feed_sha1)
            afp = zip_file_path.replace('{feed_onestop_id}', a[0])

            # get list of feeds from transitland after highest feed in data
            r = requests.get(feed_url + a[0], params={'api_key': api_key})

            # expect 200 code from transitland instead of using r.raise_for_status()
            if r.status_code == 200:

                # get feeds and reverse list to work in chronological order
                feeds = r.json()['feeds'][0]['feed_versions']
                feeds.reverse()

                for f in feeds:

                    # Set file paths
                    fp = afp.replace('{feed_sha1}',f['sha1'])
                    save_path = os.path.join(desktop_path, f"{f['sha1']}.zip")
                    extract_path = os.path.join(desktop_path, f"{f['sha1']}_extracted")

                    # Check the fetched_at date
                    fetched_at_date = dt.datetime.strptime(f['fetched_at'], '%Y-%m-%dT%H:%M:%S.%fZ').date()
                    july_1_2023 = dt.date(2023, 7, 1)

                    # check if fetched_at date is > specified date (to only import newer feeds)
                    if fetched_at_date >= july_1_2023:
                    # check if feed id > latest_id (to only import unimported feeds)
                    # if f['id'] > a[2]:
                        
                        file_id = f['id']

                        # import the file data into gtfs files table
                        columns = ', '.join(f.keys())
                        values = ', '.join([f"'{value}'" for value in f.values()])

                        # Execute the SQL query using your database library
                        sql_query = f'INSERT INTO gtfs_files ({columns}) VALUES ({values})'
                        pgdb.query(sql_query)

                        # Construct download URL
                        download_url = urljoin(dl_url.replace('{feed_version_key}', f['sha1']), f"?api_key={api_key}")

                        # Download the feed version
                        try:

                            response = requests.get(download_url)
                            # Check if the request was successful (status code 200)
                            response.raise_for_status()
                            # Save the content to a local file
                            with open(save_path, 'wb') as file:
                                file.write(response.content)
                            print(f"Downloaded successfully: {save_path}")

                        except requests.exceptions.RequestException as e:

                            print(f"Error: {e}")

                        # Unzip the downloaded file
                        try:

                            with zipfile.ZipFile(save_path, 'r') as zip_ref:
                                zip_ref.extractall(extract_path)
                            print(f"Unzipped successfully as: {extract_path}")

                        except zipfile.BadZipFile as e:

                            print(f"Error: {e}")


                        # List all files in the folder
                        file_list = os.listdir(extract_path)
                        # Iterate through each file in the folder

                        for file in file_list:

                            if file in allowed_files:
                        
                                file_path = os.path.join(extract_path, file)
                                
                                # Check if it's a file (not a subfolder)
                                if os.path.isfile(file_path):

                                    print(f"Importing file: {file}")
                                    # Split the filename and extension
                                    filename, file_extension = os.path.splitext(file)
                                    # Save the filename without the extension as a new variable
                                    file_name = filename
                                    table_name = f"transitland_{file_name}"
                                    df = pd.read_csv(file_path)
                                    df = df.astype(str)
                                    df['file_id'] = file_id

                                    # connect to Postgres db via sqlalchemy
                                    conn_string = f'postgresql://{pg_username}:{pg_password}@{pg_host}:{pg_port}/{pg_db_name}?options=-csearch_path={pg_schema}'
                                    db = create_engine(conn_string) 
                                    conn = db.connect() 

                                    
                                    # Get column names from the DataFrame
                                    df_columns = df.columns.tolist()

                                    # Get column names from the SQL table
                                    sql_columns = pd.read_sql(f"SELECT * FROM {table_name} LIMIT 0", conn).columns.tolist()

                                    # Find columns in DataFrame that are not present in SQL table
                                    df_extra_columns = set(df_columns) - set(sql_columns)
                                    # Find columns in SQL table that are not present in DataFrame
                                    sql_extra_columns = set(sql_columns) - set(df_columns)

                                    # Remove extra columns from DataFrame
                                    if df_extra_columns:

                                        print("Not including the following columns from the DataFrame as they are not present in the SQL table:")
                                        print(df_extra_columns)

                                        for column in df_extra_columns:
                                            values = df[column]
                                            if values is not None and not values.empty:
                                                column_name = column

                                                # Insert values into gtfs_extra_attributes table
                                                insert_query = text(f"INSERT INTO gtfs_extra_attributes (file_id, file_name, column_name, value) VALUES ('{file_id}', '{file_name}', '{column_name}', '{values}')")
                                                conn.execute(insert_query)

                                        df.drop(columns=df_extra_columns, inplace=True)

                                    else:

                                        print("No extra columns found in the DataFrame.")

                                    if sql_extra_columns:

                                        print("The following columns are missing from the DataFrame and will be defined with the default value")
                                        print(sql_extra_columns)

                                        for column in sql_extra_columns:

                                            default_value = ''  # Adjust the default value based on your requirements
                                            df[column] = default_value
                                        # print(df)

                                    # imort dataframe data into postgressql
                                    df.to_sql(table_name, con=conn, if_exists='append', index=False) 
                                    # print(pd.read_sql(f"SELECT * FROM {table_name}", conn))

                                    # commit the changes made to the database
                                    conn.commit()

                                    # Close the connection after interacting with the database
                                    conn.close()

                                # shutil.move(save_path, archive_file_path)
                            
                            else: 
                                
                                # note extra text files in the extra files table 
                                sql_query = f"INSERT INTO gtfs_extra_files VALUES ('{file_id}', '{file}');"
                                pgdb.query(sql_query)


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
