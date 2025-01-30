
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()

secret_key = os.getenv('secret_key')

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id




if secret_key == 'secret1':
    print(str(True))

