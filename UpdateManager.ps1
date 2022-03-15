$UsuarioAD = "CorreCP"
$ManagerAD = "brenesrm"
get-aduser $UsuarioAD | Set-ADUser -Manager $null
$Usuario = Get-ADUser $UsuarioAD -Properties *
$Manager = Get-ADUser $ManagerAD -Properties *
get-aduser $Usuario | Set-ADUser -Manager $Manager.SamAccountName -PassThru | get-aduser -Properties Manager | Select Name,Manager