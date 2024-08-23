
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






RWSstations = [{"Code": "DANTZGT", "X": 681288.275516119, "Y": 5920359.91317053},
               {"Code": "DOOVBWT", "X": 636211.321319897, "Y": 5880086.51911216},
               {"Code": "MARSDND", "X": 617481.059435953, "Y": 5871760.70559602},
               {"Code": "VLIESM", "X": 643890.614308217, "Y": 5909304.23136001}]

station_info = [station for station in RWSstations if station["Code"] == station_names]

station_name = station_info[0]["Code"]
rws_file_path = f"/tmp/data/{station_name}_Chl_2021.csv"

file_rws_file_path = open("/tmp/rws_file_path_" + id + ".json", "w")
file_rws_file_path.write(json.dumps(rws_file_path))
file_rws_file_path.close()
