from minio import Minio
import h5py
import json
import os
import pandas as pd
import pathlib
import re
import subprocess
import sys

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--odim_pvol_paths', action='store', type=str, required=True, dest='odim_pvol_paths')

arg_parser.add_argument('--param_clean_pvol_output', action='store', type=str, required=True, dest='param_clean_pvol_output')
arg_parser.add_argument('--param_clean_vp_output', action='store', type=str, required=True, dest='param_clean_vp_output')
arg_parser.add_argument('--param_minio_access_key', action='store', type=str, required=True, dest='param_minio_access_key')
arg_parser.add_argument('--param_minio_endpoint', action='store', type=str, required=True, dest='param_minio_endpoint')
arg_parser.add_argument('--param_minio_secret_key', action='store', type=str, required=True, dest='param_minio_secret_key')
arg_parser.add_argument('--param_minio_user_vp_output_prefix', action='store', type=str, required=True, dest='param_minio_user_vp_output_prefix')
arg_parser.add_argument('--param_upload_results', action='store', type=str, required=True, dest='param_upload_results')

args = arg_parser.parse_args()
print(args)

id = args.id

odim_pvol_paths = json.loads(args.odim_pvol_paths)

param_clean_pvol_output = args.param_clean_pvol_output.replace('"','')
param_clean_vp_output = args.param_clean_vp_output.replace('"','')
param_minio_access_key = args.param_minio_access_key.replace('"','')
param_minio_endpoint = args.param_minio_endpoint.replace('"','')
param_minio_secret_key = args.param_minio_secret_key.replace('"','')
param_minio_user_vp_output_prefix = args.param_minio_user_vp_output_prefix.replace('"','')
param_upload_results = args.param_upload_results.replace('"','')

conf_local_radar_db = '/tmp/data/conf/OPERA_RADARS_DB.json'

conf_local_vp = '/tmp/data/vp'

conf_minio_user_bucket_name = 'naa-vre-user-data'


conf_local_radar_db = '/tmp/data/conf/OPERA_RADARS_DB.json'
conf_local_vp = '/tmp/data/vp'
conf_minio_user_bucket_name = 'naa-vre-user-data'

def str2bool(v):
    if isinstance(v, bool):
        return v
    if v.lower() in ("yes", "true", "t", "y", "1"):
        return True
    elif v.lower() in ("no", "false", "f", "n", "0"):
        return False
    else:
        raise Exception
def load_radar_db(radar_db_path):
    """Load and return the radar database
    Output dict sample (wmo code is used as key):
    {
        11038: {'number': '1209', 'country': 'Austria', 'countryid': 'LOWM41', 'oldcountryid': 'OS41', 'wmocode': '11038', 'odimcode': 'atrau', 'location': 'Wien/Schwechat', 'status': '1', 'latitude': '48.074', 'longitude': '16.536', 'heightofstation': ' ', 'band': 'C', 'doppler': 'Y', 'polarization': 'D', 'maxrange': '224', 'startyear': '1978', 'heightantenna': '224', 'diametrantenna': ' ', 'beam': ' ', 'gain': ' ', 'frequency': '5.625', 'single_rrr': 'Y', 'composite_rrr': 'Y', 'wrwp': 'Y'},
        11052: {'number': '1210', 'country': 'Austria', 'countryid': 'LOWM43', 'oldcountryid': 'OS43', 'wmocode': '11052', 'odimcode': 'atfel', 'location': 'Salzburg/Feldkirchen', 'status': '1', 'latitude': '48.065', 'longitude': '13.062', 'heightofstation': ' ', 'band': 'C', 'doppler': 'Y', 'polarization': 'D', 'maxrange': '224', 'startyear': '1992', 'heightantenna': '581', 'diametrantenna': ' ', 'beam': ' ', 'gain': ' ', 'frequency': '5.6', 'single_rrr': 'Y', 'composite_rrr': ' ', 'wrwp': ' '},
        ...
    }
    """
    with open(
        radar_db_path, mode="r"
    ) as f:
        radar_db_json = json.load(f)
    radar_db = {}
    for radar_dict in radar_db_json:
        try:
            wmo_code = int(radar_dict.get("wmocode"))
            radar_db.update({wmo_code: radar_dict})
        except Exception:  # Happens when there is for ex. no wmo code.
            pass
    return radar_db
def translate_wmo_odim(radar_db, wmo_code):
    """"""
    if not isinstance(wmo_code, int):
        raise ValueError("Expecting a wmo_code [int]")
    else:
        pass
    odim_code = (
        radar_db.get(wmo_code).get("odimcode").upper().strip()
    )  # Apparently, people sometimes forget to remove whitespace..
    return odim_code
def extract_wmo_code(in_path):
    with h5py.File(in_path, "r") as f:
        what = f["what"].attrs
        source = what.get("source")
        source = source.decode("utf-8")
        source_list = source.split(sep=",")
    wmo_code = [string for string in source_list if "WMO" in string]
    if len(wmo_code) == 1:
        wmo_code = wmo_code[0]
        wmo_code = wmo_code.replace("WMO:", "")
    elif len(wmo_code) == 0:
        rad_str = [string for string in source_list if "RAD" in string]
        if len(rad_str) == 1:
            rad_str = rad_str[0]
        else:
            print(
                "Something went wrong with determining the rad_str and it wasnt WMO either, exiting"
            )
            sys.exit(1)
        rad_str_split = rad_str.split(":")
        rad_code = rad_str_split[1]
        rad_codes = {"NL52": "6356", "NL51": "6234", "NL50": "6260"}
        wmo_code = rad_codes.get(rad_code)
    return int(wmo_code)
def vol2bird(in_file, out_dir, radar_db, add_version=True, add_sector=False, overwrite = False):
    date_regex = "([0-9]{8})"
    if add_version == True:
        version = "v0-3-20"
        suffix = pathlib.Path(in_file).suffix
        in_file_name = pathlib.Path(in_file).name
        in_file_stem = pathlib.Path(in_file_name).stem
        out_file_name = in_file_stem.replace("pvol", "vp")
        out_file_name = "_".join([out_file_name, version]) + suffix
        wmo = extract_wmo_code(in_file)
        odim = translate_wmo_odim(radar_db, wmo)
        datetime = pd.to_datetime(re.search(date_regex, out_file_name)[0])
        ibed_path = "/".join(
            [
                odim[:2],
                odim[2:],
                str(datetime.year),
                str(datetime.month).zfill(2),
                str(datetime.day).zfill(2),
            ]
        )
        out_file = "/".join([out_dir, ibed_path, out_file_name])
        out_file_dir = pathlib.Path(out_file).parent
        if not out_file_dir.exists():
            out_file_dir.mkdir(parents=True)
    
    process = False
    if not overwrite:
        if not pathlib.Path(out_file).exists():
            process = True
            print(f"Not processing, overwrite is set to {overwrite}")
    else:
        process = True

    if process:
        command = ["vol2bird", in_file, out_file]
        result = subprocess.run(command, stdout=subprocess.DEVNULL, stderr = subprocess.STDOUT)
    return [in_file, out_file]

vertical_profile_paths = []
radar_db = load_radar_db(conf_local_radar_db)
odim_pvol_paths = [pathlib.Path(path) for path in odim_pvol_paths]
for odim_pvol_path in odim_pvol_paths:
    pvol_path, vp_path = vol2bird(odim_pvol_path, conf_local_vp, radar_db, overwrite = False)
    vertical_profile_paths.append(vp_path)
print(vertical_profile_paths)

if str2bool(param_clean_pvol_output):
    print("Removing PVOL output from local storage")
    for pvol_path in odim_pvol_paths:
        pathlib.Path(pvol_path).unlink()
        if not any(pathlib.Path(pvol_path).parent.iterdir()):
                   pathlib.Path(pvol_path).parent.rmdir()

if str2bool(param_upload_results):
    minioClient = Minio(endpoint = param_minio_endpoint,
                    access_key = param_minio_access_key,
                    secret_key = param_minio_secret_key,
                    secure = True)
    print(f"Uploading results to {param_minio_user_vp_output_prefix}")
    for vp_path in vertical_profile_paths:
        vp_path = pathlib.Path(vp_path)
        local_vp_storage = pathlib.Path(conf_local_vp)
        relative_path = vp_path.relative_to(local_vp_storage)
        remote_vp_path = param_minio_user_vp_output_prefix.joinpath(relative_path)
        exists = False
        try:
            _ = minioClient.stat_object(bucket = conf_minio_user_bucket_name,
                                    prefix = remote_vp_path)
            exists = True
        except:
            pass
        if not exists:
            print(f"Uploading {vp_path} to {remote_vp_path}")
            with open(vp_path, mode="rb") as file_data:
                        file_stat = os.stat(vp_path)
                        minioClient.put_object(
                            bucket_name=conf_minio_user_bucket_name,
                            object_name=remote_vp_path,
                            data=file_data,
                            length=file_stat.st_size,
                        )
        else:
            print(f"{remote_vp_path} exists, skipping ")
    print("Finished uploading results")
if str2bool(param_clean_vp_output):
    print("Removing VP output from local storage")
    for vp_path in vertical_profile_paths:
        pathlib.Path(vp_path).unlink()
        if not any(pathlib.Path(vp_path).parent.iterdir()):
                   pathlib.Path(vp_path).parent.rmdir()
    

