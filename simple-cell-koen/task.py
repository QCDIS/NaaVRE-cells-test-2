
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--init_complete', action='store', type=str, required=True, dest='init_complete')


args = arg_parser.parse_args()
print(args)

id = args.id

init_complete = args.init_complete.replace('"','')



print(init_complete)

