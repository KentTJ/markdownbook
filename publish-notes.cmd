@echo off
chcp 65001 >nul
cd /d "%~dp0"
node scripts\configure-editor.js
if errorlevel 1 goto failed
node scripts\sync-notes.js publish
if errorlevel 1 goto failed
echo.
echo 发布已提交，网页会在云端构建完成后更新。
pause
exit /b 0
:failed
echo.
echo 本次未完成发布，请保留上面的错误提示。
pause
exit /b 1
