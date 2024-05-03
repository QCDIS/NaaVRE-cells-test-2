
import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id




ls = [1, 2, 3, 4, 5]

import json
filename = "/tmp/ls_" + id + ".json"
file_ls = open(filename, "w")
file_ls.write(json.dumps(ls))
file_ls.close()
