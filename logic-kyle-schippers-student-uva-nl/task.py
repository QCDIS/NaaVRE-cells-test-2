import json
import requests

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id




mapping_CF_IAGOS = {'mole_fraction_of_carbon_monoxide_in_air' : ['CO'],
                   'mole_fraction_of_carbon_dioxide_in_air' : ['CO2']}

param_bbox = "0,0,50,90" #bbox="0,0,50,90"
parameters=[]
for x in mapping_CF_IAGOS:
    for y in mapping_CF_IAGOS[x]:
        parameters.append(y)
parameters=",".join(parameters)
param_start = "2021-08-01" #start="2021-08-01"
param_end = "2021-10-20" #end="2021-10-20"
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
