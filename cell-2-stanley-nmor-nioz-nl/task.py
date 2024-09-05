import json

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--access_response_filename', action='store', type=str, required=True, dest='access_response_filename')

arg_parser.add_argument('--app_configuration_filename', action='store', type=str, required=True, dest='app_configuration_filename')

arg_parser.add_argument('--catalogue_sub_filename', action='store', type=str, required=True, dest='catalogue_sub_filename')


args = arg_parser.parse_args()
print(args)

id = args.id

access_response_filename = args.access_response_filename.replace('"','')
app_configuration_filename = args.app_configuration_filename.replace('"','')
catalogue_sub_filename = args.catalogue_sub_filename.replace('"','')




with open(catalogue_sub_filename) as f:
    catalogue_sub = json.load(f)
    
with open(access_response_filename) as f:
    access_response = json.load(f)
    
with open(app_configuration_filename) as f:
    app_configuration = json.load(f)
    
print(f"Raw images will be stored in {app_configuration['raw_inputdir']}")
print(f"Analysis with acolite will start with images from {app_configuration['acolite_inputdir']}")
print(f"Processed images from acolite will be stored in {app_configuration['acolite_outputdir']}")


for key, val in app_configuration.items():
    print(key)

    



file_app_configuration = open("/tmp/app_configuration_" + id + ".json", "w")
file_app_configuration.write(json.dumps(app_configuration))
file_app_configuration.close()
