@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM Start script for SWG Discord Chat Bridge (Windows)
REM Usage:
REM   start_bot.bat                -> runs all JSON configs in configs\
REM   start_bot.bat configs\my-server.json

set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%"

if not exist ".venv\Scripts\python.exe" (
    echo [INFO] Creating virtual environment...
    py -3 -m venv .venv || goto :error
)

call ".venv\Scripts\activate.bat" || goto :error

if not exist ".venv\.deps_installed" (
    echo [INFO] Installing dependencies...
    python -m pip install --upgrade pip || goto :error
    pip install -r requirements.txt || goto :error
    type nul > ".venv\.deps_installed"
)

set "CONFIG_ARG="
if not "%~1"=="" set "CONFIG_ARG=%~1"

echo [INFO] Starting SWG Discord Chat Bridge...
if "%CONFIG_ARG%"=="" (
    python swg_chat_bridge.py
) else (
    python swg_chat_bridge.py "%CONFIG_ARG%"
)

goto :eof

:error
set "ERR=%ERRORLEVEL%"
if "%ERR%"=="" set "ERR=1"
echo [ERROR] Failed to start bot. Exit code: %ERR%
echo [ERROR] Review the messages above to identify the problem.
echo.
pause
exit /b %ERR%
