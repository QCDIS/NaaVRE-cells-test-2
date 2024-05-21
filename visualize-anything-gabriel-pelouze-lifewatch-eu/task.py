
import argparse
import papermill as pm

arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--anything', action='store', type=str, required=True, dest='anything')


args = arg_parser.parse_args()
print(args)

id = args.id
parameters = {}

anything = args.anything.replace('"','')
parameters['anything'] = anything



pm.execute_notebook(
    'task.ipynb',
    'task-output.ipynb',
    prepare_only=True,
    parameters=dict(parameters)
)

