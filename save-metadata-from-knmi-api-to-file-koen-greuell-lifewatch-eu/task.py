import json
import requests

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--secret_KNMI_API_key', action='store', type=str, required=True, dest='secret_KNMI_API_key')


args = arg_parser.parse_args()
print(args)

id = args.id

secret_KNMI_API_key = args.secret_KNMI_API_key.replace('"','')



def get_metadata_from_KNMI():
    base_url = "https://api.dataplatform.knmi.nl/edr/v1/collections/observations"
    headers = {"Authorization": secret_KNMI_API_key}
    r = requests.get(base_url, headers=headers)
    r.raise_for_status()
    return r.json()

metadata = get_metadata_from_KNMI()
filename: str = 'Metadata_KNMI.json'
with open(filename, 'w') as f:
    f.write(json.dumps(metadata))

