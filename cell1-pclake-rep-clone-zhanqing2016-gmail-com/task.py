
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id





clone_dir  = "/tmp/data" 

if not os.path.exists(clone_dir):
    os.makedirs(clone_dir)
    
clone = "git clone https://github.com/NIOZ-QingZ/PCLake_NaaVRE.git"


os.chdir(clone_dir) # Specifying the path where the cloned project needs to be copied
os.system(clone) # Cloning


file_Bifur_PLoads = open("/tmp/Bifur_PLoads_" + id + ".json", "w")
file_Bifur_PLoads.write(json.dumps(Bifur_PLoads))
file_Bifur_PLoads.close()
