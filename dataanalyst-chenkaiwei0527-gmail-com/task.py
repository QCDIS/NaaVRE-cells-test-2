from pathlib import Path
import csv
import glob
import os
import shutil
import subprocess
import zipfile

import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--classes_cube', action='store', type=str, required=True, dest='classes_cube')

arg_parser.add_argument('--grid_file', action='store', type=str, required=True, dest='grid_file')

arg_parser.add_argument('--taxa_cube', action='store', type=str, required=True, dest='taxa_cube')


args = arg_parser.parse_args()
print(args)

id = args.id

classes_cube = args.classes_cube.replace('"','')
grid_file = args.grid_file.replace('"','')
taxa_cube = args.taxa_cube.replace('"','')


conf_data_dir = '/tmp/data'


conf_data_dir = '/tmp/data'

be_alien_taxa_path = taxa_cube
be_classes_path = classes_cube
temp_file_path = grid_file


def create_directory_if_not_exists(path):
    if not os.path.exists(path):
        try:
            os.makedirs(path)
            print("Directory created successfully at:", path)
        except OSError as e:
            print("Error creating directory:", e)
    else:
        print("Directory already exists at:", path)



create_directory_if_not_exists(f"{conf_data_dir}/output/cubeDA_out")
out_DA_maps = f"{conf_data_dir}/output/cubeDA_out"





local_df_be_alientaxa_path = Path(be_alien_taxa_path)
local_df_be_classes_path = Path(be_classes_path)
local_tif_incidence_path = Path(temp_file_path)

if "zip" in Path(local_tif_incidence_path).suffix:
    work_dir = Path(out_DA, "grid")
    os.mkdir(work_dir)

    shutil.unpack_archive(filename=local_tif_incidence_path,format="zip",extract_dir=work_dir)
    local_tif_incidence_path = glob.glob(os.path.join(work_dir,"*.tif"))[0]

print(f"Using grid tif : {local_tif_incidence_path}")
print(f"Using be classes csv : {local_df_be_classes_path}")
print(f"Using alien taxa csv : {local_df_be_alientaxa_path}")

otbbin = "/usr/local/otb/bin/"
otbLWapps = "/usr/local/lw_apps/"

inRaster = local_tif_incidence_path
inCubeTot = local_df_be_classes_path
inCubeIAS = local_df_be_alientaxa_path

outTot = Path(inRaster[:-4] + "_tot.tif")
outIAS = Path(inRaster[:-4] + "_totias.tif")
outIncidence = Path(inRaster[:-4] + "_incidence.tif")

s = "?&gdal:co:COMPRESS=LZW&gdal:co:TILED=YES&gdal:co:BIGTIFF=YES"

xmin = 40000
ymin = 40000
xmax = -40000
ymax = -40000
i = 0

with open(inCubeTot, "r") as datacube_csv:
    csvreader = csv.reader(datacube_csv, delimiter=";")
    for row in csvreader:
        try:
            if i > 0:
                keyval = int(row[1])
                temp_x = int(keyval / 100000)
                temp_y = keyval % 100000
                if temp_y < ymin:
                    ymin = temp_y
                elif temp_y > ymax:
                    ymax = temp_y
                if temp_x < xmin:
                    xmin = temp_x
                elif temp_x > xmax:
                    xmax = temp_x
            i += 1
        except ValueError:
            pass

print(
    " ".join(
        [
            "gdalbuildvrt",
            "-te",
            str(xmin * 1000),
            str(ymin * 1000),
            str(xmax * 1000 + 1000),
            str(ymax * 1000 + 1000),
            inRaster[:-4] + ".vrt",
            inRaster,
        ]
    )
)

subprocess.call(
    [
        "gdalbuildvrt",
        "-te",
        str(xmin * 1000),
        str(ymin * 1000),
        str(xmax * 1000 + 1000),
        str(ymax * 1000 + 1000),
        inRaster[:-4] + ".vrt",
        inRaster,
    ]
)

subprocess.call([otbLWapps + "lwLookUpAggregate", outTot, inRaster, inCubeTot, "0", "1", "3"])
subprocess.call([otbLWapps + "lwLookUpAggregate", outIAS, inRaster, inCubeIAS, "0", "1", "3"])

subprocess.call(
    [
        otbbin + "otbcli_BandMath",
        "-il",
        outTot,
        outIAS,
        "-out",
        str(outIncidence) + s,
        "-exp",
        "(im1b1<=0)?(-1):(im2b1/im1b1)",
    ],
)

if not outTot.is_file():
    raise FileNotFoundError(f"{outTot} is missing")

if not outIAS.is_file():
    raise FileNotFoundError(f"{outIAS} is missing")

if not outIncidence.is_file():
    raise FileNotFoundError(f"{outIncidence} is missing")

outzip = os.path.join(out_DA, "map_tifs.zip")

with zipfile.ZipFile(outzip, "w") as zipObj:
    zipObj.write(filename=str(outIAS), arcname=outIAS.name)
    zipObj.write(filename=str(outIncidence), arcname=outIncidence.name)
    
subprocess.call(['unzip', outzip, '-d', out_DA])

import json
filename = "/tmp/out_DA_maps_" + id + ".json"
file_out_DA_maps = open(filename, "w")
file_out_DA_maps.write(json.dumps(out_DA_maps))
file_out_DA_maps.close()
