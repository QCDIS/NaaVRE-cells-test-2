from pathlib import Path
from shapely.geometry import Point
import csv
from osgeo import gdal
import glob
from osgeo import ogr
import os
from osgeo import osr
import pandas
from functools import partial
import pyproj
import re
import subprocess
from shapely.ops import transform

import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--occ_taxa', action='store', type=str, required=True, dest='occ_taxa')

arg_parser.add_argument('--pathway_file', action='store', type=str, required=True, dest='pathway_file')

arg_parser.add_argument('--sh_transform', action='store', type=str, required=True, dest='sh_transform')

arg_parser.add_argument('--shp', action='store', type=str, required=True, dest='shp')

arg_parser.add_argument('--sys', action='store', type=str, required=True, dest='sys')

arg_parser.add_argument('--weight_file', action='store', type=str, required=True, dest='weight_file')

arg_parser.add_argument('--param_zone_field_para', action='store', type=str, required=True, dest='param_zone_field_para')

args = arg_parser.parse_args()
print(args)

id = args.id

occ_taxa = args.occ_taxa.replace('"','')
pathway_file = args.pathway_file.replace('"','')
import json
sh_transform = json.loads(args.sh_transform)
shp = args.shp.replace('"','')
import json
sys = json.loads(args.sys)
weight_file = args.weight_file.replace('"','')

param_zone_field_para = args.param_zone_field_para

conf_data_dir = '/tmp/data'


conf_data_dir = '/tmp/data'


occ_and_taxa_path = occ_taxa
biotope_shp_path = shp
weights_path = weight_file
pathways_path = pathway_file

out_path =  os.mkdirs(f"{conf_data_dir}/output/Cimpal")


try:
except:
try:
except:





gbif_dir = Path(occ_and_taxa_path)
shp_dir = biotope_shp_path
shp_files = os.listdir(shp_dir)
impact_matrix = weights_path
grid_size = param_zone_field_para
nis_pathways_matrix_path_dir = pathways_path


otbbin = "/usr/local/otb/bin/"
outpath = out_path

shp_file = None

for file in shp_files:
    if file.endswith(".shp"):
        shp_file = os.path.join(shp_dir, file)
        break

if not shp_file:
    raise FileNotFoundError("`.shp` file not found in zip")


biotopes = str(shp_dir) + '/'
outpath = out_path + '/'
weight_matrix_template = weights_path
filter_matrix_csv = pathways_path
occurences = str(Path(gbif_dir, "occurrence.txt"))
alienTaxa = str(Path(gbif_dir, "alientaxa.txt"))

print("=================================")
print(f"biotopes {biotopes}")
print(f"outpath {outpath}")
print(f"weight_matrix_template {weight_matrix_template}")
print(f"filter_matrix_csv {filter_matrix_csv}")
print(f"occurences {occurences}")
print(f"alienTaxa {alienTaxa}")
print("=================================")



zone_field = 'id_habitat'
field_name_oc = "scientificName"
useEEA = True
LAEA=True
grid_size = int(25)
field_name_radius = "dispersionRadius"
radius_default = 100
field_name = "Habitat"

extent_tot = [
    100000000,
    -100000000,
    100000000,
    -100000000,
]  # initialise extent: xmin, xmax, ymin, ymax

if useEEA:
    shp_candidates = glob.glob(biotopes + "[sS]ingle_*.shp") + glob.glob(
        biotopes + "[Ll]ist_*.shp"
    )
    print(len(shp_candidates))
    for shp in [x for x in shp_candidates if not "LAEA" in x]:
        print("reprojecting " + shp)
        outshp = shp[:-4] + "_LAEA.shp"
        subprocess.call(["ogr2ogr", "-t_srs", "EPSG:3035", outshp, shp])
        driver = ogr.GetDriverByName("ESRI Shapefile")
        dataSource = driver.Open(outshp, 0)  # 0 means read-only. 1 means writeable.

        if dataSource is None:
            print("Could not open %s" % (shp))
        else:
            inLayer = dataSource.GetLayer()
            extent = inLayer.GetExtent()
            if extent[0] < extent_tot[0]:
                extent_tot[0] = extent[0]
            if extent[1] > extent_tot[1]:
                extent_tot[1] = extent[1]
            if extent[2] < extent_tot[2]:
                extent_tot[2] = extent[2]
            if extent[3] > extent_tot[3]:
                extent_tot[3] = extent[3]
    grid_srs = osr.SpatialReference()
    grid_srs.ImportFromEPSG(3035)
else:
    srs_list = []
    refdict = {}
    for shp in glob.glob(biotopes + "[Ss]ingle_*.shp")  + glob.glob(
        biotopes + "[Ll]ist_*.shp"
    ):
        driver = ogr.GetDriverByName("ESRI Shapefile")
        dataSource = driver.Open(shp, 0)  # 0 means read-only. 1 means writeable.
        if dataSource is None:
            print("Could not open %s" % (shp))
        else:
            inLayer = dataSource.GetLayer()
            refdict[shp] = inLayer.GetSpatialRef()
            srs_list.append(inLayer.GetSpatialRef())
            extent = inLayer.GetExtent()
            if extent[0] < extent_tot[0]:
                extent_tot[0] = extent[0]
            if extent[1] > extent_tot[1]:
                extent_tot[1] = extent[1]
            if extent[2] < extent_tot[2]:
                extent_tot[2] = extent[2]
            if extent[3] > extent_tot[3]:
                extent_tot[3] = extent[3]
    grid_srs = srs_list[0]
    for my_srs in srs_list:
        if my_srs.IsSame(grid_srs):
            print("OK")
        else:
            print("all data must be in the same coordinate system")
            for layer_ref in refdict.items():
                print(
                    layer_ref[0]
                    + " has coordinate system "
                    + layer_ref[1].ExportToPrettyWkt()
                )
            sys.exit()

print("Full extent based on input files")
print(extent_tot)
x_min, x_max, y_min, y_max = extent_tot


x_min = ((x_min // grid_size) - 1) * grid_size
y_min = ((y_min // grid_size) - 1) * grid_size
x_max = ((x_max // grid_size) + 1) * grid_size
y_max = ((y_max // grid_size) + 1) * grid_size


for shp in glob.glob(biotopes + "[Ll]ist_*.shp"):
    dataSource = driver.Open(shp, 0)
    layer = dataSource.GetLayer()
    values_list = []
    for feature in layer:
        newval = feature.GetField(field_name)
        values_list.append(newval)
    layer.ResetReading()
    for fieldval in list(set(values_list)):
        layer.SetAttributeFilter("{0} = '{1}'".format(field_name, fieldval))
        filename = re.sub("[^a-zA-Z0-9\n\.]", "_", fieldval).lower()
        print(filename)
        outShapefile = os.path.join(
            os.path.split(shp)[0], "single_{}.shp".format(filename)
        )
        outDriver = ogr.GetDriverByName("ESRI Shapefile")
        if os.path.exists(outShapefile):
            outDriver.DeleteDataSource(outShapefile)
        outDataSource = outDriver.CreateDataSource(outShapefile)
        out_lyr_name = os.path.splitext(os.path.split(outShapefile)[1])[0]
        outLayer = outDataSource.CreateLayer(
            out_lyr_name, grid_srs, geom_type=ogr.wkbMultiPolygon
        )
        outLayerDefn = outLayer.GetLayerDefn()
        for inFeature in layer:
            outFeature = ogr.Feature(outLayerDefn)
            geom = inFeature.GetGeometryRef()
            outFeature.SetGeometry(geom.Clone())
            outLayer.CreateFeature(outFeature)
        layer.ResetReading()
        outDataSource.Destroy()

if LAEA:
    biotopes_proj = biotopes + "[Ss]ingle*_LAEA.shp"
else:
    biotopes_proj = biotopes + "[Ss]ingle*.shp"
for shp in glob.glob(biotopes_proj):
    
    NoData_value = 0
    norm_name = re.sub("[^a-zA-Z0-9\n\.]", "_", os.path.split(shp)[1])
    out_name = norm_name[:-4].replace("single_", "h_") + ".tif"
    raster_fn = os.path.join(os.path.split(shp)[0], out_name)
    source_ds = ogr.Open(shp)
    source_layer = source_ds.GetLayer()
    source_srs = source_layer.GetSpatialRef()
    x_res = int((x_max - x_min) / grid_size)
    y_res = int((y_max - y_min) / grid_size)
    target_ds = gdal.GetDriverByName("GTiff").Create(
        raster_fn, x_res, y_res, gdal.GDT_Byte
    )
    target_ds.SetGeoTransform((x_min, grid_size, 0, y_max, 0, -grid_size))
    band = target_ds.GetRasterBand(1)
    band.SetNoDataValue(NoData_value)
    target_ds.SetProjection(source_srs.ExportToWkt())
    gdal.RasterizeLayer(
        target_ds, [1], source_layer, burn_values=[1], options=["ALL_TOUCHED=TRUE"]
    )

wgs84_globe = pyproj.Proj(proj="latlong", ellps="WGS84")

def point_buff_geodetic(c1, c2, radius, in_proj, out_proj):
    _lon, _lat = pyproj.transform(in_proj, wgs84_globe, c1, c2)
    aeqd = pyproj.Proj(
        proj="aeqd", ellps="WGS84", datum="WGS84", lat_0=_lat, lon_0=_lon
    )
    return sh_transform(
        partial(pyproj.transform, aeqd, out_proj), Point(0, 0).buffer(radius)
    )

def point_buff_geodetic_wgs(c1, c2, radius):
    aeqd = pyproj.Proj(proj="aeqd", ellps="WGS84", datum="WGS84", lat_0=c2, lon_0=c1)
    proj4str = "+proj=aeqd +lat_0=%s +lon_0=%s +x_0=0 +y_0=0" % (c2, c1)
    aeqd = pyproj.Proj(proj4str)  # azimuthal equidistant
    project = partial(pyproj.transform, aeqd, pyproj.Proj("EPSG:4326"), always_xy=True)
    return transform(project, Point(0, 0).buffer(radius))


print(grid_srs.ExportToWkt())
hab_proj = pyproj.Proj(grid_srs.ExportToWkt())
if ".shp" in occurences:
    dataSource = driver.Open(occurences, 0)
    sp_layer = dataSource.GetLayer()
    field_name_oc = "scientific"
    field_name_radius = "radius"
    sp_srs = sp_layer.GetSpatialRef()
    sp_proj = pyproj.Proj(sp_srs.ExportToWkt())
    species_list = []
    for feature in sp_layer:
        newval = feature.GetField(field_name_oc)
        if not newval in species_list:
            species_list.append(newval)
    sp_layer.ResetReading()
    print("there are " + str(len(species_list)) + " items")

    for fieldval in species_list:
        sp_layer.SetAttributeFilter("{0} = '{1}'".format(field_name_oc, fieldval))
        filename = re.sub("[^a-zA-Z0-9\n\.]", "_", fieldval).lower()
        print(filename)
        outShapefile = os.path.join(
            os.path.split(occurences)[0], "spf_{}.shp".format(filename)
        )
        outDriver = ogr.GetDriverByName("ESRI Shapefile")
        if os.path.exists(outShapefile):
            outDriver.DeleteDataSource(outShapefile)
        outDataSource = outDriver.CreateDataSource(outShapefile)
        out_lyr_name = os.path.splitext(os.path.split(outShapefile)[1])[0]
        outLayer = outDataSource.CreateLayer(
            out_lyr_name, grid_srs, geom_type=ogr.wkbMultiPolygon
        )
        outLayerDefn = outLayer.GetLayerDefn()
        for inFeature in sp_layer:
            outFeature = ogr.Feature(outLayerDefn)
            geom = inFeature.GetGeometryRef()
            uncertainty_radius = inFeature.GetField(field_name_radius)
            geom_out = point_buff_geodetic(
                geom.GetX(), geom.GetY(), uncertainty_radius, sp_proj, hab_proj
            )
            poly = ogr.CreateGeometryFromWkt(geom_out.wkt)
            multipolygon = ogr.Geometry(ogr.wkbMultiPolygon)
            multipolygon.AddGeometry(poly)
            outFeature.SetGeometry(multipolygon)
            outLayer.CreateFeature(outFeature)
        sp_layer.ResetReading()
        outDataSource.Destroy()
elif ".txt" in occurences:
    radius = 50
    print("csv input")
    alien_taxa = {}
    with open(alienTaxa, newline="") as csvfile_at:
        atl = csv.reader(csvfile_at, delimiter="\t", quotechar="|")
        i = 0
        for row in atl:
            if i == 0:
                fld_idx = row.index("scientificName")
                try:
                    radius_idx = row.index("dispersionRadius")
                except:
                    radius_idx = -1
                i += 1
            else:
                if radius_idx < 0:
                    alien_taxa[row[fld_idx]] = radius_default
                else:
                    alien_taxa[row[fld_idx]] = float(row[radius_idx])
    print("there are " + str(len(alien_taxa)) + " items")
    df_occs = pandas.read_csv(
        occurences,
        delimiter="\t",
        usecols=[
            field_name_oc,
            "decimalLatitude",#-"NCoord",
            "decimalLongitude",#-"ECoord",
        ],
    )
    sp_out_srs = osr.SpatialReference()
    sp_out_srs.ImportFromEPSG(4326)
    for alien_sp in alien_taxa:
        print(alien_sp + " " + str(round(alien_taxa[alien_sp], 0)))
        dis_radius = alien_taxa[alien_sp]
        df_temp = df_occs.loc[df_occs[field_name_oc] == alien_sp]
        filename = re.sub("[^a-zA-Z0-9\n\.]", "_", alien_sp).lower()
        outShapefile_csv = os.path.join(
            os.path.split(occurences)[0], "sp_{}.shp".format(filename)
        )
        outDriver = ogr.GetDriverByName("ESRI Shapefile")
        if os.path.exists(outShapefile_csv):
            outDriver.DeleteDataSource(outShapefile_csv)
        outDataSource_csv = outDriver.CreateDataSource(outShapefile_csv)
        out_lyr_name_csv = os.path.splitext(os.path.split(outShapefile_csv)[1])[0]
        outLayer_csv = outDataSource_csv.CreateLayer(
            out_lyr_name_csv, sp_out_srs, geom_type=ogr.wkbMultiPolygon
        )
        outLayerDefn_csv = outLayer_csv.GetLayerDefn()
        j = 0
        for i, row in df_temp.iterrows():
            outFeature_csv = ogr.Feature(outLayerDefn_csv)
            geom_out = point_buff_geodetic_wgs(
                float(row.decimalLongitude) ,float(row.decimalLatitude),dis_radius
            )  # float(row.DispersionRadius))
            poly = ogr.CreateGeometryFromWkt(geom_out.wkt)
            multipolygon = ogr.Geometry(ogr.wkbMultiPolygon)
            multipolygon.AddGeometry(poly)
            outFeature_csv.SetGeometry(multipolygon)
            outLayer_csv.CreateFeature(outFeature_csv)
            j += 1
        print(filename + " has" + str(j) + " features")
        outDataSource_csv.Destroy()
        grid_srs.AutoIdentifyEPSG()
        subprocess.call(
            [
                "ogr2ogr",
                "-t_srs",
                "EPSG:" + str(grid_srs.GetAuthorityCode(None)),
                outShapefile_csv[:-4] + "_loc.shp",
                outShapefile_csv,
            ]
        )
else:
    print("No valid imput for species occurences")



for shp in glob.glob(os.path.join(os.path.split(occurences)[0], "sp_*loc.shp")):

    NoData_value = 0

    raster_fn = shp[:-4].replace("sp_", "s_") + ".tif"
    print(raster_fn + " raster processing")
    source_ds = ogr.Open(shp)
    source_layer = source_ds.GetLayer()
    source_srs = source_layer.GetSpatialRef()

    x_res = int((x_max - x_min) / grid_size)
    y_res = int((y_max - y_min) / grid_size)
    target_ds = gdal.GetDriverByName("GTiff").Create(
        raster_fn, x_res, y_res, gdal.GDT_Byte
    )
    target_ds.SetGeoTransform((x_min, grid_size, 0, y_max, 0, -grid_size))
    band = target_ds.GetRasterBand(1)
    band.SetNoDataValue(NoData_value)
    target_ds.SetProjection(source_srs.ExportToWkt())
    gdal.RasterizeLayer(
        target_ds, [1], source_layer, burn_values=[1], options=["ALL_TOUCHED=TRUE"]
    )



for weight_matrix_csv in [weight_matrix_template]:
    w = os.path.split(weight_matrix_csv)[1][:-4]
    print(w)
    with open(weight_matrix_csv, newline="") as csvfile:
        w_matrix = csv.reader(csvfile, delimiter="\t", quotechar="|")
        i = 0
        for row in w_matrix:
            print(f"{row}")
            if i == 0:
                habitat_names = [
                    re.sub("[^a-zA-Z0-9\n\.]", "_", x).lower() for x in row
                ]
                i += 1
            else:
                sp_name = re.sub("[^a-zA-Z0-9\n\.]", "_", row[0]).lower()
                sp_file = os.path.join(
                    os.path.split(occurences)[0], "s_{}_loc.tif".format(sp_name)
                )
                if os.path.exists(sp_file):
                    j = 0
                    k = 1
                    expression = []
                    file_list = [sp_file]
                    for habitat in row:
                        if j > 0:
                            if LAEA:
                                hab_file = os.path.join(
                                    biotopes, "h_{}_LAEA.tif".format(habitat_names[j])
                                    )
                            else:
                                hab_file = os.path.join(
                                    biotopes, "h_{}.tif".format(habitat_names[j])
                                    )
                            if os.path.exists(hab_file):
                                if float(habitat) > 0:
                                    k += 1
                                    expression.append(
                                        "im1b1*im{0}b1*{1}".format(k, habitat)
                                    )
                                    file_list.append(hab_file)
                            else:
                                print(
                                    "WARNING: no file for {}".format(habitat_names[j])
                                )
                                expression.append("0") #use zero in case a file is not found to avoid NoData rasters
                            j += 1
                        else:
                            j += 1
                    if len(file_list) > 0:
                        if len(expression) == 0:
                            expression = ["0"]
                        outfile = os.path.join(
                            outpath,
                            "impact_{0}_{1}.tif{2}".format(
                                sp_name,
                                w,
                                "?&gdal:co:COMPRESS=LZW&gdal:co:TILED=YES&gdal:co:BIGTIFF=YES",
                            ),
                        )
                        print("+".join(expression))
                        subprocess.call(
                            [
                                otbbin + "otbcli_BandMath",
                                "-out",
                                outfile,
                                "-exp",
                                "+".join(expression),
                                "-il",
                            ]
                            + file_list
                        )
                else:
                    print("WARNING: no file for {}".format(sp_name))
    if filter_matrix_csv and os.path.exists(filter_matrix_csv):
        with open(filter_matrix_csv, newline="") as csvfile_f:
            f_matrix = csv.reader(csvfile_f, delimiter="\t", quotechar="|")
            i = 0
            for row in f_matrix:
                if i == 0:
                    sp_names = [re.sub("[^a-zA-Z0-9\n\.]", "_", x).lower() for x in row]
                    i += 1
                    print("number of species " + str(len(sp_names)))
                else:
                    j = 0
                    k = 0
                    expression = []
                    sp_file_list = []
                    for sp in row:
                        if j > 0:
                            impact_file = os.path.join(
                                outpath, "impact_{0}_{1}.tif".format(sp_names[j], w)
                            )
                            if os.path.exists(impact_file):
                                if float(sp) > 0:
                                    k += 1
                                    expression.append("im{0}b1".format(k))
                                    sp_file_list.append(impact_file)
                            else:
                                print(j)
                                print("WARNING: no file for {}".format(sp_names[j]))
                                expression.append("0") # add zero in case of missing file to avoid nodata in further calculations
                            j += 1
                        else:
                            j += 1
                    if len(sp_file_list) > 0:
                        outfile = os.path.join(
                            outpath,
                            "cimpal_{0}_{1}.tif{2}".format(
                                row[0],
                                w,
                                "?&gdal:co:COMPRESS=LZW&gdal:co:TILED=YES&gdal:co:BIGTIFF=YES",
                            ),
                        )
                        subprocess.call(
                            [
                                otbbin + "otbcli_BandMath",
                                "-out",
                                outfile,
                                "-exp",
                                "+".join(expression),
                                "-il",
                            ]
                            + sp_file_list
                        )
                    else:
                        print("WARNING: no file for pathway {row[0]} and matrix {w}")
    else:
        k = 1
        expression = []
        sp_file_list = []
        for impact_file in glob.glob(
            os.path.join(outpath, "impact_*_{0}.tif".format(w))
        ):
            expression.append("im{0}b1".format(k))
            sp_file_list.append(impact_file)
            k += 1
        if len(sp_file_list) > 0:
            outfile = os.path.join(
                outpath,
                "cimpal_all_{0}.tif{1}".format(
                    w, "?&gdal:co:COMPRESS=LZW&gdal:co:TILED=YES&gdal:co:BIGTIFF=YES"
                ),
            )
            subprocess.call(
                [
                    otbbin + "otbcli_BandMath",
                    "-out",
                    outfile,
                    "-exp",
                    "+".join(expression),
                    "-il",
                ]
                + sp_file_list
            )
        else:
            print(f"WARNING: No impact files matrix {w}")
grid_srs_out = Path(outpath, "grid_srs_toWkt.txt")
f = open(grid_srs_out, mode="w+")
f.write(grid_srs.ExportToWkt())
f.close()

import json
filename = "/tmp/out_path_" + id + ".json"
file_out_path = open(filename, "w")
file_out_path.write(json.dumps(out_path))
file_out_path.close()
