import torch
import torch.nn as nn

import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id





linear_layer = nn.Linear(in_features=3, out_features=1)

input_data = torch.tensor([[1.0, 2.0, 3.0]])

output = str(linear_layer(input_data))

import json
filename = "/tmp/output_" + id + ".json"
file_output = open(filename, "w")
file_output.write(json.dumps(output))
file_output.close()
