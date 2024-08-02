import time

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--pod_chunks', action='store', type=str, required=True, dest='pod_chunks')


args = arg_parser.parse_args()
print(args)

id = args.id

pod_chunks = json.loads(args.pod_chunks)




arrays = []
for chunk_size_mb in pod_chunks:
    chunk_size_bytes = int(chunk_size_mb * 1024**2)
    a = bytearray(chunk_size_bytes)
    arrays.append(a)
    print(f'Allocated {len(a) / 1024**2} MiB')
    
while True:
    time.sleep(10)

