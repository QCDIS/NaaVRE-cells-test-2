import pandas as pd

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--data', action='store', type=str, required=True, dest='data')


args = arg_parser.parse_args()
print(args)

id = args.id

data = json.loads(args.data)



df = pd.DataFrame.from_dict(data, orient='records')
df = df[df['Battery'] == 'B0005']
df = df[df['Temperature_measured'] > 36] #choose battery B0005
dfb = df.groupby(['id_cycle']).max()
dfb['Cumulated_T'] = dfb['Time'].cumsum()
dfbrecords  = dfb.to_dict(orient="records")           # list[dict]

file_dfb = open("/tmp/dfb_" + id + ".json", "w")
file_dfb.write(json.dumps(dfb))
file_dfb.close()
