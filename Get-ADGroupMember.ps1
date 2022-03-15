#Importa el modulo de AD
Import-Module ActiveDirectory

#Get al grupo Cambia-ADAccountExpiration donde el objeto usuario, set Set-ADAccountExpiration -DateTime "12/31/2017"
#Get-ADGroupMember Cambia-ADAccountExpiration | where {$_.objectClass -eq "user"} | Set-ADAccountExpiration -DateTime "12/31/2017"

#Get al grupo Cambia-ADAccountExpiration donde el objeto usuario, set Cambia UPN
#Get-ADGroupMember Cambia-ADAccountExpiration | where {$_.objectClass -eq "user"} | foreach { Set-ADUser $_ -UserPrincipalName (“{0}@{1}” -f $_.sAMAccountName,”sugese.fi.cr”)}

#Exporta User de un OU al archivo C:\Users.txt
#Get-ADUser -Filter * -SearchBase "OU=Usuarios,OU=Objetos Usuarios Finales,DC=sugese,DC=bccr,DC=fi,DC=cr" -Properties UserPrincipalName | select #SamAccountName | fl > C:\Users.txt


#Get-ADGroupMember Cambia-ADAccountExpiration | where {$_.objectClass -eq "user"} | foreach Get-Aduser -Filter * -Properties UserPrincipalName | #select SamAccountName

#Get-ADGroupMember users_AccesoRemotoVDI_SUGESE -Recursive | Get-ADUser -Properties * | Select-Object cn, enabled, DistinguishedName, Name, #UserPrincipalName | export-csv "E:\Scripts\users_AccesoRemotoVDI_SUGESE.csv" -NoTypeInformation