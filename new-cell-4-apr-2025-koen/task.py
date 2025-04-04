
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--init_complete', action='store', type=str, required=True, dest='init_complete')


args = arg_parser.parse_args()
print(args)

id = args.id

init_complete = args.init_complete.replace('"','')


conf_radars = conf_radars = {'HRW': ['radar_volume_full_herwijnen', 1.0, 'https://api.dataplatform.knmi.nl/open-data/v1/datasets/radar_volume_full_herwijnen/versions/1.0/files', 'NL/HRW'], 'DHL': ['radar_volume_full_denhelder', 2.0, 'https://api.dataplatform.knmi.nl/open-data/v1/datasets/radar_volume_denhelder/versions/2.0/files', 'NL/DHL']}

start_ts = "2019-12-31T23:00+00:00" 
end_ts = "2019-12-31T23:00+00:00" 
datasetName, datasetVersion, api_url, _ = conf_radars.get("")
params = {
    "datasetName": datasetName,
    "datasetVersion": datasetVersion,
    "maxKeys": 10,
    "sorting": "asc",
    "orderBy": "created",
    "begin": start_ts,
    "end": end_ts,
}
dataset_files2 = []
while True:
    list_files_response = "no dep"
    list_files = list_files_response.json()
    dset_files = list_files.get("files")
    dset_files = [list(dset_file.values()) for dset_file in dset_files]
    dataset_files2 += dset_files
    nextPageToken = list_files.get("nextPageToken")
    if not nextPageToken:
        break
    else:
        params.update({"nextPageToken": nextPageToken})

filtered_list = []
interval_list = list(range(0, 60, 100))
for dataset_file in dataset_files2:
    minute = int(dataset_file[0].split("_")[-1].split(".")[0][-2:])
    if minute in interval_list:
        filtered_list.append(dataset_file)

print(f"Found {len(dataset_files2)} files")
print(dataset_files2)
print(init_complete)

