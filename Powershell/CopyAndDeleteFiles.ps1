$src = "C:\temp\testDirSrc"
$dst = "C:\temp\testDirdst"
$log = "C:\temp\copy.log"

Set-Location $src

ForEach($i in ls) {
    $date = Get-Date
    $success = copy-item $i.name $dst -PassThru -ErrorAction SilentlyContinue

    if($success){
        remove-item $i.Name
        $success_log = $date.ToString() + " - Copy Successful: " + $src + "\" + $i.Name + " ~> " + $dst + "\" + $i.Name
  
        echo $success_log >> $log
    } else {
        $failure_log = $date.ToString() + " - Copy Failure: " + $src + "\" + $i.Name

        echo $failure_log >> $log
    }
}