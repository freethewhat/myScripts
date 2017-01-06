$limit = (get-date).AddDays(-30)
$path = "C:\Temp"

Get-ChildItem -Path $path -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $limit } | Remove-Item -Force