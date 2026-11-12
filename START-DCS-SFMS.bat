@echo off
title DCS-SFMS - Service Starter
color 0A
cd /d "%~dp0"

echo ================================================
echo  DCS-SFMS - Stakeholder Feedback Management System
echo  Starting the application service...
echo ================================================
echo.

rem ---- 1. Node.js check ----
where node >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Node.js was not found in PATH.
    echo         Install Node.js v20+ from https://nodejs.org
    echo.
    pause
    exit /b 1
)

rem ---- 2. Environment file ----
if not exist ".env" (
    echo [SETUP] .env not found - creating from .env.example ...
    copy ".env.example" ".env" >nul
)
if not exist ".env" (
    echo [ERROR] Could not create .env file.
    echo.
    pause
    exit /b 1
)

rem ---- 2b. Ensure a SESSION_SECRET is present ----
findstr /B /C:"SESSION_SECRET=" ".env" >nul 2>&1
if %errorlevel% neq 0 (
    echo [SETUP] Generating SESSION_SECRET ...
    powershell -NoProfile -Command "$s = -join ((48..57)+(65..90)+(97..122) | Get-Random -Count 48 | %% {[char]$_}); Add-Content -LiteralPath '.env' -Value ('SESSION_SECRET=' + $s)"
)

rem ---- 3. Dependencies ----
if not exist "node_modules" (
    echo [SETUP] Installing dependencies ^(first run, please wait^) ...
    call npm.cmd install
    if errorlevel 1 (
        echo [ERROR] npm install failed. Check your internet connection.
        echo.
        pause
        exit /b 1
    )
)

rem ---- 4. Database ----
if not exist "prisma\dev.db" (
    echo [SETUP] Creating database schema ...
    call npx.cmd prisma db push
    echo [SETUP] Seeding default accounts and survey ...
    call npx.cmd tsx prisma\seed.ts
)

rem ---- 5. Production build (first run) ----
if not exist ".next\BUILD_ID" (
    echo [SETUP] Building application for the first time, please wait ...
    call npm.cmd run build
    if errorlevel 1 (
        echo [ERROR] Build failed. Check the console for details.
        echo.
        pause
        exit /b 1
    )
)

rem ---- 6. Stop any existing instance ----
if exist ".sfms_pid" (
    set /p OLD_PID=<".sfms_pid"
    echo [INFO] Stopping previous server process %OLD_PID% ...
    taskkill /PID %OLD_PID% /T /F >nul 2>&1
    del ".sfms_pid" >nul 2>&1
)
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :3000 ^| findstr LISTENING') do (
    taskkill /PID %%a /F >nul 2>&1
)

rem ---- 7. Start the production server (hidden) + capture PID ----
echo [INFO] Starting Next.js server on http://localhost:3000 ...
powershell -NoProfile -WindowStyle Hidden -Command "$p = Start-Process -FilePath 'node' -ArgumentList 'node_modules/next/dist/bin/next','start','-p','3000' -WorkingDirectory '%~dp0' -WindowStyle Hidden -PassThru; $p.Id | Out-File -LiteralPath '.sfms_pid' -Encoding ascii"

rem ---- 8. Wait for the server to respond ----
echo [INFO] Waiting for the server to become ready ...
set /a tries=0
:waitloop
set /a tries+=1
if %tries% gtr 45 (
    echo [WARN] Server took too long to respond. It may still be starting.
    goto :ready
)
timeout /t 1 /nobreak >nul
powershell -NoProfile -Command "try { (Invoke-WebRequest -Uri 'http://localhost:3000' -UseBasicParsing -TimeoutSec 2).StatusCode } catch { 0 }" | findstr /C:"200" /C:"307" /C:"308" >nul 2>&1 || goto :waitloop
:ready

rem ---- 9. Open admin login in the browser ----
echo [INFO] Opening the Admin Portal in your browser ...
start "" "http://localhost:3000/admin/login"

rem ---- 10. Optional public tunnel for cellular/mobile data ----
echo.
choice /C YN /N /M "Start an automatic mobile tunnel (cellular data / any network)? [Y/N]: "
if errorlevel 2 goto :done

start "DCS-SFMS - Mobile Public Tunnel" cmd /k "node start_tunnel.mjs"

:done
echo.
echo ================================================
echo   SERVICE IS RUNNING
echo   Admin portal : http://localhost:3000/admin/login
echo   Stop service : double-click STOP-DCS-SFMS.bat
echo ================================================
echo.
pause