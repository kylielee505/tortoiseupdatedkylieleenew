#!/bin/bash

# Initialize and update Git submodules
git submodule init
git submodule update --remote

# Set up the environment for ROCm and bits and bytes
# Ensure ROCm is properly installed and set in your environment

# Create a virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    python -m venv venv
fi

# Activate the virtual environment
source ./venv/bin/activate

# Upgrade pip
python -m pip install --upgrade pip

# Install ROCm-compatible PyTorch and its dependencies
python -m pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/rocm4.5/

# Install requirements for Tortoise TTS and DLAS modules
python -m pip install -r ./modules/tortoise-tts/requirements.txt
python -m pip install -e ./modules/tortoise-tts/
python -m pip install -r ./modules/dlas/requirements.txt
python -m pip install -e ./modules/dlas/
python -m pip install -r ./requirements.txt

# Set up BnB (bits and bytes)
./setup-cuda-bnb.sh

# Clean up any unnecessary files
rm -f *.sh

# Pause for user input before deactivating
read -p "Press any key to continue... " -n1 -s

# Deactivate the virtual environment
deactivate
