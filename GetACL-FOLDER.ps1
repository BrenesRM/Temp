$FolderPath = Get-ChildItem -Directory -Path "I:\SIMPANA" -Recurse -Force
$Output = @()
ForEach ($Folder in $FolderPath) {
    $Acl = Get-Acl -Path $Folder.FullName 
    ForEach ($Access in $Acl.Access) {
$Properties = [ordered]@{'Folder Name'=$Folder.FullName;'Group/User'=$Access.IdentityReference;'Permissions'=$Access.FileSystemRights;'Inherited'=$Access.IsInherited}
$Output += New-Object -TypeName PSObject -Property $Properties            
}
}
$Output | Out-GridView
#$Output | export-csv "E:\Scripts\groupinfo.csv" -NoTypeInformation