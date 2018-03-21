function Install-DC-Roles {
    'Installing Domain Controller Roles'
    Install-windowsfeature AD-domain-services -IncludeManagementTools
    write-host -ForegroundColor green "Domain Controller Roles Installed"
}

function Install-DHCP-Roles {
    'Installing DHCP Server Roles'
    Install-WindowsFeature DHCP -IncludeManagementTools
    write-host -ForegroundColor green "Roles Installed"
}

function Install-DNS-Roles {
    'Installing DNS Server Roles'
    Install-WindowsFeature DNS -IncludeManagementTools
    write-host -ForegroundColor green "DNS Roles Installed"
}

function Install-FS-Roles {
    'Installing File Server Roles'
    Install-WindowsFeature FS-FileServer, FS-DFS-Namespace, FS-DFS-Replication, RSAT-DFS-Mgmt-Con -IncludeManagementTools
    New-Item -ItemType Directory -Path D:\Data
    New-Item -ItemType Directory -Path D:\Users
    New-Item -ItemType Directory -Path D:\Software
    write-host -ForegroundColor green "File Server Roles Installed"
}

function Install-HV-Roles {
    'Installing Hyper-V Roles'
    Install-WindowsFeature -Name Hyper-V -IncludeManagementTools

    #Create NIC teams
    New-NetLbfoTeam -Name "Hyper-V" -TeamMembers "SLOT*" -confirm:$false
    New-NetLbfoTeam -Name "Management" -TeamMembers "NIC*"-confirm:$false

    #configure Hyper-V
    New-VMSwitch -name ExternalSwitch  -NetAdapterName "Hyper-V" -AllowManagementOS $false

    #Configure Hyper-V Server Settings
    Set-VMHost -VirtualMachinePath "D:\Hyper-V"
    Set-VMHost -VirtualHardDiskPath "D:\Hyper-V\Virtual Disks"

    write-host -ForegroundColor green "Hyper-V Roles Installed"
}

function Install-PS-Roles {
    'Installing Print Server Roles'
    Install-WindowsFeature Print-Server -IncludeManagementTools
    write-host -ForegroundColor green "Print Server Roles Installed"
}

function Role-Selection {
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Data Entry Form"
    $form.Size = New-Object System.Drawing.Size(300,200)
    $form.StartPosition = "CenterScreen"

    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Location = New-Object System.Drawing.Point(75,120)
    $OKButton.Size = New-Object System.Drawing.Size(75,23)
    $OKButton.Text = "OK"
    $OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $OKButton
    $form.Controls.Add($OKButton)

    $CancelButton = New-Object System.Windows.Forms.Button
    $CancelButton.Location = New-Object System.Drawing.Point(150,120)
    $CancelButton.Size = New-Object System.Drawing.Size(75,23)
    $CancelButton.Text = "Cancel"
    $CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $CancelButton
    $form.Controls.Add($CancelButton)

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10,20)
    $label.Size = New-Object System.Drawing.Size(280,20)
    $label.Text = "Please make a selection from the list below (Hold CTRL to select multiple):"
    $form.Controls.Add($label)

    $listBox = New-Object System.Windows.Forms.Listbox
    $listBox.Location = New-Object System.Drawing.Point(10,40)
    $listBox.Size = New-Object System.Drawing.Size(260,20)

    $listBox.SelectionMode = "MultiExtended"

    [void] $listBox.Items.Add("Domain Controller")
    [void] $listBox.Items.Add("DHCP Server")
    [void] $listBox.Items.Add("DNS Server")
    [void] $listBox.Items.Add("File Server")
    [void] $listBox.Items.Add("Hyper-V Server")
    [void] $listBox.Items.Add("Print Server")

    $listBox.Height = 70
    $form.Controls.Add($listBox)
    $form.Topmost = $True

    $result = $form.ShowDialog()

    return $listbox.SelectedItems
}

function Role-Installation ($Roles) {
    Switch ( $Roles ) {
        "Domain Controller" { Install-DC-Roles }
        "DHCP Server" { Install-DHCP-Roles }
        "DNS Server" { Install-DNS-Roles }
        "File Server" { Install-FS-Roles }
        "Hyper-V Server" { Install-HV-Roles }
        "Print Server" { Install-PS-Roles }
    }
}
