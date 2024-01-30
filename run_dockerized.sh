#!/usr/bin/env bash

docker build -t pec4 .

mkdir -p pec4-output

docker run --rm -v $(pwd)/input_data/:/app/input_data/ -v $(pwd)/pec4-output:/app/pec4-output pec4