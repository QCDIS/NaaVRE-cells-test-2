from minio import Minio
from dtAcolite import dtAcolite
from dtSat import dtSat

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--app_configuration', action='store', type=str, required=True, dest='app_configuration')


args = arg_parser.parse_args()
print(args)

id = args.id

app_configuration = json.loads(args.app_configuration)





minio_client = Minio(param_s3_server, access_key=secret_s3_access_key, secret_key=secret_s3_secret_key, region = "nl", secure=True)
minio_client

dtSat.upload_satellite_to_minio(client = minio_client,
                                bucket_name = param_s3_public_bucket,  
                                local_path = app_configuration["raw_inputdir"],
                                minio_path = f"/app_acolite/raw/{app_configuration['collection']}/{app_configuration['year']}", 
                                collection = app_configuration["raw_inputdir"], 
                                year = app_configuration["raw_inputdir"])


inputfilenames = dtAcolite.create_acolite_input(app_configuration = app_configuration)
outfilepaths   = dtAcolite.create_acolite_output(app_configuration=app_configuration, filenames=inputfilenames)
dtAcolite.unzip_inputfiles(app_configuration=app_configuration)

