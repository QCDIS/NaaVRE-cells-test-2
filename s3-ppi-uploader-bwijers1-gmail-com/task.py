from minio import Minio
import pathlib

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()

secret_minio_access_key = os.getenv('secret_minio_access_key')
secret_minio_secret_key = os.getenv('secret_minio_secret_key')

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--local_ppi_paths', action='store', type=str, required=True, dest='local_ppi_paths')

arg_parser.add_argument('--param_jupyterhub_user', action='store', type=str, required=True, dest='param_jupyterhub_user')

args = arg_parser.parse_args()
print(args)

id = args.id

local_ppi_paths = json.loads(args.local_ppi_paths)

param_jupyterhub_user = args.param_jupyterhub_user.replace('"','')

conf_minio_endpoint = 'scruffy.lab.uvalight.net:9000'

conf_minio_user_bucket_name = 'naa-vre-user-data'


conf_minio_endpoint = 'scruffy.lab.uvalight.net:9000'
conf_minio_user_bucket_name = 'naa-vre-user-data'


minioClient = Minio(
    endpoint=conf_minio_endpoint,
    access_key=secret_minio_access_key,
    secret_key=secret_minio_secret_key,
    secure=True,
)

for path in local_ppi_paths:
    print(path)
    obj_key = pathlib.Path(*pathlib.Path(path).parts[3:])
    obj_name = f"{conf_minio_user_bucket_name}/{param_jupyterhub_user}/{obj_key}"
    print(obj_name)
    minioClient.fput_object(bucket_name = conf_minio_user_bucket_name,
                            object_name = obj_name,
                            file_path = path)

