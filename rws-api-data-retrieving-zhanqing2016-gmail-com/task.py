import csv
from datetime import datetime
import pytz
import requests

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--RWSstations', action='store', type=str, required=True, dest='RWSstations')


args = arg_parser.parse_args()
print(args)

id = args.id

RWSstations = json.loads(args.RWSstations)




station_info = RWSstations[0]
station_name = station_info["Code"]




collect_catalogus = ('https://waterwebservices.rijkswaterstaat.nl/ONLINEWAARNEMINGENSERVICES_DBO/OphalenWaarnemingen')
request = {
    "Locatie": {"Code": station_info["Code"], "X": station_info["X"], "Y": station_info["Y"]},
    "AquoPlusWaarnemingMetadata": {
        "AquoMetadata": {"Compartiment": {"Code": "OW"}, "Grootheid": {"Code": "CONCTTE"},"Parameter":{"Code": "CHLFa"}},
        "WaarnemingMetadata": {"KwaliteitswaardecodeLijst": ["00", "10", "20", "25", "30", "40"]}
    },
    "Periode": {
        "Begindatumtijd": "2021-01-01T08:00:00.000+01:00",
        "Einddatumtijd": "2021-12-31T23:00:00.000+01:00"
    }
}
resp = requests.post(collect_catalogus, json=request)
elements = resp.json()



rws_file_path = f"/tmp/data/{station_name}_Chl_2021.csv"
rws_file_path

with open(rws_file_path, mode='w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['datetime','LocatieCode', 'latitude', 'longitude', 'CompartimentCode', 'GrootheidCode', 'Chl'])

    for waarnemingen in elements['WaarnemingenLijst']:
        locatie_code = request['Locatie']['Code']
        x = request['Locatie']['X']
        y = request['Locatie']['Y']
        compartiment_code = request['AquoPlusWaarnemingMetadata']['AquoMetadata']['Compartiment']['Code']
        grootheid_code = request['AquoPlusWaarnemingMetadata']['AquoMetadata']['Grootheid']['Code']


        for lijst in waarnemingen['MetingenLijst']:
            waarde_numeriek = lijst['Meetwaarde']['Waarde_Numeriek']
            
            Tijdstip=lijst['Tijdstip']
            
            dt = datetime.fromisoformat(Tijdstip)
            cet = pytz.timezone('CET')
            dt_cet = dt.astimezone(cet)
            formatted_time = dt_cet.strftime('%Y-%m-%d %H:%M:%S %Z')
            
            writer.writerow([formatted_time, locatie_code, x, y, compartiment_code, grootheid_code, waarde_numeriek])

file_rws_file_path = open("/tmp/rws_file_path_" + id + ".json", "w")
file_rws_file_path.write(json.dumps(rws_file_path))
file_rws_file_path.close()
