from SPARQLWrapper import JSON
from SPARQLWrapper import SPARQLWrapper

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--retEXV', action='store', type=str, required=True, dest='retEXV')


args = arg_parser.parse_args()
print(args)

id = args.id

retEXV = json.loads(args.retEXV)





sparql2 = SPARQLWrapper(
    "http://vocab.nerc.ac.uk/sparql/sparql"
)
sparql2.setReturnFormat(JSON)
variables = []
for r in retEXV["results"]["bindings"]:
    sparql2.setQuery("""
      PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
    PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
    SELECT * WHERE {
      <%s> skos:prefLabel ?obj .
    } 
        """ % r['o']['value']
    )
    try:
        retCF = sparql2.queryAndConvert()
        for b in retCF["results"]["bindings"]:
            variables.append(b['obj']['value'])
    except Exception as e:
        print(e)
print(variables)

file_variables = open("/tmp/variables_" + id + ".json", "w")
file_variables.write(json.dumps(variables))
file_variables.close()
