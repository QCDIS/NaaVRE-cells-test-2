from secrets_provider import SecretsProvider

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--param_secrets_file_path', action='store', type=str, required=True, dest='param_secrets_file_path')


args = arg_parser.parse_args()
print(args)

id = args.id

param_secrets_file_path = args.param_secrets_file_path.replace('"','')



def store_hash_of_key(filename, key_name):
    key = SecretsProvider(param_secrets_file_path).get_secret(key_name)
    if (key is not None):
        content = str(hash(key))
    else:
        content = "Did not manage to retrieve key"
    with open(filename, 'w') as f:
        f.write(content)

store_hash_of_key('output.txt', 'fake_key')

