get-aduser -filter * | Where-Object {$_.enabled -eq 'True'} | FT samaccountname