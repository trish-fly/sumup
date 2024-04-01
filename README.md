## About
Repository provides an E2E solution from reading a locally stored file, uploading to BQ and running dbt on top. By using dbt we clean the data apply some tests, and documentation, and create views in the reporting layer to answer the technical challenge questions.
- designed E2E flow is:

<img width="877" alt="sumup_e2e_flow" src="https://github.com/trish-fly/sumup/assets/164615132/ddfa2302-47b8-4680-9b7f-a54e541913c1">

### Main Assumptions
- usage of dbt, Airflow and BigQUery is in place
- code to import data to bigquery is assumed from a local machine but can be done from GCS bucket or other solutions
  
## .github workflows
  Provides local GA implementation in order to run and trigger dbt after PR is merged.

## /scr directory
  Contains files with .xlsx and .csv suffixes as well as functions to convert to CSV and import data to BQ.
  Please note that a full path defined for the input and output folders should be either replaced by yours (use os.chdir('[path]') or ideally store the path in your ~zrsh file.


## /dbt directory
  Contains dbt implementation including required setup and data modelling.
