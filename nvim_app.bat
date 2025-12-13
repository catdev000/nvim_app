@echo off

:main
:: Start nvim if possible
where nvim >nul 2>&1
if %errorlevel% == 0 (
    nvim
    exit /b
)

echo NeoVim is not installed, installing NeoVim...

:: Installing Chocolatey if not installed
where choco >nul 2>&1
if %errorlevel% == 0 (
    choco --version
) else (
    echo Chocolatey required for installation, installing Chocolatey first
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
)

:: Install NeoVim
choco install neovim --yes

:: Refresh environment variables so nvim is recognized
refreshenv

nvim --version

:: If --pipeline argument is passed, start nvim and quit immediately, otherwise start nvim
if "%1" == "--pipeline" (
    nvim -c ":qa"
) else (
    nvim
)

goto :eof

