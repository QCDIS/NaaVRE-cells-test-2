
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id




text: str = 'input text'
secret_text: str = 'do not containerize'

file_text = open("/tmp/text_" + id + ".json", "w")
file_text.write(json.dumps(text))
file_text.close()
file_secret_text = open("/tmp/secret_text_" + id + ".json", "w")
file_secret_text.write(json.dumps(secret_text))
file_secret_text.close()
