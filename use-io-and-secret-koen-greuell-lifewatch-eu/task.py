
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()

secret_a = os.getenv('secret_a')
secret_jupyterhub_user = os.getenv('secret_jupyterhub_user')
secret_key_knmi_api = os.getenv('secret_key_knmi_api')

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--var_io', action='store', type=str, required=True, dest='var_io')


args = arg_parser.parse_args()
print(args)

id = args.id

var_io = args.var_io.replace('"','')



print(secret_jupyterhub_user)
print(var_io)
print(secret_key_knmi_api)
print(secret_a)

