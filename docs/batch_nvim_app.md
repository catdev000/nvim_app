## How does batch installation work for windows

### Start nvim if it exists
```
:main
if exist "C:\tools\neovim\nvim-win64\bin\nvim.exe" (
    set "PATH=%PATH%;C:\tools\neovim\nvim-win64\bin"
    nvim %*
    exit /b
)
```

### Installing nvim if it does not exist with choco
```
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
```

### Fixing chocolatey if it throws error
```
echo Fixing Chocolatey...
if exist "C:\ProgramData\chocolatey" rmdir /s /q "C:\ProgramData\chocolatey"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
```

### Installation of nvim with chocolatey
```
echo Installing NeoVim...
choco install neovim --yes
```

### Try to launch neovim again after installation
```
:choco_ready
set "PATH=%PATH%;C:\ProgramData\chocolatey\bin"

:: NOW check nvim again with correct PATH
where nvim >nul 2>&1
if %errorlevel! == 0 (
    echo NeoVim ready
    goto :launch_nvim
)
```

### Install nvim if it still does not exist
```
:: Only install if truly missing
echo Installing NeoVim...
choco install neovim --yes
```

### Start nvim after the installation (quit it directly afterwards for pipeline testing)
```
if "%1"=="--pipeline" (
    nvim -c ":qa"
) else (
    nvim
)
```

### Helper function
```
:launch_nvim
nvim --version

if "%1"=="--pipeline" (
    nvim -c ":qa"
) else (
    nvim
)
```
