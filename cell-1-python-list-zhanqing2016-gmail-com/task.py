
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id







station_names = ["DANTZGT", "DOOVBWT", "MARSDND", "VLIESM"]
station_names[1]

file_station_names = open("/tmp/station_names_" + id + ".json", "w")
file_station_names.write(json.dumps(station_names))
file_station_names.close()
