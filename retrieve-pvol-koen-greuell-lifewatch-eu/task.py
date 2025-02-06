from minio import Minio
import pathlib
import sys

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()

secret_minio_access_key = os.getenv('secret_minio_access_key')
secret_minio_secret_key = os.getenv('secret_minio_secret_key')

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--param_country', action='store', type=str, required=True, dest='param_country')
arg_parser.add_argument('--param_day', action='store', type=str, required=True, dest='param_day')
arg_parser.add_argument('--param_dtype', action='store', type=str, required=True, dest='param_dtype')
arg_parser.add_argument('--param_jupyterhub_user', action='store', type=str, required=True, dest='param_jupyterhub_user')
arg_parser.add_argument('--param_month', action='store', type=str, required=True, dest='param_month')
arg_parser.add_argument('--param_radar', action='store', type=str, required=True, dest='param_radar')
arg_parser.add_argument('--param_year', action='store', type=str, required=True, dest='param_year')

args = arg_parser.parse_args()
print(args)

id = args.id


param_country = args.param_country.replace('"','')
param_day = args.param_day.replace('"','')
param_dtype = args.param_dtype.replace('"','')
param_jupyterhub_user = args.param_jupyterhub_user.replace('"','')
param_month = args.param_month.replace('"','')
param_radar = args.param_radar.replace('"','')
param_year = args.param_year.replace('"','')

conf_minio_endpoint = 'scruffy.lab.uvalight.net:9000'

conf_pvol_output_prefix = 'pvol'

conf_vp_output_prefix = 'vp'

conf_minio_user_bucket_name = 'naa-vre-user-data'

conf_local_visualization_input = '/tmp/data/visualizations/input'


conf_minio_endpoint = 'scruffy.lab.uvalight.net:9000'
conf_pvol_output_prefix = 'pvol'
conf_vp_output_prefix = 'vp'
conf_minio_user_bucket_name = 'naa-vre-user-data'
conf_local_visualization_input = '/tmp/data/visualizations/input'

minioClient = Minio(
    endpoint=conf_minio_endpoint,
    access_key=secret_minio_access_key,
    secret_key=secret_minio_secret_key,
    secure=True,
)

recursive = True

if param_dtype.lower() in ["pvol", "polar volume", "polarvolume"]:
    search_prefix = f"{param_jupyterhub_user}/{conf_pvol_output_prefix}/{param_country}/{param_radar}/{param_year}/{param_month}/{param_day}"
elif param_dtype.lower() in ["vp", "vertical profile", "verticalprofile"]:
    search_prefix = f"{param_jupyterhub_user}/{conf_vp_output_prefix}/{param_country}/{param_radar}/{param_year}/{param_month}/{param_day}"
else:
    print(f"{param_dtype} not understood")
    sys.exit(1)
print(f"{search_prefix=}")
objects = minioClient.list_objects(
    bucket_name=conf_minio_user_bucket_name,
    prefix=search_prefix,
    recursive=recursive,
)
local_file_paths = []
for obj in objects:
    obj_path = pathlib.Path(obj._object_name)
    local_file_path = f"{conf_local_visualization_input}/{obj_path.name}"
    local_file_paths.append(local_file_path)
    print(f"Downloading {obj._object_name} to {local_file_path}")
    minioClient.fget_object(
        bucket_name=obj._bucket_name,
        object_name=obj._object_name,
        file_path=local_file_path,
    )
    local_file_paths.append(local_file_path)
print("Finished")

