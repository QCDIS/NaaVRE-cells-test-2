
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id




names = ["Alice", "Bob"]
whole_numbers = [1,2]
decimal_numbers = [1.1, 2.1]
single_name = "Carlisle"
single_number = 3
single_decimal = 3.1

file_decimal_numbers = open("/tmp/decimal_numbers_" + id + ".json", "w")
file_decimal_numbers.write(json.dumps(decimal_numbers))
file_decimal_numbers.close()
file_names = open("/tmp/names_" + id + ".json", "w")
file_names.write(json.dumps(names))
file_names.close()
file_single_decimal = open("/tmp/single_decimal_" + id + ".json", "w")
file_single_decimal.write(json.dumps(single_decimal))
file_single_decimal.close()
file_single_name = open("/tmp/single_name_" + id + ".json", "w")
file_single_name.write(json.dumps(single_name))
file_single_name.close()
file_single_number = open("/tmp/single_number_" + id + ".json", "w")
file_single_number.write(json.dumps(single_number))
file_single_number.close()
file_whole_numbers = open("/tmp/whole_numbers_" + id + ".json", "w")
file_whole_numbers.write(json.dumps(whole_numbers))
file_whole_numbers.close()
