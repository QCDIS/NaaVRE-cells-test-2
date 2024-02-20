import matplotlib.pyplot as plt

import argparse
arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id





x_values = [1, 2, 3, 4, 5]
y_values = [2, 4, 6, 8, 10]

plt.plot(x_values, y_values, label='Linear Function')

plt.xlabel('X-axis')
plt.ylabel('Y-axis')
plt.title('Simple Linear Plot')

plt.legend()

plt.show()

import json
filename = "/tmp/x_values_" + id + ".json"
file_x_values = open(filename, "w")
file_x_values.write(json.dumps(x_values))
file_x_values.close()
