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
if errorlevel 0 (
    choco --version >nul 2>&1
    if errorlevel 0 (
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
if errorlevel 1 (
    :: Only install if truly missing
    echo Installing NeoVim...
    choco install neovim --yes

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

    :: Correct Neovim PATH
    set "PATH=%PATH%;C:\tools\neovim\nvim-win64\bin"
)


echo Neovim configuration setup complete.


if "%1"=="--pipeline" (
    nvim -c ":qa"
    
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
)

goto :eof
