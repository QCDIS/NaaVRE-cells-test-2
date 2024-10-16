
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()

secret_a = os.getenv('secret_a')

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--c', action='store', type=int, required=True, dest='c')

arg_parser.add_argument('--param_a', action='store', type=int, required=True, dest='param_a')

args = arg_parser.parse_args()
print(args)

id = args.id

c = args.c

param_a = args.param_a

conf_a = 3


conf_a = 3
print(c)
print(param_a, secret_a, conf_a)

