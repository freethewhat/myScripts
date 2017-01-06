Dim from_sv, to_sv, PrinterPath, PrinterName, DefaultPrinterName, DefaultPrinter
Dim DefaultPrinterServer, SetDefault, key
Dim spoint, Loop_Counter
Dim WshNet, WshShell
Dim WS_Printers

DefaultPrinterName = ""
spoint = 0
SetDefault = 0
set WshShell = CreateObject("WScript.shell")

from_sv = "\\MCHS-SERVICE01" 'This should be the name of the old server.
to_sv = "\\MCHS-DC02" 'This should be the name of your new server.

'Make sure there are printers installed
On Error Resume Next
key = "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows\Device"
DefaultPrinter = LCase(WshShell.RegRead (key))
If Err.Number <> 0 Then
DefaultPrinterName = ""
else
'If the registry read was successful then parse out the printer name so we can
' compare it with each printer later and reset the correct default printer
' if one of them matches this one read from the registry.
spoint = instr(3,DefaultPrinter,"\")+1
DefaultPrinterServer = left(DefaultPrinter,spoint-2)
if DefaultPrinterServer = from_sv then
DefaultPrinterName = mid(DefaultPrinter,spoint,len(DefaultPrinter)-spoint+1)
end if
end if
Set WshNet = CreateObject("WScript.Network")
Set WS_Printers = WshNet.EnumPrinterConnections
For Loop_Counter = 0 To WS_Printers.Count - 1 Step 2
PrinterPath = lcase(WS_Printers(Loop_Counter + 1))
if LEFT(PrinterPath,len(from_sv)) = from_sv then
spoint = instr(3,PrinterPath,"\")+1
PrinterName = mid(PrinterPath,spoint,len(PrinterPath)-spoint+1)
WshNet.RemovePrinterConnection from_sv+"\"+PrinterName
WshNet.AddWindowsPrinterConnection to_sv+"\"+PrinterName
if DefaultPrinterName = PrinterName then
WshNet.SetDefaultPrinter to_sv+"\"+PrinterName
end if
end if
Next
Set WS_Printers = Nothing
Set WshNet = Nothing
Set WshShell = Nothing