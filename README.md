## Main Assumptions
- usage of dbt, Airflow and BigQUery is in place
- code to import data to bigquery is assumed from a local machine but can be done from GCS bucket or other solutions
- designed E2E flow is:

<img width="877" alt="sumup_e2e_flow" src="https://github.com/trish-fly/sumup/assets/164615132/ddfa2302-47b8-4680-9b7f-a54e541913c1">

## Home directory 
  Contains requirements.txt file, setup for dbt including sources, project file and the main daily_import_dag

## /scr directory
  Contains files with .xlsx and .csv suffixes as well as functions to convert to CSV and import data to BQ.
  Please note that a full path defined for the input and output folders should be either replaced by yours (use os.chdir('[path]') or ideally store the path in your ~zrsh file.


## /documentation
  Contains main dbt .md file with documented models, metrics and dimensions

## /queries
  Contains curated and reporting folders. Under curated can be found model materialisations with respective config and .yml files with sample documentation and tests included. 
  Under reporting can be found queries to answer the 5 questions from the technical task.
