
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--whole_numbers', action='store', type=str, required=True, dest='whole_numbers')


args = arg_parser.parse_args()
print(args)

id = args.id

whole_numbers = json.loads(args.whole_numbers)



for number in whole_numbers:
    print(f"Hello, {number}!")

