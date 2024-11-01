#!/bin/bash

# Activate the virtual environment
source ./venv/bin/activate

# Run the training script with the provided YAML configuration
python3 ./src/train.py --yaml "$1"

# Deactivate the virtual environment
deactivate
