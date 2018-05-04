Set-ExecutionPolicy RemoteSigned
$cred = Get-Credential
$session =  New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $cred -Authentication Basic –AllowRedirection

Import-PSSession $Session

Set-IRMConfiguration -RMSOnlineKeySharingLocation "https://sp-rms.na.aadrm.com/TenantManagement/ServicePartner.svc"

Import-RMSTrustedPublishingDomain -RMSOnline -name "RMS Online"

Remove-PSSession $Session