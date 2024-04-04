from minio import Minio

import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--param_bucket_name', action='store', type=str, required=True, dest='param_bucket_name')
arg_parser.add_argument('--param_minio_server', action='store', type=str, required=True, dest='param_minio_server')
arg_parser.add_argument('--param_remote_path_root', action='store', type=str, required=True, dest='param_remote_path_root')
arg_parser.add_argument('--param_remote_server_type', action='store', type=str, required=True, dest='param_remote_server_type')

args = arg_parser.parse_args()
print(args)

id = args.id


param_bucket_name = args.param_bucket_name
param_minio_server = args.param_minio_server
param_remote_path_root = args.param_remote_path_root
param_remote_server_type = args.param_remote_server_type




laz_files = []
if param_remote_server_type == 'minio':
    minio_client = Minio(param_minio_server, secure=True)
    objects = minio_client.list_objects(param_bucket_name, prefix=param_remote_path_root, recursive=True)
    for obj in objects:
        if obj.object_name.lower().endswith('.laz'):
            laz_files.append(obj.object_name.split('/')[-1])

print(laz_files)

import json
filename = "/tmp/laz_files_" + id + ".json"
file_laz_files = open(filename, "w")
file_laz_files.write(json.dumps(laz_files))
file_laz_files.close()
