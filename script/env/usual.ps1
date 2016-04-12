
Write-Host "Installing usual utilities" -foregroundcolor "yellow";

scoop install sublime-text
scoop install python
scoop install nodejs

Write-Host "Installing node utilities" -foregroundcolor "yellow";
npm install -g rimraf live-server

Write-Host "Preconfiguring Sublime-Text" -foregroundcolor "yellow";
wget https://sublime.wbond.net/Package%20Control.sublime-package -O ((split-path ((scoop which subl) -replace '~',$home)) + "\Data\Installed Packages\Package Control.sublime-package");
wget https://github.com/juliostanley/scoop-setup/raw/master/conf/sublime-package.json?raw=true -O ((split-path ((scoop which subl) -replace '~',$home)) + "\Data\Packages\User\Package Control.sublime-settings");