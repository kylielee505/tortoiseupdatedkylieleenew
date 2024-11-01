@echo off
REM Activate the Python virtual environment
call .\venv\Scripts\activate.bat

REM Prepend the local bin directory to the PATH
set PATH=.\bin\;%PATH%

REM Set the PYTHONUTF8 environment variable for UTF-8 support
set PYTHONUTF8=1

REM Run the main Python script with any provided arguments
python .\src\main.py %*

REM Pause the script to keep the window open after execution
pause
