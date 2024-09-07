import acolite as ac

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()

secret_copernicus_api = os.getenv('secret_copernicus_api')
secret_s3_access_key = os.getenv('secret_s3_access_key')
secret_s3_secret_key = os.getenv('secret_s3_secret_key')

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--app_configuration', action='store', type=str, required=True, dest='app_configuration')

arg_parser.add_argument('--outputfilepaths', action='store', type=str, required=True, dest='outputfilepaths')

arg_parser.add_argument('--settings', action='store', type=str, required=True, dest='settings')

arg_parser.add_argument('--param_copernicus_api', action='store', type=str, required=True, dest='param_copernicus_api')
arg_parser.add_argument('--param_s3_public_bucket', action='store', type=str, required=True, dest='param_s3_public_bucket')
arg_parser.add_argument('--param_s3_server', action='store', type=str, required=True, dest='param_s3_server')

args = arg_parser.parse_args()
print(args)

id = args.id

app_configuration = json.loads(args.app_configuration)
outputfilepaths = json.loads(args.outputfilepaths)
settings = json.loads(args.settings)

param_copernicus_api = args.param_copernicus_api.replace('"','')
param_s3_public_bucket = args.param_s3_public_bucket.replace('"','')
param_s3_server = args.param_s3_server.replace('"','')



acolite_processing = []
for i in range(len(inputfilepaths)):
    print("---------------------------------------------------------------------------------------")
    settings['inputfile'] = inputfilepaths[i]
    settings['output']    = outputfilepaths[i]
    ac.acolite.acolite_run(settings=settings)

    message = f"processing done and output is in {inputfilepaths[i]}"
    acolite_processing.append(message)
print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
print(f"processing done and output is in {inputfilepaths[i]}")
print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")


file_acolite_processing = open("/tmp/acolite_processing_" + id + ".json", "w")
file_acolite_processing.write(json.dumps(acolite_processing))
file_acolite_processing.close()
