
import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--names', action='store', type=str, required=True, dest='names')

arg_parser.add_argument('--param_greeting_name', action='store', type=str, required=True, dest='param_greeting_name')

args = arg_parser.parse_args()
print(args)

id = args.id

import json
names = json.loads(args.names)

param_greeting_name = args.param_greeting_name


for name in names:
    print(f"{param_greeting_name}, {name}!")

