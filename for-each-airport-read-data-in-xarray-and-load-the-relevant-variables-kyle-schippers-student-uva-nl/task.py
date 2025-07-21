import io
import json
import requests
import xarray as xr

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--airports', action='store', type=str, required=True, dest='airports')

arg_parser.add_argument('--parameters', action='store', type=str, required=True, dest='parameters')

arg_parser.add_argument('--variables', action='store', type=str, required=True, dest='variables')

arg_parser.add_argument('--param_end', action='store', type=str, required=True, dest='param_end')
arg_parser.add_argument('--param_start', action='store', type=str, required=True, dest='param_start')

args = arg_parser.parse_args()
print(args)

id = args.id

airports = args.airports.replace('"','')
parameters = json.loads(args.parameters)
variables = json.loads(args.variables)

param_end = args.param_end.replace('"','')
param_start = args.param_start.replace('"','')


url="https://services.iagos-data.fr/prod/v2.0/l3/search?codes="+airports+"&from="+param_start+"&to="+param_end+"&level=2&parameters="+parameters
print(url)
response=requests.get(url)
data = json.loads(response.text)
datasets = {}
for dataset in data:
    datasets[dataset['title']] = dataset

dataset=datasets['IAGOS Daily median profiles at FRA, Frankfurt, Germany airport (FRA)']
url = None
for _url_info in dataset['urls']:
    if _url_info['type'].upper() == 'LANDING_PAGE':
        url = _url_info['url']
urlDl="https://services.iagos-data.fr/prod/v2.0/l3/loadNetcdfFile?fileId=" + url.replace("#", "%23")
print(urlDl)
response = requests.get(urlDl)
response.raise_for_status()
with io.BytesIO(response.content) as buf:
    with xr.open_dataset(buf) as ds:
        varlist = []
        for varname, da in ds.data_vars.items():
            if 'standard_name' not in da.attrs:
                continue
            std_name = da.attrs['standard_name']
            if std_name in variables:
                varlist.append(varname)
        ds = ds[varlist].load()
for var in ds.data_vars:
    varData = ds.get(var)[0]
    print(varData)
    varPlot = varData.sel(time=slice(param_start, param_end))
    varPlot.plot()

