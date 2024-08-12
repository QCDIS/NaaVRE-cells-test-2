
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

file_year = open("/tmp/year_" + id + ".json", "w")
file_year.write(json.dumps(year))
file_year.close()
file_start_date = open("/tmp/start_date_" + id + ".json", "w")
file_start_date.write(json.dumps(start_date))
file_start_date.close()
file_end_date = open("/tmp/end_date_" + id + ".json", "w")
file_end_date.write(json.dumps(end_date))
file_end_date.close()
file_data_collection = open("/tmp/data_collection_" + id + ".json", "w")
file_data_collection.write(json.dumps(data_collection))
file_data_collection.close()
file_product_type = open("/tmp/product_type_" + id + ".json", "w")
file_product_type.write(json.dumps(product_type))
file_product_type.close()
file_aoi = open("/tmp/aoi_" + id + ".json", "w")
file_aoi.write(json.dumps(aoi))
file_aoi.close()
