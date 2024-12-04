
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id




text: str = 'input text \n'
secret_text: str = 'do not containerize \n'

file_text = open("/tmp/text_" + id + ".json", "w")
file_text.write(json.dumps(text))
file_text.close()
