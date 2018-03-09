# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install Applications
choco install adobe-creative-cloud
choco install steam
choco install googlechrome
choco install firefox
choco install spotify
choco install atom
choco install github
choco install vlc
choco install office365proplus
choco install discord

# Install Environments
choco install putty.install
choco install conemu
choco install nodejs.install
choco install bitnami-xampp
choco install python2
choco install jdk8
choco install jre8
