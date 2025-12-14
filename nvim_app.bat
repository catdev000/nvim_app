@echo off
setlocal enabledelayedexpansion

:main
if exist "C:\tools\neovim\nvim-win64\bin\nvim.exe" (
    set "PATH=%PATH%;C:\tools\neovim\nvim-win64\bin"
    nvim %*
    exit /b
)

echo NeoVim is not installed, installing NeoVim...

:: Setup Chocolatey
where choco >nul 2>&1
if %errorlevel% == 0 (
    choco --version >nul 2>&1
    if !errorlevel! == 0 (
        echo Chocolatey ready
        goto :choco_ready
    )
)

echo Fixing Chocolatey...
if exist "C:\ProgramData\chocolatey" rmdir /s /q "C:\ProgramData\chocolatey"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"

:choco_ready
set "PATH=%PATH%;C:\ProgramData\chocolatey\bin"

:: NOW check nvim again with correct PATH
where nvim >nul 2>&1
if %errorlevel! == 0 (
    echo NeoVim ready
    goto :launch_nvim
)

:: Only install if truly missing
echo Installing NeoVim...
choco install neovim --yes

:: Correct Neovim PATH
set "PATH=%PATH%;C:\tools\neovim\nvim-win64\bin"

:launch_nvim
nvim --version

if "%1"=="--pipeline" (
    nvim -c ":qa"
) else (
    nvim
)

goto :eof
