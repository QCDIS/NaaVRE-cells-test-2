
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--secret_text', action='store', type=str, required=True, dest='secret_text')


args = arg_parser.parse_args()
print(args)

id = args.id

secret_text = args.secret_text.replace('"','')



def create_text():
    return secret_text

created_text: str = create_text()

file_created_text = open("/tmp/created_text_" + id + ".json", "w")
file_created_text.write(json.dumps(created_text))
file_created_text.close()
