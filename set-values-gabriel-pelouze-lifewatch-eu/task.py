
import argparse
import json
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id




elements = ['element 1', 'element 2', 'element 3']

file_elements = open("/tmp/elements_" + id + ".json", "w")
file_elements.write(json.dumps(elements))
file_elements.close()
