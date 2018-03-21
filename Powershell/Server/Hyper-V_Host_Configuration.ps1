$computerName = read-host "What is the name of the server? "

#issue with volume letters
set-volume -DriveLetter C -NewFileSystemLabel "System"
set-volume -DriveLetter D -NewFileSystemLabel "Data"

#Enable Shadows
vssadmin add shadowstorage /for=C: /on=C:  /maxsize=10%
vssadmin add shadowstorage /for=D: /on=D:  /maxsize=10%

#Create Shadows
vssadmin create shadow /for=C:
vssadmin create shadow /for=D:

#Set Shadow Copy Scheduled Task for C: AM
$Action=new-scheduledtaskaction -execute "c:\windows\system32\vssadmin.exe" -Argument "create shadow /for=C:"
$Trigger=new-scheduledtasktrigger -daily -at 6:00AM
Register-ScheduledTask -TaskName ShadowCopyC_AM -Trigger $Trigger -Action $Action -Description "ShadowCopyC_AM"

#Set Shadow Copy Scheduled Task for D: AM
$Action=new-scheduledtaskaction -execute "c:\windows\system32\vssadmin.exe" -Argument "create shadow /for=D:"
$Trigger=new-scheduledtasktrigger -daily -at 7:00AM
Register-ScheduledTask -TaskName ShadowCopyD_AM -Trigger $Trigger -Action $Action -Description "ShadowCopyD_AM"

Install-WindowsFeature -Name Hyper-V -IncludeManagementTools
DISM /Online /Enable-Feature /FeatureName:NetFx3 /All /NoRestart

#Create NIC teams
New-NetLbfoTeam -Name "Hyper-V" -TeamMembers "SLOT*" -confirm:$false
New-NetLbfoTeam -Name "Management" -TeamMembers "NIC*"-confirm:$false

#configure Hyper-V
New-VMSwitch -name ExternalSwitch  -NetAdapterName "Hyper-V" -AllowManagementOS $false

Set-VMHost -VirtualMachinePath "D:\Hyper-V"
Set-VMHost -VirtualHardDiskPath "D:\Hyper-V\Virtual Disks"

#Rename Computer
rename-computer -NewName $computerName

#Reboot Computer
restart-computer -confirm
