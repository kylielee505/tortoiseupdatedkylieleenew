#!/bin/bash

# Set the soft limit for the number of open file descriptors to the hard limit
ulimit -Sn `ulimit -Hn` # ROCm is a bitch

# Activate the Python virtual environment
source ./venv/bin/activate

# Execute the main Python script with all passed arguments
python3 ./src/main.py "$@"

# Deactivate the virtual environment
deactivate
