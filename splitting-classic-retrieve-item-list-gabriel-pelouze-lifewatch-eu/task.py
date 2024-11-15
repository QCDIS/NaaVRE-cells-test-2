
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--processed_items', action='store', type=str, required=True, dest='processed_items')


args = arg_parser.parse_args()
print(args)

id = args.id

processed_items = json.loads(args.processed_items)



print(f'Processed items: {processed_items}')

