call .\venv\Scripts\activate.bat
python ./src/train.py -opt "%1"
deactivate
pause