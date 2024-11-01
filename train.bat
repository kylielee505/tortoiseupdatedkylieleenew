@echo off
REM Activate the virtual environment
call .\venv\Scripts\activate.bat

REM Set the PYTHONUTF8 environment variable to handle UTF-8 encoding
set PYTHONUTF8=1

REM Run the training script with the provided YAML configuration
python ./src/train.py --yaml "%1"

REM Pause to keep the console window open
pause

REM Deactivate the virtual environment
deactivate
