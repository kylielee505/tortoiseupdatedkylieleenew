#!/bin/bash

# Update the local Git repository
git pull

# Update all submodules to their latest commit
git submodule update --remote

# Activate the virtual environment
source ./venv/bin/activate

# Check if whispercpp is installed and update it if it is
if python -m pip show whispercpp &>/dev/null; then 
    python -m pip install -U git+https://git.ecker.tech/lightmare/whispercpp.py
fi

# Deactivate the virtual environment
deactivate
