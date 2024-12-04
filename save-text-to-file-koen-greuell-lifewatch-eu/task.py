
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--conf_fixed_text', action='store', type=str, required=True, dest='conf_fixed_text')

arg_parser.add_argument('--param_n_prints', action='store', type=int, required=True, dest='param_n_prints')

arg_parser.add_argument('--text', action='store', type=str, required=True, dest='text')


args = arg_parser.parse_args()
print(args)

id = args.id

conf_fixed_text = args.conf_fixed_text.replace('"','')
param_n_prints = args.param_n_prints
text = args.text.replace('"','')



def write_to_file(filename, content):
  """Writes the given content to a file.

  Args:
    filename: The name of the file to create.
    content: The content to write to the file.
  """

  with open(filename, 'w') as f:
    f.write(content)

concatenated_string: str = ''
for i in list(range(param_n_prints)):
    concatenated_string += text
concatenated_string += conf_fixed_text

write_to_file('output.txt', concatenated_string)

