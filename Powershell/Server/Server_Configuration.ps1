function Disable-IE-Security {
  $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
  $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
  Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
  Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0
  Stop-Process -Name Explorer
  write-host -ForegroundColor green "IE Enhanced Security Disabled"
}

function Enable-IE-File-Downloads {
  $HKLM = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3"
  $HKCU = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3"
  Set-ItemProperty -Path $HKLM -Name "1803" -Value 0
  Set-ItemProperty -Path $HKCU -Name "1803" -Value 0
  write-host -ForegroundColor green "IE File Download Enabled"
}

function Enable-Shadow-Copy($DriveLetter) {
  #DriveLetter should be in format of C, D, E
  $Drive = $DriverLetter + ":"

  vssadmin add shadowstorage /for=$Drive /on=$Drive  /maxsize=10%
  vssadmin create shadow /for=$Drive
  write-host -ForegroundColor green "Shadow Copy Enabled for $Drive"
}

function Schedule-Shadow-Copy($DriveLetter, $Time) {
  #Time should be formatted as 6:00AM, 12:00PM, 7:00PM
  #DriveLetter should be in format of C, D, E
  $Drive = $DriveLetter + ":"
  $TaskName = "ShadowCopy_" + $DriveLetter + "_" + ($Time -replace ":", "")

  $Action=new-scheduledtaskaction -execute "c:\windows\system32\vssadmin.exe" -Argument "create shadow /for=$DriveLetter"
  $Trigger=new-scheduledtasktrigger -daily -at $Time
  Register-ScheduledTask -TaskName $TaskName -Trigger $Trigger -Action $Action -Description $TaskName
  Write-Host -ForegroundColor green "Created Scheduled Task $TaskName"
}

function Enable-Remote-Desktop {
  Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0
  Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
  Write-Host -ForegroundColor green "Remote Desktop is Enabled"
}
