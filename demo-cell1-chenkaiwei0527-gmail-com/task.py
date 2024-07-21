
import argparse
import json
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--param_name', action='store', type=str, required=True, dest='param_name')

args = arg_parser.parse_args()
print(args)

id = args.id


param_name = args.param_name.replace('"','')


l1 = ["Python", "R", param_name, "code"]

file_l1 = open("/tmp/l1_" + id + ".json", "w")
file_l1.write(json.dumps(l1))
file_l1.close()
