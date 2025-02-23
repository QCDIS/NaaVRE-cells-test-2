from matplotlib_scalebar.scalebar import ScaleBar
import matplotlib.pyplot as plt
import rioxarray

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--clim_mod', action='store', type=str, required=True, dest='clim_mod')

arg_parser.add_argument('--clim_sce', action='store', type=str, required=True, dest='clim_sce')

arg_parser.add_argument('--mean_url', action='store', type=str, required=True, dest='mean_url')

arg_parser.add_argument('--species', action='store', type=str, required=True, dest='species')

arg_parser.add_argument('--time_per', action='store', type=str, required=True, dest='time_per')

arg_parser.add_argument('--param_habitat_name', action='store', type=str, required=True, dest='param_habitat_name')

args = arg_parser.parse_args()
print(args)

id = args.id

clim_mod = args.clim_mod.replace('"','')
clim_sce = args.clim_sce.replace('"','')
mean_url = args.mean_url.replace('"','')
species = args.species.replace('"','')
time_per = args.time_per.replace('"','')

param_habitat_name = args.param_habitat_name.replace('"','')

conf_data_path = '/tmp/data/'


conf_data_path = '/tmp/data/'
fig, ax = plt.subplots(figsize=(10, 8))
data_mean = rioxarray.open_rasterio(mean_url)
data_mean.plot(ax=ax, cmap="Spectral")
image_name = f"Mean Species Distribution for {species} in {param_habitat_name} for {time_per} and {clim_mod} {clim_sce}"
plt.title(image_name)

ax.grid(True, linestyle='--', linewidth=0.5)

scalebar = ScaleBar(1, location='upper right')  # 1 pixel = 1 unit
ax.add_artist(scalebar)

x, y, arrow_length = 0.95, 0.95, 0.1
ax.annotate('N', xy=(x, y), xytext=(x, y-arrow_length),
            arrowprops=dict(facecolor='black', width=5, headwidth=15),
            ha='center', va='center', fontsize=12,
            xycoords=ax.transAxes)


plt.savefig(conf_data_path+image_name)
plt.close()





    

file_x = open("/tmp/x_" + id + ".json", "w")
file_x.write(json.dumps(x))
file_x.close()
file_y = open("/tmp/y_" + id + ".json", "w")
file_y.write(json.dumps(y))
file_y.close()
file_arrow_length = open("/tmp/arrow_length_" + id + ".json", "w")
file_arrow_length.write(json.dumps(arrow_length))
file_arrow_length.close()
