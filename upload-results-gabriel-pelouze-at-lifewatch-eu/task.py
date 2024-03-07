from minio import Minio
import os

import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--output_dirs', action='store', type=str, required=True, dest='output_dirs')

arg_parser.add_argument('--param_s3_access_key', action='store', type=str, required=True, dest='param_s3_access_key')
arg_parser.add_argument('--param_s3_secret_key', action='store', type=str, required=True, dest='param_s3_secret_key')
arg_parser.add_argument('--param_s3_server', action='store', type=str, required=True, dest='param_s3_server')
arg_parser.add_argument('--param_s3_user_bucket', action='store', type=str, required=True, dest='param_s3_user_bucket')
arg_parser.add_argument('--param_s3_user_prefix', action='store', type=str, required=True, dest='param_s3_user_prefix')

args = arg_parser.parse_args()
print(args)

id = args.id

import json
output_dirs = json.loads(args.output_dirs)

param_s3_access_key = args.param_s3_access_key
param_s3_secret_key = args.param_s3_secret_key
param_s3_server = args.param_s3_server
param_s3_user_bucket = args.param_s3_user_bucket
param_s3_user_prefix = args.param_s3_user_prefix

conf_data_dir = '/tmp/data'


conf_data_dir = '/tmp/data'


minio_client = Minio(param_s3_server, access_key=param_s3_access_key, secret_key=param_s3_secret_key, secure=True)

for output_dir in output_dirs:
    for filename in os.listdir(f"{conf_data_dir}/acolite-output/{output_dir}"):
        file_path = f"{conf_data_dir}/acolite-output/{output_dir}/{filename}"
        object_name = f"{param_s3_user_prefix}/vl-waddenzee-proto-dt/acolite-output/{output_dir}/{filename}"
        print("Uploading", file_path)
        minio_client.fput_object(param_s3_user_bucket, object_name=object_name, file_path=file_path)

