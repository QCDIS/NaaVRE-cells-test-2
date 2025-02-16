
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--greetings', action='store', type=str, required=True, dest='greetings')


args = arg_parser.parse_args()
print(args)

id = args.id

greetings = json.loads(args.greetings)



print(greetings)

