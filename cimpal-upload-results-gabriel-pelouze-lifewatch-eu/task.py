from minio import Minio
import base64
import os
import uuid

import argparse
import json
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--out_path2', action='store', type=str, required=True, dest='out_path2')

arg_parser.add_argument('--param_s3_access_key', action='store', type=str, required=True, dest='param_s3_access_key')
arg_parser.add_argument('--param_s3_bucket_output', action='store', type=str, required=True, dest='param_s3_bucket_output')
arg_parser.add_argument('--param_s3_prefix_output', action='store', type=str, required=True, dest='param_s3_prefix_output')
arg_parser.add_argument('--param_s3_secret_key', action='store', type=str, required=True, dest='param_s3_secret_key')
arg_parser.add_argument('--param_s3_server', action='store', type=str, required=True, dest='param_s3_server')

args = arg_parser.parse_args()
print(args)

id = args.id

out_path2 = args.out_path2.replace('"','')

param_s3_access_key = args.param_s3_access_key.replace('"','')
param_s3_bucket_output = args.param_s3_bucket_output.replace('"','')
param_s3_prefix_output = args.param_s3_prefix_output.replace('"','')
param_s3_secret_key = args.param_s3_secret_key.replace('"','')
param_s3_server = args.param_s3_server.replace('"','')




minio_client = Minio(param_s3_server, access_key=param_s3_access_key, secret_key=param_s3_secret_key, secure=True)

unique_folder = str(uuid.uuid4())

for filename in os.listdir(out_path2):
    file_path = f"{out_path2}/{filename}"
    dir_basename = os.path.basename(out_path2)
    user_prefix = param_s3_prefix_output[:-1]
    object_name = f"{user_prefix}/{unique_folder}/{dir_basename}/{filename}"
    print("Uploading", file_path, "->", object_name)
    minio_client.fput_object(param_s3_bucket_output, object_name=object_name, file_path=file_path)

print(
    f"Files uploaded to https://{param_s3_server.replace('9000', '9001')}"
    f"/browser"
    f"/{param_s3_bucket_output}"
    f"/{base64.b64encode(f'{user_prefix}/{unique_folder}/'.encode()).decode()}")

