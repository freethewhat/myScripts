import-module activedirectory

get-aduser -filter * -Properties EmailAddress, ProxyAddresses | where {$_.ProxyAddresses -ne $null} | select-object GivenName, name, SamAccountName, EmailAddress, @{Name="proxyAddresses";Expression={[string]::join(";"ù, ($_.proxyAddresses))}} | export-csv C:\temp\Users.csv
write-host "Users Exported to C:\temp\users.csv"
