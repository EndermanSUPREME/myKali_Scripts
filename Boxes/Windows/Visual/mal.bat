@echo off
setlocal

:: Define the path to the executable file
set "executablePath=C:\Users\Public\Documents\shell2.exe"

:: Use PowerShell to execute the executable
powershell.exe -Command "& {Start-Process -FilePath '%executablePath%' -Wait}"

:: Exit the batch script
exit /b 0
