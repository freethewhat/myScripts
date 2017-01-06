On Error Resume Next

'--------------------------------------------Declarations, Objects and Const-------------------------------------------------------------------


Set FSO = CreateObject("Scripting.FileSystemObject")
Const ForReading = 1, ForWriting = 2, ForAppending = 8
Dim strDate1
Dim strTime1
Dim strTime2
Dim myDateString1
Dim myTimeString4
myDateString1 = FormatDateTime(Date(), 1)
myTimeString4 = FormatDateTime(Time(), 4)
strDate = Replace(Date, "/","_")
strTime1 = Left(myTimeString4, 2)
strTime2 = Right(myTimeString4, 2)
Const adVarChar = 200
Const MaxCharacters = 255
Const adFldIsNullable = 32


'---------------------------------------------Open and Create Log Files-------------------------------------------------------------------------

SPath = "ROOT PATH"											 																						' root folder location
masterPath = "MASTER ARCHIVE FILE PATH"																									     		' master_archive file path, txt file with everything ever archived
Set masterFile = FSO.OpenTextFile(masterPath, ForAppending, True) 																					' open master archive file to add to it.
Set logFile = FSO.OpenTextFile("JOB PATH\archive_" & strDate & "_" & strTime1 & "-" & strTime2 & ".txt", ForWriting, True)  						' create job log file
logFile.Write "------------File Archive Run Log------------" & VbCrLf & VbCrLf                                         								' start writing to the job log file

'---------------------------------------------Create Objects------------------------------------------------------------------------------------

Dim objFSO, ofolder, objStream
Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("scripting.filesystemobject")
Set objNet = CreateObject("WScript.NetWork")
Set objShell = CreateObject("Wscript.Shell")
 
'--------------------------------------------End Declarations and Sets-------------------------------------------------------------------------- 
 
retentionTime = 730                                            																							' amount of retention time in days
moveCount = 0												 																							' total amount of moved files
rootSize = 0												 																							' total size of root 
movedSize = 0                                                																							' total size of moved data in bytes

Set rootFolder = FSO.GetFolder(SPath)                        																							' set object with root folder
rootSize = rootFolder.Size                                   																							' get size of root folder in bytes

'------------------------------------------Do Archiving Job--------------------------------------------------------------------------------------

CheckFolder FSO.GetFolder(SPath)                             																							' Check Root of folder for archiving
CheckSubfolders FSO.GetFolder(SPath)					     																							' start parsing through subfolders looking through all subfolders

movedSize = movedSize / 1048576                              																							' turn total size of files moved from bytes to megabytes

logFile.Write VbCrLf & VbCrLf & "------------Log File End------------" & VbCrLf       																	' finish writing moved files to the log file
logFile.Write VbCrLf & "Total amount of files moved: " & moveCount & VbCrLf           																	' writes the total number of files moved to the log
logFile.Write "Total size moved (MB):" & movedSize & VbCrLf                           																	' writes the total size of files moved in MBs to the log  
logFile.Close																		  																	' closes the log file
masterFile.Close																	  																	' closes the master log file
donePopup = objShell.Popup("Files successfully archived.", 10, "Task Success")     							   											' display completion popup

'--------------------------------------------Start Subs and Functions For Archiving-------------------------------------------------------------


		Sub CheckSubFolders(Folder)                          											 												' Find all sub folders within root
			For Each Subfolder in Folder.SubFolders
				CheckFolder(subfolder)													   				 												' for each subfolder, check each  with in object
				CheckSubFolders Subfolder
			Next
		End Sub
		

		Sub CheckFolder(objCurrentFolder)                                       																		'checks files within the specified folder
		Dim objFile
		today = date 
		For Each objFile In objCurrentFolder.Files                               
		FileName = objFile
		FileAccessed = FormatDateTime(objFile.DateLastAccessed, "2")                         															' get the Last Date Accessed from file
		If DateDiff("d", FileAccessed, today) > retentionTime Then                           															'checks that the file is within the specified time period
			mRoot = objFile
			stubPath = mRoot
			fileSize = objFile.size
			mRoot = Replace(mRoot,"\\SOURCE_IP","DESTINATION_IP")                                     													'replaces the root file path with the destination path
			mFolder = objCurrentFolder
			mFolder = Replace(mFolder,"\\SOURCE_IP","\\DESTINATION_IP")                                 												'replaces the root folder path with the destination path
				If Not FSO.FolderExists(mFolder) Then										 															'check to see if root folder is in the destination 
					   objShell.Run "cmd /c mkdir """ & mFolder & """"							 														'if doesn't exist, create folder using command shell
					   WScript.Sleep 200                                                     															'wait 2/10 of second before ending If statement
				End If
			FSO.MoveFile objFile, mRoot			                                             															'moves the file to the destination folder
            moveCount = moveCount + 1				                                         															'add 1 to the move count
			movedSize = movedSize + fileSize																											'add the total file size to the total moved size
			logFile.Write date & " Moved File To: " & mRoot & VbCrLf 								 													'write the moved files new location to logfile
			masterFile.Write date & " Moved File To: " & mRoot & VbCrLf								 													'write the moved files new location to the master log file
				Set stubFile = FSO.OpenTextFile(stubPath & ".txt", ForWriting, True) 																	'creates a stub file named after the moved file
				stubFile.Write "This file has been archived due to the retention policy of: 730 days since last accessed." & VbCrLf & "Read-Only access to this file can be obtained by copying the following link into a run box: " & VbCrLf & VbCrLf & mRoot & "" 'puts the full archived path in the stub file
				stubFile.Close																															' closes the stub file and moves on
		End If
		Next
		End Sub
		
'--------------------------------------------------------End Script------------------------------------------------------------------------------------
		