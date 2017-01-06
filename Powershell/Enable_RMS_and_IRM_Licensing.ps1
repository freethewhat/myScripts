Set-IRMConfiguration -RMSOnlineKeySharingLocation https://sp-rms.na.aadrm.com/TenantManagement/ServicePartner.svc
Import-RMSTrustedPublishingDomain -RMSOnline -name “RMS Online”
Set-IRMConfiguration -InternalLicensingEnabled $True
Test-IRMConfiguration -RMSOnline