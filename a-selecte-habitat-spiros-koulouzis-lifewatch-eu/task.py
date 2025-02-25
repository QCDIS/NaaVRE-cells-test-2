import pandas as pd

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id




url = "http://opendap.biodt.eu/ias-pdt/0/outputs/key.csv"
df_hab = pd.read_csv(url)

print("Select a habitat type from the dropdown list:")


selected_hab_abb = '1'
param_habitat_type = 'human_maintained_grasslands'
conf_data_path = '/tmp/data/'
selected_hab_abb = str(df_hab[df_hab["hab_name"] == param_habitat_type]["hab_abb"].values[0])

print(f"Selected Habitat Abbreviation: {selected_hab_abb}")


param_habitat_name =  'Human maintained grasslands'
param_climate_model = 'Current'
param_climate_scenario = 'Current'
param_time_period = '1981-2010'
param_species_name = 'Agave americana' 


conf_x =  0.95
conf_y =  0.95
conf_arrow_length = 0.1

file_selected_hab_abb = open("/tmp/selected_hab_abb_" + id + ".json", "w")
file_selected_hab_abb.write(json.dumps(selected_hab_abb))
file_selected_hab_abb.close()
