
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--conf_fixed_text', action='store', type=str, required=True, dest='conf_fixed_text')

arg_parser.add_argument('--param_n_prints', action='store', type=int, required=True, dest='param_n_prints')

arg_parser.add_argument('--secret_key', action='store', type=str, required=True, dest='secret_key')


args = arg_parser.parse_args()
print(args)

id = args.id

conf_fixed_text = args.conf_fixed_text.replace('"','')
param_n_prints = args.param_n_prints
secret_key = args.secret_key.replace('"','')



def key_is_correct() -> bool:
    return secret_key is not None

def write_to_file(filename, content):
  """Writes the given content to a file.

  Args:
    filename: The name of the file to create.
    content: The content to write to the file.
  """

  with open(filename, 'w') as f:
    f.write(content)

if key_is_correct():
    text_for_file: str = ''
    for i in list(range(param_n_prints)):
        text_for_file += conf_fixed_text

    write_to_file('output.txt', text_for_file)
else:
    write_to_file('output.txt', 'incorrect input')

