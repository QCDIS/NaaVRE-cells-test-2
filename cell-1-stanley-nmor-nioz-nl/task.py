from dtSat import dtSat
import json

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()

secret_copernicus_api = os.getenv('secret_copernicus_api')

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--param_copernicus_api', action='store', type=str, required=True, dest='param_copernicus_api')

args = arg_parser.parse_args()
print(args)

id = args.id


param_copernicus_api = args.param_copernicus_api.replace('"','')



year = 2015
start_date = f"{year}-01-01"
end_date   = f"{year}-12-31"
data_collection = "SENTINEL-2"
product_type = "S2MSI1C"
aoi = "POLYGON((4.6 53.1, 4.9 53.1, 4.9 52.8, 4.6 52.8, 4.6 53.1))'"

catalogue_response = dtSat.get_sentinel_catalogue(start_date, end_date, data_collection = data_collection, aoi= aoi, product_type=product_type, cloudcover=10.0, max_results=1000)
catalogue_sub = dtSat.filter_by_orbit_and_tile(catalogue_response, orbit = "R051", tile = "T31UFU", name_only = False)

catalogue_sub_filename = "/tmp/data/catalogue_sub.json"
with open(catalogue_sub_filename, 'w') as f:
    json.dump(catalogue_sub, f)
    
access_response = dtSat.get_copernicus_access_token(username = param_copernicus_api, 
                                                    password = secret_copernicus_api)

access_response_filename = "/tmp/data/access_response.json"
with open(access_response_filename, 'w') as f:
    json.dump(access_response, f)

file_year = open("/tmp/year_" + id + ".json", "w")
file_year.write(json.dumps(year))
file_year.close()
file_catalogue_sub_filename = open("/tmp/catalogue_sub_filename_" + id + ".json", "w")
file_catalogue_sub_filename.write(json.dumps(catalogue_sub_filename))
file_catalogue_sub_filename.close()
file_access_response_filename = open("/tmp/access_response_filename_" + id + ".json", "w")
file_access_response_filename.write(json.dumps(access_response_filename))
file_access_response_filename.close()
