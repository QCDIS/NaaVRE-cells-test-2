
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--names', action='store', type=str, required=True, dest='names')


args = arg_parser.parse_args()
print(args)

id = args.id

names = json.loads(args.names)





output_names = []
for name in names:
    a = print(f"Hello, {name}!")    
    output_names.append(a)

file_output_names = open("/tmp/output_names_" + id + ".json", "w")
file_output_names.write(json.dumps(output_names))
file_output_names.close()
