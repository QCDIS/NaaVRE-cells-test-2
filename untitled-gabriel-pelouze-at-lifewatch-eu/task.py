import acolite as ac

import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id




ac.acolite.acolite_run('./settings.txt', inputfile='./input/S2B_MSIL1C_20200704T104619_N0209_R051_T31UFU_20200704T125053.SAFE', output='./output')
foo = 1

import json
filename = "/tmp/foo_" + id + ".json"
file_foo = open(filename, "w")
file_foo.write(json.dumps(foo))
file_foo.close()
