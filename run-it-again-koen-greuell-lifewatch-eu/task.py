
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--secret_number1', action='store', type=int, required=True, dest='secret_number1')


args = arg_parser.parse_args()
print(args)

id = args.id

secret_number1 = args.secret_number1



print(secret_number1)

