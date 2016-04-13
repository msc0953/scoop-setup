# Scoop Setup

Provides a common installation of scoop, and access essential development utilities

> NOTE: Each tool and scoop itself are not part of this project, this only facilitates the initial setup/access. They each have their own license (many are open source, but others may not) please review their licenses before using them.

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

Console2 should have been installed and configured after you ran the install script above. If you would like to update to the latest settings provided available in [console.xml](./conf/console.xml), open powershell and run:
```Update-ConsoleConfig```

#### Manually updating settings

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
  	- New Tab 1: Ctrl+T
  	- Next Tab: Alt+Right
  	- Previous Tab: Alt+Left
  - Tabs:
  	- Title: W
  	- Shell: C:\Windows\System32\WindowsPowershell\v1.0\powershell.exe
  	- Startup dir: C:\Users\YOUR_USERNAME\workspace
  - Press ok
  - Close the console and open it again

#### Colors

Using https://github.com/stevenharman/console2-solarized you can paste the following colors within console.xml in order to use a solarized tone for console2.

Usually under: C:\Users\YOUR_USERNAME\AppData\Local\scoop\apps\console2\VERSION\console.xml

```
<colors>
  <color id="0" r="7" g="54" b="66"/>
  <color id="1" r="38" g="139" b="210"/>
  <color id="2" r="133" g="153" b="0"/>
  <color id="3" r="42" g="161" b="152"/>
  <color id="4" r="220" g="50" b="47"/>
  <color id="5" r="211" g="54" b="130"/>
  <color id="6" r="181" g="137" b="0"/>
  <color id="7" r="238" g="232" b="213"/>
  <color id="8" r="42" g="161" b="152"/>
  <color id="9" r="131" g="148" b="150"/>
  <color id="10" r="88" g="110" b="117"/>
  <color id="11" r="147" g="161" b="161"/>
  <color id="12" r="203" g="75" b="22"/>
  <color id="13" r="108" g="113" b="196"/>
  <color id="14" r="101" g="123" b="131"/>
  <color id="15" r="253" g="246" b="227"/>
</colors>
```

### More installations

Under [script/env](./script/env) you can find commonly used scripts to setup some developer tools.









