## 0.0.4

### Add Docker terminal window to nvim
- [ ] Add an docker terminal overview plugin on first startup if user wants that (after Installation)


## 0.0.3

### Add Start Menu on startup
- [ ] Add a menu option into the nvchad configuration and bind it to a shortcut
- [ ] Menu shall have options "Open recent projects (<Space>+f+p)", "Package Manager (:Mason)", "Exit Menu", "Quit Nvim (:qa)", 
- [ ] Start that menu on each startup of the nvim / execute the shortcut

### Add a terminal opener at the bottom of NvimTree
- [ ] Add an clickable option to open a new horizontal terminal

### Add Updates for nvim_app
- [ ] Executables create a folder in root directory of OS ".nvim_app" and run "git clone git@github.com:foxy00000/nvim_app.git"
- [ ] If folder .nvim_app/nvim_app already exists run "git pull" in it on startup (before running "nvim")
- [ ] The Executable just calls the shell / batch script from there
- [ ] Before running nvim in the script it asks where to open nvim exactly and then cd there

### Complete README
- [ ] Describe how to install nvim and how to use it (script and executable files)


## 0.0.2

### Create Executables via pipeline
- [ ] Executables will be created in the pipeline for windows and linux and added as realeases
- [ ] Realeases shall only be created on main branch and only if the Commit message contains "\d{1,}.\d{1,}.\d{1,}"

### Adding choice of special options
- [ ] Added option to install nvchad after nvim Installation
- [ ] Implement template strategy to add code to add custom code to init.lua and mappings.lua
- [ ] Add pipeline tests to ensure templates are applied correctly to the files
- [ ] Added option to preconfigurate nvim to always display the file selection "NVimTree"


## 0.0.1

### Shell script / Batch-Script
- [x] shell and batch file are created for Linux/Mac and Windows
- [x] Installation for linux macOS and Windows are working => docker tested

