
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id




RWSstations = ["DANTZGT","DOOVBWT","MARSDND","VLIESM"]

file_RWSstations = open("/tmp/RWSstations_" + id + ".json", "w")
file_RWSstations.write(json.dumps(RWSstations))
file_RWSstations.close()
