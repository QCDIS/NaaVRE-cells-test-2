from minio import Minio
import os

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--param_my_var', action='store', type=int, required=True, dest='param_my_var')
arg_parser.add_argument('--param_s3_access_key', action='store', type=str, required=True, dest='param_s3_access_key')
arg_parser.add_argument('--param_s3_bucket_input', action='store', type=str, required=True, dest='param_s3_bucket_input')
arg_parser.add_argument('--param_s3_prefix_input', action='store', type=str, required=True, dest='param_s3_prefix_input')
arg_parser.add_argument('--param_s3_secret_key', action='store', type=str, required=True, dest='param_s3_secret_key')
arg_parser.add_argument('--param_s3_server', action='store', type=str, required=True, dest='param_s3_server')

args = arg_parser.parse_args()
print(args)

id = args.id


param_my_var = args.param_my_var
param_s3_access_key = args.param_s3_access_key.replace('"','')
param_s3_bucket_input = args.param_s3_bucket_input.replace('"','')
param_s3_prefix_input = args.param_s3_prefix_input.replace('"','')
param_s3_secret_key = args.param_s3_secret_key.replace('"','')
param_s3_server = args.param_s3_server.replace('"','')

conf_data_dir = '/tmp/data'


conf_data_dir = '/tmp/data'



minio_client = Minio(param_s3_server, access_key=param_s3_access_key, secret_key=param_s3_secret_key, secure=True)

for item in minio_client.list_objects(param_s3_bucket_input, prefix=f"{param_s3_prefix_input}", recursive=True):
    target_file = f"{conf_data_dir}/input/{item.object_name.removeprefix(param_s3_prefix_input)}"
    if not os.path.exists(target_file):
        print("Downloading", item.object_name)
        minio_client.fget_object(param_s3_bucket_input, item.object_name, target_file)

occ_taxa = f"{conf_data_dir}/input/Cimpal_resources"
biotope_shp_path_file = f"{conf_data_dir}/input/Cimpal_resources"
weight_file = f"{conf_data_dir}/input/Cimpal_resources/weight_wp.csv"
pathway_file = f"{conf_data_dir}/input/Cimpal_resources/CIMPAL_paths.csv"
zones_file = f"{conf_data_dir}/input/zones"

print(param_my_var)

file_occ_taxa = open("/tmp/occ_taxa_" + id + ".json", "w")
file_occ_taxa.write(json.dumps(occ_taxa))
file_occ_taxa.close()
file_biotope_shp_path_file = open("/tmp/biotope_shp_path_file_" + id + ".json", "w")
file_biotope_shp_path_file.write(json.dumps(biotope_shp_path_file))
file_biotope_shp_path_file.close()
file_weight_file = open("/tmp/weight_file_" + id + ".json", "w")
file_weight_file.write(json.dumps(weight_file))
file_weight_file.close()
file_pathway_file = open("/tmp/pathway_file_" + id + ".json", "w")
file_pathway_file.write(json.dumps(pathway_file))
file_pathway_file.close()
file_zones_file = open("/tmp/zones_file_" + id + ".json", "w")
file_zones_file.write(json.dumps(zones_file))
file_zones_file.close()
