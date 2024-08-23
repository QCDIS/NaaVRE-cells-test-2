
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--station_names', action='store', type=str, required=True, dest='station_names')


args = arg_parser.parse_args()
print(args)

id = args.id

station_names = json.loads(args.station_names)






RWSstations = [
    {"Code": "DANTZGT", "X": 681288.275516119, "Y": 5920359.91317053},
    {"Code": "DOOVBWT", "X": 636211.321319897, "Y": 5880086.51911216},
    {"Code": "MARSDND", "X": 617481.059435953, "Y": 5871760.70559602},
    {"Code": "VLIESM", "X": 643890.614308217, "Y": 5909304.23136001}
]

selected_location = [station for station in RWSstations if station["Code"] == station_names]

print(selected_location)

file_selected_location = open("/tmp/selected_location_" + id + ".json", "w")
file_selected_location.write(json.dumps(selected_location))
file_selected_location.close()
