
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--knmi_pvol_paths', action='store', type=str, required=True, dest='knmi_pvol_paths')


args = arg_parser.parse_args()
print(args)

id = args.id

knmi_pvol_paths = json.loads(args.knmi_pvol_paths)



print(knmi_pvol_paths)

