#AGREGAR LOS GRUPOS A EXPORTAR LOS ATRIBUTOS DE LOS USUARIOS
Get-ADGroupMember -Server ‘pruebas.local’ –identity ‘Cambia-ADAccountExpiration’ -Recursive | Get-ADUser –Server ‘pruebas.local’ -Property * | Select UserPrincipalName, SamAccountName, DistinguishedName, Department, Name, Manager | export-csv "E:\Scripts\Test.csv" -NoTypeInformation


users_AccesoAlteryx_VDI
users_AccesoInvestigacionVDI_DE
users_AccesoRemotoVDI_DA
users_AccesoRemotoVDI_DE
users_AccesoRemotoVDI_DGD
users_AccesoRemotoVDI_DISI
users_AccesoRemotoVDI_DISS
users_AccesoRemotoVDI_DST
users_AccesoRemotoVDI_EDSL
Users_accesoremotoVDI_EXT
users_AccesoRemotoVDI_FE
users_AccesoRemotoVDI_FICO
users_AccesoRemotoVDI_GAP
users_AccesoRemotoVDI_SG
Users_AccesoRemotoVDI_SP
users_AccesoRemotoVDI_SUGEF
users_AccesoRemotoVDI_SUGESE
users_AccesoRemotoVDI_SUPEN
users_AccesoRemotoVDI_SWIFT
users_AccesoSupervisionVDI_SUGEF
users_AccesoSupervisionVDI_SUPEN
users_DSA_AccesoF5
users_DST_DGI_Servidores
users_DST_DGI_Telecom
users_DST_DSA_Base_Datos
users_DST_DSA_Seguridad
Users_DST_Validación_VDI


# What you asked for
Get-ADGroupMember -Server ‘Region2.decocompany.com’ –identity ‘Geo_Room_45’ -Recursive | 
Get-ADUser –Server ‘GlobalCatalogue22.decocompany.com:3268’ -Property Name, ObjectClass, Title, Department, City | 
Select Name, ObjectClass, Title, Department, City,@{n='ADGroup';e={Get-ADGroup –Server ‘Region2.decocompany.com’ –Identity ‘Geo_Room_45’ | Select-Object Name}} | 
Export-CSV –path C:\Temp\Group.csv –NoTypeInformation

# OR

# more dynamic, you have to enter the name only once
$identity = 'Geo_Room_45'
Get-ADGroupMember –identity $identity -Server 'Region2.decocompany.com' -Recursive | 
Get-ADUser –Server ‘GlobalCatalogue22.decocompany.com:3268’ -Property Name, ObjectClass, Title, Department, City | 
Select Name, ObjectClass, Title, Department, City,@{n='ADGroup';e={Get-ADGroup –Server ‘Region2.decocompany.com’ –Identity $identity | Select-Object Name}} | 
Export-CSV –path C:\Temp\Group.csv –NoTypeInformation

#OR

# you litteraly just display the name without an AD query as you know the name already
Get-ADGroupMember -Server 'Region2.decocompany.com’ –identity 'Geo_Room_45’ -Recursive | 
Get-ADUser –Server 'GlobalCatalogue22.decocompany.com:3268’ -Property Name, ObjectClass, Title, Department, City | 
Select Name, ObjectClass, Title, Department, City,@{n='ADGroup';e={'Geo_Room_45'}} | 
Export-CSV –path C:\Temp\Group.csv –NoTypeInformation