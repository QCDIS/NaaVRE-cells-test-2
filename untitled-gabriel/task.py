
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id




msg = "msg"

file_msg = open("/tmp/msg_" + id + ".json", "w")
file_msg.write(json.dumps(msg))
file_msg.close()
