from icoscp.cpauth.authentication import Authentication
from icoscp.cpb.dobj import Dobj
import matplotlib.pyplot as plt
import slugify

import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--dobj_list', action='store', type=str, required=True, dest='dobj_list')

arg_parser.add_argument('--param_cpauth_token', action='store', type=str, required=True, dest='param_cpauth_token')
arg_parser.add_argument('--param_variable', action='store', type=str, required=True, dest='param_variable')

args = arg_parser.parse_args()
print(args)

id = args.id

import json
dobj_list = json.loads(args.dobj_list)

param_cpauth_token = args.param_cpauth_token
param_variable = args.param_variable




Authentication(token=param_cpauth_token)

plot_files = []
for dobj_pid in dobj_list:
    dobj = Dobj(dobj_pid)
    unit = dobj.variables[dobj.variables.name == param_variable].unit.values[0]
    name = dobj.station['org']['name']
    uri = dobj.station['org']['self']['uri']
    title = f"{name} \n {uri}"
    plot = dobj.data.plot(x='TIMESTAMP', y=param_variable, grid=True, title=title)
    plot.set(ylabel=unit)
    filename = f'/tmp/data/{slugify.slugify(dobj_pid)}.pdf'
    plt.savefig(filename)
    plot_files.append(filename)
    plt.show()

plot_files

import json
filename = "/tmp/plot_files_" + id + ".json"
file_plot_files = open(filename, "w")
file_plot_files.write(json.dumps(plot_files))
file_plot_files.close()
