import random
import string

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id




random_string = ''.join(random.choice(string.ascii_letters) for i in range(20))
print(random_string)

file_random_string = open("/tmp/random_string_" + id + ".json", "w")
file_random_string.write(json.dumps(random_string))
file_random_string.close()
