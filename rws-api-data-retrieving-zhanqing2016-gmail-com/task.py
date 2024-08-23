import aws.s3

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()

secret_s3_access_key = os.getenv('secret_s3_access_key')
secret_s3_secret_key = os.getenv('secret_s3_secret_key')

arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--station_names', action='store', type=str, required=True, dest='station_names')

arg_parser.add_argument('--param_s3_endpoint', action='store', type=str, required=True, dest='param_s3_endpoint')

args = arg_parser.parse_args()
print(args)

id = args.id

station_names = json.loads(args.station_names)

param_s3_endpoint = args.param_s3_endpoint.replace('"','')



RWSstations = [{"Code": "DANTZGT", "X": 681288.275516119, "Y": 5920359.91317053},
               {"Code": "DOOVBWT", "X": 636211.321319897, "Y": 5880086.51911216},
               {"Code": "MARSDND", "X": 617481.059435953, "Y": 5871760.70559602},
               {"Code": "VLIESM", "X": 643890.614308217, "Y": 5909304.23136001}]

station_info = [station for station in RWSstations if station["Code"] == station_names[0]]


station_name = station_info[0]["Code"]
rws_file_path = f"/tmp/data/{station_name}_Chl_2021.csv"




collect_catalogus = ('https://waterwebservices.rijkswaterstaat.nl/ONLINEWAARNEMINGENSERVICES_DBO/OphalenWaarnemingen')
request = {
    "Locatie": {"Code": station_info[0]["Code"], "X": station_info[0]["X"], "Y": station_info[0]["Y"]},
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
elements

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
