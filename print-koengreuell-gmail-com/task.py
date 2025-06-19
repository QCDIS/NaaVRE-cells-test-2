
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--variable1', action='store', type=int, required=True, dest='variable1')


args = arg_parser.parse_args()
print(args)

id = args.id

variable1 = args.variable1



print(variable1)

