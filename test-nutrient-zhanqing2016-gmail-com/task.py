
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id





P_load = list[1,2,3]

file_P_load = open("/tmp/P_load_" + id + ".json", "w")
file_P_load.write(json.dumps(P_load))
file_P_load.close()
