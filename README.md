# Nvim App (v0.0.2)
An Easy to run shell / batch script for installing and starting nvim

## How the install

Either git clone or download the latest release: <br>
- On windows execute the nvim_app.bat (Double click)
- On linux/mac execute the nvim_app.sh (Right click and execute)
- After executing the script once for installation you can also use "nvim" to start the app
- If you have already installed nvim simply move the nvim_core into your `.config` folder on linux or your `C:\Users\<YourUsername>\AppData\Roaming\nvim` on windows and rename it nvim (replace the old nvim config)

## How to update

In the start menu you can always choose to "Check for updates"
Warning: This will overwrite certain custom setting you set within the nvim folder (init.lua, lua/plugins.lua, lua/mappings.lua, lua/configs/buddy.lua)

## Documentation

[Roadmap](docs/ROADMAP.md) <br>
[How does the batch installation and executing work?](docs/batch_nvim_app.md) <br>
[How does the shell installation and executing work?](docs/shell_nvim_app.md) <br>
[How does the custom config work?](docs/custom_config.md) <br>
[How does the pipeline work?](docs/pipeline.md)

