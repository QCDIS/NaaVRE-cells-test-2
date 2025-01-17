import pandas as pd

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id





df1 = pd.DataFrame({'PLoad': [1, 1, 1], 'Chla': [4, 5, 6]})
df2 = pd.DataFrame({'PLoad': [2, 2, 2], 'Chla': [10, 11, 12]})
df3 = pd.DataFrame({'PLoad': [3, 3, 3], 'Chla': [16, 17, 18]})

df_list = [df1, df2, df3]

for i, df in enumerate(df_list):
    print(f"DataFrame {i+1}:\n{df}\n")

P_loads = [1,2,3]

file_df_list = open("/tmp/df_list_" + id + ".json", "w")
file_df_list.write(json.dumps(df_list))
file_df_list.close()
