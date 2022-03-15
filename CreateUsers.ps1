Import-Module activedirectory
 Import-Csv "E:\ps\create_new_ad_users.csv" | ForEach-Object {
 $upn = $_.SamAccountName + “@capacitacion.local”
 $uname = $_.LastName + " " + $_.FirstName
 New-ADUser -Name $uname `
 -DisplayName $uname `
 -GivenName $_.FirstName `
 -Surname $_.LastName `
 -OfficePhone $_.Phone `
 -Department $_.Department `
 -Title $_.JobTitle `
 -UserPrincipalName $upn `
 -SamAccountName $_.samAccountName `
 -Path $_.OU `
 -AccountPassword (ConvertTo-SecureString $_.Password -AsPlainText -force) -Enabled $true
 }