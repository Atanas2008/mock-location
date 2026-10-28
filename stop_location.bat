@echo off
setlocal
cd /d "%~dp0"

python -m pymobiledevice3 developer dvt simulate-location clear --tunnel ""
if errorlevel 1 (
    echo Could not clear the simulated location. Check the iPhone connection and tunnel.
    pause
    exit /b 1
)

echo Simulated location cleared.
pause
