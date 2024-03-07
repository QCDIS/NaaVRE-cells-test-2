import acolite as ac

import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--input_dirs', action='store', type=str, required=True, dest='input_dirs')


args = arg_parser.parse_args()
print(args)

id = args.id

import json
input_dirs = json.loads(args.input_dirs)


conf_data_dir = '/tmp/data'


conf_data_dir = '/tmp/data'


output_dirs = []

for input_dir in input_dirs:
    output_dir = input_dir.removesuffix('.SAFE')
    ac.acolite.acolite_run(
        './settings.txt',
        inputfile=f"{conf_data_dir}/input/{input_dir}",
        output=f"{conf_data_dir}/acolite-output/{output_dir}",
    )
    output_dirs.append(output_dir)

import json
filename = "/tmp/output_dirs_" + id + ".json"
file_output_dirs = open(filename, "w")
file_output_dirs.write(json.dumps(output_dirs))
file_output_dirs.close()
