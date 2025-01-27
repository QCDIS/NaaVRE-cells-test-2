
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id




secret_number1: int = 2
secret_number2 = 3

file_secret_number1 = open("/tmp/secret_number1_" + id + ".json", "w")
file_secret_number1.write(json.dumps(secret_number1))
file_secret_number1.close()
