import json
import requests

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--param_bbox', action='store', type=str, required=True, dest='param_bbox')
arg_parser.add_argument('--param_end', action='store', type=str, required=True, dest='param_end')
arg_parser.add_argument('--param_start', action='store', type=str, required=True, dest='param_start')

args = arg_parser.parse_args()
print(args)

id = args.id


param_bbox = args.param_bbox.replace('"','')
param_end = args.param_end.replace('"','')
param_start = args.param_start.replace('"','')


mapping_CF_IAGOS = {'mole_fraction_of_carbon_monoxide_in_air' : ['CO'],
                   'mole_fraction_of_carbon_dioxide_in_air' : ['CO2']}

parameters=[]
for x in mapping_CF_IAGOS:
    for y in mapping_CF_IAGOS[x]:
        parameters.append(y)
parameters=",".join(parameters)
indexPage=0
sizePage=20
url="https://services.iagos-data.fr/prod/v2.0/airports/public?active=true&bbox="+param_bbox+"&from="+param_start+"&to="+param_end+"&cursor="+str(indexPage)+"&size="+str(sizePage)
response=requests.get(url)
data = json.loads(response.text)
airports = []
for dataset in data:
    airports.append(dataset['iata_code'])
airports=",".join(airports)
print(airports)

file_parameters = open("/tmp/parameters_" + id + ".json", "w")
file_parameters.write(json.dumps(parameters))
file_parameters.close()
file_airports = open("/tmp/airports_" + id + ".json", "w")
file_airports.write(json.dumps(airports))
file_airports.close()
