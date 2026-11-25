@echo off
title Muhamka Inven - Local Network Launcher
echo ========================================================
echo   MENYIAPKAN APLIKASI INVENMUHAMKA UNTUK JARINGAN LOKAL
echo ========================================================
echo.

set IP=172.20.10.2
echo IP Komputer ini di Jaringan Wi-Fi: %IP%
echo.
echo URL Backend API  : http://%IP%:3000
echo URL Frontend Web : http://%IP%:5000
echo.
echo Perangkat lain (HP / Tablet / Laptop) yang terhubung ke Wi-Fi
echo yang sama dapat langsung membuka: http://%IP%:5000
echo ========================================================
echo.

echo Menjalankan Frontend InvenMuhamka Web di 0.0.0.0:5000...
flutter run -d web-server --web-hostname=0.0.0.0 --web-port=5000

pause
