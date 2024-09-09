
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()

secret_api_key = os.getenv('secret_api_key')

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--param_username', action='store', type=str, required=True, dest='param_username')

args = arg_parser.parse_args()
print(args)

id = args.id


param_username = args.param_username.replace('"','')


print(param_username, secret_api_key)

