# INSERT DOCUMENTATION HERE


# system imports
import os
import datetime as dt
import zipfile

# external library imports
import requests
import psycopg2


# Database info
db_name = 'orca_ng'
username = 'orca_upload'
password = 'GHSWWiFjACUuc8C0Z0dK'
host = '172.31.11.24'
port = '5432'
schema_name = 'gtfs_test'
timezone = 'US/Pacific'

# Transitland info

api_key = 'IQGg53CuV0CVTGepYYZlebRGHEFc5XeJ'

agency_list = ['f-c23-metrokingcounty']
# agency_list = ['f-c29-communitytransit', 
#                 'f-c290-everetttransit', 
#                 'f-c23-metrokingcounty', 
#                 'f-c22y-kitsaptransit', 
#                 'f-c22-piercetransit~soundtransit', 
#                 'f-c23-soundtransit', 
#                 'f-c28-washingtonstateferries', 
#                 'f-c22e-intercitytransit', 
#                 'f-seattlemonorail~wa~us', 
#                 'f-c23p1-seattlechildrenshospitalshuttle']


# Links
# agency: onestop_id
# id = sha1 OR unique int id
all_feeds = 'https://transit.land/api/v2/rest/feed_versions?api_key={api_key}'
agency_feeds = 'https://transit.land/api/v2/rest/feeds/{agency}?api_key={api_key}'
specific_feed = 'https://transit.land/api/v2/rest/feed_versions/{id}/download?api_key={api_key}'


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
        
        print(f"Unzipped successfully to: {extract_path}")

    except zipfile.BadZipFile as e:
        print(f"Error: {e}")



def main():
    try:

        # Fetch feed information by agency
        for agency in agency_list:

            feed_response = requests.get(agency_feeds.replace('{agency}', agency).replace('{api_key}', api_key))
            feed_response.raise_for_status()
            feeds = feed_response.json()['feeds'][0]['feed_versions']
            feeds.reverse()

            for f in feeds:

                # Set file path
                save_path = os.path.join(desktop_path, f"{f['sha1']}.zip")
                extract_path = os.path.join(desktop_path, f"{f['sha1']}_extracted")
                # Check the fetched_at date
                fetched_at_date = dt.datetime.strptime(f['fetched_at'], '%Y-%m-%dT%H:%M:%S.%fZ').date()
                july_1_2023 = dt.date(2023, 7, 1)

                if fetched_at_date >= july_1_2023:

                    # Construct download URL
                    download_url = specific_feed.replace('{id}', f['sha1']).replace('{api_key}', api_key)
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
                                try:

                                    connection = psycopg2.connect(
                                        dbname=db_name,
                                        user=username,
                                        password=password,
                                        host=host,
                                        port=port
                                    )
                                    # Create a cursor object to interact with the database
                                    cursor = connection.cursor()
                                    # Set schema
                                    cursor.execute(f"SET search_path TO {schema_name}")
                                    # Define the PostgreSQL table name based on the file name
                                    table_name = f"transitland_{file_name}"
                                    next(file)
                                    cursor.copy_expert(f"COPY {table_name} FROM STDIN (format csv, delimiter ',', quote '\"')", file)
                                    # Commit the changes
                                    connection.commit()
                                    # Close the cursor and connection
                                    cursor.close()
                                    connection.close()

                                except psycopg2.Error as e:
                                    print(f"Error connecting to the PostgreSQL database: {e}")

                                finally:
                                    # Close the cursor and connection to release resources
                                    if cursor:
                                        cursor.close()

                                    if connection:
                                        connection.close()
                                        print(f'Database Connection Closed')

    except requests.exceptions.RequestException as e:
        print(f"Error: {e}")

    









if __name__ == "__main__": main()
