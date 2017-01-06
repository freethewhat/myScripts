$Path = "C:\Users\msutton\Desktop"
$Move = "C:\Test Archive"
$Months = 5


$List = get-childitem -path $Path -recurse |? {!$_.PsiScontainer -and $_.lastaccesstime -lt (get-date).adddays(-$Months)}

foreach($file in $List)
{
	$new = $file.DirectoryName #-replace [regex]::Escape($Path),$Move
	new-item $new -type directory -ea SilentlyContinue
	move-item -Path $file.FullName -destination $new
}

#dir $Path -recurse | Where {$_.PSIsContainer -and @(dir -Lit $_.Fullname -r | Where {!$_.PSIsContainer}).Length -eq 0} | Remove-Item -recurse

