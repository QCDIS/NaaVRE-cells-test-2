
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--more_path', action='store', type=str, required=True, dest='more_path')


args = arg_parser.parse_args()
print(args)

id = args.id

more_path = json.loads(args.more_path)



print(more_path)

