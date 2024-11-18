import acolite as ac
from dtAcolite import dtAcolite
import glob

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--path_id_batches', action='store', type=str, required=True, dest='path_id_batches')


args = arg_parser.parse_args()
print(args)

id = args.id

path_id_batches = json.loads(args.path_id_batches)




year = 2016
start_date = f"{year}-01-01"
end_date   = f"{year}-12-31"
data_collection = "SENTINEL-2"
product_type = "S2MSI1C"
aoi = "POLYGON((4.6 53.1, 4.9 53.1, 4.9 52.8, 4.6 52.8, 4.6 53.1))'"
collection = "sentinel"

app_configuration = dtAcolite.configure_acolite_directory(base_dir = "/tmp/data", year = year, collection = collection)
inputfilepaths = glob.glob(f"{app_configuration['acolite_inputdir']}/**")
outputfilepaths = glob.glob(f"{app_configuration['acolite_outputdir']}/**")
settings = {'limit': [52.5,4.7,53.50,5.4], 
            'inputfile': '', 
            'output': '', 
            "cirrus_correction": True,
            'l2w_parameters' : ["rhow_*","rhos_*", "Rrs_*", "chl_oc3", "chl_re_gons", "chl_re_gons740", 
                                "chl_re_moses3b", "chl_re_moses3b740",  "chl_re_mishra", "chl_re_bramich", 
                                "ndci", "ndvi","spm_nechad2010"]}

acolite_processing_batches = []
for path_id_batch in path_id_batches:
    acolite_processing_batch = []
    for i in path_id_batch:
        print("---------------------------------------------------------------------------------------")
        settings['inputfile'] = inputfilepaths[i]
        settings['output']    = outputfilepaths[i]
        ac.acolite.acolite_run(settings=settings)

        message = f"processing done and output is in {inputfilepaths[i]}"
        acolite_processing_batch.append(message)
    acolite_processing_batches.append(acolite_processing_batche)


print(acolite_processing_batches)

file_acolite_processing_batches = open("/tmp/acolite_processing_batches_" + id + ".json", "w")
file_acolite_processing_batches.write(json.dumps(acolite_processing_batches))
file_acolite_processing_batches.close()
