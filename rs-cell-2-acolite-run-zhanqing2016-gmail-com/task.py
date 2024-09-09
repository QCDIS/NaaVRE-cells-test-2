from dtAcolite import dtAcolite
import glob

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()

secret_copernicus_api = os.getenv('secret_copernicus_api')
secret_s3_access_key = os.getenv('secret_s3_access_key')
secret_s3_secret_key = os.getenv('secret_s3_secret_key')

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--path_ids', action='store', type=str, required=True, dest='path_ids')

arg_parser.add_argument('--param_copernicus_api', action='store', type=str, required=True, dest='param_copernicus_api')
arg_parser.add_argument('--param_s3_public_bucket', action='store', type=str, required=True, dest='param_s3_public_bucket')
arg_parser.add_argument('--param_s3_server', action='store', type=str, required=True, dest='param_s3_server')
arg_parser.add_argument('--year', action='store', type=int, required=True, dest='year')

args = arg_parser.parse_args()
print(args)

id = args.id

path_ids = json.loads(args.path_ids)

param_copernicus_api = args.param_copernicus_api.replace('"','')
param_s3_public_bucket = args.param_s3_public_bucket.replace('"','')
param_s3_server = args.param_s3_server.replace('"','')
year = args.year



start_date = f"{year}-01-01"
end_date   = f"{year}-12-31"
data_collection = "SENTINEL-2"
product_type = "S2MSI1C"
aoi = "POLYGON((4.6 53.1, 4.9 53.1, 4.9 52.8, 4.6 52.8, 4.6 53.1))'"
collection = "sentinel"

app_configuration = dtAcolite.configure_acolite_directory(base_dir = "/tmp/data", year = year, collection = collection)
inputfilepaths = glob.glob(f"{app_configuration['acolite_inputdir']}/**")
outputfilepaths = glob.glob(f"{app_configuration['acolite_outputdir']}/**")
settings = {'limit': [52.5,4.7,53.50,5.4], 
            'inputfile': '', 
            'output': '', 
            "cirrus_correction": True,
            'l2w_parameters' : ["rhow_*","rhos_*", "Rrs_*", "chl_oc3", "chl_re_gons", "chl_re_gons740", 
                                "chl_re_moses3b", "chl_re_moses3b740",  "chl_re_mishra", "chl_re_bramich", 
                                "ndci", "ndvi","spm_nechad2010"]}

acolite_processing = []
for i in path_ids:
    print("---------------------------------------------------------------------------------------")
    settings['inputfile'] = inputfilepaths[i]
    settings['output']    = outputfilepaths[i]

    message = f"processing done and output is in {inputfilepaths[i]}"
    acolite_processing.append(message)


acolite_processing

file_acolite_processing = open("/tmp/acolite_processing_" + id + ".json", "w")
file_acolite_processing.write(json.dumps(acolite_processing))
file_acolite_processing.close()
