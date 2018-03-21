Import-Module .\Server_Configuration.ps1 -force
Import-Module .\Server_Role_Installation.ps1 -force

# @TODO if BWS Standard file server create associated folder automatically and configure DFS
# @TODO enable access based enumeration
# @TODO create medkit fabricator
# @TODO update Server

$ComputerName = Read-Host "What is the name of the server?"
$Roles = Role-Selection
$DiskSystem = get-disk | where {$_.OperationalStatus -eq "Online"}
$DiskData = get-disk | where {$_.OperationalStatus -eq "Offline"}

# Set System Partition Name
set-volume -DriveLetter C -NewFileSystemLabel "System"

# Configure Data Disk
set-disk -number $DiskData.Number -isOffline $false
Initialize-Disk -Number $DiskData.number -PartitionStyle GPT
New-Partition -DiskNumber $DiskData.Number -AssignDriveLetter -UseMaximumSize
Format-Volume -DriveLetter D -FileSystem NTFS -NewFileSystemLabel "Data" -confirm:$false

# Enable Shadow Copy
Enable-Shadow-Copy C
Enable-Shadow-Copy D

# Set Shadow Copy Scheduled Task for C:
Schedule-Shadow-Copy C 6:00AM
Schedule-Shadow-Copy C 12:00PM
Schedule-Shadow-Copy C 6:00PM
Schedule-Shadow-Copy D 7:00AM
Schedule-Shadow-Copy D 12:00PM
Schedule-Shadow-Copy D 7:00PM

# Set TimeZone
Set-TimeZone -Id "Mountain Standard Time"
write-host -ForegroundColor Green "TimeZone set to MST"
# Enable RDP
Enable-Remote-Desktop

# Disable IE Enhanced Security
Disable-IE-Security

# Enable File Download Internet Explorer
Enable-IE-File-Downloads

Role-Installation $Roles

Rename-Computer $ComputerName
Restart-Computer
