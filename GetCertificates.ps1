#dir cert: -Recurse | Where-Object { $_.FriendlyName -like "*SINPE-901-702$*" }
#dir cert: -Recurse | Where-Object { $_.FriendlyName -like "*DigiCert*" }
#dir cert: -Recurse | Where-Object { $_.Thumbprint -like "*0563B8630D62D75ABBC8AB1E4B*" }
#dir cert: -Recurse | Where-Object { $_.NotAfter -lt (Get-Date 2018-12-31) }
#dir cert: -Recurse | Where-Object { $_.NotAfter -gt (Get-Date) -and $_.NotAfter -lt (Get-Date).AddYears(1) }
