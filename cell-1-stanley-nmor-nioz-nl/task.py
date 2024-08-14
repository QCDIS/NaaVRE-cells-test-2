import sys

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id




path_sys = sys.path

file_path_sys = open("/tmp/path_sys_" + id + ".json", "w")
file_path_sys.write(json.dumps(path_sys))
file_path_sys.close()
