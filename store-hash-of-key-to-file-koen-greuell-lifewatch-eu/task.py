
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



def store_hash_of_key(filename, key):
    if (key is not None):
        content = str(hash(key))
    else:
        content = "Did not manage to retrieve key"
    with open(filename, 'w') as f:
        f.write(content)

store_hash_of_key('output.txt', secret_KNMI_API_key)

