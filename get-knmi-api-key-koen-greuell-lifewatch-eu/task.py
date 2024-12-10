from secrets_provider import SecretsProvider

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--param_KMNI_key_name', action='store', type=str, required=True, dest='param_KMNI_key_name')

arg_parser.add_argument('--param_secrets_file_path', action='store', type=str, required=True, dest='param_secrets_file_path')


args = arg_parser.parse_args()
print(args)

id = args.id

param_KMNI_key_name = args.param_KMNI_key_name.replace('"','')
param_secrets_file_path = args.param_secrets_file_path.replace('"','')



secret_KNMI_API_key: str = SecretsProvider(param_secrets_file_path).get_secret(param_KMNI_key_name)

file_secret_KNMI_API_key = open("/tmp/secret_KNMI_API_key_" + id + ".json", "w")
file_secret_KNMI_API_key.write(json.dumps(secret_KNMI_API_key))
file_secret_KNMI_API_key.close()
