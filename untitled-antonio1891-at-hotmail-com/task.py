
import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--ls', action='store', type=str, required=True, dest='ls')


args = arg_parser.parse_args()
print(args)

id = args.id

import json
ls = json.loads(args.ls)



for l in ls:
    print(l)

