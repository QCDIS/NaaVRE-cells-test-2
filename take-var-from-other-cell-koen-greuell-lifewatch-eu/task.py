
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--variable_to_exchange', action='store', type=str, required=True, dest='variable_to_exchange')

arg_parser.add_argument('--param_some_text', action='store', type=str, required=True, dest='param_some_text')

args = arg_parser.parse_args()
print(args)

id = args.id

variable_to_exchange = args.variable_to_exchange.replace('"','')

param_some_text = args.param_some_text.replace('"','')


print(variable_to_exchange)
print(param_some_text)

