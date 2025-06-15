import pandas as pd

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id




df = pd.read_csv('/tmp/data/discharge.csv')

file_df = open("/tmp/df_" + id + ".json", "w")
file_df.write(json.dumps(df))
file_df.close()
