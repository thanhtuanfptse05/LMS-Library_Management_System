@echo off
setlocal

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup-supabase-env.ps1"

echo.
pause
