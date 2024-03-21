
import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--names', action='store', type=str, required=True, dest='names')

arg_parser.add_argument('--param_greeting', action='store', type=str, required=True, dest='param_greeting')

args = arg_parser.parse_args()
print(args)

id = args.id

import json
names = json.loads(args.names)

param_greeting = args.param_greeting


for name in names:
    print(f'{param_greeting}, {name}')

