#!/bin/bash
# get local dependencies
git submodule init
git submodule update --remote
# setup venv
python3 -m venv venv
source ./venv/bin/activate
python3 -m pip install --upgrade pip # just to be safe
# ROCM
pip3 install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/rocm5.1.1 # 5.2 does not work for me desu
# install requirements
python3 -m pip install -r ./dlas/requirements.txt # instal DLAS requirements
python3 -m pip install -r ./tortoise-tts/requirements.txt # install TorToiSe requirements
python3 -m pip install -e ./tortoise-tts/ # install TorToiSe
python3 -m pip install -r ./requirements.txt # install local requirements
# swap to ROCm version of BitsAndBytes
pip3 uninstall bitsandbytes
pip3 install git+https://github.com/broncotc/bitsandbytes-rocm

deactivate