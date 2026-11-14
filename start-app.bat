@echo off
chcp 65001 >nul
rem Launcher for Raspisanie app. Works from ANY folder.
cd /d "%~dp0"
title Raspisanie - server (ne zakryvayte eto okno)

where node >nul 2>nul
if errorlevel 1 (
  echo [!] Node.js ne naiden. Ustanovite Node.js LTS s https://nodejs.org i zapustite etot fajl snova.
  start https://nodejs.org
  pause
  exit /b 1
)

rem --- Poisk PostgreSQL i sozdanie bazy app_db (esli ee esche net) ---
set "PGBIN="
for /d %%D in ("%ProgramFiles%\PostgreSQL\*") do set "PGBIN=%%D\bin"
if defined PGBIN (
  set "PGPASSWORD=postgres"
  "%PGBIN%\psql.exe" -U postgres -h 127.0.0.1 -tAc "SELECT 1 FROM pg_database WHERE datname='app_db'" 2>nul | findstr 1 >nul
  if errorlevel 1 (
    echo Sozdayu bazu dannyh app_db...
    "%PGBIN%\psql.exe" -U postgres -h 127.0.0.1 -c "CREATE DATABASE app_db" 2>nul
  )
) else (
  echo [!] PostgreSQL ne naiden v standartnoj papke. Esli baza uzhe nastroena - prodolzhaem.
)

if not exist ".env" (
  echo DATABASE_URL=postgresql://postgres:postgres@127.0.0.1:5432/app_db> .env
)

if not exist "node_modules" (
  echo Pervyj zapusk: ustanovka komponentov (5-10 minut)...
  call npm install
  if errorlevel 1 ( echo [!] Oshibka ustanovki. & pause & exit /b 1 )
)

if not exist ".next\BUILD_ID" (
  echo Sborka prilozheniya...
  call npm run build
  if errorlevel 1 ( echo [!] Oshibka sborki. & pause & exit /b 1 )
)

echo Proverka tablic bazy dannyh...
call npx drizzle-kit push --force

rem --- Otkryt okno prilozheniya cherez neskolko sekund ---
start "" /min "%~dp0open-window.bat"

echo.
echo Prilozhenie zapushcheno: http://localhost:3000
echo Eto okno mozhno svernut, no ne zakryvat.
echo.
call npm run start
pause
