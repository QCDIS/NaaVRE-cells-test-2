
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--random_string', action='store', type=str, required=True, dest='random_string')


args = arg_parser.parse_args()
print(args)

id = args.id

random_string = args.random_string.replace('"','')



print(random_string)

