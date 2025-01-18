import os
import shutil

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id






temp_clone_dir = "/tmp/data/temp_clone"

if not os.path.exists(temp_clone_dir):
    os.makedirs(temp_clone_dir)

clone = "git clone https://github.com/NIOZ-QingZ/PCLake_NaaVRE.git " 
os.chdir(temp_clone_dir) # Specifying the path where the cloned project needs to be copied
os.system(clone) # Cloning
    
    
pclake_dirs = ["/tmp/data/scenario_1", "/tmp/data/scenario_2", "/tmp/data/scenario_3",
              "/tmp/data/scenario_4", "/tmp/data/scenario_5", "/tmp/data/scenario_6",
              "/tmp/data/scenario_7", "/tmp/data/scenario_8", "/tmp/data/scenario_9",
              "/tmp/data/scenario_10"]

for clone_dir in pclake_dirs:
    if not os.path.exists(clone_dir):
        os.makedirs(clone_dir)  # Create the directory if it doesn't exist
    shutil.copytree(temp_clone_dir, clone_dir, dirs_exist_ok=True)  # Copy the contents
    print("Repository copied to all specified directories where it didn't already exist.")
    
Bifur_PLoads = [0.0001, 0.001,0.003,0.005]     

file_Bifur_PLoads = open("/tmp/Bifur_PLoads_" + id + ".json", "w")
file_Bifur_PLoads.write(json.dumps(Bifur_PLoads))
file_Bifur_PLoads.close()
