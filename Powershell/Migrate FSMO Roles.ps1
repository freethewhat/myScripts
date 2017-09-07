$Server = Read-Host -prompt "Which server would you like to move FSMO roles to? "
$Confirm = Read-Host -prompt "Are you sure? (y/n) "
if($confirm -eq "y"){
	write-host "Migrating FSMO roles to '$Server'."
} else {
	write-host "FSMO role migration cancelled"
}