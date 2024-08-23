import aws.s3

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()

secret_s3_access_key = os.getenv('secret_s3_access_key')
secret_s3_secret_key = os.getenv('secret_s3_secret_key')

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--rws_file_path', action='store', type=str, required=True, dest='rws_file_path')

arg_parser.add_argument('--param_s3_endpoint', action='store', type=str, required=True, dest='param_s3_endpoint')

args = arg_parser.parse_args()
print(args)

id = args.id

rws_file_path = args.rws_file_path.replace('"','')

param_s3_endpoint = args.param_s3_endpoint.replace('"','')




os.environ['AWS_ACCESS_KEY_ID']=secret_s3_access_key
os.environ['AWS_SECRET_ACCESS_KEY']=secret_s3_secret_key
os.environ["AWS_S3_ENDPOINT"]=param_s3_endpoint

MINIO_CLIENT = Minio(param_s3_endpoint, 
                     access_key=secret_s3_access_key, 
                     secret_key=secret_s3_secret_key)
MINIO_CLIENT.fput_object( 
    bucket_name="naa-vre-waddenzee-shared", 
    file_path= rws_file_path, 
    object_name=f"/waterinfo_RWS/raw_data/{station_name}_Chl_2021.csv",)


