# To use use must run from an administrative powershell prompt
# You need to set the execution policy to unrestricted
# Set-ExecutionPolicy Unrestructed

function Change-ComputerName($ComputerName) {
    rename-computer -NewName $ComputerName
    write-host -ForegroundColor green "Computer renamed to: " . $ComputerName
}

function Install-Chocolatey {
  Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
  write-host -ForegroundColor green "Chocolatey Installed"
}

function Install-Chrome {
  choco install googlechrome -y
  write-host -ForegroundColor green "Google Chrome Installed"
}

function Install-Bluebeam {
 set-location "X:\$ CLIENT SPECIFIC\JCG\BlueBeamDeploy"
 msiexec.exe /i "Bluebeam Revu x64 17.msi" BB_SERIALNUMBER=9805794 BB_PRODUCTKEY=BUD4B-5AZE4P4 BB_EDITION=2 BB_DESKSHORTCUT=1 BB_DEFAULTVIEWER=1 /qn

 $installing = Get-Process msiexec -ErrorAction SilentlyContinue
 write-host "Installing Bluebeam"
}

function Install-Office365ProPlus {
  set-location "X:\Microsoft\Office 365 Pro Plus"
  ./setup.exe /configure .\configuration.xml
  write-host -ForegroundColor green "Office 365 Pro Plus Installed"
}

$computerName = read-host "What is the name of this computer?"

net use X: \\fcbuild-hv\SOFTWARE
Install-Chocolatey
Install-Chrome
Install-Office365ProPlus
Install-Bluebeam

Change-ComputerName $computerName
