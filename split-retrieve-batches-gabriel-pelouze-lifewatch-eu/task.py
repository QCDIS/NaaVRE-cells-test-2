from itertools import chain

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--processed_batches', action='store', type=str, required=True, dest='processed_batches')


args = arg_parser.parse_args()
print(args)

id = args.id

processed_batches = json.loads(args.processed_batches)



print(f'Processed batches: {processed_batches}')

processed_items = list(chain(*processed_batches))
print(f'Processed items: {processed_items}')

