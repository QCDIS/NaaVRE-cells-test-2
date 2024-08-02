
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--param_mem_per_pod_mb', action='store', type=int, required=True, dest='param_mem_per_pod_mb')
arg_parser.add_argument('--param_pod_count', action='store', type=int, required=True, dest='param_pod_count')

args = arg_parser.parse_args()
print(args)

id = args.id


param_mem_per_pod_mb = args.param_mem_per_pod_mb
param_pod_count = args.param_pod_count


pod_chunks = [param_mem_per_pod_mb] * param_pod_count
pod_chunks

file_pod_chunks = open("/tmp/pod_chunks_" + id + ".json", "w")
file_pod_chunks.write(json.dumps(pod_chunks))
file_pod_chunks.close()
