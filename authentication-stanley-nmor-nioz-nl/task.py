from dtSat import dtSat
import json

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()

secret_copernicus_api = os.getenv('secret_copernicus_api')

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--param_copernicus_api', action='store', type=str, required=True, dest='param_copernicus_api')

args = arg_parser.parse_args()
print(args)

id = args.id


param_copernicus_api = args.param_copernicus_api.replace('"','')


access_response = dtSat.get_copernicus_access_token(username = param_copernicus_api, 
                                                    password = secret_copernicus_api)

access_response_filename = "/tmp/data/access_response.json"
with open(access_response_filename, 'w') as f:
    json.dump(access_response, f)

file_access_response_filename = open("/tmp/access_response_filename_" + id + ".json", "w")
file_access_response_filename.write(json.dumps(access_response_filename))
file_access_response_filename.close()
