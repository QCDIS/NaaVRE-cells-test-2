import ipywidgets as widgets
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

habitat_dropdown = widgets.Dropdown(
    options=df_mod[
        "hab_name"
    ].unique(),  # Replace 'column_name' with the actual column name you want to use
    description="Habitat Type:",
    disabled=False,
    layout=widgets.Layout(margin="0 0 0 0px"),
)

climate_model_dropdown = widgets.Dropdown(
    options=df_mod["climate_model"].unique(),
    description="Climate Model:",
    disabled=False,
    layout=widgets.Layout(margin='0 0 0 0px')
)

climate_model_dropdown.options = list(climate_model_dropdown.options) + ["Ensemble"]


climate_scenario_dropdown = widgets.Dropdown(
    options=df_mod["climate_scenario"].unique(),
    description="Climate Scenario:",
    disabled=False,
    layout=widgets.Layout(margin='0 0 0 0px')
)

time_period_dropdown = widgets.Dropdown(
    options=df_mod["time_period"].unique(),
    description="Time Period:",
    disabled=False,
    layout=widgets.Layout(margin='0 0 0 0px')
)

species_name_dropdown = widgets.Dropdown(
    options=df_mod["species_name"].dropna().unique(),
    description="Species Name:",
    disabled=False,
) 

param_habitat_name = ''
param_habitat_name =  df_mod["hab_name"].unique()[0]
param_climate_model = 'Current'
param_climate_scenario = 'Current'
param_time_period = '1981-2010'
param_species_name = 'Agave americana' 

