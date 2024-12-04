
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id




param_n_prints: int = 3
conf_fixed_text: str = 'this is a configured text \n' 
secret_text: str = 'do not containerize \n'

file_param_n_prints = open("/tmp/param_n_prints_" + id + ".json", "w")
file_param_n_prints.write(json.dumps(param_n_prints))
file_param_n_prints.close()
file_conf_fixed_text = open("/tmp/conf_fixed_text_" + id + ".json", "w")
file_conf_fixed_text.write(json.dumps(conf_fixed_text))
file_conf_fixed_text.close()
file_secret_text = open("/tmp/secret_text_" + id + ".json", "w")
file_secret_text.write(json.dumps(secret_text))
file_secret_text.close()
