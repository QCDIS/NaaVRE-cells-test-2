import matplotlib.pyplot as plt

import argparse
import papermill as pm

arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id
parameters = {}




pm.execute_notebook(
    'task.ipynb',
    'task-output.ipynb',
    prepare_only=True,
    parameters=dict(parameters)
)

import json
filename = "/tmp/x_" + id + ".json"
file_x = open(filename, "w")
file_x.write(json.dumps(x))
file_x.close()
