import os

import argparse
import json
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id





custom_path = '/tmp/my/python/modules/'

os.makedirs(custom_path, exist_ok=True)

with open(os.path.join(custom_path, 'something_custom.py'), 'w') as f:
    f.write('print("hello, world!")\n')

file_custom_path = open("/tmp/custom_path_" + id + ".json", "w")
file_custom_path.write(json.dumps(custom_path))
file_custom_path.close()
