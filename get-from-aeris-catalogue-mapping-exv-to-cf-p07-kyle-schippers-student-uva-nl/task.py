from SPARQLWrapper import JSON
from SPARQLWrapper import SPARQLWrapper

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id





sparql = SPARQLWrapper("https://skosmos.aeris-data.fr/sparql")
sparql.setReturnFormat(JSON)
sparql.setQuery("""
   PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
SELECT * FROM <https://vocab.aeris-data.fr/parameter>
WHERE {
  ?param skos:relatedMatch <http://vocab.nerc.ac.uk/collection/EXV/current/EXV015/> .
  ?param skos:narrowMatch ?o .
} 
    """)
try:
    retEXV = sparql.queryAndConvert()
    for r in retEXV["results"]["bindings"]:
        print(r)
except Exception as e:
    print(e)

file_retEXV = open("/tmp/retEXV_" + id + ".json", "w")
file_retEXV.write(json.dumps(retEXV))
file_retEXV.close()
