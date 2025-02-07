
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--int_val', action='store', type=int, required=True, dest='int_val')


args = arg_parser.parse_args()
print(args)

id = args.id

int_val = args.int_val



print(int_val)

