
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id




SFUrLfYV = 1

file_SFUrLfYV = open("/tmp/SFUrLfYV_" + id + ".json", "w")
file_SFUrLfYV.write(json.dumps(SFUrLfYV))
file_SFUrLfYV.close()
