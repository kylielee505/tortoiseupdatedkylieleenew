@echo off

:: Initialize and update Git submodules
git submodule init
git submodule update --remote

:: Create a virtual environment named venv
python -m venv venv

:: Activate the virtual environment
call .\venv\Scripts\activate.bat

:: Upgrade pip to the latest version
python -m pip install --upgrade pip

:: Install PyTorch and its associated libraries with CUDA support
python -m pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu118

:: Install the requirements for Tortoise TTS
python -m pip install -r .\modules\tortoise-tts\requirements.txt
python -m pip install -e .\modules\tortoise-tts\

:: Install the requirements for DL-Art-School
python -m pip install -r .\modules\dlas\requirements.txt
python -m pip install -e .\modules\dlas\

:: Install additional project requirements
python -m pip install -r .\requirements.txt

:: Run the setup script for BnB (bitsandbytes)
.\setup-cuda-bnb.bat

:: Delete any shell scripts in the current directory
del *.sh

:: Pause to allow the user to see output before closing the window
pause

:: Deactivate the virtual environment
deactivate
