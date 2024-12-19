
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id




filename = '/tmp/data/test.txt'
with open(filename, 'w') as f:
    f.write('test')

file_filename = open("/tmp/filename_" + id + ".json", "w")
file_filename.write(json.dumps(filename))
file_filename.close()
