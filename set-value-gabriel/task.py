
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id




b = 1

file_b = open("/tmp/b_" + id + ".json", "w")
file_b.write(json.dumps(b))
file_b.close()
