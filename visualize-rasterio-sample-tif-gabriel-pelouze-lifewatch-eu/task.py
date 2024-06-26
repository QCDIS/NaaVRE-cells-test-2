from matplotlib import pyplot
import rasterio
from rasterio.plot import show
from rasterio.plot import show_hist

import argparse
import papermill as pm

arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--download_done', action='store', type=str, required=True, dest='download_done')

arg_parser.add_argument('--filename', action='store', type=str, required=True, dest='filename')


args = arg_parser.parse_args()
print(args)

id = args.id
parameters = {}

download_done = args.download_done.replace('"','')
parameters['download_done'] = download_done
filename = args.filename.replace('"','')
parameters['filename'] = filename



pm.execute_notebook(
    'visualize-rasterio-sample-tif-gabriel-pelouze-lifewatch-eu.ipynb',
    'visualize-rasterio-sample-tif-gabriel-pelouze-lifewatch-eu-output.ipynb',
    prepare_only=True,
    parameters=dict(parameters)
)

