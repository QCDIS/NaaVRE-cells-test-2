from minio import Minio
import os

import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--plot_files', action='store', type=str, required=True, dest='plot_files')

arg_parser.add_argument('--param_s3_access_key', action='store', type=str, required=True, dest='param_s3_access_key')
arg_parser.add_argument('--param_s3_bucket', action='store', type=str, required=True, dest='param_s3_bucket')
arg_parser.add_argument('--param_s3_secret_key', action='store', type=str, required=True, dest='param_s3_secret_key')
arg_parser.add_argument('--param_s3_server', action='store', type=str, required=True, dest='param_s3_server')
arg_parser.add_argument('--param_s3_user_prefix', action='store', type=str, required=True, dest='param_s3_user_prefix')

args = arg_parser.parse_args()
print(args)

id = args.id

import json
plot_files = json.loads(args.plot_files)

param_s3_access_key = args.param_s3_access_key
param_s3_bucket = args.param_s3_bucket
param_s3_secret_key = args.param_s3_secret_key
param_s3_server = args.param_s3_server
param_s3_user_prefix = args.param_s3_user_prefix




minio_client = Minio(param_s3_server, access_key=param_s3_access_key, secret_key=param_s3_secret_key, secure=True)

for plot_file  in plot_files:
    print("Uploading", plot_file)
    object_name = f'{param_s3_user_prefix}/vl-openlab/icos-naavre-demo/{os.path.basename(plot_file)}'
    minio_client.fput_object(param_s3_bucket, object_name=object_name, file_path=plot_file)

