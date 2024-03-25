## this dag loads data from CSV file into BQ every day

from airflow import DAG
from airflow.operators.dummy_operator import DummyOperator
from airflow.operators.python_operator import PythonOperator
from datetime import datetime, timedelta
import sys
sys.path.insert(0, '/src/functions')

DAG_ID = "daily_import_to_bq"

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2024, 3, 25),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}
dag = DAG(
    dag_id=DAG_ID,
    description="Workflow to upload data to BQ.",
    schedule="0 0 * * *",
    start_date=dag_start_date,
    default_args=default_args,
    access_control={"Analytics": {"can_read", "can_edit"}},
)

start_task = DummyOperator(task_id='start', dag=dag)

import_to_bq_task = PythonOperator(
    task_id='import_to_bq',
    python_callable=import_to_bq,
    dag=dag
)

end_task = DummyOperator(task_id='end', dag=dag)

start_task >> import_to_bq_task >> end_task
