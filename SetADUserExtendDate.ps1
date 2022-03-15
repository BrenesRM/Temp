$Fecha = '1.1.2022'
$name = "TERE@pruebas.local"


$Username = Get-ADUser -filter { UserPrincipalName -Eq $name }

if ($Username.UserPrincipalName -eq $name){
    $setDate = [DateTime]::Parse($Fecha) # Formato de fecha ('Mes.Dia.Ano').
    Set-ADAccountExpiration -Identity $Username -DateTime $setDate.AddHours(24)
    write-host ("Fecha cambiada")
}else {
    write-host ("Fecha Sin Cambios")
}

