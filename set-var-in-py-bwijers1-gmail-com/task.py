
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id




int_val = 1

file_int_val = open("/tmp/int_val_" + id + ".json", "w")
file_int_val.write(json.dumps(int_val))
file_int_val.close()
