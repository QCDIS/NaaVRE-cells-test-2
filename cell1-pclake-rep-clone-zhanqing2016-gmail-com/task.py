
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id






Bifur_PLoads = [0.0001, 0.002,0.005] 
pclake_dirs = ["/tmp/data/scenario_a","/tmp/data/scenario_b","/tmp/data/scenario_c"]
pclake_dirs
for clone_dir in pclake_dirs:
    if not os.path.exists(clone_dir):
        os.makedirs(clone_dir) # Create the directory if it doesn't exist
    clone = "git clone https://github.com/NIOZ-QingZ/PCLake_NaaVRE.git"
    os.chdir(clone_dir) # Specifying the path where the cloned project needs to be copied
    os.system(clone) # Cloning

file_Bifur_PLoads = open("/tmp/Bifur_PLoads_" + id + ".json", "w")
file_Bifur_PLoads.write(json.dumps(Bifur_PLoads))
file_Bifur_PLoads.close()
file_pclake_dirs = open("/tmp/pclake_dirs_" + id + ".json", "w")
file_pclake_dirs.write(json.dumps(pclake_dirs))
file_pclake_dirs.close()
