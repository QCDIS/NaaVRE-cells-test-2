
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()

secret_b = os.getenv('secret_b')

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--param_a', action='store', type=int, required=True, dest='param_a')

args = arg_parser.parse_args()
print(args)

id = args.id


param_a = args.param_a


print(param_a)
print(secret_b)

