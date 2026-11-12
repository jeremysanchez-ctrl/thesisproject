@echo off
title DCS-SFMS - System Launcher
color 0B
cd /d "%~dp0"

echo ==============================================================
echo    DCS-SFMS - Stakeholder Feedback Management System
echo ==============================================================
echo.
echo [1/4] Checking and stopping any previous processes...
call STOP-DCS-SFMS.bat --no-pause >nul 2>&1

echo [2/4] Starting DCS-SFMS Application Server on http://localhost:3000 ...
powershell -NoProfile -WindowStyle Hidden -Command "$p = Start-Process -FilePath 'node' -ArgumentList 'start_server.mjs' -WorkingDirectory '%~dp0' -WindowStyle Hidden -PassThru; $p.Id | Out-File -LiteralPath '.sfms_pid' -Encoding ascii"

echo [3/4] Starting Mobile and Cellular Data Tunnel...
powershell -NoProfile -WindowStyle Hidden -Command "$p = Start-Process -FilePath 'node' -ArgumentList 'start_tunnel.mjs' -WorkingDirectory '%~dp0' -WindowStyle Hidden -PassThru; $p.Id | Out-File -LiteralPath '.tunnel_pid' -Encoding ascii"

echo [4/4] Waiting for server and opening browser...
set /a tries=0
:waitloop
set /a tries+=1
if %tries% gtr 35 goto :ready
ping 127.0.0.1 -n 2 >nul
powershell -NoProfile -Command "try { (Invoke-WebRequest -Uri 'http://localhost:3000' -UseBasicParsing -TimeoutSec 1).StatusCode } catch { 0 }" | findstr /C:"200" /C:"307" /C:"308" >nul 2>&1 || goto :waitloop
:ready

start "" "http://localhost:3000/admin/login"

echo.
echo ==============================================================
echo   SUCCESS! DCS-SFMS IS NOW RUNNING.
echo.
echo   Local Address:      http://localhost:3000
echo   Admin Login:        http://localhost:3000/admin/login
echo   Active Surveys:     http://localhost:3000/scan
echo.
echo   To STOP the system anytime, double-click STOP-DCS-SFMS.bat
echo ==============================================================
echo.
ping 127.0.0.1 -n 6 >nul
exit
