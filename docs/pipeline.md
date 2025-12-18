# How does the pipeline "Test & Deploy" work?

The Pipeline is run every push on a branch. <br>
This ensures the code is tested properly, deploys releases etc. <br>

## Change Detection Stage
Here we prefilter which job needs to run and which not. <br>
There are 4 values possible to be set: <br>

- workflows_changed >> The .github/workflows is changed in this commit
- sh_changed >> The nvim_app.sh is changed in this commit
- bat_changed >> The nvim_app.bat is changed in this commit
- version_changed >> The commit message contains "number.number.number" (for example 1.2.1)

| Jobs | workflows_changed | sh_changed | bat_changed | version_changed
| -- | -- | -- | -- | -- |  
| Testing Linux | ✅ | ✅ | x | ✅ |
| Testing Mac | ✅ | ✅ | x | ✅ |
| Testing Windows | ✅ | x | ✅ | ✅ |
| Uploads | x | x | x | ✅ |
| Releases | x | x | x | ✅ |


## Test Stage

### Testing Linux
- Check out repo >> Retrieve the Git Repo Code for further steps
- Testing Linux Installation >> Testing Installation of nvim on linux (nvim_app.sh)

### Testing Mac
- Check out repo >> Retrieve the Git Repo Code for further steps
- Unistall Homebrew >> Because brew is preinstalled, we need to uninstall it to test the nvim_app.sh
- Testing MacOS Installation >> Testing Installation of nvim on macOS (nvim_app.sh)

### Testing Windows
- Check out repo >> Retrieve the Git Repo Code for further steps
- Unistall Chocolatey (if installed) >> Because Chocolatey could be installed we need to unistall it to test the nvim_app.bat Installation
- Testing Windows Installation >> Testing Installation of nvim on windows (nvim_app.bat)

## Upload Stage

### Upload Windows
- Check out repo >> Retrieve the Git Repo Code for further steps
- Rename and package Windows >> Raname nvim_app.bat into nvim_windows.bat, so users can identify which Installation for which system to pick
- Upload Artifact >> Upload the nvim_windows.bat to add it to release

### Upload Mac
- Check out repo >> Retrieve the Git Repo Code for further steps
- Rename and package MacOS >> Raname nvim_app.sh into nvim_macOS.sh, so users can identify which Installation for which system to pick
- Upload Artifact >> Upload the nvim_macOS.sh to add it to release

### Upload Linux
- Check out repo >> Retrieve the Git Repo Code for further steps
- Rename and package Linux >> Raname nvim_app.sh into nvim_linux.sh, so users can identify which Installation for which system to pick
- Upload Artifact >> Upload the nvim_linux.sh to add it to release

## Release Stage

- Check out repo >> Retrieve the Git Repo Code for further steps
- Get created artifacts >> Get the 3 created Artifacts from the upload jobs
- Extract version from commit >> Get the version number from the commit message
- List artifacts for debug >> prints out which artifacts are picked (Debug messages help devs narrow down errors)
- Create Release >> Create a new release with the version number, so "v1.2.3" for example
