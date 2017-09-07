$computerName = read-host "What would you like to name the computer? "
$domainName = read-host "What domain would you like to join? "
$localCred = get-credentials -message "Enter the local Administrator credentials"
$domainCred = get-credentials -message "Enter the domain Administrator credentials"

rename-computer -newName $computerName -local
add-computer -domainName $domainName -credential $cred -restart