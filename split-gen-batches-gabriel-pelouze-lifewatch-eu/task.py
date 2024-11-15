
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--param_item_count', action='store', type=int, required=True, dest='param_item_count')
arg_parser.add_argument('--param_max_batch_count', action='store', type=int, required=True, dest='param_max_batch_count')

args = arg_parser.parse_args()
print(args)

id = args.id


param_item_count = args.param_item_count
param_max_batch_count = args.param_max_batch_count



items = list(range(param_item_count))
print(f'Generated items: {items}')

def batch_items(items, max_batch_count) -> list:
    if len(items) == 0:
        return [[]]
    batch_size = len(items) // max_batch_count + bool(len(items) % max_batch_count)
    return [items[i:i+batch_size] for i in range(0, len(items), batch_size)]
batches = batch_items(items, param_max_batch_count)
print(f'Item batches: {batches}')

file_items = open("/tmp/items_" + id + ".json", "w")
file_items.write(json.dumps(items))
file_items.close()
file_batches = open("/tmp/batches_" + id + ".json", "w")
file_batches.write(json.dumps(batches))
file_batches.close()
