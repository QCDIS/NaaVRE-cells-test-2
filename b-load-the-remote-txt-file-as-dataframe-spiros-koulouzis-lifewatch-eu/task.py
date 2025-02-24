import pandas as pd

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--selected_hab_abb', action='store', type=str, required=True, dest='selected_hab_abb')


args = arg_parser.parse_args()
print(args)

id = args.id

selected_hab_abb = args.selected_hab_abb.replace('"','')



url_txt = f"http://opendap.biodt.eu/ias-pdt/0/outputs/hab{selected_hab_abb}/predictions/Prediction_Summary_Shiny.txt"
df_mod = pd.read_csv(url_txt, sep="\t")








param_habitat_name =  'Human maintained grasslands'
param_climate_model = 'Current'
param_climate_scenario = 'Current'
param_time_period = '1981-2010'
param_species_name = 'Agave americana' 


conf_x =  0.95
conf_y =  0.95
conf_arrow_length = 0.1

