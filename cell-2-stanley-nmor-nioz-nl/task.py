
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--dictionary', action='store', type=str, required=True, dest='dictionary')


args = arg_parser.parse_args()
print(args)

id = args.id

dictionary = json.loads(args.dictionary)



for key, val in dictionary.items():
    print(val)

