
import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id





name = "me"

import json
filename = "/tmp/name_" + id + ".json"
file_name = open(filename, "w")
file_name.write(json.dumps(name))
file_name.close()
