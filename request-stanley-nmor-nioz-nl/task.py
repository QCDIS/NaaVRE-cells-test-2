import dtSat

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--access_response', action='store', type=str, required=True, dest='access_response')

arg_parser.add_argument('--catalogue_sub', action='store', type=str, required=True, dest='catalogue_sub')

arg_parser.add_argument('--year', action='store', type=int, required=True, dest='year')


args = arg_parser.parse_args()
print(args)

id = args.id

access_response = json.loads(args.access_response)
catalogue_sub = json.loads(args.catalogue_sub)
year = args.year




dtSat.data_sentinel_request(access_response, 
                            catalogue_sub,  
                            dir_path = f"./inputdir/sentinel/{year}")

