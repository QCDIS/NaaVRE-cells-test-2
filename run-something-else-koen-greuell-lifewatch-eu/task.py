
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()

secret_number2 = os.getenv('secret_number2')

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--random_string', action='store', type=str, required=True, dest='random_string')

arg_parser.add_argument('--secret_number1', action='store', type=int, required=True, dest='secret_number1')


args = arg_parser.parse_args()
print(args)

id = args.id

random_string = args.random_string.replace('"','')
secret_number1 = args.secret_number1



print(str(secret_number1) + "_" + str(secret_number2) + "_" + random_string)

