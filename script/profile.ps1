
# Get the command path for a given command
function which {
	(get-command $args).path
}

# Get the directory for a given scoop package
function which-path($command = "scoop") {
	$path = (which $command);
	if($path -match 'shims'){ $path = (scoop which $command) };
	Split-Path (Resolve-Path $path).path
}

# Make a bit more simple to import certs for java
function java:ssl:import {
	if($args) {$_HOST=$args[0]} else {$_HOST="ca"}
	$_PORT=443
	$_KEYSTOREFILE="$(split-path(which java))\..\jre\lib\security\cacerts"
	$_KEYSTOREPASS="changeit"
	$_CERT="$home\.certs\import.cer"

	if(($_HOST -ne "ca") -and ((Test-Path $_KEYSTOREFILE) -ne $True)){
		Write-Host "Unable to find the 'java' binary, please make sure it is available"
		return
	}
	if(-not(Test-Path $_CERT)){
		Write-Host "You want to import a certificate for '$_HOST', but the file '$_CERT' does not exist"
		return
	}

	# Get the SSL Certificate
	keytool -import -noprompt -trustcacerts -alias $_HOST -file $_CERT -keystore "$_KEYSTOREFILE" -storepass $_KEYSTOREPASS

	# Verify it
	# keytool -list -v -keystore $_KEYSTOREFILE -storepass $_KEYSTOREPASS
}

# For symbolic links like:
# mklink /d linkname ../../dom-target-dir
# mklink filelinkname C:/somefilepath-or-it-could-be-relative
function mklink {
	sudo cmd /c mklink $args
}

# To list the current directory showing hidden files as well as links (dir in powershell acts a bit different and does not show links)
function ll {
	cmd /c dir /a $args
}

# Make it shinny
function cool {
	# Initialize pshazz
	try { $null = gcm pshazz -ea stop; pshazz init 'default' }
	catch { Write-Host 'You do not have pshazz installed. Install it with scoop install pshazz' }
}

# Forget all cmd password
function cmdkey:forget {
	Get-Process ssh-agent | Stop-Process
	cmdkey /list | where { $_.Contains('Target:') } `
	| foreach { cmdkey /delete:($_ -replace 'Target: LegacyGeneric:target=').trim() }
}

# To reset paths for scoop apps
function scoop:resetall {
	get-childitem -path "$(which scoop)\..\..\apps" | ForEach-Object {scoop reset $_.Name}
}

# Set the node_modules path
function Set-NodeModulesPath {
    if(-not("$env:path" -match "node_modules")) {
        $NEWPATH = '.\node_modules\.bin;' + [environment]::GetEnvironmentVariable('PATH','User');
        [environment]::SetEnvironmentVariable('PATH',$NEWPATH,'User');
        $env:Path = $NEWPATH;
    }
}

# NPM Assistant. Allows to run from a GUI npm scripts that are described in a package.json (the scripts do not have to be nodejs related, they can be java or any other type of command)
# package.json simply provides a nice standard way of defining named command snippets
function assist {
    # Install it if missing
    if(-not(get-command npm-assistant -ErrorAction SilentlyContinue)){ npm install -g --legacy-bundling npm-assistant; }
    # It runs as a seperate process and in the background. It can be turned off from the gui
    Start-Process npm-assistant -WindowStyle Hidden;
    # Open chrome browser
    Write-Host "`nNPM Assistant has started in the background`nNavigate to http://localhost:61101`nUse ctrl+click to start scripts on a visible window`n" -ForegroundColor Yellow;
}

# Get the path
function Path {
	$env:Path -replace ";","`n";
}

# Open visual studio code without SSL checks (useful when installing plugins and having issues with certs behind proxies)
function vcode {
	$env:NODE_TLS_REJECT_UNAUTHORIZED=0;
	code $args;
}

# Move multiple git files
function git-mv-children {
	$from=$args[0];
	$to=$args[1];
	Get-ChildItem $from | % {
		git mv "$($from)/$($_.name)" "$to";
	}
}

# Edit the hosts file
function Edit-Hosts {
    sudo subl "$env:windir/System32/drivers/etc/hosts"
}

# Update the console config
function Update-ConsoleConfig {
	Write-Host "Updating your console2 profile" -foregroundcolor "yellow";
	$url = "https://github.com/juliostanley/scoop-setup" + "/raw/master/conf/console.xml?raw=true";
	wget $url -OutFile "$(which-path console)/console.xml"
}

# Update to the latest profile
function Update-Profile {
	$url = "https://github.com/juliostanley/scoop-setup" + "/raw/master/script/profile.ps1?raw=true";
	Write-Host "Updating your powershell profile" -foregroundcolor "yellow";
	$profileScript = (new-object net.webclient).downloadstring($url)
	if(!(Test-Path -Path $profile)){
		New-Item -path $profile -itemtype file -force
	}
	Copy-Item $PROFILE ("$PROFILE."+(Get-Date).millisecond+".bak")
	Set-Content $PROFILE $profileScript
	. $profile
	Write-Host "Your profile has been updated, if it is not there, please download the code from $($url)"
}

# Make home the Users' machine home directory
$me = ((whoami) -split "\\")[1]
$null = Remove-Variable -Force -ErrorAction SilentlyContinue HOME;
Set-Variable HOME "C:\Users\$me"
(get-psprovider filesystem).Home = "C:\Users\$me"

# Start configuring current window
Write-Host "Hi $me! Let's do this!"
Write-Host "Checking on your ssh-agent and environment..."

# Use node_modules binaries since they are very common
if(-not("$env:path" -match "node_modules")) {
    Write-Host "Ensuring relative paths for binaries..."
    Set-NodeModulesPath
}

# Run the ssh agent, and auto ocnfigure the password
Write-Host "Checking ssh-agent"
if( test-path "$(which scoop)\..\..\apps\pshazz" ){
	. (((split-path (scoop which pshazz)) -replace '~',$home) + '\..\plugins\ssh.ps1')
	try { pshazz:ssh:init } catch { $_ | fl -force }
} else {
	Write-Host "You do not yet have pshazz, this helps with ssh. 'scoop install pshazz"
}

# Setup GIT_SSH environment
Write-Host "Setting SSH agent for git..."
$env:GIT_SSH=((scoop which ssh) -replace '~',$home)

# Notify we are ready
Write-Host "Type 'cool' and you will get pshazz running.";
Write-Host "Done. Lets do this!";

# Current working directory set to something other than the drive letter or home
if(((Get-Location).path.length -gt 3) -and -not((Get-Location).path -eq $home)){
  $workingDirectory = (Get-Location).path;
}

# Stay at the current directory if a workingDirectory was provided
if(-Not ($workingDirectory)){
  if($null=(test-path $home\workspace)) {cd $home\workspace}
  else {cd $home}
}

# Load the profile extension if available or create it if not
$personalProfile="$(split-path $profile -parent)/Personal.Profile.ps1";
if (!(Test-Path $personalProfile))
{
   $null = New-Item -path $personalProfile -value 'Write-Host "You should run `"notepad `$personalProfile`" and modify your personal profile."';
   Write-Host "Created $personalProfile";
}
. $personalProfile
