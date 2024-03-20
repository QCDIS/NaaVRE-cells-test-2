
import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--param_test', action='store', type=list, required=True, dest='param_test')

args = arg_parser.parse_args()
print(args)

id = args.id


param_test = args.param_test


print(param_test)
for name in param_test:
    print(name)

