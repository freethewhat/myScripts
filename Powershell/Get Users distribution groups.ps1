$firstname = Read-Host "First Name: " #ask for first name
$lastname = Read-host "Last Name: " #ask for last name
$user = $firstname + " " + $lastname #concatenate

Get-DistributionGroup | where-object { ( Get-DistributionGroupMember $_ | where-object { $_.Name -eq $user}) } #searches the database
