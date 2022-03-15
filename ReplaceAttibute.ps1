$Manager = Get-ADUser brenesrm | Get-ADObject -Properties DistinguishedName
Set-aduser -identity CorreCP -replace @{Manager=$Manager}


Get-ADUser CorreCP -Properties *
-replace @{ 'MobilePhone' = $($Number) }

Set-aduser -identity CorreCP -replace @{Manager=$Manager}