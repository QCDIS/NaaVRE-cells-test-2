from dtSat import dtSat
import git
import json

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--aoi', action='store', type=str, required=True, dest='aoi')

arg_parser.add_argument('--data_collection', action='store', type=str, required=True, dest='data_collection')

arg_parser.add_argument('--end_date', action='store', type=str, required=True, dest='end_date')

arg_parser.add_argument('--product_type', action='store', type=str, required=True, dest='product_type')

arg_parser.add_argument('--start_date', action='store', type=str, required=True, dest='start_date')


args = arg_parser.parse_args()
print(args)

id = args.id

aoi = args.aoi.replace('"','')
data_collection = args.data_collection.replace('"','')
end_date = args.end_date.replace('"','')
product_type = args.product_type.replace('"','')
start_date = args.start_date.replace('"','')




print(git)

catalogue_response = dtSat.get_sentinel_catalogue(start_date, end_date, data_collection = data_collection, aoi= aoi, product_type=product_type, cloudcover=10.0, max_results=1000)

catalogue_sub = dtSat.filter_by_orbit_and_tile(catalogue_response, orbit = "R008", tile = "T32ULE", name_only = False)

catalogue_sub_json = json.dumps(catalogue_sub)

file_catalogue_sub_json = open("/tmp/catalogue_sub_json_" + id + ".json", "w")
file_catalogue_sub_json.write(json.dumps(catalogue_sub_json))
file_catalogue_sub_json.close()
