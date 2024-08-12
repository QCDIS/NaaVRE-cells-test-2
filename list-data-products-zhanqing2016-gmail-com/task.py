import pandas as pd
from icoscp.station import station
import warnings

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--stations_id_list', action='store', type=str, required=True, dest='stations_id_list')

arg_parser.add_argument('--param_data_type', action='store', type=str, required=True, dest='param_data_type')

args = arg_parser.parse_args()
print(args)

id = args.id

stations_id_list = json.loads(args.stations_id_list)

param_data_type = args.param_data_type.replace('"','')




dobj_list = []
for station_id in stations_id_list:
    with warnings.catch_warnings():
        warnings.simplefilter("ignore")
        s = station.get(station_id)
        datasets = s.data()
    if not isinstance(datasets, pd.DataFrame):
        print(f'No datasets for station {station_id}')
        continue
    datasets = datasets[datasets.specLabel == param_data_type]
    dobj_list += list(datasets.dobj)

dobj_list

file_dobj_list = open("/tmp/dobj_list_" + id + ".json", "w")
file_dobj_list.write(json.dumps(dobj_list))
file_dobj_list.close()
