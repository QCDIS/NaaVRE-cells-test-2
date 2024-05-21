import matplotlib.pyplot as plt
from scipy.stats import norm
import numpy as np
import pandas as pd

import argparse
import papermill as pm

arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--forecasting_all_file', action='store', type=str, required=True, dest='forecasting_all_file')


args = arg_parser.parse_args()
print(args)

id = args.id
parameters = {}

forecasting_all_file = args.forecasting_all_file.replace('"','')
parameters['forecasting_all_file'] = forecasting_all_file



pm.execute_notebook(
    'task.ipynb',
    'task-output.ipynb',
    prepare_only=True,
    parameters=dict(parameters)
)

