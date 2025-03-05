from pyproj import Transformer
import numpy as np
import rioxarray

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id







conf_current_mean = "http://opendap.biodt.eu/ias-pdt/0/outputs/hab3/predictions/Current/Sp_0171_mean.tif"
tif_data = rioxarray.open_rasterio(conf_current_mean)

print(tif_data)

print(tif_data.rio.crs)
tif_data = tif_data.rio.reproject("EPSG:4326")
print(tif_data.rio.crs)


param_minx = 15.721436
param_maxx = 18.803101
param_miny = 39.537940
param_maxy = 40.884448

subset = tif_data.rio.clip_box(minx=param_minx, miny=param_miny, maxx=param_maxx, maxy=param_maxy)

subset.plot()



valid_coords = np.column_stack(np.where(~np.isnan(subset.values[0])))

valid_x = subset.x.values[valid_coords[:, 1]]
valid_y = subset.y.values[valid_coords[:, 0]]

num_points = 40  # Number of random points to generate
random_indices = np.random.choice(len(valid_coords), num_points, replace=False)

random_points = np.column_stack((valid_x[random_indices], valid_y[random_indices]))


transformer = Transformer.from_crs(subset.rio.crs, "EPSG:4326", always_xy=True)

random_points_4326 = np.array([transformer.transform(x, y) for x, y in random_points])

print(type(random_points))
random_points_csv_path = '/tmp/data/random_points.csv'
np.savetxt(random_points_csv_path, random_points, delimiter=",")

file_random_points_csv_path = open("/tmp/random_points_csv_path_" + id + ".json", "w")
file_random_points_csv_path.write(json.dumps(random_points_csv_path))
file_random_points_csv_path.close()
