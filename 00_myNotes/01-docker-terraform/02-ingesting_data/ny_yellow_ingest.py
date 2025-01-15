#!/usr/bin/env python
# coding: utf-8

import os
import argparse
import pyarrow

from time import time

import pandas as pd
import numpy as np
from sqlalchemy import create_engine

def main(params):
    user = params.user
    password = params.password
    host = params.host 
    port = params.port 
    db = params.db
    table_name = params.table_name
    url = params.url

    if url.endswith('.parquet.gz'):
        pqt_name = 'output.parquet.gz'
    else:
        pqt_name = 'output.parquet'

    os.system(f"wget {url} -O {pqt_name}")

    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')
    

    # FOR PARQUET Read the parquet file
    df = pd.read_parquet(pqt_name, engine='pyarrow', columns=None, use_nullable_dtypes=False)

    # Split the dataframe into chunks
    chunk_size = 100000
    df_chunks = np.array_split(df, len(df) // chunk_size + 1)

    # fix the data format for these 2 itens
    df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
    df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)

    # add only the header to the database (checking purpose)
    df.head(n=0).to_sql(name=table_name, con=engine, if_exists='replace')

    # Process each chunk
    for i, df_chunk in enumerate(df_chunks):
        # Convert datetime columns
        df_chunk.tpep_pickup_datetime = pd.to_datetime(df_chunk.tpep_pickup_datetime)
        df_chunk.tpep_dropoff_datetime = pd.to_datetime(df_chunk.tpep_dropoff_datetime)

        # Insert the chunk into the database
        df_chunk.to_sql(name=table_name, con=engine, if_exists='append')

        # Print a message after inserting each chunk
        print(f"Inserted chunk {i+1}/{len(df_chunks)}")

        # Clean up memory
        del df_chunk

    # Close the connection
    engine.dispose()
    print("Data inserted successfully!")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Ingest CSV data to Postgres')

    parser.add_argument('--user', required=True, help='user name for postgres')
    parser.add_argument('--password', required=True, help='password for postgres')
    parser.add_argument('--host', required=True, help='host for postgres')
    parser.add_argument('--port', required=True, help='port for postgres')
    parser.add_argument('--db', required=True, help='database name for postgres')
    parser.add_argument('--table_name', required=True, help='name of the table where we will write the results to')
    parser.add_argument('--url', required=True, help='url of the csv file')

    args = parser.parse_args()

    main(args)