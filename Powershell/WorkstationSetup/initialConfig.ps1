$hostname = read-host "Computer Name: "

rename-computer -NewName $hostname

Install-WindowsFeature -Name Hyper-V -IncludeManagementTools
