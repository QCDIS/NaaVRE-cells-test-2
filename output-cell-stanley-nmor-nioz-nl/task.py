
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--access_response', action='store', type=str, required=True, dest='access_response')


args = arg_parser.parse_args()
print(args)

id = args.id

access_response = json.loads(args.access_response)



print(access_response)

