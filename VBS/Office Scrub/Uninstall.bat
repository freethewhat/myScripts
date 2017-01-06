@echo off

REM uninstalls Office 2003
cscript OffScrub03.vbs ALL /Quiet /NoCancel /Force /OSE

REM uninstalls Office 2007
cscript OffScrub07.vbs ALL /Quiet /NoCancel /Force /OSE 

REM uninstalls Office 2010
cscript OffScrub10.vbs ALL /Quiet /NoCancel /Force /OSE

REM uninstalls Office 2016
cscript OffScrub_O16msi.vbs ALL /Quiet /NoCancel /Force /OSE

REM uninstalls Office 2013
cscript OffScrub_O15msi.vbs ALL /Quiet /NoCancel /Force /OSE

REM uninstalls Office Click2Run
cscript OffScrubc2r.vbs ALL /Quiet /NoCancel /OSE