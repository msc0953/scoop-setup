# Scoop Setup

Provides a common installation of scoop, and essential development utilities.

### What is scoop?

[Scoop](http://scoop.sh) is a dependency manager primarily for dev tools, like NodeJS, JDK, IDEs.

### How to use it

- Open powershell with administrative privilages (Right click, Run As Administrator)
- Run the following command
- ```set-executionpolicy unrestricted;```
- Close powerhsell
- Open powershell WITHOUT administrative privilages
- Run the following command

```
iex (new-object net.webclient).downloadstring('https://github.com/juliostanley/scoop-setup/raw/master/script/install.ps1?raw=true');
```

### Why use scoop?

So you do not need to simulate a linux environment inside windows, yet have access to all the common utitlities: ps, grep, sed, vim, git, ssh-add, ssh-agent, sudo, etc... All of these done from powershell, which provides you with many other utiltites native to windows. It also provides you with a very simple package manager which can be used to easily install other dependencies like Nodejs (scoop install nodejs). They will all be under a single directory. It will also update your PATH when needed.

### Where is everything installed

Scoop will "install" everything under ~/AppData/Local/scoop

### How to add more entries to the repository?

- You can either use buckets which are directories with json files (each describes for scoop how to install a package)
- You can create a single json and use that to install some package

### Useful powershell commands

- ```scoop uninstall scoop```
- ```scoop list``` Show installed packages
- ```scoop search``` To list all available packages
- ```scoop reset nodejs0127``` To set the version of node to a previous version (if installed, similar for other packages)
- ```scoop bucket list``` To list the buckets available in scoop
- ```scoop bucket update somename``` To update a bucket called somename (youl will need to have installed it first)
- ```sudo``` To run commands with administrator privileges
- ```mklink``` Use this to create symbolic links
- ```which``` To echo the filesystem path to a specific command/binary
- ```ll``` For listing directories
- ```explorer .``` Opens the explorer in the current directory use ```ii . ``` for short
- ```subl .``` Open sublime in the current directory
- ```subl $profile``` Open the powershell profile in order to view/edit
- ```vim $profile``` Open the powershell profile with vim
- ```$env:PATH``` To see the current environmental variable for PATH
- ```$env:PATH='C:/some/dir/;'+$env:PATH``` To update temporarily the path
- ```[environment]::SetEnvironmentVariable('key','value','User')``` To set a environmental variable permanently
- ```[environment]::SetEnvironmentVariable('key',$null,'User')``` To delete a environmental variable permanently

### Console2

The powershell window in terms of funccionality is very simple. A better option is Console2, which will provide you with tabs, easier copy/paste and just a better experience overall.


- Open powershell
- Run ```scoop install console2```
- Type console
- Pin the just opened app to your taskbar
- Close powershell and console
- Open console by clicking on the icon
- From the menu open Edit -> Settings
  - Console:
    - Shell: C:\Windows\System32\WindowsPowershell\v1.0\powershell.exe
    - Startup dir (which ever you perfer): C:\Users\YOUR_USERNAME\workspace 
  - Behaviour:
  	- Copy on select
  - Hot Keys:
  	- New Tab 1: ctrl+tab
  	- Next Tab: Alt-Right
  	- Previous Tab: Alt+Left
  - Tabs:
  	- Title: W
  	- Shell: C:\Windows\System32\WindowsPowershell\v1.0\powershell.exe
  	- Startup dir: C:\Users\YOUR_USERNAME\workspace
  - Check save settings to user directory
  - Press ok
  - Close the console and open it again

### More installations

Under [script/env](./script/env) you can find commonly used scripts to setup some developer tools.









