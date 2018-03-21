# Maintained OS images on reference server
$OS = @(
  @{
    Version = "Windows Server 2016 Std."
    Filename = "Windows Sever 2016 Standard.vhdx"
    Path = "\\10.194.1.20\Virtual Hard Disks\Windows Sever 2016 Standard.vhdx"
  },
  @{
    Version = "Windows Server 2012 R2 Std"
    Filename = "Windows Server 2012 R2.vhdx"
    Path = "\\10.194.1.20\Virtual Hard Disks\Windows Server 2012 R2.vhdx"
  },
  @{
    Version = "Windows Server 2008 R2 Std"
    Filename = "Windows Server 2008 R2.vhdx"
    Path = "\\10.194.1.20\Virtual Hard Disks\Windows Server 2008 R2.vhdx"
  }
)

###############
## PREP WORK ##
###############
$Creds = get-credential -Message "Domain credentials to copy VHD from build server."

## Initial VM Settings
$VM = @{
  Name = read-host "Virtual Machine Name"
  Cores = read-host "Core Count (ie. 1, 2, 3)"
  Memory = 1GB*(read-host "Memory Count in GBs (ie. 4, 8, 16)")
  DiskDataSize = 1GB*(read-host "Size of Data Partition in GBs (ei. 100, 500, 2000)")
  Boot = "VHD"
  Gen = 2
  Switch = (get-vmswitch).name
  VMPath = (Get-VMHost).VirtualMachinePath
  VHDPath = (Get-VMHost).VirtualHardDiskPath
}

## Create VHD Names
$VM.DiskNameSystem = $VM.Name + "_C_SYSTEM.vhdx"
$VM.DiskNameData = $VM.Name + "_D_SYSTEM.vhd"

## OS Version Selection
write-host "`nAvailable Operating Systems:"
for($i = 0; $i -le $OS.length-1; $i++) {
  write-host `t$i - $OS[$i].Version
}

$VM.OS = (read-host "Which OS? [0, 1, 2]")

echo $VM

# @TODO give user option to confirm Settings

#################
## START MAGIC ##
#################

# Create VM
New-VM -Name $VM.Name -MemoryStartupBytes $VM.Memory -Generation $VM.Gen -SwitchName $VM.Switch
Set-VMProcessor $VM.Name -Count $VM.Cores
Set-VMMemory $VM.Name -DynamicMemoryEnabled $false
Set-VM $VM.name -AutomaticStartAction "Start" -AutomaticStopAction "ShutDown"
Disable-VMIntegrationService $VM.Name  -name "Time Synchronization"

if(!(Test-Path ($VM.VHDPath + "\" + $OS[$VM.OS].Filename))) {
  # @TODO create a status for the Copying

  write-host "Copying VHD. This might take a while..."
  write-host "Wouldn't it be cool if you had a status?"
  copy-item -Path $OS[$VM.OS].Path -Destination ($VM.VHDPath + "\" + $OS[$VM.OS].Filename)
} else {
  write-host "System Image is already copied"
}

write-host "Creating VM Data Disk"
copy-item -Path ($VM.VHDPath + "\" + $OS[$VM.OS].Filename) -Destination ($VM.VHDPath + "\" + $VM.DiskNameSystem)

New-VHD -Path ($VM.VHDPath + "\" + $VM.DiskNameData) -size $VM.DiskDataSize -Dynamic
Add-VMHardDiskDrive -VMName $VM.Name -Path ($VM.VHDPath + "\" + $VM.DiskNameSystem)
Add-VMHardDiskDrive -VMName $VM.Name -Path ($VM.VHDPath + "\" + $VM.DiskNameData)
Set-VMFirmware $VM.Name -FirstBootDevice (Get-VMHardDiskDrive $VM.Name | where{$_.ControllerLocation -eq 0})

# Start newly configured VM
Start-VM -Name $VM.Name
