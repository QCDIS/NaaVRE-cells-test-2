
import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id




filename = '/tmp/data/my_file.csv'
with open(filename, 'w') as f:
    f.write('file content')

import json
filename = "/tmp/filename_" + id + ".json"
file_filename = open(filename, "w")
file_filename.write(json.dumps(filename))
file_filename.close()
