
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id






dest_dir  = "/tmp/data/pclake_Naavre" 

clone = "git clone https://github.com/NIOZ-QingZ/PCModel.git"


os.chdir(dest_dir) # Specifying the path where the cloned project needs to be copied
os.system(clone) # Cloning

file_dest_dir = open("/tmp/dest_dir_" + id + ".json", "w")
file_dest_dir.write(json.dumps(dest_dir))
file_dest_dir.close()
