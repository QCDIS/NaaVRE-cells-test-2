
import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id




names = ["bob", "alice", 123, 100.33]

import json
filename = "/tmp/names_" + id + ".json"
file_names = open(filename, "w")
file_names.write(json.dumps(names))
file_names.close()
