Import-Module ActiveDirectory
$path="OU=Usuarios,DC=central,DC=bccr,DC=fi,DC=cr"
$ADUsers = Get-ADUser -filter * -SearchBase $path -Properties SamAccountName
$User = $ADUsers
	ForEach ($User in $ADUsers){
        Add-ADGroupMember -Identity BCCR_Navegacion_General -Members $user
}