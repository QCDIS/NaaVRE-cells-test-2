import requests
import sys

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()

secret_key_knmi_api = os.getenv('secret_key_knmi_api')

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--init_complete', action='store', type=str, required=True, dest='init_complete')

arg_parser.add_argument('--param_end_date', action='store', type=str, required=True, dest='param_end_date')
arg_parser.add_argument('--param_interval_in_minutes', action='store', type=int, required=True, dest='param_interval_in_minutes')
arg_parser.add_argument('--param_maximum_KNMI_files', action='store', type=int, required=True, dest='param_maximum_KNMI_files')
arg_parser.add_argument('--param_radar', action='store', type=str, required=True, dest='param_radar')
arg_parser.add_argument('--param_start_date', action='store', type=str, required=True, dest='param_start_date')

args = arg_parser.parse_args()
print(args)

id = args.id

init_complete = args.init_complete.replace('"','')

param_end_date = args.param_end_date.replace('"','')
param_interval_in_minutes = args.param_interval_in_minutes
param_maximum_KNMI_files = args.param_maximum_KNMI_files
param_radar = args.param_radar.replace('"','')
param_start_date = args.param_start_date.replace('"','')

conf_radars = {'hrw': ['radar_volume_full_herwijnen', 1.0, 'https://api.dataplatform.knmi.nl/open-data/v1/datasets/radar_volume_full_herwijnen/versions/1.0/files', 'NL/HRW'], 'herwijnen': ['radar_volume_full_herwijnen', 1.0, 'https://api.dataplatform.knmi.nl/open-data/v1/datasets/radar_volume_full_herwijnen/versions/1.0/files', 'NL/HRW'], 'dhl': ['radar_volume_full_denhelder', 2.0, 'https://api.dataplatform.knmi.nl/open-data/v1/datasets/radar_volume_denhelder/versions/2.0/files', 'NL/DHL'], 'den helder': ['radar_volume_full_denhelder', 2.0, 'https://api.dataplatform.knmi.nl/open-data/v1/datasets/radar_volume_denhelder/versions/2.0/files', 'NL/DHL']}


conf_radars = {'hrw': ['radar_volume_full_herwijnen', 1.0, 'https://api.dataplatform.knmi.nl/open-data/v1/datasets/radar_volume_full_herwijnen/versions/1.0/files', 'NL/HRW'], 'herwijnen': ['radar_volume_full_herwijnen', 1.0, 'https://api.dataplatform.knmi.nl/open-data/v1/datasets/radar_volume_full_herwijnen/versions/1.0/files', 'NL/HRW'], 'dhl': ['radar_volume_full_denhelder', 2.0, 'https://api.dataplatform.knmi.nl/open-data/v1/datasets/radar_volume_denhelder/versions/2.0/files', 'NL/DHL'], 'den helder': ['radar_volume_full_denhelder', 2.0, 'https://api.dataplatform.knmi.nl/open-data/v1/datasets/radar_volume_denhelder/versions/2.0/files', 'NL/DHL']}
"""
consume dummy var from config to signal workflow start
There is something dodgy going on with how
strings are being passed around.
The string "Yes" is being sent as '"Yes"'
So, to prevent extra quotes being introduced
we eval init_complete first before
we test if it contains "Yes"
"""

def validate_number_of_KNMI_files():
    if len(dataset_files) > param_maximum_KNMI_files:
        raise ValueError(f"{len(dataset_files)} KNMI files were found to download, but {param_maximum_KNMI_files=}."
                         f"\n The data was retrieved with the following parameters:"
                         f"\n {param_start_date=} \n {param_end_date=} \n {param_interval_in_minutes=}"
                         f"\n Increase {param_maximum_KNMI_files=}, decrease the time range, or increase the interval.")

init_complete = init_complete.replace("'", "")
init_complete = init_complete.replace('"', "")
if init_complete == "Yes":
    print("Workflow configuration succesfull")
else:
    print("Workflow configuration was not complete, exitting")

    sys.exit(1)


start_ts = param_start_date
end_ts = param_end_date
datasetName, datasetVersion, api_url, _ = conf_radars.get(param_radar.lower())
params = {
    "datasetName": datasetName,
    "datasetVersion": datasetVersion,
    "maxKeys": 10,
    "sorting": "asc",
    "orderBy": "created",
    "begin": start_ts,
    "end": end_ts,
}
dataset_files = []
while True:
    list_files_response = requests.get(
        url=api_url,
        headers={"Authorization": secret_key_knmi_api},
        params=params,
    )
    list_files = list_files_response.json()
    dset_files = list_files.get("files")
    dset_files = [list(dset_file.values()) for dset_file in dset_files]
    dataset_files += dset_files
    nextPageToken = list_files.get("nextPageToken")
    if not nextPageToken:
        break
    else:
        params.update({"nextPageToken": nextPageToken})

filtered_list = []
interval_list = list(range(0, 60, param_interval_in_minutes))
for dataset_file in dataset_files:
    minute = int(dataset_file[0].split("_")[-1].split(".")[0][-2:])
    if minute in interval_list:
        filtered_list.append(dataset_file)

dataset_files = filtered_list

validate_number_of_KNMI_files()
print(f"Found {len(dataset_files)} files")
print(dataset_files)

file_dataset_files = open("/tmp/dataset_files_" + id + ".json", "w")
file_dataset_files.write(json.dumps(dataset_files))
file_dataset_files.close()
