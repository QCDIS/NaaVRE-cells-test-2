
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id




variable_to_exchange = "mimami"

file_variable_to_exchange = open("/tmp/variable_to_exchange_" + id + ".json", "w")
file_variable_to_exchange.write(json.dumps(variable_to_exchange))
file_variable_to_exchange.close()
