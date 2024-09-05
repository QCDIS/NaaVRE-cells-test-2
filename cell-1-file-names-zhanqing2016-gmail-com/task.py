
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id





files = ["20230915_019", "20231022_001", "20231022_002"]
files

file_files = open("/tmp/files_" + id + ".json", "w")
file_files.write(json.dumps(files))
file_files.close()
