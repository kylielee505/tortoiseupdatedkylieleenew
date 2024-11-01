@echo off
rem Fetch the latest changes from the remote repository
git fetch --all

rem Reset the local repository to match the remote master branch
git reset --hard origin/master

rem Call the update.bat script
call .\update.bat

rem Create a new Python virtual environment
python -m venv venv
call .\venv\Scripts\activate.bat

rem Upgrade pip to the latest version
python -m pip install --upgrade pip

rem Upgrade requirements for tortoise-tts module
python -m pip install -U -r .\modules\tortoise-tts\requirements.txt
python -m pip install -U -e .\modules\tortoise-tts 

rem Upgrade requirements for dlas module
python -m pip install -U -r .\modules\dlas\requirements.txt

rem Upgrade local requirements
python -m pip install -U -r .\requirements.txt

rem Pause to allow the user to see the output
pause

rem Deactivate the virtual environment
deactivate
