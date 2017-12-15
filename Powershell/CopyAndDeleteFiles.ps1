<#
    Copies a file and verified the copy was successful. If it was succesful it will delete the old file and log successfully 
    in the application log. If the copy does not complete successfully the file will not be deleted and will log a failure in
    the application log.
#>

$src = "C:\temp\testDirSrc"
$dst = "C:\temp\testDirdst"
$logSource = "FileCopy"

Set-Location $src

New-EventLog -Source $logSource -LogName Application

ForEach($i in ls) {
    $date = Get-Date
    $success = copy-item $i.name $dst -PassThru -ErrorAction SilentlyContinue

    if($success){
        remove-item $i.Name

        $success_log = $date.ToString() + " - Copy Successful: " + $src + "\" + $i.Name + " ~> " + $dst + "\" + $i.Name
        
        Write-EventLog -LogName Application -Source $logSource -EventID "0" -EntryType Information -Message $success_log
    } else {
        $failure_log = $date.ToString() + " - Copy Failure: " + $src + "\" + $i.Name

        Write-EventLog -LogName Application -Source $logSource -EventID "1" -EntryType Error -Message $failure_log
    }
}