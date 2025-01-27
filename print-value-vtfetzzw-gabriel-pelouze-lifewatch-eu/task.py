
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()

secret_EtnWavZq = os.getenv('secret_EtnWavZq')

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--vtFeTZZw', action='store', type=int, required=True, dest='vtFeTZZw')

arg_parser.add_argument('--param_ZvoeKsPQ', action='store', type=str, required=True, dest='param_ZvoeKsPQ')

args = arg_parser.parse_args()
print(args)

id = args.id

vtFeTZZw = args.vtFeTZZw

param_ZvoeKsPQ = args.param_ZvoeKsPQ.replace('"','')


print(vtFeTZZw, param_ZvoeKsPQ, secret_EtnWavZq)

