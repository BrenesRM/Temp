#Powershell

#Install-WindowsFeature –ConfigurationFilePath E:\DeploymentConfigTemplate_Net35.xml -Source C:\Windows\System32\sxs

Install-WindowsFeature –ConfigurationFilePath E:\DeploymentConfigTemplate_Net35.xml -Source D:\sources\sxs

#$servers = ('server1', 'server2')
#foreach ($server in $servers) {Install-WindowsFeature -ConfigurationFilePath D:\ConfigurationFiles\ADCSConfigFile.xml -ComputerName $server}

#Get-WindowsFeature -Name Web-* | Install-WindowsFeature