
import argparse
import papermill as pm

arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--Fig_Qrobur', action='store', type=str, required=True, dest='Fig_Qrobur')

arg_parser.add_argument('--forecasting_plot', action='store', type=str, required=True, dest='forecasting_plot')

arg_parser.add_argument('--validation_plot_all', action='store', type=str, required=True, dest='validation_plot_all')


args = arg_parser.parse_args()
print(args)

id = args.id
parameters = {}

Fig_Qrobur = args.Fig_Qrobur.replace('"','')
parameters['Fig_Qrobur'] = Fig_Qrobur
forecasting_plot = args.forecasting_plot.replace('"','')
parameters['forecasting_plot'] = forecasting_plot
validation_plot_all = args.validation_plot_all.replace('"','')
parameters['validation_plot_all'] = validation_plot_all



pm.execute_notebook(
    'visualize-veluwe-output-gabriel-pelouze-lifewatch-eu.ipynb',
    'visualize-veluwe-output-gabriel-pelouze-lifewatch-eu-output.ipynb',
    prepare_only=True,
    parameters=dict(parameters)
)

