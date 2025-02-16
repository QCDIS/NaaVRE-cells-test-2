
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--names', action='store', type=str, required=True, dest='names')

arg_parser.add_argument('--param_greeting_template', action='store', type=str, required=True, dest='param_greeting_template')

args = arg_parser.parse_args()
print(args)

id = args.id

names = json.loads(args.names)

param_greeting_template = args.param_greeting_template.replace('"','')


greetings = []
for name in names:
    greetings.append(param_greeting_template.format(name))

file_greetings = open("/tmp/greetings_" + id + ".json", "w")
file_greetings.write(json.dumps(greetings))
file_greetings.close()
