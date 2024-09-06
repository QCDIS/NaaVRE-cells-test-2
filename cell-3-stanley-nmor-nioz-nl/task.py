from minio import Minio
import acolite as ac
from dtAcolite import dtAcolite
from dtSat import dtSat
import glob

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()

secret_s3_access_key = os.getenv('secret_s3_access_key')
secret_s3_secret_key = os.getenv('secret_s3_secret_key')

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--app_configuration', action='store', type=str, required=True, dest='app_configuration')

arg_parser.add_argument('--collection', action='store', type=str, required=True, dest='collection')

arg_parser.add_argument('--year', action='store', type=int, required=True, dest='year')

arg_parser.add_argument('--param_s3_public_bucket', action='store', type=str, required=True, dest='param_s3_public_bucket')
arg_parser.add_argument('--param_s3_server', action='store', type=str, required=True, dest='param_s3_server')

args = arg_parser.parse_args()
print(args)

id = args.id

app_configuration = json.loads(args.app_configuration)
collection = args.collection.replace('"','')
year = args.year

param_s3_public_bucket = args.param_s3_public_bucket.replace('"','')
param_s3_server = args.param_s3_server.replace('"','')



minio_client = Minio(param_s3_server, access_key=secret_s3_access_key, secret_key=secret_s3_secret_key, region = "nl", secure=True)
minio_client

minio_base_path = 'app_acolite_stan'
dtSat.upload_satellite_to_minio(client = minio_client,
                                bucket_name = param_s3_public_bucket,  
                                local_path = app_configuration["raw_inputdir"],
                                minio_path = f"/{minio_base_path}/raw/{app_configuration['collection']}/{app_configuration['year']}", 
                                collection = app_configuration["raw_inputdir"], 
                                year = app_configuration["raw_inputdir"])


inputfilenames = dtAcolite.create_acolite_input(app_configuration = app_configuration)
outfilepaths   = dtAcolite.create_acolite_output(app_configuration=app_configuration, filenames=inputfilenames)
dtAcolite.unzip_inputfiles(app_configuration=app_configuration)

settings = {'limit': [52.5,4.7,53.50,5.4], 
            'inputfile': '', 
            'output': '', 
            "cirrus_correction": True,
            'l2w_parameters' : ["rhow_*","rhos_*", "Rrs_*", "chl_oc3", "chl_re_gons", "chl_re_gons740", 
                                "chl_re_moses3b", "chl_re_moses3b740",  "chl_re_mishra", "chl_re_bramich", 
                                "ndci", "ndvi","spm_nechad2010"]}

inputfilepaths = glob.glob(f"{app_configuration['acolite_inputdir']}/**")
outputfilepaths = glob.glob(f"{app_configuration['acolite_outputdir']}/**")
outputfilepaths


for i in range(len(inputfilepaths)):
    print("---------------------------------------------------------------------------------------")
    settings['inputfile'] = inputfilepaths[i]
    settings['output']    = outputfilepaths[i]
    ac.acolite.acolite_run(settings=settings)
print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
print(f"processing done and output is in {inputfilepaths[i]}")
print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")


dtSat.upload_local_directory_to_minio(client = minio_client,
                                      bucket_name = param_s3_public_bucket,  
                                      local_path = app_configuration['acolite_output'], 
                                      minio_path = f"/{minio_base_path}/processed/outputdir/{app_configuration['collection']}/{app_configuration['year']}", 
                                      collection = collection, 
                                      year = year)

file_minio_client = open("/tmp/minio_client_" + id + ".json", "w")
file_minio_client.write(json.dumps(minio_client))
file_minio_client.close()
file_minio_base_path = open("/tmp/minio_base_path_" + id + ".json", "w")
file_minio_base_path.write(json.dumps(minio_base_path))
file_minio_base_path.close()
