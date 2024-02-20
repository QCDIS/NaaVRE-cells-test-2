import requests as req

import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id





url = "https://www.example.com"
response = req.get(url)

import json
filename = "/tmp/response_" + id + ".json"
file_response = open(filename, "w")
file_response.write(json.dumps(response))
file_response.close()
