from itertools import chain

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--acolite_processing_batches', action='store', type=str, required=True, dest='acolite_processing_batches')


args = arg_parser.parse_args()
print(args)

id = args.id

acolite_processing_batches = json.loads(args.acolite_processing_batches)




acolite_processing = list(chain(*acolite_processing_batches))
print(acolite_processing)

acolite_processing

