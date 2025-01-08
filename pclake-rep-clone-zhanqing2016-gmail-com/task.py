
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()

secret_github_auth_token = os.getenv('secret_github_auth_token')

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id






wd_path  = "/tmp/data/pclake_Naavre" 

clone = "git clone https://github.com/NIOZ-QingZ/PCModel.git"


os.chdir(wd_path) # Specifying the path where the cloned project needs to be copied
os.system(clone) # Cloning

file_wd_path = open("/tmp/wd_path_" + id + ".json", "w")
file_wd_path.write(json.dumps(wd_path))
file_wd_path.close()
