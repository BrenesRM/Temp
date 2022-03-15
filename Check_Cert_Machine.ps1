Import-Module PKI
Set-Location Cert:\LocalMachine\My
Get-ChildItem -path cert:\LocalMachine\My 
Get-ChildItem –Recurse –ExpiringInDays 120 | fl -Property *
