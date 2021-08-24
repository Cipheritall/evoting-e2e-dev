#!/usr/bin/env python
import sys
import json

"""Helper script to sort the rabbitmq.definitions json for better readability.

Arguments:
input_filename: path to the rabbitmq.definitioons to sort
output_fiilnemae: path to ouput the sorted json
"""

def main():
    definitions_filename = sys.argv[1]
    definitions_file = open(definitions_filename, "r")
    output_filename = sys.argv[2]
    output_file = open(output_filename, "w")

    definitions = definitions_file.read()
    definitions_json = json.loads(definitions)
    sorted_definitions_json = definitions_json
    sorted_definitions_json['users'] = sorted(definitions_json['users'], key=lambda k: k['name'])
    sorted_definitions_json['queues'] = sorted(definitions_json['queues'], key=lambda k: k['name'])
    sorted_definitions_json['permissions'] = sorted(definitions_json['permissions'], key=lambda k: k['user'])
    sorted_definitions = json.dumps(sorted_definitions_json, indent=2)
    output_file.write(sorted_definitions,)


if __name__ == "__main__":
    main()
