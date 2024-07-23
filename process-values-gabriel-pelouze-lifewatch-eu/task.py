
import argparse
import json
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--elements', action='store', type=str, required=True, dest='elements')


args = arg_parser.parse_args()
print(args)

id = args.id

elements = json.loads(args.elements)



def process_element(element):
    print(element)

for element in elements:
    process_element(element)

