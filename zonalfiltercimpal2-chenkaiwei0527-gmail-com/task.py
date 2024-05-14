from pathlib import Path
from osgeo import gdal
import glob
import os
import subprocess

import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--out_path', action='store', type=str, required=True, dest='out_path')

arg_parser.add_argument('--zones_file', action='store', type=str, required=True, dest='zones_file')

arg_parser.add_argument('--param_zone_field_para', action='store', type=str, required=True, dest='param_zone_field_para')

args = arg_parser.parse_args()
print(args)

id = args.id

out_path = args.out_path.replace('"','')
zones_file = args.zones_file.replace('"','')

param_zone_field_para = args.param_zone_field_para

conf_data_dir = '/tmp/data'


conf_data_dir = '/tmp/data'

gris_srs_to_Wkt_path = out_path + "/grid_srs_toWkt.txt"
maps_path = out_path

shps_path = zones_file


def create_directory_if_not_exists(path):
    if not os.path.exists(path):
        try:
            os.makedirs(path)
            print("Directory created successfully at:", path)
        except OSError as e:
            print("Error creating directory:", e)
    else:
        print("Directory already exists at:", path)




out_path2 = create_directory_if_not_exists(f"{conf_data_dir}/output/Zonal_out")

species_para = True





    


os.environ['PROJ_LIB'] = '/usr/local/otb/share/proj/'



shp_dir = shps_path
shp_files = os.listdir(shp_dir)

maps_dir = maps_path

grid_srs_to_Wkt = gris_srs_to_Wkt_path

if Path(grid_srs_to_Wkt).exists():
    with open(grid_srs_to_Wkt, "r") as f:
        grid_srs_to_Wkt = f.read()

out = out_path2

shp_file = None

for file in shp_files:
    if file.endswith(".shp"):
        shp_file = os.path.join(shp_dir, file)
        break

shp_zone = shp_file

zone_field = param_zone_field_para
zonal = Path("/usr/local/lw_apps/lwZonalStatistics")

raster_z = shp_zone[:-4] + ".tif"

tif_files = glob.glob(os.path.join(maps_dir, "*.tif"))

hDataset = gdal.Open(tif_files[0], gdal.GA_ReadOnly)
adfGeoTransform = hDataset.GetGeoTransform(can_return_null=True)

if adfGeoTransform is not None:
    dfGeoXUL = adfGeoTransform[0]
    dfGeoYUL = adfGeoTransform[3]
    dfGeoXLR = (
        adfGeoTransform[0] + adfGeoTransform[1] * hDataset.RasterXSize + adfGeoTransform[2] * hDataset.RasterYSize
    )
    dfGeoYLR = (
        adfGeoTransform[3] + adfGeoTransform[4] * hDataset.RasterXSize + adfGeoTransform[5] * hDataset.RasterYSize
    )
    xres = str(abs(adfGeoTransform[1]))
    yres = str(abs(adfGeoTransform[5]))

outshp = shp_zone[:-4] + "_gridSRS.shp"

subprocess.call(["ogr2ogr", "-progress", "-t_srs", grid_srs_to_Wkt, outshp, shp_zone])
subprocess.call(
    [
        "gdal_rasterize",
        "-a",
        zone_field,
        "-ot",
        "uint16",
        "-co",
        "BIGTIFF=YES",
        "-co",
        "TILED=YES",
        "-co",
        "COMPRESS=DEFLATE",
        "-te",
        str(dfGeoXUL),
        str(dfGeoYLR),
        str(dfGeoXLR),
        str(dfGeoYUL),
        "-tr",
        str(xres),
        str(yres),
        outshp,
        raster_z,
    ]
)

if not species_para:
    tif_files =[f for f in tif_files if 'cimpal_' in f]

for file in tif_files:
    is_cimpal = True
    print(f"Running for: {file}")
    
    tabular_out = Path(
        out, os.path.split(file)[1][:-4] + "_stat.csv",
    )
    
    print(f"{str(tabular_out)}")

    subprocess.call([str(zonal), raster_z, file, tabular_out])

import json
filename = "/tmp/out_path2_" + id + ".json"
file_out_path2 = open(filename, "w")
file_out_path2.write(json.dumps(out_path2))
file_out_path2.close()
