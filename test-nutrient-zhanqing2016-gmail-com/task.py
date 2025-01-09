
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id





P_loads = [1,2,3]

file_P_loads = open("/tmp/P_loads_" + id + ".json", "w")
file_P_loads.write(json.dumps(P_loads))
file_P_loads.close()
