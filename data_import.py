# INSERT DOCUMENTATION HERE


# system imports
import os
import datetime as dt
import zipfile
import argparse
import sys
from urllib.parse import urljoin

# external module imports
import requests
import psycopg2

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

# Desktop path
desktop_path = os.path.join(os.path.expanduser('~'), 'Desktop')


# class to download a file using python requests library
def download_file(url, save_path):
    try:
        response = requests.get(url)

        # Check if the request was successful (status code 200)
        response.raise_for_status()

        # Save the content to a local file
        with open(save_path, 'wb') as file:
            file.write(response.content)

        print(f"Downloaded successfully: {save_path}")

    except requests.exceptions.RequestException as e:
        print(f"Error: {e}")


# class to unzip a file 
def unzip_file(zip_path, extract_path):
    try:
        with zipfile.ZipFile(zip_path, 'r') as zip_ref:
            zip_ref.extractall(extract_path)
        
        print(f"Unzipped successfully as: {extract_path}")

    except zipfile.BadZipFile as e:
        print(f"Error: {e}")



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
    # db_name = cfgutil.get_item('db_postgres','db_name')
    # username = cfgutil.get_item('db_postgres','username')
    # password = cfgutil.get_item('db_postgres','password')
    # host = cfgutil.get_item('db_postgres','host')
    # port = cfgutil.get_item('db_postgres','port')
    pg_schema = cfgutil.get_item('db_postgres','schema_name')
    # transitland api info
    api_key = cfgutil.get_item('feed_info','api_key')
    api_url = cfgutil.get_item('feed_info','api_endpoint')
    feed_url = api_url + cfgutil.get_item('feed_info','feed_list')
    dl_url = api_url + cfgutil.get_item('feed_info','feed_download')
    # file path
    file_path = cfgutil.get_item('feed_info','file_path')
    #dt_fmt = '%Y-%m-%d'
    #orca_start = dt.datetime.strptime('2019-01-01',dt_fmt)

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

        # if xit: sys.exit()

        # if args.input_dir:


        # start
        #log.info('----- desc -----')
        # iterate over each agency - get agency id (0) feed endpoints (1) and latest id (2) from database
        for a in pgdb.fetchall('SELECT agency_id, feed_onestop_id, latest_id FROM gtfs.v_transitland_feed_info'):

            # initialize agency file path with onestop_id (still missing feed_sha1)
            afp = file_path.replace('{feed_onestop_id}', a[1])

            # get list of feeds from transitland after highest feed in data
            r = requests.get(feed_url + a[1], params={'api_key': api_key})
            if r.status_code == 200:    # expect 200 code from transitland instead of using r.raise_for_status()
                # get feeds and reverse list to work in chronological order
                feeds = r.json()['feeds'][0]['feed_versions']
                feeds.reverse()

            # feed_response = requests.get(agency_feeds.replace('{agency}', agency).replace('{api_key}', api_key))
            # feed_response.raise_for_status()
            # feeds = feed_response.json()['feeds'][0]['feed_versions']
            # feeds.reverse()

                for f in feeds:

                    # Set file paths
                    fp = fp = afp.replace('{feed_sha1}',f['sha1'])
                    save_path = os.path.join(desktop_path, f"{f['sha1']}.zip")
                    extract_path = os.path.join(desktop_path, f"{f['sha1']}_extracted")


                    # Check the fetched_at date
                    # fetched_at_date = dt.datetime.strptime(f['fetched_at'], '%Y-%m-%dT%H:%M:%S.%fZ').date()
                    # july_1_2023 = dt.date(2023, 7, 1)

                    # if fetched_at_date >= july_1_2023:


                    # check if feed id > latest_id (to only import newer feeds)
                    if f['id'] > a[2]:

                        # check if file already downloaded
                        if not os.path.isfile(fp):

                            # Construct download URL
                            download_url = urljoin(dl_url.replace('{feed_version_key}', f['sha1']), f"?api_key={api_key}")
                            # Download the feed version
                            download_file(download_url, save_path)

                            # Unzip the downloaded file
                            try:

                                unzip_file(save_path, extract_path)
                        
                            except Exception as e:
                                print(f"Error unzipping file: {e}")

                            # List all files in the folder
                            file_list = os.listdir(extract_path)
                            # Iterate through each file in the folder

                            for file in file_list:
                            
                                file_path = os.path.join(extract_path, file)
                                # Check if it's a file (not a subfolder)

                                if os.path.isfile(file_path):

                                    print(f"Importing file: {file}")
                                    # Split the filename and extension
                                    filename, file_extension = os.path.splitext(file)
                                    # Save the filename without the extension as a new variable
                                    file_name = filename
                                
                                    with open(file_path, 'r') as file:

                                        # Establish a connection to the PostgreSQL database
                                        # try:

                                            
                                        #    connection = psycopg2.connect(
                                        #         dbname=db_name,
                                        #         user=username,
                                        #         password=password,
                                        #         host=host,
                                        #         port=port
                                        #     )
                                            

                                            # Create a cursor object to interact with the database
                                            # cursor = pgdb.cursor()




                                            # Set schema
                                            # cursor.execute(f"SET search_path TO {pg_schema}")
                                            
                                            
                                            # Define the PostgreSQL table name based on the file name
                                            table_name = f"transitland_{file_name}"
                                            next(file)
                                            pgdb.cursor().copy_expert(f"COPY {table_name} FROM STDIN (format csv, delimiter ',', quote '\"')", file)
                                            # Commit the changes
                                            pgdb.commit()
                                            # Close the cursor and connection
                                            # cursor.close()
                                            pgdb.close()

                                        # except psycopg2.Error as e:
                                        #     print(f"Error connecting to the PostgreSQL database: {e}")

                                        # finally:
                                        #     # Close the cursor and connection to release resources
                                        #     if cursor:
                                        #         cursor.close()

                                        #     if connection:
                                        #         connection.close()
                                        #         print(f'Database Connection Closed')

    except Exception as e:
        #import pdb
        #pdb.set_trace()
        import traceback as tb
        log.error(tb.format_exc())

    finally:
        # close the log file with final message
        logutil.remove_file_log('script completed')

    

if __name__ == "__main__": main()
