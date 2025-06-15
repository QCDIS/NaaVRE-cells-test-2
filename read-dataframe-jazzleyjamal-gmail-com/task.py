import pandas as pd
import pathlib
import requests

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id





"""
download_discharge_csv.py
—————————
Grab `discharge.csv` from the Li-ion-battery digital-twin repo
and save it alongside your notebook / workflow step.

Usage (inside Jupyter or any Python-capable container):
    python download_discharge_csv.py   # saves into ./data/
"""


URL  = (
    "https://raw.githubusercontent.com/"
    "Javihaus/Digital-Twin-in-python/main/discharge.csv"
)
DEST_DIR = pathlib.Path("data")          # change if you prefer another folder
DEST_DIR.mkdir(parents=True, exist_ok=True)
DEST = DEST_DIR / "discharge.csv"

print(f"Downloading:\n  {URL}\n→ {DEST.resolve()}")

with requests.get(URL, stream=True, timeout=30) as resp:
    resp.raise_for_status()                      # die on 4xx / 5xx
    with open(DEST, "wb") as f:
        for chunk in resp.iter_content(65536):   # 64 KB chunks
            if chunk:                            # keep-alive chunks are empty
                f.write(chunk)

print(
    f"✅ Saved {DEST.name}  ({DEST.stat().st_size/1_048_576:.2f} MB)"
    "\nLoad it with:  pd.read_csv('data/discharge.csv')"
)


df = pd.read_csv('/app/data/discharge.csv')

file_df = open("/tmp/df_" + id + ".json", "w")
file_df.write(json.dumps(df))
file_df.close()
