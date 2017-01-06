$CRED = Get-Credential
$SESSION = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $CRED -Authentication Basic -AllowRedirection
Import-PSSession $SESSION

$USER = read-host "Which email would you like to convert to a shared mailbox?"

Get-Mailbox -identity $USER | set-mailbox -type Shared

#Change the users below if changes happens
Add-MailboxPermission -identity $USER -User "Matt Manley" -AccessRights FullAccess
Add-MailboxPermission -identity $USER -User "Conor Smith" -AccessRights FullAccess
Add-MailboxPermission -identity $USER -User "Stephen Mccollum" -AccessRights FullAccess
Add-MailboxPermission -identity $USER -User "Tyler Grutsch" -AccessRights FullAccess
Add-MailboxPermission -identity $USER -User "Brandy Fowler" -AccessRights FullAccess