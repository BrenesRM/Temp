Import-Module ActiveDirectory
#Enter a path to your import CSV file
$ADUsers = Import-csv E:\Scripts\create_new_ad_users.csv
$path="OU=Usuarios a Eliminar,OU=Objetos Servicios ISI,DC=pruebas,DC=local"
$Password = "Nuevo123*"
foreach ($User in $ADUsers){
 $Username = $User.Username
 $Firstname = $User.Firstname
 $Lastname = $User.Lastname
 $Department = $User.Department
 #$OU = $User.ou
 #Check if the user account already exists in AD
   if (Get-ADUser -F {SamAccountName -eq $Username})
    {
     #If user does exist, output a warning message
     Write-Warning "A user account $Username has already exist in Active Directory."
    }
     else
      {
       #If a user does not exist then create a new user account
       #Account will be created in the OU listed in the $OU variable in the CSV file; don’t forget to change the domain name in the"-UserPrincipalName" variable
       New-ADUser `
       -SamAccountName $Username `
       -UserPrincipalName "$Username@pruebas.local" `
       -Name "$Firstname $Lastname" `
       -GivenName $Firstname `
       -Surname $Lastname `
       -Enabled $True `
       -ChangePasswordAtLogon $True `
       -DisplayName "$Lastname, $Firstname" `
       -Department $Department `
       -Path $path `
       -AccountPassword (convertto-securestring $Password -AsPlainText -Force)
      }
}