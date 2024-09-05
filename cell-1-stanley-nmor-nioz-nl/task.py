
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id




dictionary = {"one" : 1, 
             "two": 2}

file_dictionary = open("/tmp/dictionary_" + id + ".json", "w")
file_dictionary.write(json.dumps(dictionary))
file_dictionary.close()
