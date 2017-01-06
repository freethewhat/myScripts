cd /d %windir%\system32
net stop vss
net stop swprv
regsvr32 /s ole32.dll
regsvr32 /s oleaut32.dll
regsvr32 /s vss_ps.dll
vssvc /register
regsvr32 /s /i swprv.dll
regsvr32 /s /i eventcls.dll
regsvr32 /s es.dll
regsvr32 /s stdprov.dll
regsvr32 /s vssui.dll
regsvr32 /s msxml.dll
regsvr32 /s msxml3.dll
regsvr32 /s msxml4.dll
vssvc /register
net start swprv
net start vss