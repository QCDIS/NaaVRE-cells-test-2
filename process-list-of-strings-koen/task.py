
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--index', action='store', type=int, required=True, dest='index')

arg_parser.add_argument('--names', action='store', type=str, required=True, dest='names')


args = arg_parser.parse_args()
print(args)

id = args.id

index = args.index
names = json.loads(args.names)



for name in names:
    print(f"Hello, {names[index]}!")

