@echo off
rem Launcher for Raspisanie app. Works from ANY folder.
timeout /t 8 /nobreak >nul
start "" msedge --app=http://localhost:3000
if errorlevel 1 start "" chrome --app=http://localhost:3000
exit
