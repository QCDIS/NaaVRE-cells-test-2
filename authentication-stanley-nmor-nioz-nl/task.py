import dtSat

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


access_response = dtSat.get_copernicus_access_token(username=param_copernicus_api, 
                                                 password=secret_copernicus_api)

file_access_response = open("/tmp/access_response_" + id + ".json", "w")
file_access_response.write(json.dumps(access_response))
file_access_response.close()
