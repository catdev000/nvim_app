## 0.0.4

### Add Docker terminal window to nvim
- [ ] Add an docker terminal overview plugin on first startup if user wants that (after Installation)


## 0.0.3

### Add Start Menu on startup 
- [ ] Add a menu option into the nvchad configuration and bind it to a shortcut
- [ ] Menu shall have options "Open recent projects (<Space>+f+p)", "Package Manager (:Mason)", "Settings", "Check for Updates", "Exit Menu", "Quit Nvim (:qa)",
- [ ] Add Settings tab
- [ ] Add Check for updates function (Display warning that it will overwrite the nvim config) (also run brew upgrade nvim)
- [ ] Start that menu on each startup of the nvim / execute the shortcut

### Add a terminal opener at the bottom of NvimTree
- [ ] Add an clickable option to open a new horizontal terminal

### Add Updates for nvim_app
- [ ] When entering ":CheckforUpdates" it needs to evaluate if there are differences between nvim and nvim_core (remote)
- [ ] If there are differences ask for each file if the user is okay with the overwrite (also add Accept all)


## 0.0.2

### Upload Files for Downloading
- [x] Batch and Shell Files will always be added as realeases
- [x] Realeases shall only be created on main branch and only if the Commit message contains "\d{1,}.\d{1,}.\d{1,}"

### Add docs
- [x] Added Pipeline documentation
- [x] Added How-shell-works doc
- [x] Added How-batch-works doc
- [x] Added custom-config doc (mappings and plugin changes etc.)
- [x] Added README

### Adding custom configuration and tests
- [x] Preconfigurate nvim to use the custom nvchad config (nvim_core will replace nvim in .config => nvim will become nvim_backup) (shell)
- [x] Add pipeline test to ensure templates are applied correctly to the files
- [x] nvim preconfig also for batch (+ nvim_backup)
- [x] Add pipeline test also for batch
- [ ] update documentation for batch and shell
- [ ] Releases also need to include the nvim_core folder to ensure that installation works as well


## 0.0.1

### Shell script / Batch-Script
- [x] shell and batch file are created for Linux/Mac and Windows
- [x] Installation for linux macOS and Windows are working => docker tested

