
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--reverse_and_check', action='store', type=str, required=True, dest='reverse_and_check')


args = arg_parser.parse_args()
print(args)

id = args.id

reverse_and_check = json.loads(args.reverse_and_check)



list = reverse_and_check(list)

