
Write-Host "Installing usual utilities" -foregroundcolor "yellow";

scoop install sublime-text
scoop install python
scoop install nodejs

Write-Host "Installing node utilities" -foregroundcolor "yellow";
npm install -g rimraf live-server

Write-Host "Preconfiguring Sublime-Text" -foregroundcolor "yellow";
$sublPath = (which-path subl);

# Get the package control
wget https://sublime.wbond.net/Package%20Control.sublime-package -O "$sublPath\Data\Installed Packages\Package Control.sublime-package");

# Get the sublime packages that should be installed
wget https://github.com/juliostanley/scoop-setup/raw/master/conf/sublime-packages.json?raw=true -O "$sublPath\Data\Packages\User\Package Control.sublime-settings";

# Get the initial user preferences
wget https://github.com/juliostanley/scoop-setup/raw/master/conf/sublime-preferences.json?raw=true -O "$sublPath\Data\Packages\User\Preferences.sublime-settings";