@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM Start script for SWG Discord Chat Bridge (Windows)
REM Usage:
REM   start_bot.bat                -> runs all JSON configs in configs\
REM   start_bot.bat configs\my-server.json

set "SCRIPT_DIR=%~dp0"
set "LOG_FILE=%SCRIPT_DIR%start_bot.log"

echo ================================================== > "%LOG_FILE%"
echo [%date% %time%] Starting SWG Discord Chat Bridge... >> "%LOG_FILE%"
echo ================================================== >> "%LOG_FILE%"

call :run %* >> "%LOG_FILE%" 2>&1
set "ERR=%ERRORLEVEL%"

if not "%ERR%"=="0" (
    echo [ERROR] Failed to start bot. Exit code: %ERR% >> "%LOG_FILE%"
    echo [ERROR] Failed to start bot. Exit code: %ERR%
    echo [ERROR] Full output has been saved to:
    echo         "%LOG_FILE%"
    echo.
    pause
    exit /b %ERR%
)

echo [INFO] Bot started successfully. Output file:
echo        "%LOG_FILE%"
exit /b 0

:run
cd /d "%SCRIPT_DIR%" || exit /b 1

if not exist ".venv\Scripts\python.exe" (
    echo [INFO] Creating virtual environment...
    py -3 -m venv .venv || exit /b 1
)

call ".venv\Scripts\activate.bat" || exit /b 1

if not exist ".venv\.deps_installed" (
    echo [INFO] Installing dependencies...
    python -m pip install --upgrade pip || exit /b 1
    pip install -r requirements.txt || exit /b 1
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

exit /b %ERRORLEVEL%
