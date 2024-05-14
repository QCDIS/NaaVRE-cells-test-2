from minio import Minio
import os

import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--param_s3_access_key', action='store', type=str, required=True, dest='param_s3_access_key')
arg_parser.add_argument('--param_s3_secret_key', action='store', type=str, required=True, dest='param_s3_secret_key')
arg_parser.add_argument('--param_s3_server', action='store', type=str, required=True, dest='param_s3_server')
arg_parser.add_argument('--param_s3_user_bucket', action='store', type=str, required=True, dest='param_s3_user_bucket')
arg_parser.add_argument('--param_s3_user_prefix', action='store', type=str, required=True, dest='param_s3_user_prefix')

args = arg_parser.parse_args()
print(args)

id = args.id


param_s3_access_key = args.param_s3_access_key
param_s3_secret_key = args.param_s3_secret_key
param_s3_server = args.param_s3_server
param_s3_user_bucket = args.param_s3_user_bucket
param_s3_user_prefix = args.param_s3_user_prefix

conf_data_dir = '/tmp/data'


conf_data_dir = '/tmp/data'



minio_client = Minio(param_s3_server, access_key=param_s3_access_key, secret_key=param_s3_secret_key, secure=True)

for item in minio_client.list_objects(param_s3_user_bucket, prefix=f"{param_s3_user_prefix}", recursive=True):
    target_file = f"{conf_data_dir}/input/{item.object_name.removeprefix(param_s3_user_prefix)}"
    if not os.path.exists(target_file):
        print("Downloading", item.object_name)
        minio_client.fget_object(param_s3_user_bucket, item.object_name, target_file)

occ_taxa = f"{conf_data_dir}/input/Cimpal_resources"
shp = f"{conf_data_dir}/input/Cimpal_resources"
weight_file = f"{conf_data_dir}/input/Cimpal_resources/weight_wp.csv"
pathway_file = f"{conf_data_dir}/input/Cimpal_resources/CIMPAL_paths.csv"
zones_file = f"{conf_data_dir}/input/zones"
sys_not_use = "empty"
transform_not_use = "empty"

import json
filename = "/tmp/occ_taxa_" + id + ".json"
file_occ_taxa = open(filename, "w")
file_occ_taxa.write(json.dumps(occ_taxa))
file_occ_taxa.close()
filename = "/tmp/shp_" + id + ".json"
file_shp = open(filename, "w")
file_shp.write(json.dumps(shp))
file_shp.close()
filename = "/tmp/weight_file_" + id + ".json"
file_weight_file = open(filename, "w")
file_weight_file.write(json.dumps(weight_file))
file_weight_file.close()
filename = "/tmp/pathway_file_" + id + ".json"
file_pathway_file = open(filename, "w")
file_pathway_file.write(json.dumps(pathway_file))
file_pathway_file.close()
filename = "/tmp/zones_file_" + id + ".json"
file_zones_file = open(filename, "w")
file_zones_file.write(json.dumps(zones_file))
file_zones_file.close()
filename = "/tmp/sys_not_use_" + id + ".json"
file_sys_not_use = open(filename, "w")
file_sys_not_use.write(json.dumps(sys_not_use))
file_sys_not_use.close()
filename = "/tmp/transform_not_use_" + id + ".json"
file_transform_not_use = open(filename, "w")
file_transform_not_use.write(json.dumps(transform_not_use))
file_transform_not_use.close()
