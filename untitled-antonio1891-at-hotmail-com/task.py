
import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--data', action='store', type=str, required=True, dest='data')


args = arg_parser.parse_args()
print(args)

id = args.id

import json
data = json.loads(args.data)



for d in data:
    print(d)

