
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id







names = ["Alice","Bob"]

file_name = open("/tmp/name_" + id + ".json", "w")
file_name.write(json.dumps(name))
file_name.close()
