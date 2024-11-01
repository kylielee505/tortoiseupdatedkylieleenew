#!/bin/bash

# Fetch the latest changes from the remote repository
git fetch --all

# Reset the local repository to match the remote master branch
git reset --hard origin/master

# Execute the update.sh script
./update.sh

# Create a new Python virtual environment
python3 -m venv venv

# Activate the virtual environment
source ./venv/bin/activate

# Upgrade pip to the latest version
python3 -m pip install --upgrade pip

# Install or upgrade requirements for tortoise-tts module
python3 -m pip install -r ./modules/tortoise-tts/requirements.txt
python3 -m pip install -e ./modules/tortoise-tts

# Install or upgrade requirements for dlas module
python3 -m pip install -r ./modules/dlas/requirements.txt
python3 -m pip install -e ./modules/dlas

# Install or upgrade local requirements
python3 -m pip install -r ./requirements.txt

# Deactivate the virtual environment
deactivate
