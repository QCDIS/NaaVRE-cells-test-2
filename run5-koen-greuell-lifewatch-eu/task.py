
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()

secret_number2 = os.getenv('secret_number2')

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id




print("5" + str(secret_number2))

