Import-Module .\Server_Configuration.ps1 -force
Import-Module .\Server_Role_Installation.ps1 -force

$computerName = read-host "What is the name of the server? "

# Rename Volume Labels
set-volume -DriveLetter C -NewFileSystemLabel "System"
set-volume -DriveLetter D -NewFileSystemLabel "Data"

# Enable Shadow Copy
Enable-Shadow-Copy C
Enable-Shadow-Copy D

# Schedule Shadow Copy
Schedule-Shadow-Copy C 6:00AM
Schedule-Shadow-Copy D 7:00AM

# Set TimeZone
Set-TimeZone -Id "Mountain Standard Time"
write-host -ForegroundColor Green "TimeZone set to MST"

# Configure OS Settings
Disable-IE-Security
Enable-IE-File-Downloads
Enable-Remote-Desktop

# Install .Net 3.5
DISM /Online /Enable-Feature /FeatureName:NetFx3 /All /NoRestart

# Install Hyper-V Roles
Install-HV-Roles

#Rename and Reboot Computer
rename-computer -NewName $computerName
restart-computer -confirm
