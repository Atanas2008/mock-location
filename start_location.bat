@echo off
setlocal
cd /d "%~dp0"

set "LAT=YOUR_LATITUDE"
set "LON=YOUR_LONGITUDE"

if "%LAT%"=="YOUR_LATITUDE" goto coordinates_missing
if "%LON%"=="YOUR_LONGITUDE" goto coordinates_missing

python -m pip show pymobiledevice3 >nul 2>&1
if errorlevel 1 goto package_missing

echo Starting pymobiledevice3 tunnel in an administrator window...
powershell -NoProfile -Command "Start-Process -FilePath 'cmd.exe' -Verb RunAs -ArgumentList '/k python -m pymobiledevice3 remote tunneld'"
if errorlevel 1 goto tunnel_failed

echo Waiting for the tunnel to start...
timeout /t 5 /nobreak >nul

echo Mounting the Developer Disk Image...
python -m pymobiledevice3 mounter auto-mount
if errorlevel 1 goto command_failed

echo Setting simulated location to %LAT%, %LON%...
python -m pymobiledevice3 developer dvt simulate-location set --tunnel "" -- %LAT% %LON%
if errorlevel 1 goto command_failed

echo Location simulation started. Keep the administrator tunnel window open.
pause
exit /b 0

:coordinates_missing
echo Edit LAT and LON at the top of this file before running it.
pause
exit /b 1

:package_missing
echo pymobiledevice3 is not installed for this Python interpreter.
echo Install it with: python -m pip install -U pymobiledevice3
pause
exit /b 1

:tunnel_failed
echo Could not start the elevated tunnel. Confirm the UAC prompt and try again.
pause
exit /b 1

:command_failed
echo The command failed. Check the iPhone connection, Developer Mode, and iOS version.
pause
exit /b 1
