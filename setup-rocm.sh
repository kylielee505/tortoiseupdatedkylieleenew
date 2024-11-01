#!/bin/bash

# Initialize and update Git submodules
git submodule init
git submodule update --remote

# Setup Python virtual environment
python3 -m venv venv

# Activate the virtual environment
source ./venv/bin/activate

# Upgrade pip to the latest version
python3 -m pip install --upgrade pip

# Install ROCM-compatible PyTorch and its libraries
pip3 install torch==1.13.1 torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/rocm5.2

# Install requirements for Tortoise TTS
python3 -m pip install -r ./modules/tortoise-tts/requirements.txt
python3 -m pip install -e ./modules/tortoise-tts/

# Install requirements for DLAS
python3 -m pip install -r ./modules/dlas/requirements.txt
python3 -m pip install -e ./modules/dlas/

# Install local requirements
python3 -m pip install -r ./requirements.txt

# Clean up unnecessary .bat files if they exist
rm -f *.bat

# Run the BnB setup script
./setup-rocm-bnb.sh

# Deactivate the virtual environment
deactivate
