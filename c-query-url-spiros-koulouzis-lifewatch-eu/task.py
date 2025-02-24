import pandas as pd

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--selected_hab_abb', action='store', type=str, required=True, dest='selected_hab_abb')

arg_parser.add_argument('--param_climate_model', action='store', type=str, required=True, dest='param_climate_model')
arg_parser.add_argument('--param_climate_scenario', action='store', type=str, required=True, dest='param_climate_scenario')
arg_parser.add_argument('--param_habitat_name', action='store', type=str, required=True, dest='param_habitat_name')
arg_parser.add_argument('--param_species_name', action='store', type=str, required=True, dest='param_species_name')
arg_parser.add_argument('--param_time_period', action='store', type=str, required=True, dest='param_time_period')

args = arg_parser.parse_args()
print(args)

id = args.id

selected_hab_abb = args.selected_hab_abb.replace('"','')

param_climate_model = args.param_climate_model.replace('"','')
param_climate_scenario = args.param_climate_scenario.replace('"','')
param_habitat_name = args.param_habitat_name.replace('"','')
param_species_name = args.param_species_name.replace('"','')
param_time_period = args.param_time_period.replace('"','')


url_txt = f"http://opendap.biodt.eu/ias-pdt/0/outputs/hab{selected_hab_abb}/predictions/Prediction_Summary_Shiny.txt"
df_mod = pd.read_csv(url_txt, sep="\t")

hab_num = df_mod[df_mod["hab_name"] == param_habitat_name]["hab_abb"].values[0]
tif_path_mean = df_mod[
    (df_mod["hab_abb"] == hab_num) &
    (df_mod["climate_model"] == param_climate_model) &
    (df_mod["climate_scenario"] == param_climate_scenario) &
    (df_mod["time_period"] == param_time_period) &
    (df_mod["species_name"] == param_species_name)
]["tif_path_mean"].values[0]

tif_path_sd = df_mod[
    (df_mod["hab_abb"] == hab_num)
    & (df_mod["climate_model"] == param_climate_model)
    & (df_mod["climate_scenario"] == param_climate_scenario)
    & (df_mod["time_period"] == param_time_period)
    & (df_mod["species_name"] == param_species_name)
]["tif_path_sd"].values[0]

tif_path_cov = df_mod[
    (df_mod["hab_abb"] == hab_num)
    & (df_mod["climate_model"] == param_climate_model)
    & (df_mod["climate_scenario"] == param_climate_scenario)
    & (df_mod["time_period"] == param_time_period)
    & (df_mod["species_name"] == param_species_name)
]["tif_path_cov"].values[0]

tif_path_anomaly = df_mod[
    (df_mod["hab_abb"] == hab_num)
    & (df_mod["climate_model"] == param_climate_model)
    & (df_mod["climate_scenario"] == param_climate_scenario)
    & (df_mod["time_period"] == param_time_period)
    & (df_mod["species_name"] == param_species_name)
]["tif_path_anomaly"].values[0]

mean_url = f"http://opendap.biodt.eu/ias-pdt/0/outputs/hab{hab_num}/predictions/{tif_path_mean}"
sd_url = f"http://opendap.biodt.eu/ias-pdt/0/outputs/hab{hab_num}/predictions/{tif_path_sd}"
cov_url = f"http://opendap.biodt.eu/ias-pdt/0/outputs/hab{hab_num}/predictions/{tif_path_cov}"
anomaly_url = f"http://opendap.biodt.eu/ias-pdt/0/outputs/hab{hab_num}/predictions/{tif_path_anomaly}"

file_mean_url = open("/tmp/mean_url_" + id + ".json", "w")
file_mean_url.write(json.dumps(mean_url))
file_mean_url.close()
file_sd_url = open("/tmp/sd_url_" + id + ".json", "w")
file_sd_url.write(json.dumps(sd_url))
file_sd_url.close()
file_cov_url = open("/tmp/cov_url_" + id + ".json", "w")
file_cov_url.write(json.dumps(cov_url))
file_cov_url.close()
file_anomaly_url = open("/tmp/anomaly_url_" + id + ".json", "w")
file_anomaly_url.write(json.dumps(anomaly_url))
file_anomaly_url.close()
