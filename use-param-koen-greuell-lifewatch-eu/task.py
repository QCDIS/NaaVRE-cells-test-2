
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--param_jupyterhub_user', action='store', type=str, required=True, dest='param_jupyterhub_user')

args = arg_parser.parse_args()
print(args)

id = args.id


param_jupyterhub_user = args.param_jupyterhub_user.replace('"','')


print(param_jupyterhub_user)

