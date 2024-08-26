import json

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--catalogue_sub_filename', action='store', type=str, required=True, dest='catalogue_sub_filename')


args = arg_parser.parse_args()
print(args)

id = args.id

catalogue_sub_filename = args.catalogue_sub_filename.replace('"','')



with open(catalogue_sub_filename) as f:
    catalogue_sub = json.load(f)

print(catalogue_sub)

