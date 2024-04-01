from google.cloud import bigquery
import os
import csv

def infer_csv_schema(csv_file):

    with open(csv_file, "r", newline='') as file:
        reader = csv.reader(file)
        sample_data = [next(reader) for _ in range(10)]

    schema = []
    for field in sample_data[0]:
        schema.append(bigquery.SchemaField(field, "STRING"))

    return schema

def upload_csv_to_bigquery(csv_file, project_id, dataset_id, table_id):

    ### create the dataset if it does not exist and infer schema from the csv file
    client = bigquery.Client(project=project_id)
    dataset_ref = client.dataset(dataset_id)
    dataset = bigquery.Dataset(dataset_ref)

    if not client.get_dataset(dataset_ref):
        dataset.location = "US"
        client.create_dataset(dataset)

    table_ref = dataset_ref.table(table_id)
    schema = infer_csv_schema(csv_file)

    ### load data in BQ
    job_config = bigquery.LoadJobConfig(
        write_disposition=bigquery.WriteDisposition.WRITE_APPEND, schema=schema, skip_leading_rows=1
    )

    with open(csv_file, "rb") as source_file:
        job = client.load_table_from_file(source_file, table_ref, job_config=job_config)

    job.result()

    print(f"Loaded {job.output_rows} rows into {dataset_id}.{table_id} from {csv_file}.")

def upload_csv_files_to_bigquery(input_folder, project_id, dataset_id):

    for filename in os.listdir(input_folder):
        if filename.endswith(".csv"):

            csv_file = os.path.join(input_folder, filename)
            table_id = os.path.splitext(filename)[0]
            upload_csv_to_bigquery(csv_file, project_id, dataset_id, table_id)

    print("Upload of all CSV files to BigQuery complete.")

input_folder = "/System/Volumes/Data/Users/patricia/Documents/GitHub/sumup/src/files/csv"
project_id = "sumup-raw"
dataset_id = "csv_import"

upload_csv_files_to_bigquery(input_folder, project_id, dataset_id)
