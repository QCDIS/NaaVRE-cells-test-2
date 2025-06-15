import plotly.express as px

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--dfb', action='store', type=str, required=True, dest='dfb')


args = arg_parser.parse_args()
print(args)

id = args.id

dfb = json.loads(args.dfb)



fig = px.scatter_matrix(dfb.drop(columns=['Time','type', 'ambient_temperature', 
                                          'time', 'Battery']), 
                                )
fig.update_traces(marker=dict(size=2,
                              color='crimson',
                              symbol='square')),
fig.update_traces(diagonal_visible=False)
fig.update_layout(
    title='Battery dataset',
    width=900,
    height=1200,
)
fig.update_layout({'plot_bgcolor': '#f2f8fd',
                   'paper_bgcolor': 'white',}, 
                    template='plotly_white',
                    font=dict(size=7)
                    )

fig.show()

