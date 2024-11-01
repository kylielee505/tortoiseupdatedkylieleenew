@echo off
REM Initialize and update Git submodules
git submodule init
git submodule update --remote

REM Create a virtual environment named venv
python -m venv venv

REM Activate the virtual environment
call .\venv\Scripts\activate.bat

REM Upgrade pip to the latest version
python -m pip install --upgrade pip

REM Install PyTorch and its associated libraries with DirectML support
python -m pip install torch torchvision torchaudio torch-directml

REM Install the requirements for Tortoise TTS
python -m pip install -r .\modules\tortoise-tts\requirements.txt
python -m pip install -e .\modules\tortoise-tts\

REM Install the requirements for DL-Art-School
python -m pip install -r .\modules\dlas\requirements.txt
python -m pip install -e .\modules\dlas\

REM Install additional project requirements
python -m pip install -r .\requirements.txt

REM Remove any shell scripts in the current directory (if needed)
del *.sh

REM Pause to allow the user to see output before closing
echo Setup complete. Press any key to exit.
pause

REM Deactivate the virtual environment
deactivate
