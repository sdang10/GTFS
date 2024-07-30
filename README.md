# GTFS ETL Pipeline

The purpose of this code base is to create an ETL pipeline from [General Transit Feed Specification (GTFS)](https://gtfs.org/). 

The process in this pipeline involves the following components:
1) Create a Luigi Task, CreateDbFromCsv, that creates a new database and fills it with data from the sample dataset 
provided. The sample dataset is compressed to not include time readings where the sensor reading did not change. Hence,
I first uncompressed these readings and create a table entry for the three sensors and all their readings from time 0 to
the end of recording. 
2) The Luigi task then outputs the result into a local csv file called ```sql-db-{datetime}.csv``` as an intermediary
file. This is specified as a LocalTarget in the output function. 
3) The next Luigi task waits for the previous to finish and then it performs a transformation on the table to create a 
new table. The result is then outputted into a csv file called ````output-{datetime}.csv````.

## To run the code:
1) Make sure to have MySQL installed on your machine. If not follow here: https://dev.mysql.com/doc/refman/5.7/en/installing.html
If you have a mac, you can simply run 
````
    brew install mysql
```` 
2) Make sure to have Python 2.7 on your computer. Follow here: https://www.python.org/downloads/
3) Have pip installed on your computer (Comes with versions greater than Python 2.7.9). If not follow here: https://pip.pypa.io/en/stable/installing/#do-i-need-to-install-pip
4) From the terminal navigate to the etl_pipeline folder on your machine. Run the following command to install all the 
necessary pip packages to run the program: 
```
    sudo pip install -r requirements.txt
```
5) To run the Luigi Pipeline, run the following command: 
```
    python etl_pipeline.py
```
6) To view the results of the ETL transformation, find the newly created file: ```output-{datetime}.csv``` to view the 
results.
7) To run the unit tests, simply run:
```
    python -m unittest discover
```
