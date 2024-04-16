
import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id




x_output=[1,2,3,4,5,6,7,8,9,10]

import json
filename = "/tmp/x_output_" + id + ".json"
file_x_output = open(filename, "w")
file_x_output.write(json.dumps(x_output))
file_x_output.close()
