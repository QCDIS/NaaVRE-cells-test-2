
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--output_names', action='store', type=str, required=True, dest='output_names')


args = arg_parser.parse_args()
print(args)

id = args.id

output_names = json.loads(args.output_names)




print(output_names)

