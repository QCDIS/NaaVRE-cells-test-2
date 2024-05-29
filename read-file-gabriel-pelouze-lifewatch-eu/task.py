
import argparse
import json
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--filename', action='store', type=str, required=True, dest='filename')


args = arg_parser.parse_args()
print(args)

id = args.id

filename = args.filename.replace('"','')



with open(filename, 'r') as f:
    data = f.read()

