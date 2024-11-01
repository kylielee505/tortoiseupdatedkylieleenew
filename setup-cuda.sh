#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Initialize and update Git submodules
git submodule init
git submodule update --remote

# Create a virtual environment named venv
python3 -m venv venv

# Activate the virtual environment
source ./venv/bin/activate

# Upgrade pip to the latest version
python -m pip install --upgrade pip

# Install PyTorch and its associated libraries with CUDA support
python -m pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu118

# Install the requirements for Tortoise TTS
python -m pip install -r ./modules/tortoise-tts/requirements.txt
python -m pip install -e ./modules/tortoise-tts/

# Install the requirements for DL-Art-School
python -m pip install -r ./modules/dlas/requirements.txt
python -m pip install -e ./modules/dlas/

# Install additional project requirements
python -m pip install -r ./requirements.txt

# Run the setup script for BnB (bitsandbytes)
./setup-cuda-bnb.sh

# Remove any shell scripts in the current directory (if needed)
rm -f *.sh

# Pause to allow the user to see output before closing (only relevant if using a terminal emulator that exits)
echo "Setup complete. Press any key to exit."
read -n 1 -s

# Deactivate the virtual environment
deactivate
