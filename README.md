# adbss (Android Debug Bridge ScreenShoter)
*Small bash script for easy screenshot taking on Android devices/emulators*

`adbss.sh` is small bash script that will allow you to interactively take screenshots on your connected Android device or emulator. You just need to make sure that you have `adb` in your path.

Screenshots are first saved to a temporary file on the device, before being transferred. `adbss` cleans those files.

See the sample of screenshot taking process:

![](res/adbss-demo.gif)

### Options

* **-o** Specify output directory for screenshots, e.g. `adbss -o ~/Desktop/test_dir`
* **-h** Print help.

### Installation (Linux and MacOS)

1) Make sure you have ADB in your path. You can add it to your shell config file (`.bash_profile`, `.zshrc`, etc.):

```sh
# Your ADB might be different, these are just common locations.

# Linux
export PATH=${PATH}:$HOME/Android/Sdk/platform-tools/

# MacOS
export PATH=${PATH}:$HOME/Library/Android/sdk/platform-tools/
```

2) Check that you have a device/emulator connected to the ADB by running `adb devices`. Output should look like this:

```sh
List of devices attached
emulator-5554   device 
```

3) You can simply download `adbss.sh` and call it however you like. This is simpler example for nicer integration and easier updates:

```sh
# Clone adbss repo to your home directory.
git clone https://github.com/chef417/adbss ~

# Create alias in your shell config file ('.bash_profile', '.zshrc', etc.).
echo "alias adbss=\"sh $HOME/adbss/adbss.sh\"" >> ~/.zshrc

# Reload configuration.
source ~/.zshrc

# Start taking screenshots.
adbss
```
