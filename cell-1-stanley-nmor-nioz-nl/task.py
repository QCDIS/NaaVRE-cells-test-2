from minio import Minio
import acolite as ac
import zipfile

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()

secret_s3_access_key = os.getenv('secret_s3_access_key')
secret_s3_secret_key = os.getenv('secret_s3_secret_key')

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--param_s3_server', action='store', type=str, required=True, dest='param_s3_server')

args = arg_parser.parse_args()
print(args)

id = args.id


param_s3_server = args.param_s3_server.replace('"','')



def download_satellite_from_minio(client = None, bucket_name = "naa-vre-waddenzee-shared",dir_path = "./", 
                                 filename = "S2A_MSIL1C_20150706T105016_N0204_R051_T31UFU_20150706T105351.SAFE"):
        """
    Utility function for downloading acolite output files from a miniO S3 Bucket to a local LTER directory 
    
    -----------------
    Example:
    local_path = "../tmp/data"
    download_acolite_from_minio(bucket_name = param_s3_public_bucket,  
                               dir_path = local_path, 
                               tile = "T31UFU", collection = "sentinel", year = 2023)
    """
        objects = client.list_objects(bucket_name, prefix=f"acolite_input/{filename}.zip",recursive = True)
        
        for obj in objects:
            filename = dir_path 
            print(filename)
            print(dir_path + obj.object_name)
            client.fget_object("naa-vre-waddenzee-shared", obj.object_name, dir_path + obj.object_name)
            
                

minio_client = Minio(param_s3_server, access_key=param_s3_access_key, secret_key=param_s3_secret_key, region = "nl", secure=True)
minio_client

download_satellite_from_minio(client=minio_client,
                              dir_path = "/tmp/data/")


with zipfile.ZipFile("/tmp/data/acolite_input/S2A_MSIL1C_20150706T105016_N0204_R051_T31UFU_20150706T105351.SAFE.zip", 'r') as zip_ref:
    zip_ref.extractall("/tmp/data/acolite_input/")
    print(f"Downloaded file unzipping completed!!!!") 

    
settings = {'limit': [52.5,4.7,53.50,5.4], 
            'inputfile': '/tmp/data/acolite_input/S2A_MSIL1C_20150706T105016_N0204_R051_T31UFU_20150706T105351.SAFE', 
            'output': '/tmp/data/acolite_output/S2A_MSIL1C_20150706T105016', 
            "cirrus_correction": True,
            'l2w_parameters' : ["rhow_*","rhos_*", "Rrs_*", "chl_oc3", "chl_re_gons", "chl_re_gons740", 
                                "chl_re_moses3b", "chl_re_moses3b740",  "chl_re_mishra", "chl_re_bramich", 
                                "ndci", "ndvi","spm_nechad2010"]}

ac.acolite.acolite_run(settings=settings)

