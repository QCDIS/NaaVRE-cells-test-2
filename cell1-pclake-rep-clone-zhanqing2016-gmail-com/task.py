
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--end_PLoad', action='store', type=float, required=True, dest='end_PLoad')
arg_parser.add_argument('--num_elements', action='store', type=int, required=True, dest='num_elements')
arg_parser.add_argument('--start_PLoad', action='store', type=float, required=True, dest='start_PLoad')

args = arg_parser.parse_args()
print(args)

id = args.id


end_PLoad = args.end_PLoad
num_elements = args.num_elements
start_PLoad = args.start_PLoad




start = 0.0001
end = 0.008
num_elements = 5

Bifur_PLoads = np.linspace(start_PLoad, end_PLoad, num_elements)

Bifur_PLoads = np.round(Bifur_PLoads, 4).tolist()

print(Bifur_PLoads)

temp_clone_dir  = "/tmp/data" 
clone = "git clone https://github.com/NIOZ-QingZ/PCLake_NaaVRE.git"



Bifur_PLoads = [0.0001, 0.001, 0.002,0.003,0.004,0.005,0.006,0.007,0.008,0.009] 
pclake_dirs = ["/tmp/data/scenario_1", "/tmp/data/scenario_2", "/tmp/data/scenario_3",
              "/tmp/data/scenario_4", "/tmp/data/scenario_5", "/tmp/data/scenario_6",
              "/tmp/data/scenario_7", "/tmp/data/scenario_8", "/tmp/data/scenario_9",
              "/tmp/data/scenario_10","/tmp/data/scenario_1000"]
pclake_dirs
for clone_dir in pclake_dirs:
    if not os.path.exists(clone_dir):
        os.makedirs(clone_dir) # Create the directory if it doesn't exist
    shutil.copytree(temp_clone_dir, clone_dir, dirs_exist_ok=True) # copy the contents
    print("Repository copied to all specified directories.")

file_Bifur_PLoads = open("/tmp/Bifur_PLoads_" + id + ".json", "w")
file_Bifur_PLoads.write(json.dumps(Bifur_PLoads))
file_Bifur_PLoads.close()
