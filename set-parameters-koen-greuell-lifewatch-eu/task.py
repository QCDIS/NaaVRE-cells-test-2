
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id




param_secrets_file_path: str = "../secrets.yaml"
param_KMNI_key_name: str = "KNMI_OPEN_DATA_API_KEY"
param_incorrect_file_path: str = "../nonexistent_file.yaml"
param_polluted_file_path: str = "../polluted_secrets_file.yaml"
param_not_parsed_to_dict_file_path: str = "../secrets_not_in_yaml_format.yaml"

file_param_secrets_file_path = open("/tmp/param_secrets_file_path_" + id + ".json", "w")
file_param_secrets_file_path.write(json.dumps(param_secrets_file_path))
file_param_secrets_file_path.close()
file_param_KMNI_key_name = open("/tmp/param_KMNI_key_name_" + id + ".json", "w")
file_param_KMNI_key_name.write(json.dumps(param_KMNI_key_name))
file_param_KMNI_key_name.close()
file_param_incorrect_file_path = open("/tmp/param_incorrect_file_path_" + id + ".json", "w")
file_param_incorrect_file_path.write(json.dumps(param_incorrect_file_path))
file_param_incorrect_file_path.close()
file_param_polluted_file_path = open("/tmp/param_polluted_file_path_" + id + ".json", "w")
file_param_polluted_file_path.write(json.dumps(param_polluted_file_path))
file_param_polluted_file_path.close()
file_param_not_parsed_to_dict_file_path = open("/tmp/param_not_parsed_to_dict_file_path_" + id + ".json", "w")
file_param_not_parsed_to_dict_file_path.write(json.dumps(param_not_parsed_to_dict_file_path))
file_param_not_parsed_to_dict_file_path.close()
