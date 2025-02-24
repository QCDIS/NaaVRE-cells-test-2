from matplotlib_scalebar.scalebar import ScaleBar
import matplotlib.pyplot as plt
import rioxarray

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--anomaly_url', action='store', type=str, required=True, dest='anomaly_url')

arg_parser.add_argument('--param_climate_model', action='store', type=str, required=True, dest='param_climate_model')
arg_parser.add_argument('--param_climate_scenario', action='store', type=str, required=True, dest='param_climate_scenario')
arg_parser.add_argument('--param_species_name', action='store', type=str, required=True, dest='param_species_name')
arg_parser.add_argument('--param_time_period', action='store', type=str, required=True, dest='param_time_period')

args = arg_parser.parse_args()
print(args)

id = args.id

anomaly_url = args.anomaly_url.replace('"','')

param_climate_model = args.param_climate_model.replace('"','')
param_climate_scenario = args.param_climate_scenario.replace('"','')
param_species_name = args.param_species_name.replace('"','')
param_time_period = args.param_time_period.replace('"','')

conf_x = 0.95

conf_y = 0.95

conf_arrow_length = 0.1

conf_data_path = '/tmp/data/'


conf_x = 0.95
conf_y = 0.95
conf_arrow_length = 0.1
conf_data_path = '/tmp/data/'
if "nan" not in anomaly_url:
    data_anomaly = rioxarray.open_rasterio(anomaly_url)
    fig, ax = plt.subplots(figsize=(10, 8))
    data_anomaly.plot(ax=ax, cmap="Spectral")
    image_name = f"Anomaly of {param_species_name} distribution for {param_climate_model} {param_climate_scenario} {param_time_period}"
    plt.title(image_name)

    ax.grid(True, linestyle='--', linewidth=0.5)

    scalebar = ScaleBar(1, location='upper right')  # 1 pixel = 1 unit
    ax.add_artist(scalebar)

    ax.annotate('N', xy=(conf_x, conf_y), xytext=(conf_x, conf_y-conf_arrow_length),
                arrowprops=dict(facecolor='black', width=5, headwidth=15),
                ha='center', va='center', fontsize=12,
                xycoords=ax.transAxes)

    plt.savefig(conf_data_path+image_name)
    plt.close()
else:
    print("Anomaly map does not exist for the current selection")

