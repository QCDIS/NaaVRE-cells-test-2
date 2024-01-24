
import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--param_password', action='store', type=str, required=True, dest='param_password')

args = arg_parser.parse_args()
print(args)

id = args.id


param_password = args.param_password



print(param_password)

