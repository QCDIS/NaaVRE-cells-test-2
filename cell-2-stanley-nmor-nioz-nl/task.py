from dtSat import dtSat
import json

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--access_response_filename', action='store', type=str, required=True, dest='access_response_filename')

arg_parser.add_argument('--catalogue_sub_filename', action='store', type=str, required=True, dest='catalogue_sub_filename')

arg_parser.add_argument('--year', action='store', type=int, required=True, dest='year')


args = arg_parser.parse_args()
print(args)

id = args.id

access_response_filename = args.access_response_filename.replace('"','')
catalogue_sub_filename = args.catalogue_sub_filename.replace('"','')
year = args.year




with open(catalogue_sub_filename) as f:
    catalogue_sub = json.load(f)
    
with open(access_response_filename) as f:
    access_response = json.load(f)
    
dtSat.data_sentinel_request(access_response, 
                            catalogue_sub, 
                           dir_path = f"/tmp/data/sentinel/{year}")

