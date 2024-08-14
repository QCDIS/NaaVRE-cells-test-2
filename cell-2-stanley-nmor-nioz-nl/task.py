
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--path_sys', action='store', type=str, required=True, dest='path_sys')


args = arg_parser.parse_args()
print(args)

id = args.id

path_sys = json.loads(args.path_sys)



more_path = [path_sys, "/app/more"]

file_more_path = open("/tmp/more_path_" + id + ".json", "w")
file_more_path.write(json.dumps(more_path))
file_more_path.close()
