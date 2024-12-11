import time

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--batches', action='store', type=str, required=True, dest='batches')

arg_parser.add_argument('--param_sleep_seconds', action='store', type=int, required=True, dest='param_sleep_seconds')

args = arg_parser.parse_args()
print(args)

id = args.id

batches = json.loads(args.batches)

param_sleep_seconds = args.param_sleep_seconds



def process_item(item):
    print(f'Processing item {item}')
    time.sleep(param_sleep_seconds)
    return item / 42

print(f'Batches to process: {batches}')
processed_batches = []
for batch in batches:
    processed_batch = []
    for item in batch:
        processed_batch.append(process_item(item))
    processed_batches.append(processed_batch)
print(f'Processed batches: {processed_batches}')

file_processed_batches = open("/tmp/processed_batches_" + id + ".json", "w")
file_processed_batches.write(json.dumps(processed_batches))
file_processed_batches.close()
