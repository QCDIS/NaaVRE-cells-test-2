from minio import Minio
import acolite as ac
from dtAcolite import dtAcolite
from dtSat import dtSat
import glob
import pandas as pd

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()

secret_s3_access_key = os.getenv('secret_s3_access_key')
secret_s3_secret_key = os.getenv('secret_s3_secret_key')

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--app_configuration', action='store', type=str, required=True, dest='app_configuration')

arg_parser.add_argument('--collection', action='store', type=str, required=True, dest='collection')

arg_parser.add_argument('--year', action='store', type=int, required=True, dest='year')

arg_parser.add_argument('--param_s3_public_bucket', action='store', type=str, required=True, dest='param_s3_public_bucket')
arg_parser.add_argument('--param_s3_server', action='store', type=str, required=True, dest='param_s3_server')

args = arg_parser.parse_args()
print(args)

id = args.id

app_configuration = json.loads(args.app_configuration)
collection = args.collection.replace('"','')
year = args.year

param_s3_public_bucket = args.param_s3_public_bucket.replace('"','')
param_s3_server = args.param_s3_server.replace('"','')



minio_client = Minio(param_s3_server, access_key=secret_s3_access_key, secret_key=secret_s3_secret_key, region = "nl", secure=True)

minio_base_path = 'app_acolite_stan'
dtSat.upload_satellite_to_minio(client = minio_client,
                                bucket_name = param_s3_public_bucket,  
                                local_path = app_configuration["raw_inputdir"],
                                minio_path = f"/{minio_base_path}/raw/{app_configuration['collection']}/{app_configuration['year']}", 
                                collection = app_configuration["raw_inputdir"], 
                                year = app_configuration["raw_inputdir"])


inputfilenames = dtAcolite.create_acolite_input(app_configuration = app_configuration)
outfilepaths   = dtAcolite.create_acolite_output(app_configuration=app_configuration, filenames=inputfilenames)
dtAcolite.unzip_inputfiles(app_configuration=app_configuration)

settings = {'limit': [52.5,4.7,53.50,5.4], 
            'inputfile': '', 
            'output': '', 
            "cirrus_correction": True,
            'l2w_parameters' : ["rhow_*","rhos_*", "Rrs_*", "chl_oc3", "chl_re_gons", "chl_re_gons740", 
                                "chl_re_moses3b", "chl_re_moses3b740",  "chl_re_mishra", "chl_re_bramich", 
                                "ndci", "ndvi","spm_nechad2010"]}

inputfilepaths = glob.glob(f"{app_configuration['acolite_inputdir']}/**")
outputfilepaths = glob.glob(f"{app_configuration['acolite_outputdir']}/**")
outputfilepaths


for i in range(len(inputfilepaths)):
    print("---------------------------------------------------------------------------------------")
    settings['inputfile'] = inputfilepaths[i]
    settings['output']    = outputfilepaths[i]
    ac.acolite.acolite_run(settings=settings)
print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
print(f"processing done and output is in {inputfilepaths[i]}")
print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")


dtSat.upload_local_directory_to_minio(client = minio_client,
                                      bucket_name = param_s3_public_bucket,  
                                      local_path = app_configuration['acolite_output'], 
                                      minio_path = f"/{minio_base_path}/processed/outputdir/{app_configuration['collection']}/{app_configuration['year']}", 
                                      collection = collection, 
                                      year = year)


def extract_chla_per_station(st_lon, st_lat, st_name, year, app_configuration = app_configuration, verbose = False):
    column_names = ['time', 'chl_oc3', 'chl_re_gons', 'chl_re_gons740','chl_re_moses3b', 'chl_re_moses3b740', 'chl_re_mishra', 'chl_re_bramich']

    dfs = pd.DataFrame(index= column_names).T

    if st_lat <= 53.1:
        tile = "T31UFU"
        ncfs = glob.glob(app_configuration['acolite_outputdir'] + f"/*{tile}*/S2**L2W**.nc")
    elif st_lat > 53.18 and st_lat <= 53.4:
        tile = 'T31UGV' # T31UFV
        ncfs = glob.glob(app_configuration['acolite_outputdir'] + f"/*{tile}*/S2**L2W**.nc")
    else: 
        tile = 'T32ULE'
        ncfs = glob.glob(app_configuration['acolite_outputdir'] + f"/*{tile}*/S2**L2W**.nc")
        
    if verbose: print(tile)
        
    chl_oc3 = [ac.shared.nc_extract_point(ncf, st_lon, st_lat, extract_datasets = None, shift_edge = False, box_size = 1)['data']["chl_oc3"] for ncf in ncfs]
    chl_re_gons = [ac.shared.nc_extract_point(ncf, st_lon, st_lat, extract_datasets = None, shift_edge = False, box_size = 1)['data']["chl_re_gons"] for ncf in ncfs]
    chl_re_gons740 = [ac.shared.nc_extract_point(ncf, st_lon, st_lat, extract_datasets = None, shift_edge = False, box_size = 1)['data']["chl_re_gons740"] for ncf in ncfs]
    chl_re_moses3b = [ac.shared.nc_extract_point(ncf, st_lon, st_lat, extract_datasets = None, shift_edge = False, box_size = 1)['data']["chl_re_moses3b"] for ncf in ncfs]
    chl_re_moses3b740 = [ac.shared.nc_extract_point(ncf, st_lon, st_lat, extract_datasets = None, shift_edge = False, box_size = 1)['data']["chl_re_moses3b740"] for ncf in ncfs]
    chl_re_mishra = [ac.shared.nc_extract_point(ncf, st_lon, st_lat, extract_datasets = None, shift_edge = False, box_size = 1)['data']["chl_re_mishra"] for ncf in ncfs]
    chl_re_bramich = [ac.shared.nc_extract_point(ncf, st_lon, st_lat, extract_datasets = None, shift_edge = False, box_size = 1)['data']["chl_re_bramich"] for ncf in ncfs]
    isodates = [ac.shared.nc_extract_point(ncf, st_lon, st_lat, extract_datasets = None, shift_edge = False, box_size = 1)['gatts']["isodate"] for ncf in ncfs]
    isodates = [dtAcolite.create_datetime_from_isodate(isodate) for isodate in isodates]
    df = pd.DataFrame([isodates, chl_oc3, chl_re_gons, chl_re_gons740, chl_re_moses3b, chl_re_moses3b740, chl_re_mishra, chl_re_bramich], index = column_names).T
    dfs = pd.concat([dfs, df])
    dfs['longitude'] = st_lon
    dfs['latitude'] = st_lat
    dfs["station"] = st_name
    dfs["tile"] = tile

    return dfs 

def extract_chla_all_station(stations, year, verbose = False):
    full_df = pd.DataFrame(index=['time', 'chl_oc3', 'chl_re_gons', 'chl_re_gons740','chl_re_moses3b', 'chl_re_moses3b740', 'chl_re_mishra', 'chl_re_bramich', 'station']).T
    for index, row in stations.iterrows():
        irow = row.to_list()
        dfs = extract_chla_per_station(st_lon = irow[0], st_lat = irow[1], st_name = irow[2], year = year, verbose = verbose)
        full_df = pd.concat([full_df, dfs])
    return full_df


stations_df = pd.DataFrame({"st_lon":  [4.75,  5.03, 4.90,     ], 
                           "st_lat" :  [52.98, 53.05, 52.99],
                           "station" :["MARSDND", "DOOVBWT", "MALZN"]})


full_df = extract_chla_all_station(stations = stations_df, year = app_configuration['year'])
full_df
full_df.to_csv(app_configuration['acolite_csv'] + f"/Ems_Dollards_{app_configuration['year']}.csv", sep = ",")
dtSat.upload_csv_to_minio(client = minio_client,
                          bucket_name = param_s3_public_bucket,  
                          local_path = app_configuration['acolite_csv'], 
                          minio_path = f"/{minio_base_path}/processed/csv/{app_configuration['collection']}/{app_configuration['year']}", 
                          collection = app_configuration['collection'], 
                          year = app_configuration['year'])

