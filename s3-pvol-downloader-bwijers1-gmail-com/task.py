from minio import Minio
import pandas as pd
import pathlib

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()

secret_minio_access_key = os.getenv('secret_minio_access_key')
secret_minio_secret_key = os.getenv('secret_minio_secret_key')

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--param_end_date', action='store', type=str, required=True, dest='param_end_date')
arg_parser.add_argument('--param_radar', action='store', type=str, required=True, dest='param_radar')
arg_parser.add_argument('--param_start_date', action='store', type=str, required=True, dest='param_start_date')

args = arg_parser.parse_args()
print(args)

id = args.id


param_end_date = args.param_end_date.replace('"','')
param_radar = args.param_radar.replace('"','')
param_start_date = args.param_start_date.replace('"','')

conf_minio_endpoint = 'scruffy.lab.uvalight.net:9000'

conf_minio_user_bucket_name = 'naa-vre-user-data'

conf_local_odim = '/tmp/data/odim'


conf_minio_endpoint = 'scruffy.lab.uvalight.net:9000'
conf_minio_user_bucket_name = 'naa-vre-user-data'
conf_local_odim = '/tmp/data/odim'

minioClient = ""



psd = pd.to_datetime(param_start_date)
ped = pd.to_datetime(param_end_date)
minioClient = Minio(
    endpoint=conf_minio_endpoint,
    access_key=secret_minio_access_key,
    secret_key=secret_minio_secret_key,
    secure=True,
)

download_objs = []

psd_prefix = f"bwijers1@gmail.com/pvol/NL/{param_radar}/{psd.year}/{psd.month:02}/{psd.day:02}"
psd_start_after_prefix = f"{psd_prefix}/NL{param_radar}_pvol_{psd.year}{psd.month:02}{psd.day:02}T{psd.hour:02}{psd.minute:02}"
psd_prefix_objs = minioClient.list_objects(bucket_name = conf_minio_user_bucket_name,
                                prefix = psd_prefix,
                                start_after = psd_start_after_prefix,
                                recursive = True)
download_objs += list(psd_prefix_objs)

ped_prefix = f"bwijers1@gmail.com/pvol/NL/{param_radar}/{ped.year}/{ped.month:02}/{ped.day:02}"
ped_until_prefix = f"{ped_prefix}/NL{param_radar}_pvol_{ped.year}{ped.month:02}{ped.day:02}T{ped.hour:02}{ped.minute:02}"
ped_until_datetimestr = f"{ped.year}{ped.month:02}{ped.day:02}T{ped.hour:02}{ped.minute:02}" 
ped_until_timestamp = pd.to_datetime(ped_until_datetimestr)
ped_prefix_objs = minioClient.list_objects(bucket_name = conf_minio_user_bucket_name,
                                prefix = ped_prefix,
                                recursive = True)
ped_prefix_objs = list(ped_prefix_objs)
for obj in ped_prefix_objs:
    fpath = pathlib.Path(obj._object_name)
    fname = fpath.name
    corad,dtype,datetimestr,radcode_suffix = fname.split("_")
    timestamp = pd.to_datetime(datetimestr)
    if timestamp <= ped_until_timestamp:
        download_objs.append(obj)

pvol_paths = []
for obj in download_objs:
    obj_path = pathlib.Path(obj._object_name)
    uname,dtype,country,radar,year,month,day,filename = obj_path.parts
    local_pvol_path = f"{conf_local_odim}/{country}/{radar}/{year}/{month}/{day}/{filename}"
    print(local_pvol_path)
    minioClient.fget_object(bucket_name = obj._bucket_name,
                            object_name = obj._object_name, 
                            file_path = local_pvol_path) 
    pvol_paths.append(local_pvol_path)

file_pvol_paths = open("/tmp/pvol_paths_" + id + ".json", "w")
file_pvol_paths.write(json.dumps(pvol_paths))
file_pvol_paths.close()
