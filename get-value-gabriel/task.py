
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()

secret_a = os.getenv('secret_a')

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--a', action='store', type=str, required=True, dest='a')

arg_parser.add_argument('--param_a', action='store', type=str, required=True, dest='param_a')

args = arg_parser.parse_args()
print(args)

id = args.id

a = json.loads(args.a)

param_a = args.param_a.replace('"','')


for val in a:
    print(val, param_a, secret_a)

