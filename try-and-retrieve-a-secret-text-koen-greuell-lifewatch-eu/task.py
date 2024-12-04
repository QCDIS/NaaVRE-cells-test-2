
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--conf_fixed_text', action='store', type=str, required=True, dest='conf_fixed_text')

arg_parser.add_argument('--param_n_prints', action='store', type=int, required=True, dest='param_n_prints')

arg_parser.add_argument('--secret_text', action='store', type=str, required=True, dest='secret_text')


args = arg_parser.parse_args()
print(args)

id = args.id

conf_fixed_text = args.conf_fixed_text.replace('"','')
param_n_prints = args.param_n_prints
secret_text = args.secret_text.replace('"','')



for i in list(range(param_n_prints)):
    print(secret_text)
print(conf_fixed_text)

