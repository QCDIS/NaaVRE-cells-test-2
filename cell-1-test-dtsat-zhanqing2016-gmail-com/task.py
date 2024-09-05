
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id







year = 2015
start_date = f"{year}-01-01"
end_date   = f"{year}-12-31"
data_collection = "SENTINEL-2"
product_type = "S2MSI1C"
aoi = "POLYGON((4.6 53.1, 4.9 53.1, 4.9 52.8, 4.6 52.8, 4.6 53.1))'"
collection = "sentinel"

LS = "HaHa"

file_LS = open("/tmp/LS_" + id + ".json", "w")
file_LS.write(json.dumps(LS))
file_LS.close()
