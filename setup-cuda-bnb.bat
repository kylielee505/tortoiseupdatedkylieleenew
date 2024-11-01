@echo off

:: Clone the bitsandbytes-windows repository into the specified path
git clone https://git.ecker.tech/mrq/bitsandbytes-windows.git .\modules\bitsandbytes-windows\

:: Copy the necessary binaries and setup files into the virtual environment
xcopy .\modules\bitsandbytes-windows\bin\* .\venv\Lib\site-packages\bitsandbytes\. /Y
xcopy .\modules\bitsandbytes-windows\bin\cuda_setup\* .\venv\Lib\site-packages\bitsandbytes\cuda_setup\. /Y
xcopy .\modules\bitsandbytes-windows\bin\nn\* .\venv\Lib\site-packages\bitsandbytes\nn\. /Y

echo Setup complete.
