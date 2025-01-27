
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id




vtFeTZZw = 1

file_vtFeTZZw = open("/tmp/vtFeTZZw_" + id + ".json", "w")
file_vtFeTZZw.write(json.dumps(vtFeTZZw))
file_vtFeTZZw.close()
