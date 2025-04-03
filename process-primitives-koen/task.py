
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--single_decimal', action='store', type=float, required=True, dest='single_decimal')

arg_parser.add_argument('--single_name', action='store', type=str, required=True, dest='single_name')

arg_parser.add_argument('--single_number', action='store', type=int, required=True, dest='single_number')


args = arg_parser.parse_args()
print(args)

id = args.id

single_decimal = args.single_decimal
single_name = args.single_name.replace('"','')
single_number = args.single_number



print(single_name)
print(single_number)
print(single_decimal)

