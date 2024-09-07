
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--outputfilepaths', action='store', type=str, required=True, dest='outputfilepaths')


args = arg_parser.parse_args()
print(args)

id = args.id

outputfilepaths = json.loads(args.outputfilepaths)




outputfilepaths_test = []

for path in outputfilepaths:
    temp_path = f"Hello, {path}!"
    outputfilepaths_test.append(temp_path)

file_outputfilepaths_test = open("/tmp/outputfilepaths_test_" + id + ".json", "w")
file_outputfilepaths_test.write(json.dumps(outputfilepaths_test))
file_outputfilepaths_test.close()
