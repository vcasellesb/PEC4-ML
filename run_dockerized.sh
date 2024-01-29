#!/usr/bin/env bash

docker build -t pec4 .

mkdir -p pec4-output

docker run --name pec4c -v $(pwd)/input_data/:/app/input_data/ pec4

docker cp pec4c:/app/PEC4-R.pdf pec4-output/
docker cp pec4c:/app/PEC4-Python.pdf pec4-output/
docker cp pec4c:/app/results/results_by_class.csv pec4-output/

docker rm pec4c