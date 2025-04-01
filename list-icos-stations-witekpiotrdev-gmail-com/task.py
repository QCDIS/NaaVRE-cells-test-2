from icoscp.station import station

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--param_ecosystem_type', action='store', type=str, required=True, dest='param_ecosystem_type')

args = arg_parser.parse_args()
print(args)

id = args.id


param_ecosystem_type = args.param_ecosystem_type.replace('"','')




stations = station.getIdList()
stations = stations[stations.siteType == param_ecosystem_type]
stations_id_list = list(stations.id)

stations_id_list

file_stations_id_list = open("/tmp/stations_id_list_" + id + ".json", "w")
file_stations_id_list.write(json.dumps(stations_id_list))
file_stations_id_list.close()
