Import-Module ServerManager
$(Get-Content .\Features.txt) | 
Add-WindowsFeature -Source D:\sources\sxs
