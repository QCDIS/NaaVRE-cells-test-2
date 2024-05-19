import glob
import os
import pandas as pd
import subprocess

import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--occ_data', action='store', type=str, required=True, dest='occ_data')

arg_parser.add_argument('--taxa_data', action='store', type=str, required=True, dest='taxa_data')

arg_parser.add_argument('--param_occurrences_delimiter', action='store', type=str, required=True, dest='param_occurrences_delimiter')
arg_parser.add_argument('--param_taxa_delimiter', action='store', type=str, required=True, dest='param_taxa_delimiter')

args = arg_parser.parse_args()
print(args)

id = args.id

occ_data = args.occ_data.replace('"','')
taxa_data = args.taxa_data.replace('"','')

param_occurrences_delimiter = args.param_occurrences_delimiter
param_taxa_delimiter = args.param_taxa_delimiter

conf_data_dir = '/tmp/data'


conf_data_dir = '/tmp/data'

alien_taxa = taxa_data
occurrences = occ_data

out = f"{conf_data_dir}"

syntax_output = f"{conf_data_dir}/syntax_out.zip"






input_gbif = occurrences
input_griss = alien_taxa

chunk_size = 500_000  # no of rows

work_dir = os.path.join(out, "to_zip")
occ_dir = os.path.join(out, "occ")
taxa_dir = os.path.join(out, "taxa")

os.makedirs(work_dir, exist_ok=True)
os.makedirs(occ_dir, exist_ok=True)
os.makedirs(taxa_dir, exist_ok=True)

def write_chunks(df, filename, create_file, chunk_normalization):
    for chunk in df:
        chunk = chunk_normalization(chunk)
        chunk.to_csv(
            filename, index=False, header=create_file, sep="\t", mode="w" if create_file else "a", encoding="utf-8"
        )
        create_file = False

taxa_files = []
occ_files = []

if input_gbif:
    subprocess.call(["unzip", input_gbif, "-d", occ_dir])
    occ_files = glob.glob(os.path.join(occ_dir, "occurrence*"))

    if not occ_files:
        print(
            "No files named `occurrence*` found in the occurrences zip. Assigning *all* contents as occurrences!"
        )
        occ_files = [os.path.join(occ_dir, f) for f in os.listdir(occ_dir)]

if input_griss:
    subprocess.call(["unzip", input_griss, "-d", taxa_dir])

    taxa_files = glob.glob(os.path.join(taxa_dir, "taxon*"))

    if not taxa_files:
        print("No files named `taxon*` found in the alien taxonomy zip. Assigning *all* contents as alien taxa!")
        taxa_files = [os.path.join(taxa_dir, f) for f in os.listdir(taxa_dir)]

print(f"Found {len(occ_files)} occurences files: {occ_files}")
print(f"Found {len(taxa_files)} alien species files: {taxa_files}")

for index in range(len(occ_files)):
    occ = occ_files[index]
    df = pd.read_csv(occ, sep=param_occurrences_delimiter, on_bad_lines="warn", chunksize=chunk_size)

    def occ_norm(df):
        if "coordinateUncertaintyInMeters" not in df.columns:
            print("No `coordinateUncertaintyInMeters` column was found. Assigning `-1` to all of them.")
            df["coordinateUncertaintyInMeters"] = -1
        else:
            print(
                f"{df['coordinateUncertaintyInMeters'].isna().sum()} row(s) have no value for `coordinateUncertaintyInMeters`. Assigning `-1` to all of them."
            )
            df["coordinateUncertaintyInMeters"].fillna(-1, inplace=True)

        return df

    write_chunks(df, os.path.join(work_dir, "occurrence.txt"), index == 0, occ_norm)

for index in range(len(taxa_files)):
    taxa = taxa_files[index]

    df = pd.read_csv(taxa, sep=param_taxa_delimiter, skip_blank_lines=True, on_bad_lines="warn", chunksize=chunk_size)

    def taxa_norm(df):
        if "taxonomicStatus" not in df.columns:
            print("No `taxonomicStatus` column was found. Assigning `ACCEPTED` to all of them.")
            df = df.assign(taxonomicStatus=lambda x: "ACCEPTED")
        else:
            print(
                f"{df['taxonomicStatus'].isna().sum()} row(s) have no value for `taxonomicStatus`. Assigning `ACCEPTED` to all of them."
            )
            df["taxonomicStatus"].fillna("ACCEPTED", inplace=True)

        if "speciesKey" not in df.columns and "nubKey" in df.columns:
            print("No `speciesKey` column was found. Setting it to `nubKey`.")
            df["speciesKey"] = df["nubKey"]

        if "taxonRank" in df.columns:
            print("Renaming `taxonRank` column to `rank`.")
            df = df.rename(columns={"taxonRank": "rank"})

        if "rank" in df.columns:
            print(
                f"{df['rank'].isna().sum()} row(s) have no value for `rank`. Assigning `SPECIES` to all of them."
            )
            df["rank"].fillna("SPECIES", inplace=True)

        if "nubKey" in df.columns:
            print(f"N-rows: {len(df.index)} ")

            missing_speciesKey_indices = df.loc[(df["nubKey"].isna()) | (df["nubKey"] == "NA")].index

            df.drop(missing_speciesKey_indices, inplace=True)

            print(f"Dropping rows with no or `NA` as `nubKey` values.")
            print(f"N-rows: {len(df.index)}")

        return df

    write_chunks(df, os.path.join(work_dir, "alientaxa.txt"), index == 0, taxa_norm)

subprocess.call(["zip", "-rj", os.path.join(out, "syntax_out.zip"), work_dir])

import json
filename = "/tmp/syntax_output_" + id + ".json"
file_syntax_output = open(filename, "w")
file_syntax_output.write(json.dumps(syntax_output))
file_syntax_output.close()
