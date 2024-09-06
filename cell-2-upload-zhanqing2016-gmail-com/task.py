import acolite as ac
from dtAcolite import dtAcolite
from dtSat import dtSat
import glob

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()

secret_copernicus_api = os.getenv('secret_copernicus_api')
secret_s3_secret_key = os.getenv('secret_s3_secret_key')

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--app_configuration', action='store', type=str, required=True, dest='app_configuration')

arg_parser.add_argument('--param_copernicus_api', action='store', type=str, required=True, dest='param_copernicus_api')
arg_parser.add_argument('--param_s3_public_bucket', action='store', type=str, required=True, dest='param_s3_public_bucket')
arg_parser.add_argument('--param_s3_server', action='store', type=str, required=True, dest='param_s3_server')

args = arg_parser.parse_args()
print(args)

id = args.id

app_configuration = json.loads(args.app_configuration)

param_copernicus_api = args.param_copernicus_api.replace('"','')
param_s3_public_bucket = args.param_s3_public_bucket.replace('"','')
param_s3_server = args.param_s3_server.replace('"','')




dtSat.upload_local_directory_to_minio(client = minio_client,
                                      bucket_name = param_s3_public_bucket,  
                                      local_path = app_configuration['acolite_outputdir'], 
                                      minio_path = f"/app_acolite/processed/outputdir/{app_configuration['collection']}/{app_configuration['year']}", 
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
                          minio_path = f"/app_acolite/processed/csv/{app_configuration['collection']}/{app_configuration['year']}", 
                          collection = app_configuration['collection'], 
                          year = app_configuration['year'])

