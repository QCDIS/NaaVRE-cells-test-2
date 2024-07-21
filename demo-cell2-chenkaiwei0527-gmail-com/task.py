
import argparse
import json
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--l1', action='store', type=str, required=True, dest='l1')


args = arg_parser.parse_args()
print(args)

id = args.id

l1 = json.loads(args.l1)



for l in l1:
    print(l)

