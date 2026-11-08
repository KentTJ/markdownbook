@echo off
chcp 65001 >nul
cd /d "%~dp0"
node scripts\sync-notes.js sync
if errorlevel 1 goto failed
pause
exit /b 0
:failed
echo.
echo 本次同步未完成，请保留上面的错误提示。
pause
exit /b 1
