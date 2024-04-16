from minio import Minio
import pathlib

import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--param_minio_access_key', action='store', type=str, required=True, dest='param_minio_access_key')
arg_parser.add_argument('--param_minio_endpoint', action='store', type=str, required=True, dest='param_minio_endpoint')
arg_parser.add_argument('--param_minio_secret_key', action='store', type=str, required=True, dest='param_minio_secret_key')

args = arg_parser.parse_args()
print(args)

id = args.id


param_minio_access_key = args.param_minio_access_key
param_minio_endpoint = args.param_minio_endpoint
param_minio_secret_key = args.param_minio_secret_key

conf_local_root = "/tmp/data"

conf_local_knmi = "/tmp/data/knmi"

conf_local_odim = "/tmp/data/odim"

conf_local_vp = "/tmp/data/vp"

conf_local_conf = "/tmp/data/conf"

conf_local_radar_db = "/tmp/data/conf/OPERA_RADARS_DB.json"

conf_minio_public_bucket_name = pathlib.Path("naa-vre-public")

conf_minio_public_conf_radar_db_object_name = pathlib.Path(jupyter_lab_name).joinpath("conf/OPERA_RADARS_DB.json")


conf_local_root = "/tmp/data"
conf_local_knmi = "/tmp/data/knmi"
conf_local_odim = "/tmp/data/odim"
conf_local_vp = "/tmp/data/vp"
conf_local_conf = "/tmp/data/conf"
conf_local_radar_db = "/tmp/data/conf/OPERA_RADARS_DB.json"
conf_minio_public_bucket_name = pathlib.Path("naa-vre-public")
conf_minio_public_conf_radar_db_object_name =  pathlib.Path(jupyter_lab_name).joinpath("conf/OPERA_RADARS_DB.json")
for local_dir in [conf_local_root,conf_local_knmi,conf_local_odim,conf_local_vp, conf_local_conf]:
    local_dir = pathlib.Path(local_dir)
    if not local_dir.exists():
        local_dir.mkdir(parents=True,exist_ok=True)
if not pathlib.Path(conf_local_radar_db).exists():
    from minio import Minio, S3Error
    minioClient = Minio(endpoint = param_minio_endpoint,
                access_key = param_minio_access_key,
                secret_key = param_minio_secret_key,
                secure = True)
    print(f"{conf_local_radar_db} not found, downloading")
    minioClient.fget_object(bucket_name = conf_minio_public_bucket_name, object_name = conf_minio_public_conf_radar_db_object_name,file_path = conf_local_radar_db)
    
init_complete = "Yes" # Cant sent bool
print("Finished initialization")

import json
filename = "/tmp/init_complete_" + id + ".json"
file_init_complete = open(filename, "w")
file_init_complete.write(json.dumps(init_complete))
file_init_complete.close()
