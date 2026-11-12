@echo off
title DCS-SFMS - Automatic Public Mobile Tunnel
color 0B
cd /d "%~dp0"

echo ===================================================
echo  DCS-SFMS - Automatic Mobile & Internet Tunnel
echo ===================================================
echo.
echo Starting secure tunnel so mobile phones on cellular data
echo or any external network can scan QR codes and submit!
echo.

node start_tunnel.mjs
pause
