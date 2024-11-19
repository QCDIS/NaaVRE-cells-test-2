
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()

secret_copernicus_api_password = os.getenv('secret_copernicus_api_password')
secret_s3_access_key = os.getenv('secret_s3_access_key')
secret_s3_secret_key = os.getenv('secret_s3_secret_key')

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id





pass

