
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id






RWSstations = [{"Code": "DANTZGT", "X": 681288.275516119, "Y": 5920359.91317053},
               {"Code": "DOOVBWT", "X": 636211.321319897, "Y": 5880086.51911216},
               {"Code": "MARSDND", "X": 617481.059435953, "Y": 5871760.70559602},
               {"Code": "VLIESM", "X": 643890.614308217, "Y": 5909304.23136001}]

station_names = ["DANTZGT", "DOOVBWT", "MARSDND", "VLIESM"]
station_names[1]

file_RWSstations = open("/tmp/RWSstations_" + id + ".json", "w")
file_RWSstations.write(json.dumps(RWSstations))
file_RWSstations.close()
