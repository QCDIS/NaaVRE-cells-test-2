import something_custom
import sys

import argparse
import json
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--custom_path', action='store', type=str, required=True, dest='custom_path')


args = arg_parser.parse_args()
print(args)

id = args.id

custom_path = args.custom_path.replace('"','')



sys.path.append(custom_path)

something_custom.hello()

