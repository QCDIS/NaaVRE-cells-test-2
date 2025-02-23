from matplotlib_scalebar.scalebar import ScaleBar
import matplotlib.pyplot as plt
import rioxarray

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--arrow_length', action='store', type=float, required=True, dest='arrow_length')

arg_parser.add_argument('--clim_mod', action='store', type=str, required=True, dest='clim_mod')

arg_parser.add_argument('--clim_sce', action='store', type=str, required=True, dest='clim_sce')

arg_parser.add_argument('--cov_url', action='store', type=str, required=True, dest='cov_url')

arg_parser.add_argument('--species', action='store', type=str, required=True, dest='species')

arg_parser.add_argument('--time_per', action='store', type=str, required=True, dest='time_per')

arg_parser.add_argument('--x', action='store', type=float, required=True, dest='x')

arg_parser.add_argument('--y', action='store', type=float, required=True, dest='y')


args = arg_parser.parse_args()
print(args)

id = args.id

arrow_length = args.arrow_length
clim_mod = args.clim_mod.replace('"','')
clim_sce = args.clim_sce.replace('"','')
cov_url = args.cov_url.replace('"','')
species = args.species.replace('"','')
time_per = args.time_per.replace('"','')
x = args.x
y = args.y


conf_data_path = '/tmp/data/'


conf_data_path = '/tmp/data/'
fig, ax = plt.subplots(figsize=(10, 8))
data_cov = rioxarray.open_rasterio(cov_url)
data_cov.plot(ax=ax, cmap="Spectral")
image_name = f"Coefficient of Variation of {species} distribution for {clim_mod} {clim_sce} {time_per}"
plt.title(image_name)

ax.grid(True, linestyle='--', linewidth=0.5)

scalebar = ScaleBar(1, location='upper right')  # 1 pixel = 1 unit
ax.add_artist(scalebar)

ax.annotate('N', xy=(x, y), xytext=(x, y-arrow_length),
            arrowprops=dict(facecolor='black', width=5, headwidth=15),
            ha='center', va='center', fontsize=12,
            xycoords=ax.transAxes)

plt.savefig(conf_data_path+image_name)
plt.close()

