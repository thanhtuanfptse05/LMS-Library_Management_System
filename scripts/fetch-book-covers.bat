@echo off
setlocal

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0fetch-book-covers.ps1" %*

echo.
pause
