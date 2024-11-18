from minio import Minio
from dtAcolite import dtAcolite
from dtSat import dtSat
import glob
import json
import os

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()

secret_copernicus_api_password = os.getenv('secret_copernicus_api_password')
secret_s3_access_key = os.getenv('secret_s3_access_key')
secret_s3_secret_key = os.getenv('secret_s3_secret_key')

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--param_copernicus_api_username', action='store', type=str, required=True, dest='param_copernicus_api_username')
arg_parser.add_argument('--param_s3_base_path', action='store', type=str, required=True, dest='param_s3_base_path')
arg_parser.add_argument('--param_s3_bucket', action='store', type=str, required=True, dest='param_s3_bucket')
arg_parser.add_argument('--param_s3_server', action='store', type=str, required=True, dest='param_s3_server')

args = arg_parser.parse_args()
print(args)

id = args.id


param_copernicus_api_username = args.param_copernicus_api_username.replace('"','')
param_s3_base_path = args.param_s3_base_path.replace('"','')
param_s3_bucket = args.param_s3_bucket.replace('"','')
param_s3_server = args.param_s3_server.replace('"','')




year = 2016 
start_date = f"{year}-01-01"
end_date   = f"{year}-12-31"
data_collection = "SENTINEL-2"
product_type = "S2MSI1C"
aoi = "POLYGON((4.6 53.1, 4.9 53.1, 4.9 52.8, 4.6 52.8, 4.6 53.1))'"
collection = "sentinel"

app_configuration = dtAcolite.configure_acolite_directory(base_dir = "/tmp/data", year = year, collection = collection)
print(app_configuration)

catalogue_response = dtSat.get_sentinel_catalogue(start_date, end_date, data_collection = data_collection, aoi= aoi, product_type=product_type, cloudcover=10.0, max_results=1000)
catalogue_sub = dtSat.filter_by_orbit_and_tile(catalogue_response, orbit = "R051", tile = "T31UFU", name_only = False)


catalogue_sub_filename = "/tmp/data/catalogue_sub.json"
with open(catalogue_sub_filename, 'w') as f:
    json.dump(catalogue_sub, f)
    
access_response = dtSat.get_copernicus_access_token(username = param_copernicus_api_username, 
                                                    password = secret_copernicus_api_password)

access_response_filename = "/tmp/data/access_response.json"
with open(access_response_filename, 'w') as f:
    json.dump(access_response, f)
    
print(f"Raw images will be stored in {app_configuration['raw_inputdir']}")
print(f"Analysis with acolite will start with images from {app_configuration['acolite_inputdir']}")
print(f"Processed images from acolite will be stored in {app_configuration['acolite_outputdir']}")


with open(catalogue_sub_filename) as f:
    catalogue_sub = json.load(f)
    
with open(access_response_filename) as f:
    access_response = json.load(f)
    
dtSat.data_sentinel_request(access_response, 
                            catalogue_sub, 
                            dir_path = app_configuration["raw_inputdir"])


print(f"List of all images downloaded in {app_configuration['raw_inputdir']} included: ")
print(os.listdir(app_configuration["raw_inputdir"]))


minio_client = Minio(param_s3_server, access_key=secret_s3_access_key, secret_key=secret_s3_secret_key, region = "nl-uvalight", secure=True)
minio_client

dtSat.upload_satellite_to_minio(client = minio_client,
                                bucket_name = param_s3_bucket,  
                                local_path = app_configuration["raw_inputdir"],
                                minio_path = f"/{param_s3_base_path}/raw/{app_configuration['collection']}/{app_configuration['year']}", 
                                collection = app_configuration["raw_inputdir"], 
                                year = app_configuration["raw_inputdir"])


inputfilenames = dtAcolite.create_acolite_input(app_configuration = app_configuration)
outfilepaths   = dtAcolite.create_acolite_output(app_configuration=app_configuration, filenames=inputfilenames)
dtAcolite.unzip_inputfiles(app_configuration=app_configuration)

inputfilepaths = glob.glob(f"{app_configuration['acolite_inputdir']}/**")
outputfilepaths = glob.glob(f"{app_configuration['acolite_outputdir']}/**")
outputfilepaths
inputfilepaths

path_ids = list(range(len(inputfilepaths)))

def batch_items(items, max_batch_count) -> list:
    if len(items) == 0:
        return [[]]
    batch_size = len(items) // max_batch_count + bool(len(items) % max_batch_count)
    return [items[i:i+batch_size] for i in range(0, len(items), batch_size)]
path_id_batches = batch_items(path_ids, param_max_batch_count)

file_path_id_batches = open("/tmp/path_id_batches_" + id + ".json", "w")
file_path_id_batches.write(json.dumps(path_id_batches))
file_path_id_batches.close()
