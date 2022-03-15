Import-Module ServerManager
Get-WindowsFeature | 
  ? { $_.Installed } | 
  Sort-Object Name | 
  Select Name | 
  ForEach-Object { $_.Name } | 
  Out-File .\Features.txt