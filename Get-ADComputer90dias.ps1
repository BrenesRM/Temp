import-Module ActiveDirectory
$date=[DateTime]::Today.addDays(-90)
Get-ADComputer -Filter 'PasswordLastSet -le $date' -SearchBase 'OU=SINPE,DC=pruebas,DC=local' -properties PasswordLastSet | Export-Csv c:\Maquinas_SINPE_27112019V2.csv 