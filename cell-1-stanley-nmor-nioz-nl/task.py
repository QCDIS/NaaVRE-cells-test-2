from dtSat import dtSat
import json

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id





year = 2016
start_date = f"{year}-01-01"
end_date   = f"{year}-12-31"
data_collection = "SENTINEL-2"
product_type = "S2MSI1C"
aoi = "POLYGON((5.938 53.186, 7.504 53.199, 7.504 53.710, 5.938 53.716, 5.938 53.186))'" ## ems dollards

catalogue_response = dtSat.get_sentinel_catalogue(start_date, end_date, data_collection = data_collection, aoi= aoi, product_type=product_type, cloudcover=10.0, max_results=1000)

catalogue_sub_json = json.dumps(catalogue_response)

file_catalogue_sub_json = open("/tmp/catalogue_sub_json_" + id + ".json", "w")
file_catalogue_sub_json.write(json.dumps(catalogue_sub_json))
file_catalogue_sub_json.close()
