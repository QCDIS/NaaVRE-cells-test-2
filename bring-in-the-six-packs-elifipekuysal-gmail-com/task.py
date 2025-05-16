
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--pd', action='store', type=str, required=True, dest='pd')


args = arg_parser.parse_args()
print(args)

id = args.id

pd = args.pd.replace('"','')



df_train = pd.read_csv('../input/train.csv')

