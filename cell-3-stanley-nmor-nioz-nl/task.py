
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--catalogue_sub', action='store', type=str, required=True, dest='catalogue_sub')


args = arg_parser.parse_args()
print(args)

id = args.id

catalogue_sub = json.loads(args.catalogue_sub)



print(len(catalogue_sub))

