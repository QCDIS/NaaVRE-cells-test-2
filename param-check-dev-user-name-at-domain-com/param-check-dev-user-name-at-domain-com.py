
import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--param_density', action='store', type=int, required=True, dest='param_density')

args = arg_parser.parse_args()
print(args)

id = args.id


param_density = args.param_density






if param_density == 1: 
    param_CountingStrategy = 'density0'
    
diameterofsedimentationchamber = 'diameterofsedimentationchamber'

import json
filename = "/tmp/diameterofsedimentationchamber_" + id + ".json"
file_diameterofsedimentationchamber = open(filename, "w")
file_diameterofsedimentationchamber.write(json.dumps(diameterofsedimentationchamber))
file_diameterofsedimentationchamber.close()
