
import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--minio_client', action='store', type=str, required=True, dest='minio_client')


args = arg_parser.parse_args()
print(args)

id = args.id

minio_client = args.minio_client.replace('"','')



print(minio_client)

