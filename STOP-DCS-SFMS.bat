@echo off
title DCS-SFMS - Service Stopper
color 0C
cd /d "%~dp0"

echo ================================================
echo  DCS-SFMS - Stakeholder Feedback Management System
echo  Stopping the application service...
echo ================================================
echo.

rem ---- 1. Kill the tracked server process from .sfms_pid ----
if exist ".sfms_pid" (
    set /p PID=<".sfms_pid"
    echo [INFO] Stopping tracked server process %PID% ...
    taskkill /PID %PID% /T /F >nul 2>&1
    del ".sfms_pid" >nul 2>&1
)
if exist ".tunnel_pid" (
    set /p TPID=<".tunnel_pid"
    echo [INFO] Stopping tracked tunnel process %TPID% ...
    taskkill /PID %TPID% /T /F >nul 2>&1
    del ".tunnel_pid" >nul 2>&1
)

rem ---- 2. Kill anything still listening on port 3000 ----
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :3000 ^| findstr LISTENING') do (
    echo [INFO] Stopping process %%a listening on port 3000 ...
    taskkill /PID %%a /F >nul 2>&1
)

rem ---- 3. Kill any lingering tunnels ----
taskkill /IM ngrok.exe /F >nul 2>&1
taskkill /IM cloudflared.exe /F >nul 2>&1
if exist ".tunnel_url" del ".tunnel_url" >nul 2>&1

echo.
echo ================================================
echo   ALL DCS-SFMS PROCESSES & TUNNELS STOPPED
echo ================================================
echo.
if "%1"=="--no-pause" goto :done
pause
:done