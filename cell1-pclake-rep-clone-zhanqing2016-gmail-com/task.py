
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id





clone_dir  = "/tmp/data" 

if os.path.exists(clone_dir):
    print(f"message:\n Positive. The dir ( {clone_dir} ) exist\n")
    if os.listdir(clone_dir):
        print(f"message:\n !WARNING! The dir ( {clone_dir} ) is not empty!\n Contents:\n")
        for filename in os.listdir(clone_dir): 
            print(filename)
        file_path = os.path.join(clone_dir, filename)
        try: 
            if os.path.isfile(file_path): 
                os.remove(file_path) # remove file
                print(f"{file_path} has been removed successfully\n")
            elif os.path.isdir(file_path): 
                shutil.rmtree(file_path) # remove directory
                print(f"{file_path} has been removed successfully\n")
            else:
                print(f"message:\n The dir ( {clone_dir} ) is empty.\n")
        except Exception as e:
            print(f"Failed to remove {file_path}: {e}\n")
else:
    print(f"message:\n Negative. The dir ( {clone_dir} ) does not exist, and is created\n")
    os.makedirs(clone_dir)

   
clone = "git clone https://github.com/NIOZ-QingZ/PCLake_NaaVRE.git"


os.chdir(clone_dir) # Specifying the path where the cloned project needs to be copied
os.system(clone) # Cloning

Bifur_PLoads = [0.0001, 0.001, 0.003, 0.005] # P loading in gP/m2/day

file_Bifur_PLoads = open("/tmp/Bifur_PLoads_" + id + ".json", "w")
file_Bifur_PLoads.write(json.dumps(Bifur_PLoads))
file_Bifur_PLoads.close()
