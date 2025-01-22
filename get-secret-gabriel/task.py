
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()

secret_a = os.getenv('secret_a')

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id




print(secret_a)

