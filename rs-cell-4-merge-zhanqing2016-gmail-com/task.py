
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--outputfilepaths_test', action='store', type=str, required=True, dest='outputfilepaths_test')


args = arg_parser.parse_args()
print(args)

id = args.id

outputfilepaths_test = json.loads(args.outputfilepaths_test)




print(outputfilepaths_test)

