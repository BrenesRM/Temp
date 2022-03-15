Import-Module ActiveDirectory
$path="OU=Cuentas de Correo,OU=Usuarios,OU=Objetos Infraestructura,DC=pruebas,DC=local"
$ADUsers = Get-ADUser