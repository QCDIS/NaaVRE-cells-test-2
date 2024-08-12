import dtSat

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--catalogue_response', action='store', type=str, required=True, dest='catalogue_response')


args = arg_parser.parse_args()
print(args)

id = args.id

catalogue_response = json.loads(args.catalogue_response)



catalogue_sub = dtSat.filter_by_orbit_and_tile(catalogue_response, orbit = "R008", tile = "T32ULE", name_only = False)
[catalogue_sub['value'][i]['Name'] for i in range(len(catalogue_sub["value"]))]
print(len(catalogue_sub['value']))

file_catalogue_sub = open("/tmp/catalogue_sub_" + id + ".json", "w")
file_catalogue_sub.write(json.dumps(catalogue_sub))
file_catalogue_sub.close()
