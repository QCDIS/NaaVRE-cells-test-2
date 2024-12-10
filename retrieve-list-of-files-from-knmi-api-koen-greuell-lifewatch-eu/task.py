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




api_version = "v1"
collection = "observations"
base_url = f"https://api.dataplatform.knmi.nl/edr/{api_version}/collections/{collection}"
token = secret_KNMI_API_key
headers = {"Authorization": token}

def metadata():
    r = requests.get(base_url, headers=headers)
    r.raise_for_status()
    return r.json()

md = metadata()
with open(f'../{collection}.dataplatform.knmi.json', 'w') as f:
    f.write(json.dumps(md))

