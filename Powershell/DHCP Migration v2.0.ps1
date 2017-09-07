﻿########################################################################
# DHCP Migration Script v.2.0
# -------------------------------------
# Script can be used to migrate from 2008/2008R2/2012/2012R2 DCHP servers - no support for 2003 servers
# Script presents a GUI allowing you to select migration options - single scope, full server, options only, reserverations only
# YOu must have the DHCP PowerShell module installed on the computer you are running this script from
# You must have permissions to make changes to DHCP
# 
# Generated By: Denis Cooper www.sinamon.co.uk January 2014
#
########################################################################

function GenerateForm {

#region Import the Assemblies
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
[reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null
#endregion

#region Generated Form Objects
$form1 = New-Object System.Windows.Forms.Form
$btnCancel = New-Object System.Windows.Forms.Button
$btnOK = New-Object System.Windows.Forms.Button
$gboxScopes = New-Object System.Windows.Forms.GroupBox
$txtScopeSubnet = New-Object System.Windows.Forms.TextBox
$lblScope = New-Object System.Windows.Forms.Label
$lblWarning = New-Object System.Windows.Forms.Label
$gboxServers = New-Object System.Windows.Forms.GroupBox
$txtDestinationServer = New-Object System.Windows.Forms.TextBox
$lblDestinationServer = New-Object System.Windows.Forms.Label
$lblSourceServer = New-Object System.Windows.Forms.Label
$txtSourceServer = New-Object System.Windows.Forms.TextBox
$gboxMigrationType = New-Object System.Windows.Forms.GroupBox
$chkState = New-Object System.Windows.Forms.CheckBox
$rdoReservations = New-Object System.Windows.Forms.RadioButton
$rdoServerOptions = New-Object System.Windows.Forms.RadioButton
$rdoAllScopes = New-Object System.Windows.Forms.RadioButton
$rdoSingleScope = New-Object System.Windows.Forms.RadioButton
$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState
#endregion Generated Form Objects

#form action code
$btnOK_OnClick= 
{
	#Checks to see which option was selected to run
	If(!($txtSourceServer.text)) {
			$buttons=[system.windows.forms.messageboxbuttons]::ok;
			[system.windows.forms.messagebox]::Show("You Must specify the source server name","",$buttons)
		}
	ElseIf(!($txtDestinationServer.text)) {
			$buttons=[system.windows.forms.messageboxbuttons]::ok;
			[system.windows.forms.messagebox]::Show("You Must specify the destination server name","",$buttons)
		}
	ElseIf ($rdoSingleScope.Checked -eq "True") {
		MigrateSingleScope
		}
	ElseIf ($rdoAllScopes.Checked -eq "True") {
		MigrateAllScopes
		}
	ElseIf ($rdoReservations.Checked -eq "True") {
		MigrateReservations
		}
	ElseIf ($rdoServerOptions.Checked -eq "True") {
		MigrateServerOptions
		}
}

$btnCancel_OnClick= 
{
$Form1.Close()
}

$handler_rdoSingleScope= 
{
#Enables the single scope subnet box if this option is selected
$txtScopeSubnet.Enabled = $true
}

$handler_rdoAllScopes=
{
#Disables the single scope subnet box if this option is selected
$txtScopeSubnet.Enabled = $false
}

$handler_rdoServerOptions=
{
#Disables the single scope subnet box if this option is selected
$txtScopeSubnet.Enabled = $false
}

$handler_rdoReservations=
{
#Enables the single scope subnet box if this option is selected
$txtScopeSubnet.Enabled = $true
}

$OnLoadForm_StateCorrection=
{#Correct the initial state of the form to prevent the .Net maximized form issue
	$form1.WindowState = $InitialFormWindowState
}



#----------------------------------------------
#region Generated Form Code
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 469
$System_Drawing_Size.Width = 469
$form1.ClientSize = $System_Drawing_Size
$form1.DataBindings.DefaultDataSourceUpdateMode = 0
$form1.Name = "form1"
$form1.Text = "DHCP Migrator"


$btnCancel.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 384
$System_Drawing_Point.Y = 436
$btnCancel.Location = $System_Drawing_Point
$btnCancel.Name = "btnCancel"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 71
$btnCancel.Size = $System_Drawing_Size
$btnCancel.TabIndex = 4
$btnCancel.Text = "Cancel"
$btnCancel.UseVisualStyleBackColor = $True
$btnCancel.add_Click($btnCancel_OnClick)

$form1.Controls.Add($btnCancel)


$btnOK.DataBindings.DefaultDataSourceUpdateMode = 0


$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 320
$System_Drawing_Point.Y = 436
$btnOK.Location = $System_Drawing_Point
$btnOK.Name = "btnOK"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 58
$btnOK.Size = $System_Drawing_Size
$btnOK.TabIndex = 3
$btnOK.Text = "OK"
$btnOK.UseVisualStyleBackColor = $True
$btnOK.add_Click($btnOK_OnClick)

$form1.Controls.Add($btnOK)


$gboxScopes.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 40
$System_Drawing_Point.Y = 323
$gboxScopes.Location = $System_Drawing_Point
$gboxScopes.Name = "gboxScopes"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 91
$System_Drawing_Size.Width = 394
$gboxScopes.Size = $System_Drawing_Size
$gboxScopes.TabIndex = 2
$gboxScopes.TabStop = $False
$gboxScopes.Text = "Scopes"

$form1.Controls.Add($gboxScopes)
$txtScopeSubnet.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 101
$System_Drawing_Point.Y = 49
$txtScopeSubnet.Location = $System_Drawing_Point
$txtScopeSubnet.Name = "txtScopeSubnet"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 263
$txtScopeSubnet.Size = $System_Drawing_Size
$txtScopeSubnet.TabIndex = 2
$txtScopeSubnet.Enabled = $false

$gboxScopes.Controls.Add($txtScopeSubnet)

$lblScope.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 6
$System_Drawing_Point.Y = 49
$lblScope.Location = $System_Drawing_Point
$lblScope.Name = "lblScope"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 100
$lblScope.Size = $System_Drawing_Size
$lblScope.TabIndex = 1
$lblScope.Text = "Scope Subnet"

$gboxScopes.Controls.Add($lblScope)

$lblWarning.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 6
$System_Drawing_Point.Y = 16
$lblWarning.Location = $System_Drawing_Point
$lblWarning.Name = "lblWarning"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 18
$System_Drawing_Size.Width = 249
$lblWarning.Size = $System_Drawing_Size
$lblWarning.TabIndex = 0
$lblWarning.Text = "Leave blank if migrating all scopes"

$gboxScopes.Controls.Add($lblWarning)



$gboxServers.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 42
$System_Drawing_Point.Y = 206
$gboxServers.Location = $System_Drawing_Point
$gboxServers.Name = "gboxServers"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 101
$System_Drawing_Size.Width = 393
$gboxServers.Size = $System_Drawing_Size
$gboxServers.TabIndex = 1
$gboxServers.TabStop = $False
$gboxServers.Text = "Servers"

$form1.Controls.Add($gboxServers)
$txtDestinationServer.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 112
$System_Drawing_Point.Y = 64
$txtDestinationServer.Location = $System_Drawing_Point
$txtDestinationServer.Name = "txtDestinationServer"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 250
$txtDestinationServer.Size = $System_Drawing_Size
$txtDestinationServer.TabIndex = 3

$gboxServers.Controls.Add($txtDestinationServer)

$lblDestinationServer.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 6
$System_Drawing_Point.Y = 67
$lblDestinationServer.Location = $System_Drawing_Point
$lblDestinationServer.Name = "lblDestinationServer"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 100
$lblDestinationServer.Size = $System_Drawing_Size
$lblDestinationServer.TabIndex = 2
$lblDestinationServer.Text = "Destination Server"
$lblDestinationServer.add_Click($handler_label2_Click)

$gboxServers.Controls.Add($lblDestinationServer)

$lblSourceServer.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 6
$System_Drawing_Point.Y = 33
$lblSourceServer.Location = $System_Drawing_Point
$lblSourceServer.Name = "lblSourceServer"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 100
$lblSourceServer.Size = $System_Drawing_Size
$lblSourceServer.TabIndex = 1
$lblSourceServer.Text = "Source Server"

$gboxServers.Controls.Add($lblSourceServer)

$txtSourceServer.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 112
$System_Drawing_Point.Y = 30
$txtSourceServer.Location = $System_Drawing_Point
$txtSourceServer.Name = "txtSourceServer"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 250
$txtSourceServer.Size = $System_Drawing_Size
$txtSourceServer.TabIndex = 0
$txtSourceServer.add_TextChanged($handler_textBox1_TextChanged)

$gboxServers.Controls.Add($txtSourceServer)



$gboxMigrationType.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 38
$System_Drawing_Point.Y = 12
$gboxMigrationType.Location = $System_Drawing_Point
$gboxMigrationType.Name = "gboxMigrationType"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 179
$System_Drawing_Size.Width = 298
$gboxMigrationType.Size = $System_Drawing_Size
$gboxMigrationType.TabIndex = 0
$gboxMigrationType.TabStop = $False
$gboxMigrationType.Text = "Migration Type"
$gboxMigrationType.add_Enter($handler_groupBox1_Enter)

$form1.Controls.Add($gboxMigrationType)

$chkState.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 16
$System_Drawing_Point.Y = 147
$chkState.Location = $System_Drawing_Point
$chkState.Name = "chkState"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 24
$System_Drawing_Size.Width = 231
$chkState.Size = $System_Drawing_Size
$chkState.TabIndex = 4
$chkState.Text = "Make scope inactive on desitnation server"
$chkState.UseVisualStyleBackColor = $True

$gboxMigrationType.Controls.Add($chkState)


$rdoReservations.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 16
$System_Drawing_Point.Y = 116
$rdoReservations.Location = $System_Drawing_Point
$rdoReservations.Name = "rdoReservations"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 24
$System_Drawing_Size.Width = 122
$rdoReservations.Size = $System_Drawing_Size
$rdoReservations.TabIndex = 3
$rdoReservations.TabStop = $True
$rdoReservations.Text = "Reservations Only"
$rdoReservations.UseVisualStyleBackColor = $True
$rdoReservations.add_Click($handler_rdoReservations)

$gboxMigrationType.Controls.Add($rdoReservations)


$rdoServerOptions.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 16
$System_Drawing_Point.Y = 85
$rdoServerOptions.Location = $System_Drawing_Point
$rdoServerOptions.Name = "rdoServerOptions"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 24
$System_Drawing_Size.Width = 104
$rdoServerOptions.Size = $System_Drawing_Size
$rdoServerOptions.TabIndex = 2
$rdoServerOptions.TabStop = $True
$rdoServerOptions.Text = "Server Options"
$rdoServerOptions.UseVisualStyleBackColor = $True
$rdoServerOptions.add_Click($handler_rdoServerOptions)

$gboxMigrationType.Controls.Add($rdoServerOptions)


$rdoAllScopes.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 16
$System_Drawing_Point.Y = 54
$rdoAllScopes.Location = $System_Drawing_Point
$rdoAllScopes.Name = "rdoAllScopes"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 24
$System_Drawing_Size.Width = 104
$rdoAllScopes.Size = $System_Drawing_Size
$rdoAllScopes.TabIndex = 1
$rdoAllScopes.TabStop = $True
$rdoAllScopes.Text = "All Scopes"
$rdoAllScopes.UseVisualStyleBackColor = $True
$rdoAllScopes.add_Click($handler_rdoAllScopes)

$gboxMigrationType.Controls.Add($rdoAllScopes)


$rdoSingleScope.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 16
$System_Drawing_Point.Y = 23
$rdoSingleScope.Location = $System_Drawing_Point
$rdoSingleScope.Name = "rdoSingleScope"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 24
$System_Drawing_Size.Width = 104
$rdoSingleScope.Size = $System_Drawing_Size
$rdoSingleScope.TabIndex = 0
$rdoSingleScope.TabStop = $True
$rdoSingleScope.Text = "Single Scope"
$rdoSingleScope.UseVisualStyleBackColor = $True
#$rdoSingleScope.add_CheckedChanged($handler_SingleScope_CheckedChanged)
$rdoSingleScope.add_Click($handler_rdoSingleScope)

$gboxMigrationType.Controls.Add($rdoSingleScope)


#endregion Generated Form Code

#Save the initial state of the form
$InitialFormWindowState = $form1.WindowState
#Init the OnLoad event to correct the initial state of the form
$form1.add_Load($OnLoadForm_StateCorrection)
#Show the Form
$form1.ShowDialog()| Out-Null

} 

Function MigrateSingleScope {

	#Grab the inputed variables from the form
	$SourceServer = $txtSourceServer.Text
	$DestinationServer = $txtDestinationServer.Text
	$ScopeSubnet = $txtScopeSubnet.Text

	Try{

		#Checks to see if option to disable destination scope was enabled or not
		If (!($txtScopeSubnet.Text)) {
			$buttons=[system.windows.forms.messageboxbuttons]::ok;
			[system.windows.forms.messagebox]::Show("You must specify the scope ID to work with","",$buttons)
			}
		Else{
			#Copy the scope from the source server to destination server
			Get-DhcpServerv4Scope -ComputerName $SourceServer -ScopeId $ScopeSubnet | Add-DhcpServerv4Scope -ComputerName $DestinationServer -ErrorAction SilentlyContinue
		
			#Copy the reservations from the source to destination server
			Get-DhcpServerv4reservation -ComputerName $sourceserver -scopeId $ScopeSubnet | Add-DhcpServerv4Reservation -ComputerName $DestinationServer -ScopeId $ScopeSubnet -ErrorAction SilentlyContinue
		}
		
		If (!($txtScopeSubnet.Text)) {
			}
		ElseIf ($chkState.CheckState -eq 1) {
			Set-DhcpServerv4Scope -ComputerName $destinationserver -ScopeId $ScopeSubnet -State inactive 
			$buttons=[system.windows.forms.messageboxbuttons]::ok;
			[system.windows.forms.messagebox]::Show("DHCP Scope has been migrated and disabled on $DestinationServer","",$buttons)
			}
		ElseIf ($chkState.CheckState -eq 0) {	
			Set-DhcpServerv4Scope -ComputerName $destinationserver -ScopeId $ScopeSubnet -State active 
			$buttons=[system.windows.forms.messageboxbuttons]::ok;
			[system.windows.forms.messagebox]::Show("DHCP Scope has been migrated and enabled on $DestinationServer","",$buttons)
		}
	}
	Catch { 
			$buttons=[system.windows.forms.messageboxbuttons]::ok;
			[system.windows.forms.messagebox]::Show("An error occured. Please check you have permissions and correct server names / subnet ID was used","",$buttons)
		}
	
	}
				
Function MigrateAllScopes {
	#Grab the inputed variables from the form
	$SourceServer = $txtSourceServer.Text
	$DestinationServer = $txtDestinationServer.Text
	
	Try {	
		#Gets the current scopes from the source server and copies them to the destination server
		Get-DhcpServerv4scope -ComputerName $SourceServer | Add-DhcpServerv4Scope -ComputerName $DestinationServer

		#Copies the reservations from all scopes on source server to destination server
		Get-DhcpServerv4Scope -ComputerName $SourceServer | foreach {
			Get-DhcpServerv4reservation -ComputerName $SourceServer -scopeId $_.scopeid | Add-DhcpServerv4Reservation -ComputerName $DestinationServer -ScopeId $_.scopeid
			}
		
		#Checks to see if option to disable destination scope was enabled or not
		If ($chkState.CheckState -eq 1) {
			Get-DhcpServerv4Scope -ComputerName $DestinationServer | ForEach {
				Set-DhcpServerv4Scope -ComputerName $destinationserver -ScopeId $_.scopeId -State inactive 
			}
			$buttons=[system.windows.forms.messageboxbuttons]::ok;
			[system.windows.forms.messagebox]::Show("ALL DHCP Scopes from $sourceserver have been migrated and disabled to $DestinationServer","",$buttons)
		}
			
		If ($chkState.CheckState -eq 0) {	
			Get-DhcpServerv4Scope -ComputerName $DestinationServer | ForEach {
				Set-DhcpServerv4Scope -ComputerName $destinationserver -ScopeId $_.scopeId -State active 
			}
			$buttons=[system.windows.forms.messageboxbuttons]::ok;
			[system.windows.forms.messagebox]::Show("ALL DHCP Scopes from $sourceserver have been migrated and enabled on $DestinationServer","",$buttons)
		}
	}
	Catch { 
			$buttons=[system.windows.forms.messageboxbuttons]::ok;
			[system.windows.forms.messagebox]::Show("An error occured. Please check you have permissions and correct server names / subnet ID was used","",$buttons)
		}
}

Function MigrateServerOptions {
	#Grab the inputed variables from the form
	$SourceServer = $txtSourceServer.Text
	$DestinationServer = $txtDestinationServer.Text	

	Try {
		Get-DhcpServerv4OptionDefinition -ComputerName $sourceserver | Add-DhcpServerv4OptionDefinition -ComputerName $DestinationServer -ErrorAction SilentlyContinue
		Get-DhcpServerv4OptionDefinition -ComputerName $sourceserver | Set-DhcpServerv4OptionDefinition -ComputerName $DestinationServer -ErrorAction SilentlyContinue

		Get-DhcpServerv4OptionValue -ComputerName $SourceServer | Set-DhcpServerv4OptionValue -ComputerName $DestinationServer
		
		$buttons=[system.windows.forms.messageboxbuttons]::ok;
		[system.windows.forms.messagebox]::Show("All DCHP V4 Server Options Copied from $sourceserver to $destinationserver","",$buttons)
		}
	
		Catch { 
			$buttons=[system.windows.forms.messageboxbuttons]::ok;
			[system.windows.forms.messagebox]::Show("An error occured. Please check you have permissions and correct server names / subnet ID was used","",$buttons)
			}
		}
		
Function MigrateReservations {
	#Grab the inputed variables from the form
	$SourceServer = $txtSourceServer.Text
	$DestinationServer = $txtDestinationServer.Text
	$ScopeSubnet = $txtScopeSubnet.Text
	
	Try {
		#Check if migrating reservations for a specific scope or all scopes
		#Test if scope subnet value is present
		If (!($ScopeSubnet)) {
			#Migrating DCHP for all scopes
			Get-DhcpServerv4Scope -ComputerName $SourceServer | foreach {
				Get-DhcpServerv4Reservation -ScopeId $_.scopeID | Add-DhcpServerv4Reservation -ComputerName $DestinationServer -ErrorAction SilentlyContinue
				}
			}
		
		If ($ScopeSubnet -ne $null) {
			#Micgrating DHCP for single specified scope
			Get-DhcpServerv4Reservation -ScopeId $scopersubnet | Add-DhcpServerv4Reservation -ComputerName $DestinationServer -ErrorAction SilentlyContinue
			}
		}
	Catch { 
			$buttons=[system.windows.forms.messageboxbuttons]::ok;
			[system.windows.forms.messagebox]::Show("An error occured. Please check you have permissions and correct server names / subnet ID was used","",$buttons)
		}
}
#Import relevent modules
Import-Module DhcpServer 

#Call the Functions
GenerateForm
