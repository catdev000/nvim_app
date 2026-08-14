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
    
    :: 6. Setup Configuration
    set "NVIM_CONFIG_DIR=%APPDATA%\nvim"
    set "NVIM_CORE_PATH=nvim_core"

    if not exist "%APPDATA%" (
        echo Creating %APPDATA%...
        mkdir "%APPDATA%"
    )

    if exist "%NVIM_CONFIG_DIR%" ( 
        echo Renaming existing config at %NVIM_CONFIG_DIR%...
        ren "%NVIM_CONFIG_DIR%" nvim_backup
    )

    if exist "%NVIM_CORE_PATH%" (
        echo Copying nvim_core to %NVIM_CONFIG_DIR%...
        mkdir "%NVIM_CONFIG_DIR%"
        xcopy /E /I /Y "%NVIM_CORE_PATH%\*.*" "%NVIM_CONFIG_DIR%\"
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
    
    :: Test if nvim can start and quit cleanly (catches init.lua errors)
    nvim -c "quit" >nul 2>&1
    if errorlevel 1 (
        echo Error: Neovim failed to load configuration (check init.lua for errors).
        exit /b 1
    )

    set "TARGET_PATH=%APPDATA%\nvim"

    if not exist "%TARGET_PATH%" (
        echo Error: Directory %TARGET_PATH% not found
        exit /b 1
    )

    if not exist "%TARGET_PATH%\init.lua" (
        echo Error: File %TARGET_PATH%\init.lua not found
        exit /b 1
    )

    if not exist "%TARGET_PATH%\lazy-lock.json" (
        echo Error: File %TARGET_PATH%\lazy-lock.json not found
        exit /b 1
    )

    if not exist "%TARGET_PATH%\lua" (
        echo Error: Directory %TARGET_PATH%\lua not found
        exit /b 1
    )

    echo All pipeline checks passed.
    exit /b 0
) else (
    nvim
    exit /b %ERRORLEVEL%
)

goto :eof
