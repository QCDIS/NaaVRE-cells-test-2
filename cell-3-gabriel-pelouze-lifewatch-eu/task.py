import json

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--catalogue_sub_json', action='store', type=str, required=True, dest='catalogue_sub_json')


args = arg_parser.parse_args()
print(args)

id = args.id

catalogue_sub_json = args.catalogue_sub_json.replace('"','')



catalogue_sub = json.loads(catalogue_sub_json)

print(catalogue_sub)

