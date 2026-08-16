@echo off
setlocal enabledelayedexpansion

:main
:: Check if Neovim is already installed
if exist "C:\tools\neovim\nvim-win64\bin\nvim.exe" (
    set "PATH=%PATH%;C:\tools\neovim\nvim-win64\bin"
    nvim %*
    exit /b %ERRORLEVEL%
)

echo NeoVim is not installed, installing NeoVim...

:: Setup Chocolatey
where choco >nul 2>&1
if errorlevel 1 (
    echo Chocolatey not found. Installing Chocolatey...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
    if errorlevel 1 (
        echo Error: Failed to install Chocolatey.
        exit /b 1
    )
)

set "PATH=%PATH%;C:\ProgramData\chocolatey\bin"

where choco >nul 2>&1
if errorlevel 1 (
    echo Error: Chocolatey installation failed or is not in PATH.
    exit /b 1
)

where nvim >nul 2>&1
if errorlevel 1 (
    :: Only install if truly missing
    echo Installing NeoVim...
    choco install neovim --yes --no-progress
    
    if errorlevel 1 (
        echo Error: Failed to install NeoVim via Chocolatey.
        exit /b 1
    )
     
    :: Setup Configuration
    if not exist "%APPDATA%" (
        echo Creating %APPDATA%...
        mkdir "%APPDATA%"
    )

    if exist "%APPDATA%\nvim" ( 
        echo Renaming existing config at %APPDATA%\nvim ...
        ren "%APPDATA%\nvim" nvim_backup
    )

    if exist "nvim_core" (
        echo Copying nvim_core to %APPDATA%\nvim"...
        mkdir "%APPDATA%\nvim"
        xcopy /E /I /Y "nvim_core\*.*" "%APPDATA%\nvim"
    ) else (
        echo Error: nvim_core folder not found in current directory.        
        exit /b 1
    )
    
    :: Update PATH for Neovim
    set "PATH=%PATH%;C:\tools\neovim\nvim-win64\bin"
)

echo Neovim configuration setup complete.

if "%1"=="--pipeline" (
    echo Running pipeline checks...
    
    :: Test if nvim can start and quit cleanly
    nvim -c "quit" >nul 2>&1
    if errorlevel 1 (
        echo Error: Neovim failed to load configuration. Check init.lua for errors
        exit /b 1
    )

    if not exist "%APPDATA%\nvim" (
        echo Error: Directory %APPDATA%\nvim" not found
        exit /b 1
    )

    if not exist "%APPDATA%\nvim\init.lua" (
        echo Error: File %APPDATA%\nvim\init.lua not found
        exit /b 1
    )

    if not exist "%APPDATA%\nvim\lazy-lock.json" (
        echo Error: File %APPDATA%\nvim\lazy-lock.json not found
        exit /b 1
    )

    if not exist "%APPDATA%\nvim\lua" (
        echo Error: Directory %APPDATA%\nvim\lua not found
        exit /b 1
    )

    echo All pipeline checks passed.
    exit /b 0
) else (
    nvim
    exit /b %ERRORLEVEL%
)

goto :eof
