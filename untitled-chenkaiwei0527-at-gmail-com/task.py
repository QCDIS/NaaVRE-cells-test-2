
import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--param_S1', action='store', type=str, required=True, dest='param_S1')

args = arg_parser.parse_args()
print(args)

id = args.id


param_S1 = args.param_S1


print(param_S1+"KK")

