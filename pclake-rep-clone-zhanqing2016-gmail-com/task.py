
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

dest_dir  = "/tmp/data/PCLake_NaaVRE"
Bifur_PLoads = [0.0001, 0.002] 

file_dest_dir = open("/tmp/dest_dir_" + id + ".json", "w")
file_dest_dir.write(json.dumps(dest_dir))
file_dest_dir.close()
