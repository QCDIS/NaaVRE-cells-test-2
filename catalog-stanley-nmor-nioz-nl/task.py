import dtSat

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
aoi = "POLYGON((5.938 53.186, 7.504 53.199, 7.504 53.710, 5.938 53.716, 5.938 53.186))'" ## ems dollards

catalogue_response = dtSat.get_sentinel_catalogue(start_date, end_date, data_collection = data_collection, aoi= aoi, product_type=product_type, cloudcover=10.0, max_results=1000)


catalogue_sub = dtSat.filter_by_orbit_and_tile(catalogue_response, orbit = "R008", tile = "T32ULE", name_only = False)
[catalogue_sub['value'][i]['Name'] for i in range(len(catalogue_sub["value"]))]
print(len(catalogue_sub['value']))

file_year = open("/tmp/year_" + id + ".json", "w")
file_year.write(json.dumps(year))
file_year.close()
file_catalogue_sub = open("/tmp/catalogue_sub_" + id + ".json", "w")
file_catalogue_sub.write(json.dumps(catalogue_sub))
file_catalogue_sub.close()
