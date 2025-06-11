import numpy as np

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id




n = int(np.random.random())

file_n = open("/tmp/n_" + id + ".json", "w")
file_n.write(json.dumps(n))
file_n.close()
