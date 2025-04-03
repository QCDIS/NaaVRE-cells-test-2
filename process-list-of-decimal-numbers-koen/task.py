
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--decimal_numbers', action='store', type=str, required=True, dest='decimal_numbers')


args = arg_parser.parse_args()
print(args)

id = args.id

decimal_numbers = json.loads(args.decimal_numbers)



for number in decimal_numbers:
    print(f"Hello, {number}!")

