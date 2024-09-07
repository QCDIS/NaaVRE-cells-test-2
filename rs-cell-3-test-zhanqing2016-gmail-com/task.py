
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--acolite_processing', action='store', type=str, required=True, dest='acolite_processing')


args = arg_parser.parse_args()
print(args)

id = args.id

acolite_processing = json.loads(args.acolite_processing)




acolite_processing 

