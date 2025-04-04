
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--decimal_numbers', action='store', type=str, required=True, dest='decimal_numbers')

arg_parser.add_argument('--names', action='store', type=str, required=True, dest='names')

arg_parser.add_argument('--whole_numbers', action='store', type=str, required=True, dest='whole_numbers')


args = arg_parser.parse_args()
print(args)

id = args.id

decimal_numbers = json.loads(args.decimal_numbers)
names = json.loads(args.names)
whole_numbers = json.loads(args.whole_numbers)



for index in range(max(len(names), len(whole_numbers), len(decimal_numbers))):
    print(f"Hello, {names[index]}!")
    print(f"This is number {whole_numbers[index]}")
    print(f"This is a float: {decimal_numbers[index]} \n")

