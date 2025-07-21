import json
import matplotlib.pyplot as plt
import requests
import tempfile
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



url = (
    "https://services.iagos-data.fr/prod/v2.0/l3/search?codes="
    + airports
    + "&from="
    + param_start
    + "&to="
    + param_end
    + "&level=2&parameters="
    + parameters
)
print(url)

response = requests.get(url)
data = json.loads(response.text)
datasets = {dataset['title']: dataset for dataset in data}

dataset = datasets['IAGOS Daily median profiles at FRA, Frankfurt, Germany airport (FRA)']

file_url = next(
    _url_info['url']
    for _url_info in dataset['urls']
    if _url_info['type'].upper() == 'LANDING_PAGE'
)

urlDl = "https://services.iagos-data.fr/prod/v2.0/l3/loadNetcdfFile?fileId=" + file_url.replace("#", "%23")
print(urlDl)

response = requests.get(urlDl)
response.raise_for_status()

with tempfile.NamedTemporaryFile(suffix=".nc") as tmp:
    tmp.write(response.content)
    tmp.flush()

    with xr.open_dataset(tmp.name, engine="netcdf4") as ds:
        varlist = []
        for varname, da in ds.data_vars.items():
            if 'standard_name' not in da.attrs:
                continue
            if da.attrs['standard_name'] in variables:
                varlist.append(varname)
        ds = ds[varlist].load()

for var in ds.data_vars:
    varData = ds.get(var)[0]  # Level 0 (surface)
    print(varData)
    varPlot = varData.sel(time=slice(param_start, param_end))
    varPlot.plot()
    plt.title(f"{var} at FRA")
    plt.show()

