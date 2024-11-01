@echo off
REM Update the local Git repository
git pull

REM Update all submodules to their latest commit
git submodule update --remote

pause
