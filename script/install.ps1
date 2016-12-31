# Properties used through out the script
$Props = @{
	url    = "https://github.com/juliostanley/scoop-setup"
	urlRaw = "" # To configure
	urlProfile = "" # To configure
	urlConsoleConfig = "" # To Configure
	command = "" # To configure
	powershellMin = 4
	scoop=@{
		url = "https://get.scoop.sh"
	}
	versionsBucket=@{
		url = "https://github.com/scoopinstaller/versions"
	}
	juliostanleyBucket=@{
		url = "https://github.com/juliostanley/scoop-bucket"
	}
}

# Configure missing properties
$Props.command = "iex (new-object net.webclient).downloadstring(" + $Props.url + ")"
$Props.urlRaw  = $Props.url + "/blob/master"
$Props.urlProfile = $Props.url + "/raw/master/script/profile.ps1?raw=true"
$Props.urlConsoleConfig = $Props.url + "/raw/master/conf/console.xml?raw=true"

# Make sure powershell is the minimum version
$PSVersion = $PSVersionTable.PSVersion.Major
if( $PSVersion -lt $Props.powershellMin ){
	$arch = @{$true='64';$false='86'}[([IntPtr]::Size) -eq 8];
	$msu  = 'Windows6.1-KB2819745-x'+$arch+'-MultiPkg.msu';

	# Do not proceed with the script and notify the user
	Write-Host "========================" -foregroundcolor "yellow";
	Write-Host "- You are running Powershell $PSversion, and you need version $($Props.powershellMin)" -foregroundcolor "yellow";
	Write-Host "- Download the file '$msu' from https://www.microsoft.com/en-us/download/details.aspx?id=408555, or search for windows management framework and install the proper version" -foregroundcolor "yellow";
	Write-Host "- After installing it and rebooting, run this script again. As another option in case you can not install PowerShell version $PSVersion, you may also copy this script from github and change the min version to 3, then run the modified script" -foregroundcolor "yellow";
	Write-Host "========================" -foregroundcolor "yellow";
	Read-Host "Please press any key. Powershell will exit after this";
	Exit;
}

# Utility functions
function which { (get-command $args).path }
function which-path($command = "scoop") {
	$path = (which $command);
	if($path -match 'shims'){ $path = (scoop which $command) };
	Split-Path (Resolve-Path $path).path
}

# To avoid things from being installed in any sort of network share or roaming profile when running under a domain
# We will set that the HOME is under Users
$me = ((whoami) -split "\\")[1]
$null = Remove-Variable -Force -ErrorAction SilentlyContinue HOME;
Set-Variable HOME "C:\Users\$me"
(get-psprovider filesystem).Home = "C:\Users\$me"

# Download URL
Write-Host "Lets go get scoop!!";
iex (new-object net.webclient).downloadstring($Props.scoop.url);

# Install basic scoop utils
Write-Host "Installing some essential utils"
scoop install 7zip curl sudo git openssh coreutils grep sed less vim
scoop bucket add extras
scoop bucket add versions ($Props.versionsBucket.url)
# scoop bucket add juliostanley ($Props.juliostanleyBucket.url)
scoop install pstools sysinternals

# Setting up openssh for git
[environment]::setenvironmentvariable('GIT_SSH', (resolve-path (scoop which ssh)), 'USER');

# Ready
Write-Host "Done installing the essentials"
scoop list

# Update the profile
Write-Host "Updating your powershell profile"
$profileScript = (new-object net.webclient).downloadstring($Props.urlProfile)
if(!(Test-Path -Path $profile)){
	New-Item -path $profile -itemtype file -force
}
Copy-Item $PROFILE ("$PROFILE."+(Get-Date).millisecond+".bak")
Set-Content $PROFILE $profileScript
Write-Host "Your profile has been updated, if it is not there, please download the code from $($Props.urlProfile)"

# Ask if they would like to generate a key
$caption = "Confirm"
$message = "Do you have a ssh key for github setup and is it at $home\.ssh\id_rsa? If you do not know what this is then press N and enter, otherwise press Y and enter";
$yes = new-Object System.Management.Automation.Host.ChoiceDescription "&Yes","help"
$no  = new-Object System.Management.Automation.Host.ChoiceDescription "&No","help"
$choices = [System.Management.Automation.Host.ChoiceDescription[]]($yes,$no)
$stop = $host.ui.PromptForChoice($caption,$message,$choices,0)

if( $stop -eq 1 ){
	Write-Host "We will create a new ssh key and start the local ssh-agent. Don't worry if you have on already. You will be able to just paste the agent public key" -foregroundcolor "yellow"
	try { $null = Get-Process ssh-agent | Stop-Process } catch{ }
	Write-Host "Ok, use the default id_rsa filename by pressing enter, and then type a passphrase" -foregroundcolor "yellow"
	ssh-keygen
	Get-Content "$home\.ssh\id_rsa.pub" | clip
	Write-Host "Go to https://github.com/settings/ssh, then press 'Add SSH Key', and then ctrl+v (the key is already on your clipboard)" -foregroundcolor "yellow"
} else {
	Write-Host "We will use your existing key" -foregroundcolor "yellow"
}

# Run the profile
Write-Host "Running your profile for the first time"
iex $profileScript

# Last piece of information
Write-Host "`nPlease go to $($Props.url)/script/env to see set of scripts you can run to install multiple tools" -foregroundcolor "yellow"

# Install a few more extras
Write-Host "Installing a few enhancers"
scoop install concfg

# Update the style
# Write-Host "Styling Powershell"
# sudo concfg import solarized

# Inform about the need to update git
Write-Host "==================================================" -foregroundcolor "yellow"
Write-Host "You should edit your git config by copying and running the following (use your name and email)" -foregroundcolor "yellow"
Write-Host "git config --global --edit" -foregroundcolor "yellow"
Write-Host "git config --global user.name $me" -foregroundcolor "yellow"
Write-Host "git config --global user.email $me@example.com" -foregroundcolor "yellow"
Write-Host "==================================================" -foregroundcolor "yellow"

# Installing a better console and configure it a bit
scoop install console2
wget $Props.urlConsoleConfig -OutFile "$(which-path console)/console.xml"
console
Write-Host "Console2 has been installed. Please read the README of this project in order to configure it. Its nicer to use than the native powershell terminal" -foregroundcolor "yellow"

# More testing is needed
Write-Host "Installing pshazz, it helps with ssh"
try {
	scoop install pshazz
	Write-Host "Installation complete. You will need to reopen powershell in order to see style changes. You can try 'concfg import solarized' after opening powershell if you do not see changes" -foregroundcolor "yellow"
} catch {
	try{
		# Stop any agent running attempt to
		$null = Get-Process ssh-agent | Stop-Process
		try { $null = Remove-Item "$home\.ssh\agent.env.ps1" } catch {}
		ssh-agent
	} catch{ }
	scoop uninstall pshazz
	Write-Host "We need to reopen the terminal. Please type scoop install pshazz once done (press a key)" -foregroundcolor "yellow"
	$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
	Exit
}







