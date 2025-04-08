
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id








    

occ_taxa = "BioDT-demo-biotope/data/input/Cimpal_resources/occurrence.txt"#f"{conf_data_dir}/input/Cimpal_resources"
biotope_shp_path_file = "BioDT-demo-biotope/data/input/Cimpal_resources/shapefiles_cimpal.zip"#f"{conf_data_dir}/input/Cimpal_resources"
weight_file = "BioDT-demo-biotope/data/input/Cimpal_resources/weight_wp.csv"#f"{conf_data_dir}/input/Cimpal_resources/weight_wp.csv"
pathway_file = "BioDT-demo-biotope/data/input/Cimpal_resources/CIMPAL_paths.csv"#f"{conf_data_dir}/input/Cimpal_resources/CIMPAL_paths.csv"
zones_file = "BioDT-demo-biotope/data/input/zones" #f"{conf_data_dir}/input/zones"

print("occ_taxa:", occ_taxa)
print("biotope_shp_path_file:", biotope_shp_path_file)
print("weight_file:", weight_file)
print("pathway_file:", pathway_file)
print("zones_file:", zones_file)

file_occ_taxa = open("/tmp/occ_taxa_" + id + ".json", "w")
file_occ_taxa.write(json.dumps(occ_taxa))
file_occ_taxa.close()
file_biotope_shp_path_file = open("/tmp/biotope_shp_path_file_" + id + ".json", "w")
file_biotope_shp_path_file.write(json.dumps(biotope_shp_path_file))
file_biotope_shp_path_file.close()
file_weight_file = open("/tmp/weight_file_" + id + ".json", "w")
file_weight_file.write(json.dumps(weight_file))
file_weight_file.close()
file_pathway_file = open("/tmp/pathway_file_" + id + ".json", "w")
file_pathway_file.write(json.dumps(pathway_file))
file_pathway_file.close()
file_zones_file = open("/tmp/zones_file_" + id + ".json", "w")
file_zones_file.write(json.dumps(zones_file))
file_zones_file.close()
